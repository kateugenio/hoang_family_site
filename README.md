# README

## Overview

Hoang Family Website

## Setup

### Environment Requirements
* Rails 6.0.2
* Ruby 2.6.6
* PostgreSQL 10.3
```
git clone https://github.com/kateugenio/hoang_family_site.git
cd hoang_family_site
bundle install
```

## Credentials
Secrets are encrypted in credentials.yml.enc.

Master key is kept by repo owner. Place the key under config/ in a new file called master.key. You will need this key to run the server locally, setup the database, and to run tests.

To edit secrets:
```
EDITOR=vim rails credentials:edit
```

## Database setup

```
bundle exec rails db:setup
```

## Development

### Run Tests with Rubocop and Brakeman
```
bundle exec rake spec
```

### Code Analysis
[Brakeman](https://github.com/presidentbeef/brakeman) and [Rubocop](https://github.com/bbatsov/rubocop) are configured to run automatically whenever tests are run. To run them independently:

```
# security analysis: this will provide additional detail
bundle exec brakeman

# style analysis
bundle exec rubocop
```

To start the local server:
```
bundle exec rails s
```
From your browser, head to localhost:3000