
# context:
Short 5 min lightning talk about Claude Code's new `/insights` slash command. Audience: colleagues at the consultancy who already use Claude Code daily. Goal: get them to run `/insights` themselves and treat it as a periodic coaching loop.

I'll use my own report as a live example — it's in `report.html` next to these slides.

Use Marp. Keep CSS in a separate file (`theme.css`) so we can sync styles with the rest of the team later. Same Catppuccin Mocha theme as the platform deck for consistency.

# Outline

## 1. The hook (~30s)
- claude code can now read its own logs and tell you how *you* use it
- one slash command: `/insights`
- 270h of my sessions, summarized into a coaching report

## 2. What it actually does (~45s)
- crawls your local session history (no data leaves your machine)
- categorizes work areas, tool usage, friction events, satisfaction
- outputs an HTML report — what's working, what's hindering, what to try next

## 3. My report at a glance (~60s)
- open `report.html`
- 57 sessions, 465 messages, 270h, 68 commits — over ~2 months
- 5 project areas it identified — multi-cloud infra, k8s/argocd, go/python, docs, nix tooling
- the "interaction style" paragraph reads scarily accurate

## 4. The useful bits — friction (~60s)
- categorized failure modes with concrete examples
- mine: wrong approach 24×, buggy code 20×, misaligned git workflow
- examples are pulled from actual sessions, not generic

## 5. The useful bits — suggestions (~45s)
- CLAUDE.md additions with copy-pasteable text and the *why*
- features to try (custom skills, hooks, task agents) tailored to my patterns
- usage patterns with copyable prompts

## 6. The fun part (~30s)
- every report ends with the most embarrassing moment claude caught itself in
- mine: claude confidently invented AWS Trainium 3 availability while i was drafting a real proposal
- humbling and useful

## 7. Why it matters / call to action (~30s)
- this is a coaching loop — claude reading your patterns and proposing better workflows
- run it every couple weeks, treat suggestions as a backlog
- one command. try it: `/insights`

# Time budget
- total: ~5 min
- hook: 30s
- what it does: 45s
- live example: 60s
- friction bits: 60s
- suggestions bits: 45s
- fun ending: 30s
- wrap & CTA: 30s
- ~30s buffer for Q&A or demo gods being unkind
