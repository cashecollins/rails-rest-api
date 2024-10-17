# Introduction
This app is built on a ruby on rails stack, on top of a sqlite db. It's purpose is to provide a RESTful API for a user to create an account, login, and logout. The API is secured with JWT's that are passed back and forth between the client and server. The API is also versioned, and the current version is `v1`.

# Getting Started
The following instructions were tested and run on a mac, for a different OS there may be some discrepencies between commands.

## Pre-Requisites
1. Ruby Version: 3.3.0+

## Creating the authentication secret key
We are using the `devise-jwt` library for our authentication, and it requires a secret key to be stored in the rails credentials file. This secret key is used to sign and verify the JWT's that are passed back and forth between the client and server.

To get your app credentialed walk through the following steps:

1. use a pre-determined secret OR generate a secret for your jwt: `bundle exec rails secret`
2. create and edit your encrypted credentials file: `EDITOR=VIM rails credentials:edit`
3. add the following line to your now opened credentials file `devise_jwt_secret_key: <secret_from_step_1>`
4. close out of your editor and now you should have a new `credentials.yml.enc` which is your encrypted secrets file

_NOTE: You can also use environment variables rather than the credentials file, you will need to change some code regarding devise in the `config/initializers/devise.rb` file and other files that use the  `devise_jwt_secret_key` secret key_

## Setting up the database
We are using sqlite for our database, obviously as a proof of concept this works great but for a production environment we would want to opt for a more robust and scalable solution.

1. create and populate a sqlite db: `rails db:migrate`
2. you should now see a `development.sqlite3` file in your `/storage` folder. This db should now be set up, pre-populated with any necessary data.

_NOTE: This can be migrated to a different db by changing the `config/database.yml` file_

## Tests
We are using [RSpec](https://github.com/rspec/rspec-rails) for our testing framework, we utilize [FactoryBot](https://github.com/thoughtbot/factory_bot) for creating test data, and we use [SimpleCov](https://github.com/simplecov-ruby/simplecov) to generate and view code coverage. To get started with testing you can walk through the following steps:

1. create test db: `RAILS_ENV=test rails db:migrate`
2. you should now see a `teset.sqlite3` file in your `/storage` folder, this is the test databased used by rails for testing.
3. run the tests: `rails rspec:run`
4. you should have access to the test coverage report in the `/coverage` folder and can be viewed by viewing the index.html file in a browser.

There are various custom/simplified commands that can be run and can be found in `lib/tasks/rspec_tasks.rake`.

We have git hooks set up for local testing before push, to set this up all you have to do is run the following command `git config core.hooksPath .github/hooks`

_To skip local tests on push you can run `git push --no-verify`_


## Serving
We are serving locally at http://localhost:3000, you'll be able to hit this from any rest api query tool or curl command.

1. run the server: `rails s`

## Authentication
We are using a library called [Devise](https://github.com/heartcombo/devise) for our authentication. We are using devise in conjunction with the [devise-jwt](https://github.com/waiting-for-dev/devise-jwt) library to incorporate JWT's that are passed back and forth through the headers of each RESTful API request and response between client and server.

A newly created JWT will be returned from the API as the `authorization` header on the response from both the `POST: /api/user` and `POST: /api/sessions` endpoints. The JWT will expire every 90 minutes, and the jwt can be invalidated by updating the jti column on the user record, this same process happens on logout so that there are no lingering authorized JWT's.

All other calls require a header of the following configuration `Authorization: Bearer <jwt>` or they will return a `401 Unauthorized` error.




