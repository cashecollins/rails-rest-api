# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  # TODO: write tests for registration
  describe "Login a(n)" do
    it "user" do
      user = create :user
      post :create, params: { user: { email: user.email, password: user.password } }
      expect(response).to have_http_status(:success)
    end
  end
end
