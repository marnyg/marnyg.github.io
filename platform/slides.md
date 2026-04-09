---
marp: true
theme: platform
paginate: true
footer: "Internal Developer Platform — Live Demo"
---

<!-- _class: lead -->
<!-- _paginate: false -->
<!-- _footer: "" -->

# The Platform Experience

## From zero to production in minutes

---

## Who am I?

- Marius — developer & platform engineer
- Part of a small team building an internal developer platform at our consultancy
- Today: showing you what it actually **feels like** to use this thing

---

## Where we are in the series

1. **BK** introduced internal developer platforms — the *why*
2. **Havard** showed the operator magic under the hood — the *how*
3. **Me** — tying it all together with a live demo — the *what it feels like*

> Today is all about the developer experience. No infra knowledge needed.

---

## Platform overview

Kubernetes at the core. GitOps everything.

- **ArgoCD** — CI/CD and GitOps
- **Zitadel** — identity & SSO (self-hosted, can federate Entra ID etc.)
- **Netbird** — self-hosted VPN for internal network access
- **Forgejo** — git hosting
- Supporting cast: Vault, Postgres operator, External DNS, Cert-manager, Dagger, Karpenter

---

## How it all fits together

- Tiny Terraform/Pulumi bootstrap to get the cluster up
- Everything else is GitOps from there — ArgoCD manages the full stack
- One identity provider (Zitadel) handles SSO across all services
- One VPN (Netbird) handles all internal access

> Coming soon: observability (Grafana), image updater, Kargo

---

<!-- _class: demo -->

## Onboarding a new developer

The whole flow, no tickets, no waiting, no separate credentials.

---

<!-- _class: demo -->

## Onboarding — the steps

1. Create a new user in Zitadel
2. User installs the Netbird VPN client
3. User logs in to the VPN
4. User can access all internal services — Forgejo, ArgoCD, Netbird dashboard — **all with SSO**
5. User can access `kubectl` for the cluster — also via SSO

> That's the entire onboarding. One identity, access to everything.

---

<!-- _class: demo -->

## Creating a new app

This is the "wow" moment — going from local code to deployed app.

---

<!-- _class: demo -->

## New app — the steps

1. Developer already has a local git repo with some code
2. Run the CLI: `register app in platform`
3. The operator kicks in:
   - Creates repo in Forgejo
   - Registers the app in ArgoCD
   - Kicks off the build pipeline
   - Deploys the app
4. App is running, accessible, deployed

> One command. The operator (that Havard just explained) makes this possible.

---

<!-- _class: demo -->

## Pushing a feature to prod

The "normal Tuesday" demo — what day-to-day actually looks like.

---

<!-- _class: demo -->

## Push to prod — the steps

1. Make a change to the app locally
2. `git push` to main
3. Build pipeline picks it up automatically
4. New version gets built and deployed to prod

> The developer just pushes code. The platform handles the rest.

---

<!-- _class: demo optional -->

## PR preview environments

1. Developer creates a branch and opens a PR
2. Platform automatically spins up a preview environment
3. Reviewer clicks a link and sees the changes running live
4. Merge when happy — preview gets cleaned up

> Reviewers can see changes running before they hit main.

---

## What we just saw

- **Onboarding** — new developer productive in minutes, not days
- **New app** — local repo to deployed app with one CLI command
- **Ship a feature** — `git push` and the platform does the rest
- Everything is GitOps. Everything is SSO. No tickets, no waiting.

---

## What we're offering

We're not selling a product.

We're selling ourselves as an **enabling team**.

- We've built this a few times now
- We have a working platform we use as a starting point
- We come in, help you kick-start your own platform, transfer knowledge, and leave you self-sufficient

---

<!-- _class: lead -->
<!-- _paginate: false -->
<!-- _footer: "" -->

# Thinking about building a platform?

## Already started and need help?

### Let's talk.
