export type Question = { question: string; context?: string }

export type AnswerForm = {
  phase: 'idle' | 'extracting' | 'form' | 'confirm'
  questions: Question[]
  answers: string[]
  current: number
}

declare module 'claude-code' {
  interface PluginState {
    answer: { form: Shaped<AnswerForm> }
  }
}
