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

> Coming soon: observability (Grafana), Kargo, Netbird/sso)

---

<!-- _class: demo -->

## Creating a new app

<object class="fragment-svg" type="image/svg+xml" data="diagrams/grove-register.svg" style="width:1000px;height:491px;"></object>

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

## New app — existing repo

1. Developer already has a local git repo with some code
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

<video controls src="demos/grove-register.mp4" style="max-width:1000px;max-height:500px;"></video>

---

<!-- _class: demo -->

## PR preview environments

![w:1000](diagrams/pr-preview.svg)

---

<!-- _class: demo -->

## PR preview — recording

<video controls src="demos/pr-preview.mp4" style="max-width:1000px;max-height:500px;"></video>

---

<!-- _class: demo -->

## Pushing a feature to prod

![w:1000](diagrams/push-to-prod.svg)

---

<!-- _class: demo -->

## Push to prod — the steps

Once the PR looks good on the preview env:

1. Merge the PR — that's the only click the developer makes
2. Forgejo Actions runs post-merge — docker build + push image
3. ArgoCD sees the manifest update, syncs to cluster
4. Rolling update → new version live

> One click to merge. The rest is automatic.

---

<!-- _class: demo -->

## Push to prod — recording

<video controls src="demos/push-to-prod.mp4" style="max-width:1000px;max-height:500px;"></video>

---

## What we just saw

- **New app** — local repo to deployed app with one CLI command
- **Ship a feature** — `git push` and the platform does the rest
- Everything is GitOps. Everything is SSO. No tickets, no waiting.

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

  document.querySelectorAll('object.fragment-svg').forEach(obj => {
    const init = () => resetFragments(obj);
    if (obj.contentDocument && obj.contentDocument.readyState === 'complete') init();
    obj.addEventListener('load', init);
  });

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
    if (e.target && /^(INPUT|TEXTAREA|SELECT)$/.test(e.target.tagName)) return;
    if (e.ctrlKey || e.metaKey || e.altKey) return;

    const frags = activeSvgFragments();
    if (frags.length === 0) return;

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
  }, true);
})();
</script>
