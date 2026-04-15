---
marp: true
theme: claude-insights
paginate: true
footer: "Know Thyself — /insights"
---

<!-- _class: lead -->
<!-- _paginate: false -->
<!-- _footer: "" -->

# Know Thyself

## What `/insights` knows about how you work

---

## The hook

- Claude Code can now read its own logs and coach you on how you use it
- One command: `/insights`
- It crawled 270h of my sessions and handed me a report card

---

## What it actually does

- Crawls your local Claude Code session history
- Categorizes work areas, tool usage, friction events, satisfaction
- Outputs an HTML report: what's working, what's hindering, what to try next

> No data leaves your machine. Pure local analysis.

---

<!-- _class: live -->

## My report at a glance

<div class="stats">
  <div class="stat"><span class="num">57</span><span class="label">sessions</span></div>
  <div class="stat"><span class="num">270h</span><span class="label">across ~2 months</span></div>
  <div class="stat"><span class="num">465</span><span class="label">messages</span></div>
  <div class="stat"><span class="num">68</span><span class="label">commits shipped</span></div>
</div>

> `report.html` is right next to these slides — open it during Q&A.

---

## What it surfaced — project areas

Five distinct work areas, identified from session content:

- **Multi-cloud infra & deployment pipelines** (12 sessions)
- **Kubernetes platform & ArgoCD** (8 sessions)
- **Go & Python application development** (7 sessions)
- **Technical writing & business documents** (5 sessions)
- **Developer environment & tooling — Nix/macOS** (4 sessions)

> The "interaction style" paragraph reads scarily accurate.

---

## The useful bits — friction analysis

Categorized failure modes, with examples pulled from actual sessions:

- **Wrong initial approach** — 24×
  *(e.g. created baseline HTTPRoutes in the operator instead of the app scaffold)*
- **Iterative debug loops from buggy first implementations** — 20×
- **Misaligned git workflow assumptions** — pushed when I wanted a rebase

---

## The useful bits — suggestions

Each one comes with copy-pasteable text:

- **CLAUDE.md additions** — concrete rules, with the *why* spelled out
- **Features to try** — custom skills, hooks, task agents — tailored to my patterns
- **Usage patterns** — prompts I can drop straight into my next session

> Not generic advice. Built from what I actually do.

---

## The fun part

Every report ends with the most embarrassing moment Claude caught itself in.

> Claude confidently told me AWS Trainium 3 was available via capacity blocks — it wasn't — and casually slipped in a claim that FP4 was a "Trainium 4 feature" that doesn't exist yet.

I was drafting a real proposal at the time. Humbling.

---

## Why it matters

- A **coaching loop** — Claude reads your patterns and proposes better workflows
- Run it every couple weeks
- Treat the suggestions as a backlog — try one CLAUDE.md rule or one skill at a time
- Cheaper than a retro

---

<!-- _class: lead -->
<!-- _paginate: false -->
<!-- _footer: "" -->

# Try it

## `/insights`

### Then send me your fun ending.
