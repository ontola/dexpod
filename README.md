# DexPod

The DexPod is a [Solid Pod](https://solidproject.org/) server implementation written in Ruby, powered by [Linked-Rails](https://github.com/ontola/linked_rails).
Solid is a set of specifications, building on RDF (Linked Data) to give people more control over their data.

Thanks to [Dexes](https://dexes.nl) and [SIDN Fonds](https://www.sidnfonds.nl/projecten/solid-starter) for funding this project.

## Compliance with Solid Spec

Since the [specification of Solid](https://solid.github.io/specification/) itself and the related specs are still a work in progress, it is impossible to fully comply at this moment.
However, some parts of the specification have been stable for some time and are unlikely to change.

- [x] HTTP content-type negotiation
- [x] Various RDF serialization formats (Turtle, N3, N-Triples, HexTuples)
- [x] [WebID-OIDC](https://solid.github.io/specification/webid-oidc/) for authentication
- [ ] [Linked Data Notifications](https://www.w3.org/TR/ldn/) ([issue #26](https://gitlab.com/ontola/dexpod/-/issues/26)
- [ ] ACL
- [ ] Posting arbitrary RDF documents

## Extra functionality

The DexPod provides some features that are not (yet) included in the Solid specification:

- **State synchronization** of RDF using [linked-deltas](https://github.com/ontola/linked-delta)
- **DataDeals**: formal agreements between data sharers and users, powered by [the W3C ODRL spec](https://www.w3.org/TR/odrl-model/)
- **Solid-Drive**: Easy way to manage files and folders
- **DCAT management**: Describe & share DCAT dataset descriptions / metadata.

## Setup
We use nginx internally ('devproxy') to provide reverse-proxying and TLS connections, where all traffic is routed to libro (the frontend) and requests to `/link-lib/bulk` are routed to the cache. Using the dexpod without these is possible, [`/rails/info/routes`](https://guides.rubyonrails.org/routing.html#listing-existing-routes) should list all possible API endpoints (subject to change). Nearly all endpoints require authentication, you'll have to generate a token first ().

- Clone the appropriate projects:
  - Clone the dexpod project
  - Clone libro on the same branch (not public yet)
  - Clone the cache on the same branch (not public yet)
- Create a `.env` file in dexpod based on the `.env.template`.
  - Devproxy users: copy most values form that `.env`
  - The hostname is up to you, eg `dexes.localdev`
  - `OIDC_SUBJECT_SALT` should be random (eg. `bundle exec rake secret`)
  - `OIDC_KEY` is a private key on a single line, so convert newlines to literal `\n`. The key can be generated with `ssh-keygen -t rsa -b 4096 -m pem` ensure its type is `RSA PRIVATE KEY`. (Eg. `-----BEGIN RSA PRIVATE KEY-----\n[...]\n-----END RSA PRIVATE KEY-----\n`)
  - Create OAuth2 app credentials for your client by setting `LIBRO_CLIENT_ID` and `LIBRO_CLIENT_SECRET` which are created on database initialization.
  - The first bearer token with administrative privileges can be set in the same way via `RAILS_OAUTH_TOKEN`.
- Devproxy users: Add the chosen hostname and a wildcard variant (Eg `*.dexes.localdev`) to `nginx.template.conf` as the `server_name`. The devproxy will regenerate the nginx.config from the template on restarting the devproxy.
- Set the hostnames to resolve locally, either
  - Add the chosen hostnames to `/etc/hosts`. Add them on a [single line in OSX](https://stackoverflow.com/questions/10064581/how-can-i-eliminate-slow-resolving-loading-of-localhost-virtualhost-a-2-3-secon). Don't forget all domains for tests and demo, since /etc/hosts doesn't accept wildcardds (Eg. `my.dexes.localdev`, `test.dexes.localdev`).
  - [Automatically route all `localdev` domains](https://qiita.com/bmj0114/items/9c24d863bcab1a634503)
- Ontola internal: Shut the Apex backend down. Dexpod runs on the same port.
- Create and [initialize the database](https://guides.rubyonrails.org/active_record_migrations.html) `bundle exec rake db:setup`
- Start Dexpod (`RAILS_ENV=production` for production mode)
  - `RAILS_ENV=development bundle exec rails s -b 0.0.0.0 -p 3000`
  - Devproxy users: Reboot devproxy `./dev.sh`

## Demo
- bezoek https://dexes.localdev
- registreer nieuw account
- kies podnaam en html kleur
- ga naar https://[podnaam].dexes.localdev en zie dat je gekozen kleur wordt gebruikt.
- ga naar https://pheyvaer.github.io/solid-chess/
- klik op login
- voer dexes.localdev in om mee in te loggen
- je bent nog ingelogd op dexes.localdev , dus je krijgt meteen een authorizatie scherm. Accepteer
- je bent ingelogd op de schaakapp. Jouw email wordt bovenin getoond als gebruikersnaam

## Glossary
* Relying Party (RP): data.overheid.nl
* Identity Provider (OP): dexes.nl
* Resource Server (RS): [user].dexes.nl

## Summarised flow
* User want to show data from the RS on the RP.
* User logs in at the OP and gets redirected to the RP.
* The RP stores the client token it received from the OP.
* The RP makes a request to the RS with the client token.
* The RS verifies the client token and serves the resource.

This app acts as the backend of both the RS as the OP.

Apartment makes the distinction between both roles by looking at the requested domain.

The role as OP is fulfilled with the public schema. For the RS, the schema of the requested POD is used.

## WebID-OIDC Flow
See https://github.com/solid/webid-oidc-spec
1) User visits a RP (data.overheid.nl)
2) User clicks 'Login with DexPod'
3) The RP discovers the authentication configuration of the OP (dexes.nl/.well-known/openid-configuration)
4) The RP registers authorization client at the OP and receives a CLIENT_ID (dexes.nl/oauth/register)
5) User is redirected to the Authorization endpoint of the OP (dexes.nl/oauth/authorize)
6) User is not logged in at the OP, so he is redirected to a sign up/in page (dexes.nl/u/session/new)
7) User signs in or registers
8) User is now logged in at the OP
9) User is redirected back to the Authorization endpoint of the OP (dexes.nl/oauth/authorize)
10) User approves the RP
11) User is redirected to the RP with a signed ID token in the url (data.overheid.nl)
12) The RP makes a request to the RS, containing the ID token
13) The RS validates the ID Token, and extracts the WebID URI of the User from inside it ([user].dexes.nl/profile#me).
14) The RS confirms that the OP is indeed User's authorized OIDC provider (by matching the provider URI from the iss claim with User'/'s WebID).

## DataDeal flow
* User A creates a File in his pod a.dexes.nl.
* User A creates an Offer to show his File.
* User A creates Invites which are send by email.
* User B receives an Invite, opens it, and sees the Offer.
* User B logs in with his pod b.dexes.nl on a.dexes.nl.
* User B accepts the Offer. An Agreement is created in the pod a.dexes.nl.
* This Agreement has a.dexes.nl as assigner and b.dexes.nl as assignee.
* User B can now show the File, because the pod he signed in with has an Agreement to do this.
* a.dexes.nl sends an email to User A to tell about the new Agreement.
* If b.dexes.nl has an LDN inbox:
    * a.dexes.nl sends a Notification to b.dexes.nl.
    * b.dexes.nl sends an email to User B to tell about the new Notification about the Agreement.
    * b.dexes.nl stores the Agreement received by the Notification as External Agreement.
    * b.dexes.nl creates an ExternalNode to show a reference to the File in his file explorer.
* Otherwise:
    * a.dexes.nl sends an email to User B to tell about the new Agreement.

# Sign in
## On dexes.nl:
* User goes to /u/session/new.
* User sees regular login form.
* User enters username/password.
* BFE receives POST request on /login, containing password/email. (so far nothing new)
* BFE checks if openId client for current website is present. If not: discover config & register client.
* BFE posts token to the token_endpoint given by the openId config.

## On [user].dexes.nl:
* User goes to /u/session/new.
* User sees list of recommended openId providers.
* User clicks on DexPod, is redirected to /auth/dexpod.
* BFE checks if openId client for current website is present. If not: discover config & register client.
* Client is redirected to authorization_endpoint given by the openId config, containing redirect_uri, scope, client_id & response_type as query params
* Client authenticates, and is redirected to redirect_uri (/auth/dexpod/callback).

## Both:
* BFE receives token and refresh token, and stores these in the session, together with reference to the client config.
* When an access_token expires, the BFE will read the token_endpoint from the client config and refreshes the token.
