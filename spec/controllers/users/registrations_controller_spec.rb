# frozen_string_literal: true

require 'rails_helper'

describe Users::RegistrationsController, type: :request  do
  describe 'Create a' do
    it 'user' do
      # Act
      post "/api/v1/user", params: { user: { email: 'test@impactsuite.com', name: 'Test User', password: 'Password1!' } }

      # Assert
      expect(response).to have_http_status(:created)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response.body).to include('email')
      expect(response.body).to include('name')
    end
  end
end
