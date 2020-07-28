# README

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

## Setup

- deze repo uitpakken in initial-commits branch
- `dexes` branch in libro uitpakken
- .env aanmaken in dexes op basis van .env.template . Veel waardes kan je overnemen van de env in devproxy. De hostname moet je zelf bedenken, bv dexes.localdev . OIDC_SUBJECT_SALT mag iets randoms - zijn. OIDC_KEY is een private key die je zelf kan genereren `ssh-keygen -t rsa -b 4096` (-----BEGIN RSA PRIVATE KEY-----\n[...]\n-----END RSA PRIVATE KEY-----\n  als single line in de env, dus converteer de newlines naar `\n`).
- Aan de nginx.template.conf de gekozen hostname en een variant met wildcard (*.dexes.localdev) toevoegen als server_name. De volgende keer dat je de devproxy herstart wordt de nieuwe config dan - toegevoegd aan nginx.conf.
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
