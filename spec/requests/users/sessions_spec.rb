# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'users/sessions', type: :request do
  # before :each do
  #   @user = User.create(email: 'test@impactsuite.com', full_name: 'Test User', username: 'test_user', password: 'Password1!')
  #   jwt = JWT.encode({ sub: @user.id }, Rails.application.credentials.devise_jwt_secret_key!)
  #   header = {
  #     'Authorization' => "Bearer #{jwt}"
  #   }
  #   request.headers.merge! header
  # end

  # path '/api/v1/sessions' do
  #   get('new session') do
  #     response(200, 'successful') do
  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end

  #   post('create session') do
  #     response(200, 'successful') do
  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end
  # end

  # path '/api/v1/logout' do
  #   delete('delete session') do
  #     response(200, 'successful') do
  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end
  # end
end
