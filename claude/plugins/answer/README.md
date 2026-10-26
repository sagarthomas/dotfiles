# Answer plugin

`/answer` turns the latest assistant message into a set of questions you can
answer in a form, without scrolling back and forth.

## Setup

Load it for one session while testing:

```sh
claude --plugin-dir ~/dev/dotfiles/claude/plugins/answer
```

An interactive session watches that folder and reloads the plugin when a file
changes.

Settings live in `/config` (or `pluginConfigs.answer.options` in
`~/.claude/settings.json`):

| Option  | Default            | Meaning                                                 |
| ------- | ------------------ | ------------------------------------------------------- |
| `model` | `claude-haiku-5-5` | Model alias or id that extracts the questions           |
| `debug` | `false`            | Log source messages and extractor replies to transcript |

Extraction runs on the session's own login. No credentials are stored.

## Workflow

The extraction model sees the latest assistant turn (its text rows, joined
across tool calls) and the user prompt that started it. Only requests from the
assistant are extracted. The reply must be a single JSON object
`{"questions":[{"question":"…","context":"…"}]}`. Code fences or prose around it
are tolerated. A reply that doesn't parse gets one repair request. Both
requests share a 60-second deadline.

The form opens as a pane above the prompt (docked beside the transcript in
fullscreen). Tabs show `Q1•` once an answer is nonblank. Questions and context
render as Markdown.

| Key                                          | Action                                     |
| -------------------------------------------- | ------------------------------------------ |
| Tab, or ↓ past the answer's last line        | Next question (past the last one: Send)    |
| Shift+Tab, or ↑ past the answer's first line | Previous question                          |
| Shift+Enter, `\` Enter, Alt+Enter, Ctrl+J    | Newline, as in the main prompt             |
| Enter                                        | Open the Send screen                       |
| Esc                                          | Discard everything (on Send: keep editing) |

Shift+Enter needs a terminal that reports it (kitty, Ghostty, WezTerm) or a
one-time `/terminal-setup`. Clicking a `Qn` tab, `Send` or `Back` works too.
Question switching works by catching focus as it moves onto invisible stops
drawn just before and after the answer field.

Confirming sends one user message and starts the next turn:

```text
1. Which database and host?
Context: SQLite is the default.
Answer: SQLite
On my laptop.

2. What output format?
Answer: Not answered
```

Blank answers become `Not answered`, never acceptance of a default. Escape
during extraction cancels the request. A valid empty result shows
`No questions requiring your input found.`

## Development

`hooks/register.tsx` registers the command and draws the pane.
`hooks/extraction.ts` picks the source messages, calls the model and parses the
reply. `types/index.d.ts` declares the pane's state.

```sh
claude plugin validate claude/plugins/answer
claude plugin test claude/plugins/answer
```

Once the engine has loaded the plugin from `--plugin-dir`, it writes the API
types to `.claude-plugin/types/` (git-ignored), and `tsc -p claude/plugins/answer`
type-checks it. Tests stand in for the engine and the model, so they make no
paid calls. Extraction quality and your terminal's key delivery need a manual
check in a real session.
