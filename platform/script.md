
# context: 
Ok, I'm preparing for a presentation that i will be holding in about a month. The presentation is about a internal developer platform that me and a couple of others are developing at our software consultancy company.

We will be having a total of three presentations. The first one by my colleague named BK will be a general introduction and pitch of internal developer platforms, then my other colleague named Håvard will be showing of some technical muscles by explaining and showing off how custom operators work in kubernets, and these sort of stuff we can do with them, since we are using them extensively in our platform mvp, that i will be showing off.

I show of demo of the platform as it is currently implemented, i focusing on the developer experience and the automated workflows that we have built into the platform. The idea is to show how a developer can go from zero to a running application in a matter of minutes, without having to worry about the underlying infrastructure.

The end goal of this is that we would like to attract companies that are also working on creating or looking to work on their own internal developer platforms. Then we would pitch our selves as "enabling teams" as a service. That is we are selling ourselves as competency and a way to kick-start a companies development of a in-house platform, since we have done it a few times now, and we have our own platform to use as a template

When you are creating a presentation based on this document, make sure to use the marp tool, and keep the styling in a separate CSS file, such that we can sync styles with the rest of the team once we get that far. Also, try to mimic my writing voice and style as much as possible

# Details

## Platform details
- the entire platform is kubernetes based
- we have a tiny terraform/pulumi bootstrap
- we use argocd for ci/cd and do gitops for everything 
- for user management and security, we use zitadel as a oauth server. this lets us be flexible and lets us both self host a identity provider, and  allows for federating in external identity providers like Entra id
- for internal network access, we use a self hostet netbird 
- and a smattering of other tools like: vault, postgress perator, external dns, cert-manager, dagger ,and some details around karpenter and node pools
- eventulay also: observability (grafana), image updater, kargo, 


## user stories
### onboard new developer
- create new user in zitadel
- User installs netbird vpn
- User logs in to vpn
- User can access internal services(forgjo, argo, netbird, etc) all with SSO
- User can access Kubectl for cluster via SSO

### for developers
- create a new app(remote first)
-- use cli -> new app
-- operator creates repo in forgejo, registers in argo, starts build pipeline, deploys app
-- user clones repo, or cli creates local folder

- create a new app(local repo first)
-- user creates local git repo
-- use cli -> register app in platform
-- operator creates repo in forgejo, registers in argo, starts build pipeline, deploys app

- possibly local devlopment if we get that far, (not critical)


# Script outline

## Structure
This is the third and final presentation in the series. BK has already introduced and pitched internal developer platforms in general, Håvard has shown off the technical details around custom kubernetes operators. My job is to tie it all together with a live demo showing the actual developer experience — what it feels like to use the platform day to day.

The overall arc: start by quickly anchoring the audience on what we've built, then walk through the two main user stories as live demos, and finish with a pitch for how we can help them do the same thing.

## Outline

### 1. Intro & context setting (~2 min)
- quick intro, who am i, what am i showing today
- recap: BK talked about why platforms matter, Håvard showed the operator magic under the hood
- now im going to show you what it actually looks like from the developer's perspective
- the goal: zero to running app in minutes, no infra knowledge needed

### 2. Platform overview (~3 min)
- high level architecture slide — kubernetes at the core, gitops everything
- quick rundown of the key pieces:
  - argocd for ci/cd and gitops
  - zitadel for identity/SSO (flexible, self-hosted, can federate external IdPs like Entra ID)
  - netbird for internal network access
  - forgejo for git hosting
  - the supporting cast: vault, postgres operator, external dns, cert-manager, dagger, karpenter
- tiny terraform/pulumi bootstrap to get the cluster up, then everything else is gitops from there
- mention what's coming: observability (grafana), image updater, kargo

### 3. Demo: Onboarding a new developer (~5 min)
- walk through the onboarding flow live:
  1. create a new user in zitadel
  2. user installs netbird vpn client
  3. user logs in to the vpn
  4. show that they can now access all internal services — forgejo, argocd, netbird dashboard — all with SSO
  5. show kubectl access to the cluster via SSO
- emphasize: this is the whole onboarding, no tickets, no waiting for access, no separate credentials per service

### 4. Demo: Creating a new app — remote first flow (~7 min)
- this is the main demo, the "wow" moment
- walk through:
  1. use the cli: `new app`
  2. show what the operator does behind the scenes:
     - creates repo in forgejo
     - registers the app in argocd
     - kicks off the build pipeline
     - deploys the app
  3. user clones the repo and starts working
- show the app actually running, accessible, deployed — all from one cli command
- point out how the operator (that Håvard just explained) is what makes this possible

### 5. Demo: Creating a new app — local repo first flow (~3 min)
- alternative flow for when the developer already has code locally
- walk through:
  1. user has a local git repo already
  2. use the cli: `register app in platform`
  3. same operator magic kicks in — repo in forgejo, argocd registration, build, deploy
- show that both flows end up in the same place — a fully deployed, managed app

### 6. (Optional) Local development story (~2 min)
- only include if we get this working in time
- show how the platform can help with local dev loops too
- if not ready, skip this entirely — its not critical to the narrative

### 7. Wrap up & pitch (~3 min)
- recap what we just saw: onboarding in minutes, app deployed from a single cli command, everything gitops, everything SSO
- connect back to BK's pitch: this is what an internal developer platform can do for your teams
- the pitch: we've built this a few times now, we have a working platform we use as a starting point
- we're not selling a product — we're selling ourselves as an enabling team
- we come in, help you kick-start your own platform, transfer knowledge, and leave you self-sufficient
- call to action: if you're thinking about building a platform, or if you've already started and need help, talk to us

## Time budget
- total: ~25 min (leaving room for the demo gods to be unkind)
- intro & context: 2 min
- platform overview: 3 min
- demo onboarding: 5 min
- demo remote-first app: 7 min
- demo local-first app: 3 min
- (optional local dev: 2 min)
- wrap up & pitch: 3 min

