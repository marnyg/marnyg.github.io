---
marp: true
theme: platform
style: |
  .columns {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 1rem;
  }
  .columns3 {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 1rem;
  }
  .section-title {
    text-align: center;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100%;
  }
  .cli-output {
    font-size: 14px;
    background-color: #1f1d2e;
    padding: 1rem;
    border-radius: 8px;
    border: 1px solid #524f67;
  }
  .flow-step {
    background-color: #26233a;
    border-radius: 8px;
    padding: 0.8rem;
    margin: 0.3rem 0;
    border-left: 3px solid #ebbcba;
  }

---

# The Platform in Action
### Marius Nygård
Platform Engineer @Crayon Consulting

<!-- Time Goal: 0:00 -->
<!--
.  at 0:00 Intro & context setting
..      -> title
..      what we've heard so far
..      what i'll show you

.  at 2:00 Platform overview
.  at 5:00 Demo: Onboarding a new developer
.  at 10:00 Demo: Creating an app (remote first)
.  at 17:00 Demo: Creating an app (local repo first)
.  at 20:00 Wrap up & pitch
-->
---

# What we've heard so far

- **BK** talked about why internal developer platforms matter — the value prop, the philosophy
- **Håvard** showed the technical guts — custom kubernetes operators and what they let us do
- Now I'm going to show you **what it actually feels like** to use this thing

The goal: a developer goes from nothing to a running, deployed application — in minutes, without touching any infrastructure

<!-- Time Goal: 1:00 -->
<!--
.  at 0:00 Intro & context setting
..      title
..      -> what we've heard so far
..      what i'll show you

.  at 2:00 Platform overview
.  at 5:00 Demo: Onboarding a new developer
.  at 10:00 Demo: Creating an app (remote first)
.  at 17:00 Demo: Creating an app (local repo first)
.  at 20:00 Wrap up & pitch
-->
<!--
--------------------------------
Anchor the audience on where we are in the talk series
Set expectations for a demo-heavy session
Emphasize the DX angle — this is about what it feels like, not how it works
-->
---

# What i'll show you today

1. Quick look at the platform architecture
2. **Demo:** Onboarding a new developer — from zero access to full SSO
3. **Demo:** Creating a new app with one CLI command
4. **Demo:** Bringing an existing local repo into the platform
5. How we can help you build this for your teams

<!-- Time Goal: 2:00 -->
<!--
.  at 0:00 Intro & context setting
..      title
..      what we've heard so far
..      -> what i'll show you

.  at 2:00 Platform overview
.  at 5:00 Demo: Onboarding a new developer
.  at 10:00 Demo: Creating an app (remote first)
.  at 17:00 Demo: Creating an app (local repo first)
.  at 20:00 Wrap up & pitch
-->
---










<div class="section-title">
  <div>
  <h1>Platform Overview</h1>
  <h3>what are we actually working with</h3>
  </div>
</div>

<!-- Time Goal: 2:00 -->
<!--
.  at 0:00 Intro & context setting
.  at 2:00 Platform overview
..      -> section intro
..      architecture
..      the supporting cast

.  at 5:00 Demo: Onboarding a new developer
.  at 10:00 Demo: Creating an app (remote first)
.  at 17:00 Demo: Creating an app (local repo first)
.  at 20:00 Wrap up & pitch
-->
---

# Architecture at a glance

<div class="columns" style="font-size: 20px;">
  <div>

  ## The Core
  - **Kubernetes** at the center of everything
  - Tiny **Terraform/Pulumi** bootstrap to get the cluster up
  - After that, **everything is gitops** via ArgoCD
  - Custom operators (the ones Håvard showed) tie it all together

  </div>
  <div>

  ## Identity & Access
  - **Zitadel** as our OAuth/OIDC server — self-hosted, flexible
  - Can federate external identity providers (Entra ID, etc.)
  - SSO across every tool in the platform
  - **Netbird** for internal network access — self-hosted VPN

  </div>
</div>

<!-- Time Goal: 3:00 -->
<!--
--------------------------------
Emphasize that the bootstrap is tiny and everything after is gitops
Point out that zitadel lets us be flexible with identity providers
-->
---

# Architecture at a glance (cont.)

<div class="columns" style="font-size: 20px;">
  <div>

  ## Developer Tooling
  - **Forgejo** for git hosting (self-hosted, lightweight)
  - **ArgoCD** for CI/CD and deployment
  - **Dagger** for build pipelines
  - A CLI that wraps the whole developer workflow

  </div>
  <div>

  ## The Supporting Cast
  - Vault for secrets management
  - Postgres operator for databases
  - External DNS + cert-manager for automatic DNS and TLS
  - Karpenter for node management and autoscaling

  </div>
</div>

<!-- Time Goal: 3:30 -->
<!--
.  at 0:00 Intro & context setting
.  at 2:00 Platform overview
..      section intro
..      -> architecture
..      the supporting cast

.  at 5:00 Demo: Onboarding a new developer
.  at 10:00 Demo: Creating an app (remote first)
.  at 17:00 Demo: Creating an app (local repo first)
.  at 20:00 Wrap up & pitch
-->
<!--
--------------------------------
Don't go too deep on any one tool — Håvard already covered the operator details
-->
---

# What's coming next

<div class="columns" style="font-size: 20px;">
  <div>

  ## On the roadmap
  - **Observability stack** — Grafana, Prometheus, Loki
  - **Image updater** — automatic container image promotions
  - **Kargo** — GitOps promotion pipelines across environments
  - Local development story — tighter inner loop

  </div>
  <div>

  ## The point
  - The platform is a living thing, not a finished product
  - We keep adding pieces as the developer experience demands it
  - Each new piece follows the same pattern: gitops, SSO, self-hosted where it matters

  </div>
</div>

<!-- Time Goal: 5:00 -->
<!--
.  at 0:00 Intro & context setting
.  at 2:00 Platform overview
..      section intro
..      architecture
..      -> the supporting cast

.  at 5:00 Demo: Onboarding a new developer
.  at 10:00 Demo: Creating an app (remote first)
.  at 17:00 Demo: Creating an app (local repo first)
.  at 20:00 Wrap up & pitch
-->
<!--
--------------------------------
Keep this brief — its forward looking, not the main event
Mention that the platform grows based on developer needs
-->
---










<div class="section-title">
  <div>
  <h1>Demo: Onboarding a new developer</h1>
  <h3>from zero access to full SSO in minutes</h3>
  </div>
</div>

<!-- Time Goal: 5:00 -->
<!--
.  at 0:00 Intro & context setting
.  at 2:00 Platform overview
.  at 5:00 Demo: Onboarding a new developer
..      -> section intro
..      the flow
..      live demo
..      what just happened

.  at 10:00 Demo: Creating an app (remote first)
.  at 17:00 Demo: Creating an app (local repo first)
.  at 20:00 Wrap up & pitch
-->
---

# The onboarding flow

<div style="font-size: 20px;">

1. **Create user in Zitadel** — admin creates the account, assigns roles
2. **Install Netbird** — developer installs the VPN client
3. **Log in to VPN** — authenticates via Zitadel SSO
4. **Access everything** — Forgejo, ArgoCD, Netbird dashboard — all SSO
5. **kubectl access** — cluster access via SSO, no kubeconfig juggling

</div>

That's it. No tickets, no waiting, no separate credentials per service.

<!-- Time Goal: 6:00 -->
<!--
.  at 0:00 Intro & context setting
.  at 2:00 Platform overview
.  at 5:00 Demo: Onboarding a new developer
..      section intro
..      -> the flow
..      live demo
..      what just happened

.  at 10:00 Demo: Creating an app (remote first)
.  at 17:00 Demo: Creating an app (local repo first)
.  at 20:00 Wrap up & pitch
-->
<!--
--------------------------------
Walk through each step before the demo so people know what to watch for
Emphasize the "no separate credentials" point — this is a big DX win
-->
---

# Live demo: Onboarding

<!-- DEMO TIME -->
<!-- 
  1. Show Zitadel admin panel — create a new user
  2. On "developer's" machine: install netbird, log in
  3. Show access to forgejo — SSO login
  4. Show access to argocd — same SSO
  5. Show kubectl working via SSO auth
-->

<!-- Time Goal: 9:00 -->
<!--
.  at 0:00 Intro & context setting
.  at 2:00 Platform overview
.  at 5:00 Demo: Onboarding a new developer
..      section intro
..      the flow
..      -> live demo
..      what just happened

.  at 10:00 Demo: Creating an app (remote first)
.  at 17:00 Demo: Creating an app (local repo first)
.  at 20:00 Wrap up & pitch
-->
---

# What just happened

- One user account — access to everything
- **Zitadel** handles the identity, **Netbird** handles the network
- Every service trusts the same SSO provider
- If this developer leaves the company tomorrow, we disable one account and access is revoked everywhere
- The whole onboarding took less time than filling out an IT ticket

<!-- Time Goal: 10:00 -->
<!--
.  at 0:00 Intro & context setting
.  at 2:00 Platform overview
.  at 5:00 Demo: Onboarding a new developer
..      section intro
..      the flow
..      live demo
..      -> what just happened

.  at 10:00 Demo: Creating an app (remote first)
.  at 17:00 Demo: Creating an app (local repo first)
.  at 20:00 Wrap up & pitch
-->
<!--
--------------------------------
Drive home the offboarding story too — single point of revocation
Compare to the typical "submit a ticket and wait 3 days" experience
-->
---










<div class="section-title">
  <div>
  <h1>Demo: Creating a new app</h1>
  <h3>one command, fully deployed</h3>
  </div>
</div>

<!-- Time Goal: 10:00 -->
<!--
.  at 0:00 Intro & context setting
.  at 2:00 Platform overview
.  at 5:00 Demo: Onboarding a new developer
.  at 10:00 Demo: Creating an app (remote first)
..      -> section intro
..      what happens under the hood
..      live demo
..      the result
..      connecting the dots

.  at 17:00 Demo: Creating an app (local repo first)
.  at 20:00 Wrap up & pitch
-->
---

# What happens when you run `new app`

<div class="columns" style="font-size: 20px;">
  <div>

  ## What the developer does
  1. Runs the CLI: `platform new app`
  2. Answers a couple of questions (name, template, etc.)
  3. Clones the repo and starts coding

  That's it from the developer's side.

  </div>
  <div>

  ## What the platform does
  1. **Creates a repo** in Forgejo with the right template
  2. **Registers the app** in ArgoCD
  3. **Kicks off the build pipeline** via Dagger
  4. **Deploys the app** to the cluster
  5. Sets up DNS, TLS, networking — all automatic

  </div>
</div>

<!-- Time Goal: 11:30 -->
<!--
.  at 0:00 Intro & context setting
.  at 2:00 Platform overview
.  at 5:00 Demo: Onboarding a new developer
.  at 10:00 Demo: Creating an app (remote first)
..      section intro
..      -> what happens under the hood
..      live demo
..      the result
..      connecting the dots

.  at 17:00 Demo: Creating an app (local repo first)
.  at 20:00 Wrap up & pitch
-->
<!--
--------------------------------
Split the developer's view from the platform's view
Make the contrast clear — developer does almost nothing, platform does everything
Reference Håvard's talk — this is where the operators he showed actually run
-->
---

# Live demo: Creating an app

<!-- DEMO TIME -->
<!--
  1. Run `platform new app` in terminal
  2. Show the CLI interaction
  3. Switch to Forgejo — show the repo being created
  4. Switch to ArgoCD — show the app appearing and syncing
  5. Show the build pipeline running
  6. Show the deployed app in the browser
  7. Clone the repo, show the code structure
-->

<!-- Time Goal: 16:00 -->
<!--
.  at 0:00 Intro & context setting
.  at 2:00 Platform overview
.  at 5:00 Demo: Onboarding a new developer
.  at 10:00 Demo: Creating an app (remote first)
..      section intro
..      what happens under the hood
..      -> live demo
..      the result
..      connecting the dots

.  at 17:00 Demo: Creating an app (local repo first)
.  at 20:00 Wrap up & pitch
-->
---

# What we ended up with

- A **git repo** with a working app template, ready to develop on
- A **CI/CD pipeline** that builds and deploys on every push
- A **running application** with DNS, TLS, and networking — all automatic
- The developer didn't create a single yaml file, didn't configure any CI, didn't touch any infrastructure

From zero to deployed in one command.

<!-- Time Goal: 17:00 -->
<!--
.  at 0:00 Intro & context setting
.  at 2:00 Platform overview
.  at 5:00 Demo: Onboarding a new developer
.  at 10:00 Demo: Creating an app (remote first)
..      section intro
..      what happens under the hood
..      live demo
..      -> the result
..      connecting the dots

.  at 17:00 Demo: Creating an app (local repo first)
.  at 20:00 Wrap up & pitch
-->
<!--
--------------------------------
Hammer the punchline: one command, zero yaml, zero infra knowledge
This is the slide to pause on — let it sink in
-->
---










<div class="section-title">
  <div>
  <h1>Demo: Bringing an existing repo</h1>
  <h3>already have code? just register it</h3>
  </div>
</div>

<!-- Time Goal: 17:00 -->
<!--
.  at 0:00 Intro & context setting
.  at 2:00 Platform overview
.  at 5:00 Demo: Onboarding a new developer
.  at 10:00 Demo: Creating an app (remote first)
.  at 17:00 Demo: Creating an app (local repo first)
..      -> section intro
..      live demo
..      same destination

.  at 20:00 Wrap up & pitch
-->
---

# Live demo: Registering an existing app

<!-- DEMO TIME -->
<!--
  1. Show a local git repo with some existing code
  2. Run `platform register app`
  3. Show the platform picking it up — repo in forgejo, argocd registration, build, deploy
  4. Show the app running
-->

Different starting point, same result.

<!-- Time Goal: 19:00 -->
<!--
.  at 0:00 Intro & context setting
.  at 2:00 Platform overview
.  at 5:00 Demo: Onboarding a new developer
.  at 10:00 Demo: Creating an app (remote first)
.  at 17:00 Demo: Creating an app (local repo first)
..      section intro
..      -> live demo
..      same destination

.  at 20:00 Wrap up & pitch
-->
<!--
--------------------------------
Keep this shorter — the audience already understands the pattern from the previous demo
Focus on showing that it works regardless of where you start
-->
---

# Two paths, same destination

<div class="columns" style="font-size: 20px;">
  <div>

  ## Start from scratch
  - `platform new app`
  - Get a repo with a template
  - Clone and start coding
  - Already deployed

  </div>
  <div>

  ## Start from existing code
  - Have a local repo
  - `platform register app`
  - Platform picks it up
  - Already deployed

  </div>
</div>

Either way you end up with: a git repo, a CI/CD pipeline, a running app, DNS, TLS — all managed by the platform.

<!-- Time Goal: 20:00 -->
<!--
.  at 0:00 Intro & context setting
.  at 2:00 Platform overview
.  at 5:00 Demo: Onboarding a new developer
.  at 10:00 Demo: Creating an app (remote first)
.  at 17:00 Demo: Creating an app (local repo first)
..      section intro
..      live demo
..      -> same destination

.  at 20:00 Wrap up & pitch
-->
---










<div class="section-title">
  <div>
  <h1>What this means for you</h1>
  </div>
</div>

<!-- Time Goal: 20:00 -->
<!--
.  at 0:00 Intro & context setting
.  at 2:00 Platform overview
.  at 5:00 Demo: Onboarding a new developer
.  at 10:00 Demo: Creating an app (remote first)
.  at 17:00 Demo: Creating an app (local repo first)
.  at 20:00 Wrap up & pitch
..      -> section intro
..      recap
..      what we're offering
..      thank you
..      questions
-->
---

# What you just saw

- **Onboarding:** one account, SSO everywhere, VPN access, kubectl — minutes, not days
- **New app:** one CLI command → repo, CI/CD, deployment, DNS, TLS — all automatic
- **Existing app:** same result, different starting point
- **Zero infrastructure knowledge required** from the developer
- Everything is gitops, everything is SSO, everything is self-hosted where it matters

This is what an internal developer platform can do for your teams.

<!-- Time Goal: 21:30 -->
<!--
.  at 0:00 Intro & context setting
.  at 2:00 Platform overview
.  at 5:00 Demo: Onboarding a new developer
.  at 10:00 Demo: Creating an app (remote first)
.  at 17:00 Demo: Creating an app (local repo first)
.  at 20:00 Wrap up & pitch
..      section intro
..      -> recap
..      what we're offering
..      thank you
..      questions
-->
<!--
--------------------------------
Quick recap — keep it punchy
Tie back to BK's opening pitch
-->
---

# How we can help

<div class="columns" style="font-size: 20px;">
  <div>

  ## What we're offering
  - We're not selling a product — we're selling **competency**
  - We come in as an **enabling team**
  - We help you kick-start your platform using ours as a starting point
  - We've built this a few times, we know the pitfalls

  </div>
  <div>

  ## What that looks like in practice
  - We work alongside your team
  - Adapt the platform to your needs and constraints
  - Set up the patterns, then hand over the keys
  - Transfer knowledge and leave you self-sufficient
  - **You own everything**, we just helped you get there faster

  </div>
</div>

<!-- Time Goal: 23:00 -->
<!--
.  at 0:00 Intro & context setting
.  at 2:00 Platform overview
.  at 5:00 Demo: Onboarding a new developer
.  at 10:00 Demo: Creating an app (remote first)
.  at 17:00 Demo: Creating an app (local repo first)
.  at 20:00 Wrap up & pitch
..      section intro
..      recap
..      -> what we're offering
..      thank you
..      questions
-->
<!--
--------------------------------
This is the sales slide — but keep it conversational, not salesy
Emphasize enabling, not dependency
"You own everything" is the key line
-->
---

# Thanks!

<br>
<br>
<br>
<br>
<br>

<div style="font-size: 14px; color: #6e6a86; text-align: right; margin-top: 2rem; opacity: 0.8;">

  Marius Nygård - Platform Engineer @Crayon Consulting

  Contact: [Marius.Nygard@inmeta.no](mailto:Marius.Nygard@inmeta.no)
  LinkedIn: [linkedin.com/in/marius-nygård-a7b615193](https://www.linkedin.com/in/marius-nyg%C3%A5rd-a7b615193/)
</div>

<!-- Time Goal: 24:00 -->
<!--
.  at 0:00 Intro & context setting
.  at 2:00 Platform overview
.  at 5:00 Demo: Onboarding a new developer
.  at 10:00 Demo: Creating an app (remote first)
.  at 17:00 Demo: Creating an app (local repo first)
.  at 20:00 Wrap up & pitch
..      section intro
..      recap
..      what we're offering
..      -> thank you
..      questions
-->
---

# Questions?

<!-- Time Goal: 25:00 -->
<!--
.  at 0:00 Intro & context setting
.  at 2:00 Platform overview
.  at 5:00 Demo: Onboarding a new developer
.  at 10:00 Demo: Creating an app (remote first)
.  at 17:00 Demo: Creating an app (local repo first)
.  at 20:00 Wrap up & pitch
..      section intro
..      recap
..      what we're offering
..      thank you
..      -> questions
-->
