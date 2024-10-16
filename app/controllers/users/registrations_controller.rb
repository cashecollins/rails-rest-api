# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    include RackSessionsFix
    respond_to :json

    private

    def respond_with(current_user, _opts = {})
      if resource.persisted?
        render json: {
          user: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
        }, status: :created
      else
        render json: {
          status: { message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}" }
        }, status: :unprocessable_entity
      end
    end
  end
end
