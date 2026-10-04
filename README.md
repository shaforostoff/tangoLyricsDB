# Tango Translation Database

This is the project that underlies the Tango Translation Database on https://tangotranslations.org

I developed it to teach myself Ruby on Rails. Read more about its development on my blog http://alexvicegrab.github.io

## Stack

* Ruby 4.0, Rails 8.1 (Propshaft + importmap, Turbo; no Node toolchain), Devise, Kaminari, Chartkick
* PostgreSQL 18
* Puma behind [Thruster](https://github.com/basecamp/thruster), which also obtains Let's Encrypt certificates
* Bootstrap 5 and Font Awesome from the jsDelivr CDN
* Everything runs with Docker Compose on a single GCP e2-micro VM (free tier)

## Deploying

Set up a GCP account and a project and create a GCP compute instance by following the `./terraform/instance/README.md`.
Install `docker.io` and `docker-compose-v2` on it and clone this repository.

### Secrets

Copy `.env.example` to `.env` next to `docker-compose.yml` and fill it in:

    DB_PASSWORD=...                  # any random string
    SECRET_KEY_BASE=...              # openssl rand -hex 64
    GMAIL_USERNAME=...               # I use tangotranslation@gmail.com
    GMAIL_PASSWORD=...               # a Gmail app password
    CANONICAL_HOST=tangotranslations.org
    TLS_DOMAIN=tangotranslations.org,www.tangotranslations.org

Leave `CANONICAL_HOST` and `TLS_DOMAIN` empty until DNS points at the VM; the site is then served over plain HTTP.

### Run

    docker compose up -d --build

The database schema is created (or migrated) on start.

### Update

On the e2-micro (1 GB RAM) a rebuild pushes the running app into swap: it takes 20+ minutes
and the site stops responding until it finishes. Rebuild only when it is needed
(Gemfile, assets, Dockerfile, config or initializers changed).

For changes to views, controllers, models or helpers, copy the files into the running
container and restart it (a few seconds of downtime):

    docker compose cp rails_app/app/views/layouts/_footer.html.erb web:/rails/app/views/layouts/
    docker compose restart web

Also copy the files into the checkout on the VM, so the next rebuild includes them.

After changing data with `bin/rails runner`, restart `web` too: the sidebar stats are cached
in the web process's memory, which the runner cannot clear.

### Restore a backup

    docker compose up -d db
    docker compose exec -T db pg_restore --clean --if-exists --no-acl --no-owner -U ttdb -d ttdb_production < backup/TDB_2026-10-03.dump
    docker compose up -d

### Backups

`TTdb_dump.sh` dumps the database into `backup/`. Run it monthly from cron:

    0 3 1 * * /home/ubuntu/tangoLyricsDB/TTdb_dump.sh

## Adding an admin

Connect to the VM that is running the app.

    docker compose exec web bin/rails console

This will setup a Rails console prompt.

    User.create!(email: 'email@example.com', password: 'password', password_confirmation: 'password')

## Tests

With the stack running:

    docker compose run --rm -e RAILS_ENV=test web bin/rails db:prepare test
