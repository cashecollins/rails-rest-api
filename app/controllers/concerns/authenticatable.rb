module Authenticatable extend ActiveSupport::Concern
  included do
    before_action :authenticate
    private
    def authenticate
      if request.headers['Authorization'].present?
        jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
        @current_user = User.find(jwt_payload['sub'])
      else
        render json: {
          status: 401,
          message: 'No token provided.'
        }, status: :unauthorized
      end
    end
  end
end