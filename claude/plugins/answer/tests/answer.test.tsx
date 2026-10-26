import { expect, test } from 'claude-code/testing'
import type { On, SessionMessage } from 'claude-code'

import { findSource, formatAnswers, parseQuestions } from '../hooks/extraction'

const PANE = {
  plugin: 'answer',
  component: 'Pane',
  requestId: 'answer',
  props: {
    title: 'Answer questions',
    isFocused: true,
    bodyColumns: 80,
    placement: 'inline',
    scroll: { offset: 0, bodyRows: 16 },
    view: {},
  },
} as const

const TRANSCRIPT: SessionMessage[] = [
  { role: 'user', text: 'set up the project', toolUses: [] },
  { role: 'assistant', text: 'Let me look around.', toolUses: [] },
  { role: 'user', text: '', toolUses: [], toolResults: [] },
  { role: 'assistant', text: '1. Which database?\n2. What output format?', toolUses: [] },
]

const RUN = {
  command: 'answer',
  args: '',
  origin: { kind: 'composer' },
  presentation: { isFullscreen: false, columns: 120 },
} as const

const usage = {
  input_tokens: 1,
  output_tokens: 1,
  cache_creation_input_tokens: 0,
  cache_read_input_tokens: 0,
}

/** Stands in for the engine: answers each model call with the next reply. */
function engine(on: On, replies: string[]) {
  const seen = { prompts: [] as string[], submitted: [] as string[], toasts: [] as string[], closed: 0 }
  on('clock.now', () => ({ value: 0 }))
  on('command.register', () => ({ value: { command: 'answer' } }))
  on('session.start', (_, e) => ({ cwd: e.cwd }))
  on('session.messages', () => ({ value: TRANSCRIPT }))
  on('model.complete', (_, e) => {
    seen.prompts.push(e.prompt)
    return { value: { isAnswered: true, text: replies.shift() ?? '', usage } }
  })
  on('ui.open', () => ({ value: { isPlaced: true } }))
  on('ui.focus', () => ({}))
  on('ui.close', () => {
    seen.closed += 1
    return { value: undefined }
  })
  on('ui.toast', (_, e) => {
    seen.toasts.push(e.text)
    return { value: undefined }
  })
  on('prompt.submit', (_, e) => {
    seen.submitted.push(e.text)
    return { text: e.text }
  })
  return seen
}

test('answers are sent as one message after Send', async ($, on) => {
  const seen = engine(on, [
    '{"questions":[{"question":"Which database?","context":"SQLite is the default."},{"question":"What output format?"}]}',
  ])
  await $.session.start({ cwd: '/', surface: 'terminal', isInteractive: true })
  await $.command.run(RUN)

  const ui = await $.ui.mount({ ...PANE, surface: 'terminal' })
  expect(await ui.find({ type: 'Markdown', text: /Which database/ })).toBeDefined()
  await ui.input({ key: 'answer-0', text: 'SQLite\nOn my laptop.', kind: 'change' })
  await ui.press({ key: 'tab-1' })
  expect(await ui.find({ type: 'Markdown', text: /output format/ })).toBeDefined()
  await ui.input({ key: 'answer-1', text: '   ' })
  expect(await ui.find({ type: 'Text', text: /1 of 2 answered/ })).toBeDefined()
  await ui.press({ key: 'send' })
  await ui.unmount()

  expect(seen.submitted).toEqual([
    '1. Which database?\nContext: SQLite is the default.\nAnswer: SQLite\nOn my laptop.\n\n2. What output format?\nAnswer: Not answered',
  ])
  expect(seen.prompts[0]).toBe(
    JSON.stringify({
      precedingUserMessage: 'set up the project',
      assistantMessage: 'Let me look around.\n\n1. Which database?\n2. What output format?',
    }),
  )
})

test('invalid JSON gets one repair request', async ($, on) => {
  const seen = engine(on, ['Sure! Here are the questions.', '{"questions":[{"question":"Which database?"}]}'])
  await $.session.start({ cwd: '/', surface: 'terminal', isInteractive: true })
  await $.command.run(RUN)

  expect(seen.prompts).toHaveLength(2)
  expect(seen.prompts[1]).toContain('<previous_output>\nSure! Here are the questions.')
  const ui = await $.ui.mount({ ...PANE, surface: 'desktop' })
  expect(await ui.find({ type: 'Markdown', text: /Which database/ })).toBeDefined()
  await ui.unmount()
})

test('a second invalid reply and an empty result close with a toast', async ($, on) => {
  const seen = engine(on, ['nope', 'still nope', '{"questions":[]}'])
  await $.session.start({ cwd: '/', surface: 'terminal', isInteractive: true })
  await $.command.run(RUN)
  await $.command.run(RUN)

  expect(seen.toasts).toEqual([
    'The extraction model returned invalid question JSON after one repair. Retry /answer.',
    'No questions requiring your input found.',
  ])
  expect(seen.submitted).toEqual([])
})

test('parseQuestions accepts fenced JSON and rejects bad shapes', () => {
  expect(parseQuestions('```json\n{"questions":[{"question":"A?","context":null}]}\n```')).toEqual([
    { question: 'A?' },
  ])
  expect(parseQuestions('{"questions":[]}')).toEqual([])
  expect(parseQuestions('{"questions":[{"question":"  "}]}')).toBeUndefined()
  expect(parseQuestions('{"questions":[{"context":"x"}]}')).toBeUndefined()
  expect(parseQuestions('no json here')).toBeUndefined()
})

test('findSource takes the latest turn and the prompt before it', () => {
  expect(findSource([])).toBeUndefined()
  expect(findSource(TRANSCRIPT)?.precedingUserMessage).toBe('set up the project')
  expect(formatAnswers([{ question: 'Q?' }], [''])).toBe('1. Q?\nAnswer: Not answered')
})
