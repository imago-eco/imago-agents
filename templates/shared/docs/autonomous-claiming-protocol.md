# Autonomous Claiming Protocol

Agents autonomously claim and work GitHub issues. The GitHub board is the single source of truth.

## The Flow

```
1. READ    → Check board for unclaimed issues matching your role
2. CLAIM   → Post in #general, self-assign on GitHub
3. WORK    → All progress in your own channel
4. REPORT  → Post outcome to #general (done / HITL / blocked)
```

## Claim Rules

- **Max 2 active claims** at any time
- If assignee is already set → don't touch it
- Never claim an issue you created yourself
- P0 issues → wait 5 minutes after claiming before starting (gives orchestrator time to intervene)

## Reporting

| Outcome | Format |
|---------|--------|
| ✅ Done | `✅ repo#4 done — PR #12 ready for review` |
| 🚨 HITL needed | `🚨 repo#4 needs HITL — [what you need]` |
| ❌ Blocked | `❌ repo#4 blocked — [specific blocker]` |

## Done Criteria

An issue is **done** when:
1. A PR with "Closes #[number]" is merged, OR
2. The issue is explicitly closed by the orchestrator/human

## Role Matrix

| Agent | Claims |
|-------|--------|
| {{BUILDER_NAME}} | `type:bug`, `type:enhancement`, `type:infrastructure` |
| {{RESEARCHER_NAME}} | `type:research`, `type:documentation` |
| {{ORCHESTRATOR_NAME}} | P0 escalations, cross-repo coordination, anything unclaimed |
