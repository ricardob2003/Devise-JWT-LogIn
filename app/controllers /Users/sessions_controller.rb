class Users::SessionsController < Devise::SessionsController
    # Uncomment these if you need to customize the actions (e.g., logging, handling CSRF token, etc.)
    # before_action :configure_sign_in_params, only: [:create]
    include RackSessionsFix
    protect_from_forgery with: :null_session, if: -> { request.format.json? }
    # skip_before_action :verify_authenticity_token, only: [:create]
    # before_action :log_headers, only: [:create]
    # respond_to :json
  
    def new
      super
    end
  
    def create
      field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first
      @resource = nil
      if field
        @resource = User.where(email: resource_params[:email]).first
      end
  
      if @resource && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
        valid_password = @resource.valid_password?(resource_params[:password])
        if (@resource.respond_to?(:valid_for_authentication?) && !@resource.valid_for_authentication? { valid_password }) || !valid_password
          respond_to do |format|
            format.turbo_stream { redirect_to new_user_session_path, alert: "Invalid email or password" and return }
            format.html { redirect_to new_user_session_path, alert: "Invalid email or password" and return }
          end
        else
          if @resource.admin?
            sign_in(:user, @resource)
            respond_to do |format|
              format.turbo_stream { redirect_to root_path, notice: "Admin signed in successfully." and return }
              format.html { redirect_to root_path, notice: "Admin signed in successfully." and return }
            end
          else
            sign_in(:user, @resource, store: false)  # API mode: do not store session
            render_login_response(@resource)
          end
        end
      else
        # Handle not active for authentication case or user not found
        respond_to do |format|
          format.turbo_stream { redirect_to new_user_session_path, alert: "Account not active or user not found" and return }
          format.html { redirect_to new_user_session_path, alert: "Account not active or user not found" and return }
        end
      end
    end
  
    def destroy
      if admin_logout? && request.format.html?
        # Handle admin session sign out specifically for HTML requests
        super do
          redirect_to root_path, notice: "Admin signed out successfully." and return
        end
      elsif request.format.json?
        # Handle JSON API logout
        respond_to_on_destroy
      else
        # For other formats or undefined scenarios, you might still want to call super to ensure
        # any session cleanup by Devise or provide a basic redirect
        super
        redirect_to new_user_session_path, alert: "Your session has been successfully ended." and return
      end
    end
  
    private
  
    def resource_params
      params.require(:user).permit(:email, :password, :remember_me)
    end
  
    def render_login_response(resource)
      render json: {
        status: 200,
        message: "Logged in successfully.",
        user: UserSerializer.new(resource).serializable_hash[:data][:attributes],
      }, status: :ok
    end
  
    def respond_to_on_destroy
      if request.headers["Authorization"].present?
        jwt_payload = JWT.decode(request.headers["Authorization"].split(" ").last, Rails.application.credentials.devise_jwt_secret_key!).first
        current_user = User.find(jwt_payload["sub"])
      end
  
      if current_user
        render json: {
          status: 200,
          message: "Logged out successfully.",
        }, status: :ok
      else
        render json: {
          status: 401,
          message: "Couldn't find an active session.",
        }, status: :unauthorized
      end
    end
  
    def admin_logout?
      user_signed_in? && current_user.admin?
    end
  end
  