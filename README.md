# Overview
## Name and aliases
The project is named "Go Fish Rails".

## Purpose
The system is designed to provide an online platform for playing the card game "Go Fish."

## Technologies
### Chosen
* Ruby on Rails
* Postgres
* Puma
* Rspec
* Capybara

# How to set up the project
## External tool installation
```
brew update --system
brew upgrade ruby-build
git clone http://github.com/julliancalkins/go-fish-rails
cd go-fish-rails
rbenv install
gem install bundler
bundle install
```

## How to run locally
`rails s`

## How to run tests
`bundle exec rspec`

## Editor plugins
* Rubocop linter

# Testing Strategy

## Unit tests
Due to the nature of this application, unit tests are prominent and handle most of the confidence building and documentation needs of the system below the user interface.

## System tests
Capybara is used to simulate the user experience of the application through the browser, ensuring the proper front-end structure and intractability.

# Links to:
## [Deployed Application]https://go-fish-rails-falling-thunder-6181.fly.dev
## [GitHub repo](http://github.com/julliancalkins/go-fish-rails)

# Deployment
Deployment is done with [Fly.io](http://fly.io).
`fly deploy`

## Description of host(s), DNS, certificate authority
The application is deployed to Fly.io. They are also hosting the DNS.
