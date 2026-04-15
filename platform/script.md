
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
- create a new app from scratch
-- run `grove init my-app` to scaffold a hello world app with Dockerfile, CI config, and k8s manifests
-- run `grove register` to register the app with the platform
-- operator creates repo in forgejo, registers in argo, starts build pipeline, deploys app

- create a new app (existing repo)
-- user already has a local git repo with code
-- run `grove register` to register the app with the platform
-- operator creates repo in forgejo, registers in argo, starts build pipeline, deploys app

- push a feature to prod
-- developer makes a change locally
-- pushes to main
-- build pipeline picks it up, builds new image, deploys to prod
-- show the whole flow from git push to running in prod

- (optional) PR environment
-- developer creates a branch and opens a PR
-- platform spins up a preview environment for that PR
-- reviewer can see the changes running live before merging


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

### 3. Demo: Onboarding a new developer (~7 min)
- walk through the onboarding flow live:
  1. create a new user in zitadel
  2. user installs netbird vpn client
  3. user logs in to the vpn
  4. show that they can now access all internal services — forgejo, argocd, netbird dashboard — all with SSO
  5. tease kubectl access — "and one more command gets them onto the cluster"
- emphasize: this is the whole onboarding, no tickets, no waiting for access, no separate credentials per service

#### 3a. kubectl access (drill-down)
- this is the moment where the SSO story lands properly — same identity all the way to the cluster
- walk through:
  1. run `grove kubeconfig --merge --context-name dev` — the CLI fetches the kubeconfig from a service inside the cluster, reachable only over the VPN, and merges it into the user's existing `~/.kube/config`
  2. run `kubectl get ns` — first call opens a browser for the Zitadel login, token gets cached locally, subsequent calls are instant
  3. point at the namespaces — the user sees what their Zitadel groups give them access to, no more, no less
- payoff to highlight:
  - no secrets in shell history, no kubeconfig fragments shared in slack, no copy-paste of tokens
  - rotate the password in zitadel and every future kubectl session re-auths
  - same identity / same groups in kubectl, ArgoCD, Forgejo — RBAC is one mental model
- if a question comes up about how the discovery works: the kubeconfig is published by a small service inside the cluster, only resolvable over the netbird overlay, and the kubeconfig itself uses kubelogin (the standard kubernetes OIDC exec plugin) to do the actual auth against zitadel

### 4. Demo: Creating a new app (~8 min)
- this is the main demo, the "wow" moment
- two paths to show: scaffold from scratch, or bring your own code

#### 4a. From scratch
- walk through:
  1. run `grove init my-app` — scaffolds a hello world app
  2. show what you get: working web page, Dockerfile, CI pipeline config, kubernetes manifests
  3. run `grove register` — registers the app with the platform
  4. operator does its thing: creates repo in forgejo, registers in argocd, kicks off build, deploys
  5. show the hello world app running in prod
- this is the "i have nothing and now i have a running app" path

#### 4b. Existing repo
- walk through:
  1. developer already has a local git repo with some code
  2. run `grove register`
  3. same operator flow: forgejo repo, argocd registration, build pipeline, deploy
  4. show the app running
- point out how the operator (that Håvard just explained) is what makes this possible
- this is the realistic flow — most developers already have code before they come to the platform

### 5. Demo: Pushing a feature to prod (~5 min)
- now that we have an app registered, lets show the day-to-day workflow
- walk through:
  1. make a small change to the app locally
  2. git push to main
  3. show the build pipeline picking it up automatically
  4. watch the new version get built and deployed to prod
- emphasize: the developer just pushes code, the platform handles the rest
- this is the "normal tuesday" demo — what it feels like to actually work with the platform every day

### 6. (Optional) Demo: PR preview environments (~3 min)
- only include if we get this working in time
- walk through:
  1. developer creates a branch and opens a PR
  2. platform automatically spins up a preview environment for that PR
  3. show the preview environment running with the changes
  4. reviewer can click a link and see the changes live
- if not ready, skip this — its a nice-to-have, not critical to the narrative

### 7. Wrap up & pitch (~3 min)
- recap what we just saw: onboarding in minutes, app scaffolded with `grove init`, registered with `grove register`, feature shipped with a git push, everything gitops, everything SSO
- connect back to BK's pitch: this is what an internal developer platform can do for your teams
- the pitch: we've built this a few times now, we have a working platform we use as a starting point
- we're not selling a product — we're selling ourselves as an enabling team
- we come in, help you kick-start your own platform, transfer knowledge, and leave you self-sufficient
- call to action: if you're thinking about building a platform, or if you've already started and need help, talk to us

## Time budget
- total: ~27 min (leaving room for the demo gods to be unkind)
- intro & context: 2 min
- platform overview: 3 min
- demo onboarding (incl. kubectl drill-down): 7 min
- demo create app (scaffold + existing): 8 min
- demo push to prod: 5 min
- (optional PR environments: 3 min)
- wrap up & pitch: 3 min

