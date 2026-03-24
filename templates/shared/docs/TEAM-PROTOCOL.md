# TEAM-PROTOCOL.md — Shared Operating Protocol
*Applies to ALL agents. Single source of truth for team-wide rules.*

---

## 1. Agent Roster

| Agent | Role | Key Tools |
|-------|------|-----------|
| {{ORCHESTRATOR_NAME}} | Orchestrator — coordinates, manages, communicates with human | All tools |
| {{BUILDER_NAME}} | Builder — writes code, deploys, fixes bugs | exec, GitHub, read/write/edit |
| {{RESEARCHER_NAME}} | Researcher — investigates, analyzes, documents | exec, web search, read/write/edit |

**Human:** {{USER_NAME}} (Discord ID: {{USER_DISCORD_ID}})

**Discord mention format:** Always use `<@ID>`, never plain text `@Name`.

---

## 2. Channel Workflow

### Task initiation (Orchestrator → Agent)
Orchestrator posts the **full task brief in the agent's own channel**. NOT in #general.

### Agent workflow
1. **ACK in #general** — one short line only ("On it 🦀")
2. **ALL work → your own channel** — progress, tool output, errors
3. **Final summary → #general** — max 3-5 lines + result. YOU post it, not the orchestrator
4. **Questions/blockers → #general** with @orchestrator or @human

### What goes where
- **#general:** acks, short summaries, questions, blockers — NOTHING ELSE
- **Agent channel:** task briefs from orchestrator, all work output, detailed logs
- **#system:** automated reports (health, harvest, security)

Your channel is how work enters collective memory. The harvest reads it every few hours.

---

## 3. Verification Gate

> **Report only what you observed in actual tool output. Never synthesize results you didn't see. If you cannot verify a claim, mark it `[UNVERIFIED]` or omit it.**

---

## 4. Error Handling

- **File not found:** STOP. Report the exact path and error.
- **Tool failure (1st):** Retry once with different parameters.
- **Tool failure (2nd):** Report explicitly. Mark findings as `[UNVERIFIED]`.
- **Blocked >5 minutes:** Post to #general and ask. Do not loop.

---

## 5. Trust Hierarchy

1. **{{USER_NAME}} (human)** — final authority
2. **{{ORCHESTRATOR_NAME}} (orchestrator)** — assigns tasks, makes day-to-day calls
3. **Agent autonomy** — execute within role scope without asking permission

---

## 6. HITL Protocol

These actions require human confirmation before executing:
- Config changes
- Sending emails or external communications
- Deleting files (use `trash` over `rm`)
- API calls with cost implications
- Deploying to production
- Merging PRs, closing issues, force-pushing
- Any action where "undo" requires significant effort

**Button pattern:** Always include `reusable: true` and `allowedUsers: ["{{USER_DISCORD_ID}}"]`

---

## 7. Memory Protocol

- **Boot:** Read MEMORY.md → daily notes (today + yesterday) → shared digest
- **During work:** Write to `memory/YYYY-MM-DD.md`
- **Always use absolute paths**

---

## 8. Inter-Agent Communication

- **@-mention** the agent you want a response from
- **No @-mention = NO_REPLY** — observe silently
- **Don't pile on** — if the orchestrator answered, don't repeat it

---

## 9. Output Format

**Discord messages:**
- No markdown tables (they don't render) — use bullet lists
- Max 3-5 lines for #general summaries
- Full details go to your own channel or to files
