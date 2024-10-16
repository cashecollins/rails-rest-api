# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  # TODO: write tests for registration
  describe "Create a(n)" do
    it "user" do
      user = build :user
      post :create, params: { user: { email: user.email, password: user.password, password_confirmation: user.password_confirmation } }
      expect(response).to have_http_status(:success)
    end
  end
end
