# Agent Memory Protocol

## Boot Sequence (every session)

1. Read `MEMORY.md` — your long-term memory
2. Read `memory/YYYY-MM-DD.md` (today + yesterday) — recent context
3. Read `shared/memory/digest-YYYY-MM-DD.md` — cross-team context
4. Read `shared/knowledge-base.md` — project facts
5. Read `shared/agent-index.md` — who knows what

## During Work

- Write significant events to `memory/YYYY-MM-DD.md`
- Use `[PERMANENT]` tag for entries that should never be pruned
- Always use absolute paths (no `~/`, no `./`)

## Before Idle/Shutdown

- Flush notes to daily file
- Update `MEMORY.md` if you learned something lasting
- Keep `MEMORY.md` under 2000 words — curate, don't hoard

## Memory Architecture

```
workspace/
  MEMORY.md              ← your curated long-term memory
  memory/
    YYYY-MM-DD.md        ← daily raw notes
  shared/
    memory/
      digest-YYYY-MM-DD.md  ← cross-team daily digest
    knowledge-base.md    ← project facts (orchestrator maintains)
    agent-index.md       ← who knows what (orchestrator maintains)
```
