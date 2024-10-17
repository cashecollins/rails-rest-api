# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SessionsController, type: :request do
  before :each do
    # Arrange
    @email = 'test@example.com'
    @password = 'Password1!'
    @user = create :user, email: @email, password: @password
  end

  describe "Login a(n)" do
    it "user" do
      # Act
      post "/api/v1/sessions", params: { user: { email: @email, password: @password } }

      # Assert
      body = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response.headers).to include('Authorization')
      expect(body).to include('status')
      expect(body['status']).to include('data')
      expect(body['status']['data']).to include('user')
      expect(body['status']['data']['user']).to include('email')
      expect(body['status']['data']['user']).to include('name')
    end
  end

  describe "Logout a(n)" do
    it "user" do
      # Arrange
      jwt = login_user(@user)

      # Act
      delete "/api/v1/sessions", headers: { 'Authorization': "Bearer #{jwt}" }

      # Assert
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end
end
