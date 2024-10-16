# Introduction
This app is built on a ruby on rails stack, on top of a sqlite db. It's purpose is to record and track analytics around game completion for an existing mobile app and handle user management, which includes authentication through a username and password.

# Getting Started
The following instructions were tested and run on a mac, for a different OS there may be some discrepencies between commands.

## Pre-Requisites
1. Ruby Version: 3.3.0+

## Creating the authentication secret key
In a normal situation we would just have a master.key file that we could give to developers working on this through secure channels, or store it on a secured aws s3 bucket, but in our situation it will just be easiest (and safest) to just recreate the master.key and credentials file.

1. generate a secret for your jwt: `bundle exec rails secret`
2. save the secret somewhere, it will be used later.
3. create and edit your encrypted credentials file: `EDITOR=VIM rails credentials:edit`
4. add the following line to your now opened credentials file `devise_jwt_secret_key: <secret_from_step_1>`
5. close out of your editor and now you should have a new `credentials.yml.enc` which is your encrypted secrets file

## Setting up the database
We are using sqlite for our database, obviously as a proof of concept this works great but for a production environment we would want to opt for a more robust and scalable solution.

1. create and populate a sqlite db: `rails db:migrate`
2. you should now see a `development.sqlite3` file in your `/storage` folder. This db should now be set up, pre-populated with any necessary data.

## Tests
We are using rails built in test suite, there are a lot of other really good options for testing, and I would most likely move to something like RSpec for a production environment. Documentation on the built in test suite can be found here: https://guides.rubyonrails.org/testing.html.

As a part of this test suite we are running integration tests on the models and the controllers. These can be run in specific batches or all together, though here we will just run the whole suite.

1. run tests: `rails t`
2. you should now see a `teset.sqlite3` file in your `/storage` folder, this is the test databased used by rails for testing.

## Serving
We are serving locally at http://localhost:3000, you'll be able to hit this from any rest api query tool or curl command.

1. run the server: `rails s`

## Authentication
We are using a library called [Devise](https://github.com/heartcombo/devise) for our authentication. We are using devise in conjunction with the [devise-jwt](https://github.com/waiting-for-dev/devise-jwt) library to incorporate JWT's that are passed back and forth through the headers of each RESTful API request and response between client and server.

A newly created JWT will be returned from the API as the `authorization` header on the response from both the `POST: /api/user` and `POST: /api/sessions` endpoints. The JWT will expire every 90 minutes, and the jwt can be invalidated by updating the jti column on the user record, this same process happens on logout so that there are no lingering authorized JWT's.

All other calls require a header of the following configuration `Authorization: Bearer <jwt>` or they will return a `401 Unauthorized` error.




