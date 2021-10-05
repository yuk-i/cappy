# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
 
  # GET /resource/login
  # ログイン画面
  # def new
  #   super
  # end

  # POST /resource/login
  # ログイン機能
  # def create
  #   super
  # end


  # DELETE /resource/logout
  # ログアウト機能
  # def destroy
  #   super
  # end
  
  # #ログイン後のリダイレクト先をメインページに指定
  # def after_log_in_path_for(user)
  #   root_path
  # end
  
  # ログアウト後のリダイレクト先をルートに指定
  # def after_log_out_path_for(user)
  #   root_path
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [
  #     :nickname, :user_icon, :host_user, :family, :email, :password, :password_confirmation
  #     ])
  # end
end
