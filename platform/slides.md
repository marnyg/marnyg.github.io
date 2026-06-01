---
marp: true
theme: platform
paginate: true
html: true
footer: "Internal Developer Platform — Live Demo"
---

<!-- _class: lead -->
<!-- _paginate: false -->
<!-- _footer: "" -->

# The platform experience

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
3. **Me** — tying it all together with a live demo — *what using a platform is like*

> This presentation is all about the developer experience.

---

## Platform overview

Kubernetes at the core. GitOps everything.

- **ArgoCD** — CI/CD and GitOps
- **Zitadel** — identity & SSO (self-hosted, can federate Entra ID etc.)
- **Netbird** — self-hosted VPN for internal network access
- **Forgejo** — git hosting

---

## How it all fits together

- Tiny Terraform/Pulumi bootstrap to get the cluster up
- Everything else is GitOps from there — ArgoCD manages the full stack
- One identity provider (Zitadel) handles SSO across all services
- One VPN (Netbird) handles all internal access

> Coming soon: observability (Grafana), Kargo

---

## The tools, in one picture

<object class="fragment-svg" type="image/svg+xml" data="diagrams/platform-overview.svg" style="width:1000px;height:436px;"></object>

---

## What we'll demo

1. **Onboarding** — get a new developer onto the cluster
2. **New app** — from scratch or existing repo, one CLI command
3. **PR preview environments** — a live environment for every branch
4. **Push to prod** — `git push`, the platform takes it from there

---

<!-- _class: demo -->

## Onboarding a new developer

<object class="fragment-svg" type="image/svg+xml" data="diagrams/onboarding.svg" style="width:1000px;height:400px;"></object>

---

<!-- _class: demo -->

## Onboarding — the steps

> Starting point: the user already exists in Zitadel.

1. User installs the Netbird VPN client and logs into the VPN
2. User opens Forgejo / ArgoCD / Netbird dashboard — single sign-on via Zitadel
3. User runs `kubectl` against the cluster — same identity, one more command

> One identity, access to everything. Let's zoom in on that last step.

---

<!-- _class: demo -->

## `kubectl` access — one command

<object class="fragment-svg" type="image/svg+xml" data="diagrams/kubectl-auth.svg" style="width:950px;height:432px;"></object>

---

<!-- _class: demo dense -->

## `kubectl` — the steps

1. Run: `grove targets add dev --domain <your-cluster.example.com>`
   - Fetches the kubeconfig from `kubeconfig.<domain>` over the VPN
   - Merges it into your existing `~/.kube/config` and switches the active target
2. Run `kubectl get ns`
   - First call opens a browser → Zitadel login → token cached locally
   - Subsequent calls are instant
3. The user's Zitadel groups become Kubernetes groups — same RBAC across the whole platform

> Nothing sensitive in shell history. Rotate the password in Zitadel and every kubectl session re-auths.

---

<!-- _class: demo -->

## `kubectl` — recording

<video controls src="demos/kubeconfig-over-netbird-sso.mov" style="max-width:1000px;max-height:500px;"></video>

---

<!-- _class: demo -->

## New app — from scratch

1. Run the CLI: `grove init my-app`
2. CLI templates out a hello world app with everything you need:
   - Working web page
   - Dockerfile
   - CI pipeline config
   - Kubernetes manifests
3. Run: `grove register`
4. App is live — hello world running in prod

---

<!-- _class: demo -->

## Creating a new app

<object class="fragment-svg" type="image/svg+xml" data="diagrams/grove-register.svg" style="width:1000px;height:491px;"></object>

---

<!-- _class: demo -->

## New app — existing repo

1. Repo needs the right shape: `Dockerfile`, `config/` manifests, `.forgejo/workflows/build.yml` — copy from a `grove init` scaffold if missing
2. Run the CLI: `grove register`
3. The operator kicks in:
   - Creates repo in Forgejo
   - Registers the app in ArgoCD
   - Kicks off the build pipeline
   - Deploys the app
4. App is running, accessible, deployed

---

<!-- _class: demo -->

## `grove register` — recording

<video controls src="demos/register-new-app.mov" style="max-width:1000px;max-height:500px;"></video>

---

<!-- _class: demo -->

## PR preview environments

<object class="fragment-svg" type="image/svg+xml" data="diagrams/pr-preview.svg" style="width:1000px;height:400px;"></object>

---

<!-- _class: demo -->

## PR preview — recording

<video controls src="demos/pr-env.mov" style="max-width:1000px;max-height:500px;"></video>

---

<!-- _class: demo -->

## PR into prod — the steps

1. Merge to main
2. **Kargo** picks it up and drives promotion: `tst → prd`, with a gate in between
3. Each stage is GitOps — Kargo writes the promotion, ArgoCD reconciles
4. Nothing reaches prod without passing the gate

> You merge. The pipeline does the rest — safely.

---

<!-- _class: demo -->

## Getting a PR into prod

<object class="fragment-svg" type="image/svg+xml" data="diagrams/push-to-prod.svg" style="width:1000px;height:382px;"></object>

---

<!-- _class: demo -->

## PR into prod — recording

<video controls src="demos/gated-release-pipeline.mov" style="max-width:1000px;max-height:500px;"></video>

---

<!-- _class: dense -->

## Under the hood — Kargo × ArgoCD × Image Updater

<object type="image/svg+xml" data="diagrams/kargo-release-flow.svg" style="width:880px;height:479px;"></object>

---

<!-- _class: dense -->

## Why this shape

- Every commit on the release branch is a **release candidate** — Kargo's Warehouse turns it into freight
- **tst** auto-promotes to HEAD; **stg** and **prd** are manual promotions through the gate
- Each Stage pins its ArgoCD App to a **specific SHA** — never tracking a moving branch HEAD
- **Image Updater** (cluster singleton) commits image-tag bumps back to git — release branch + every PR branch
- Feature branches with no open PR are invisible to the deploy stack — no App, no Image Updater

---

<!-- _class: demo -->

## Self-service Grafana dashboards

- Define a dashboard as a Kubernetes resource via the **Grafana operator**
- Commit it with your app — dashboards are versioned alongside the code
- The operator reconciles it into Grafana, no clicking through the UI

---

<!-- _class: demo -->

## Self-service Grafana — recording

<video controls src="demos/self-service-grafana-dashboard.mov" style="max-width:1000px;max-height:500px;"></video>

---

<!-- _class: demo -->

## Self-service OIDC

- App owners request an OIDC client through our **OIDC CRD**
- The operator provisions the client in **Zitadel** and wires up SSO
- Your app gets SSO without a ticket — same identity as the rest of the platform

---

<!-- _class: demo -->

## Self-service OIDC — recording

<video controls src="demos/self-service-oidc.mov" style="max-width:1000px;max-height:500px;"></video>

---

## What we just saw

- **Onboarding** — new developer productive in minutes, not days
- **New app** — local repo to deployed app with one CLI command
- **Ship a feature** — `git push` and the platform does the rest
- **Gated releases, dashboards, SSO** — all self-service, all GitOps
- Everything is GitOps. Everything is SSO. No tickets, no waiting.

---

## Possible expansions

- **OpenTelemetry** — traces + metrics out of the box
- **Better golden paths** — more scaffold templates, more languages
- **OPA Gatekeeper** — policy guardrails for tenants
- **External Secrets** — OpenBAO-backed secret injection per app
- **FinOps** — cost attribution per team / app

> The platform is a starting point — these are the next obvious moves.

---

## The relationship we're looking for

We work as an **enabling team** — not a product vendor.

- We bring a reference platform, not a product
- We pair with your existing or new internal platform team
- Together we implement and tune it to your stack, policies, and specific needs
- We transfer the reasoning, document the hard parts, and leave when your team owns it end-to-end

> Success: you end up with a platform that fits — and a team that doesn't need us.

---

<!-- _class: lead -->
<!-- _paginate: false -->
<!-- _footer: "" -->

# Thinking about building a platform?

## Already started and need help?

### Let's talk.

<script>
(() => {
  const ADVANCE_KEYS = new Set([' ', 'ArrowRight', 'PageDown', 'Enter']);
  const REWIND_KEYS  = new Set(['ArrowLeft', 'PageUp', 'Backspace']);

  const fragmentsIn = (obj) => {
    try {
      const frags = Array.from(obj.contentDocument.querySelectorAll('[data-fragment]'));
      frags.sort((a, b) =>
        parseInt(a.getAttribute('data-fragment'), 10) -
        parseInt(b.getAttribute('data-fragment'), 10));
      return frags;
    } catch { return []; }
  };

  const activeSvgFragments = () => {
    const slide = document.querySelector('svg.bespoke-marp-active');
    if (!slide) return [];
    const objs = Array.from(slide.querySelectorAll('object.fragment-svg'));
    return objs.flatMap(fragmentsIn);
  };

  const resetFragments = (obj) => {
    fragmentsIn(obj).forEach(f => f.classList.remove('shown'));
  };

  // When an <object> SVG loads, pre-hide its fragments (CSS already does this,
  // but we also clear any .shown class in case of re-entry).
  document.querySelectorAll('object.fragment-svg').forEach(obj => {
    const init = () => resetFragments(obj);
    if (obj.contentDocument && obj.contentDocument.readyState === 'complete') init();
    obj.addEventListener('load', init);
  });

  // Reset fragments in all SVGs whenever the active slide changes.
  // Bespoke navigates via history.replaceState (no hashchange/popstate),
  // so we watch for the `bespoke-marp-active` class toggling on slide roots.
  const slideObserver = new MutationObserver(() => {
    document.querySelectorAll('object.fragment-svg').forEach(resetFragments);
  });
  const startObserving = () => {
    document.querySelectorAll('svg.bespoke-marp-slide').forEach(slide => {
      slideObserver.observe(slide, { attributes: true, attributeFilter: ['class'] });
    });
  };
  if (document.readyState !== 'loading') startObserving();
  else document.addEventListener('DOMContentLoaded', startObserving);

  window.addEventListener('keydown', (e) => {
    // Ignore when typing into inputs (presenter notes etc)
    if (e.target && /^(INPUT|TEXTAREA|SELECT)$/.test(e.target.tagName)) return;
    if (e.ctrlKey || e.metaKey || e.altKey) return;

    const frags = activeSvgFragments();
    if (frags.length === 0) return; // no fragments on current slide — let Marp handle it

    if (ADVANCE_KEYS.has(e.key)) {
      const next = frags.find(f => !f.classList.contains('shown'));
      if (next) {
        next.classList.add('shown');
        e.preventDefault();
        e.stopPropagation();
      }
    } else if (REWIND_KEYS.has(e.key)) {
      const shown = frags.filter(f => f.classList.contains('shown'));
      if (shown.length) {
        shown[shown.length - 1].classList.remove('shown');
        e.preventDefault();
        e.stopPropagation();
      }
    }
  }, true); // capture phase, runs before bespoke
})();
</script>
