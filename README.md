# README

## Setup
- deze repo uitpakken in initial-commits branch
- `dexes` branch in libro uitpakken
- .env aanmaken in dexes op basis van .env.template . Veel waardes kan je overnemen van de env in devproxy. De hostname moet je zelf bedenken, bv dexes.localdev . OIDC_SUBJECT_SALT mag iets randoms - zijn (`bundle exec rake secret`). OIDC_KEY is een private key die je zelf kan genereren `ssh-keygen -t rsa -b 4096` (-----BEGIN RSA PRIVATE KEY-----\n[...]\n-----END RSA PRIVATE KEY-----\n  als single line in de env, dus converteer de newlines naar `\n`).
- Aan de nginx.template.conf de gekozen hostname en een variant met wildcard (*.dexes.localdev) toevoegen als server_name. De volgende keer dat je de devproxy herstart wordt de nieuwe config dan - toegevoegd aan nginx.conf.
- Instellen hostnames, of
  - [Automatisch routen van alle localdev domeinen](https://qiita.com/bmj0114/items/9c24d863bcab1a634503)
  - De gekozen hostname toevoegen aan /etc/hosts. Voeg gelijk de sudomeinen die je wil gebruiken voor de tests en demo toe, want een wildcard kan daar niet. Bv joep.dexes.localdev, test.dexes.localdev
- Sluit de argu backend af. Dexes gaat namelijk op dezelfde poort draaien.
- Maak de database aan `bundle exec rake db:setup`
- Start dexes in productie mode (RAILS_ENV=production) en herstart de devproxy ./dev.sh
- `RAILS_ENV=development bundle exec rails s -b 0.0.0.0 -p 3000`

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
6) User is not logged in at the OP, so he is redirected to a sign up/in page (dexes.nl/u/sign_in)
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
* User goes to /u/sign_in.
* User sees regular login form.
* User enters username/password.
* BFE receives POST request on /login, containing password/email. (so far nothing new)
* BFE checks if openId client for current website is present. If not: discover config & register client.
* BFE posts token to the token_endpoint given by the openId config.

## On [user].dexes.nl:
* User goes to /u/sign_in.
* User sees list of recommended openId providers.
* User clicks on DexPod, is redirected to /auth/dexpod.
* BFE checks if openId client for current website is present. If not: discover config & register client.
* Client is redirected to authorization_endpoint given by the openId config, containing redirect_uri, scope, client_id & response_type as query params
* Client authenticates, and is redirected to redirect_uri (/auth/dexpod/callback).

## Both:
* BFE receives token and refresh token, and stores these in the session, together with reference to the client config.
* When an access_token expires, the BFE will read the token_endpoint from the client config and refreshes the token.

