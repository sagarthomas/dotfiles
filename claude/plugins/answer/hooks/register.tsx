import { atom, read, update } from 'claude-code'
import type { EngineInterface, PaneOpenArgs, Register } from 'claude-code'

import type { AnswerForm } from '../types'
import { extractQuestions, formatAnswers } from './extraction'

const PANE = 'answer'
const OPEN: PaneOpenArgs = {
  id: PANE,
  title: 'Answer questions',
  focus: true,
  closeOnEscape: true,
  holdToasts: true,
  rows: 16,
}
const IDLE: AnswerForm = { phase: 'idle', questions: [], answers: [], current: 0 }
// Change the tag when AnswerForm's fields change: it declines what an earlier
// version stored, which outlives a reload.
const form = atom({ plugin: 'answer', key: 'form' } as const, IDLE, { shape: 'form-1' })

// Typing goes here rather than into `form`, so keystrokes don't redraw the
// field; `form.answers` is brought up to date on every navigation.
let drafts: string[] = []
let extraction: AbortController | undefined
let focused: string | undefined

function answerKey(index: number): string {
  return `answer-${index}`
}

function draftAt(state: AnswerForm, index: number): string {
  return drafts[index] ?? state.answers[index] ?? ''
}

function commit(state: AnswerForm): AnswerForm {
  return { ...state, answers: state.questions.map((_, index) => draftAt(state, index)) }
}

/** Moves the pane's focus ring; a refusal (the pane lost the keys) leaves it be. */
async function focus($: EngineInterface, key: string): Promise<void> {
  try {
    await $.ui.focus({ requestId: PANE, key })
  } catch {}
}

/** Shows question `index`, or the Send screen past the last one, and focuses it. */
async function show($: EngineInterface, index: number): Promise<void> {
  const state = await update($, form, (state): AnswerForm => {
    const committed = commit(state)
    if (index >= committed.questions.length) return { ...committed, phase: 'confirm' }
    return { ...committed, phase: 'form', current: Math.max(0, index) }
  })
  await focus($, state.phase === 'confirm' ? 'send' : answerKey(state.current))
}

async function step($: EngineInterface, direction: 1 | -1): Promise<void> {
  const state = await read($, form)
  await show($, state.current + direction)
}

async function reset($: EngineInterface): Promise<void> {
  extraction?.abort()
  extraction = undefined
  drafts = []
  focused = undefined
  await update($, form, () => IDLE)
}

async function send($: EngineInterface): Promise<void> {
  const { questions, answers } = commit(await read($, form))
  await $.ui.close({ id: PANE })
  await $.prompt.submit({ text: formatAnswers(questions, answers) })
}

async function reopen($: EngineInterface, index: number): Promise<void> {
  await $.ui.open(OPEN)
  await focus($, answerKey(index))
}

export const register: Register = (on, options) => {
  const settings = {
    model:
      typeof options.model === 'string' && options.model.trim() ? options.model : 'claude-haiku-5-5',
    debug: options.debug === true,
  }

  on('session.start', async ($, e, next) => {
    await $.command.register({
      name: 'answer',
      description: 'Answer questions from the latest assistant message',
    })
    // A pane left from before a reload has no extraction behind it.
    const state = await read($, form)
    if (state.phase === 'extracting') await reset($)

    return next(e)
  })

  on('command.run', { command: 'answer' }, async $ => {
    await reset($)
    const controller = new AbortController()
    extraction = controller
    await update($, form, () => ({ ...IDLE, phase: 'extracting' }))
    await $.ui.open(OPEN)

    const result = await extractQuestions($, settings, controller.signal)
    if (extraction !== controller || result === null) return {}
    extraction = undefined
    if ('error' in result || result.questions.length === 0) {
      await $.ui.close({ id: PANE })
      $.ui.toast('error' in result ? result.error : 'No questions requiring your input found.')
      return {}
    }
    drafts = result.questions.map(() => '')
    await update($, form, () => ({
      phase: 'form',
      questions: result.questions,
      answers: drafts,
      current: 0,
    }))
    await focus($, answerKey(0))

    return {}
  })

  on('ui.close', { id: PANE }, async ($, e, next) => {
    const state = await read($, form)
    // Escape on the Send screen goes back to the question instead of discarding.
    if (e.origin.kind === 'person' && state.phase === 'confirm') {
      await update($, form, (state): AnswerForm => ({ ...state, phase: 'form' }))
      void reopen($, state.current)
      return { value: undefined }
    }
    await reset($)

    return next(e)
  })

  // Tab/Shift+Tab (and Down/Up past the answer's last/first line) leave the
  // answer field for the blank `prev`/`next` stops drawn on either side of it:
  // that move switches the question instead. Reaching a stop any other way
  // lands on the answer field, so a stop never shows as focused.
  on('ui.focus', { requestId: PANE }, async ($, e, next) => {
    if (e.origin.kind === 'person' && (e.element === 'prev' || e.element === 'next')) {
      if (focused?.startsWith('answer-')) {
        void step($, e.element === 'next' ? 1 : -1)
        return {}
      }
      const element = answerKey((await read($, form)).current)
      const result = await next({ ...e, element })
      focused = element
      return result
    }
    const result = await next(e)
    focused = e.element

    return result
  })

  on('ui.render', { component: 'Pane', requestId: PANE }, async ($, e) => {
    const state = await read($, form)
    if (e.surface === 'mobile') {
      const { Text } = $.ui.resolve(e)
      return <Text>/answer needs a terminal or desktop session.</Text>
    }
    const { Box, Button, Input, Markdown, Text } = $.ui.resolve(e)
    const PADDING = { paddingX: 2, paddingY: 1 } as const

    if (state.phase === 'idle' || state.phase === 'extracting') {
      return (
        <Box {...PADDING}>
          <Text dimColor>Extracting questions… · Esc: cancel</Text>
        </Box>
      )
    }

    const total = state.questions.length
    const isConfirming = state.phase === 'confirm'
    const answered = state.questions.filter((_, index) => draftAt(state, index).trim()).length
    const tabs = (
      <Box flexDirection="row" flexWrap="wrap" columnGap={2}>
        {state.questions.map((_, index) => {
          const isCurrent = !isConfirming && index === state.current
          const mark = draftAt(state, index).trim() ? '•' : ''
          return (
            <Button key={`tab-${index}`} plain onPress={() => void show($, index)}>
              <Text bold={isCurrent} underline={isCurrent} dimColor={!isCurrent}>
                {`Q${index + 1}${mark}`}
              </Text>
            </Button>
          )
        })}
        <Button key="tab-send" plain onPress={() => void show($, total)}>
          <Text bold={isConfirming} underline={isConfirming} dimColor={!isConfirming}>
            Send
          </Text>
        </Button>
      </Box>
    )

    if (isConfirming) {
      return (
        <Box flexDirection="column" rowGap={1} {...PADDING}>
          {tabs}
          <Box flexDirection="column">
            <Text bold>Send answers?</Text>
            <Text dimColor>
              {answered} of {total} answered. Blank answers are sent as "Not answered".
            </Text>
          </Box>
          <Box flexDirection="row" columnGap={2}>
            <Button key="send" label="Send" variant="primary" autoFocus onPress={() => void send($)} />
            <Button key="back" label="Back" onPress={() => void show($, state.current)} />
          </Box>
          <Text dimColor>⏎ send · Esc keep editing</Text>
        </Box>
      )
    }

    const index = state.current
    const question = state.questions[index]!
    const answerRows = Math.max(2, Math.min(6, (e.viewport?.rows ?? 24) - 14))
    return (
      <Box flexDirection="column" {...PADDING}>
        {tabs}
        <Box flexDirection="row">
          <Text dimColor>
            {index + 1} of {total}
          </Text>
          <Button key="prev" label=" " plain onPress={() => {}} />
        </Box>
        <Box flexDirection="column" rowGap={1} marginY={1}>
          <Markdown text={question.question} />
          {question.context && <Markdown text={question.context} dimColor />}
        </Box>
        <Input
          key={answerKey(index)}
          rows={answerRows}
          autoFocus
          placeholder="Your answer"
          submitLabel="review"
          value={draftAt(state, index)}
          onInput={value => {
            const wasBlank = !(drafts[index] ?? '').trim()
            drafts[index] = value
            // Redraw only when the tab's answered mark changes.
            if (wasBlank !== !value.trim()) void update($, form, commit)
          }}
          onSubmit={value => {
            drafts[index] = value
            void show($, total)
          }}
        />
        <Box flexDirection="row">
          <Text dimColor>Tab/↓ next · Shift+Tab/↑ prev · Esc discard</Text>
          <Button key="next" label=" " plain onPress={() => {}} />
        </Box>
      </Box>
    )
  })
}
