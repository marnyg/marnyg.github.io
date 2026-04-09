
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
-- TODO

