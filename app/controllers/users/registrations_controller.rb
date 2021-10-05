#★ユーザーの登録・編集・削除を行う

# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  # before_action :set_family, only: [:edit,:destroy]
  

  # GET /resource/sign_up
  # 新規登録画面
  def new
    logger.debug("----------------- sesion faimlyid = #{session[:family_id]}")
    @family = Family.find(session[:family_id])
    @user_icons = UserIcon.all
    super
  end

  # POST /resource
  # 新規登録機能
  def create
    @family = Family.find(session[:family_id])
    super
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    logger.debug("==================== user update #{params[:user][:user_icon_id]}")
    
  end

  # DELETE /resource
  # def destroy
  #   super
  # end
  
  # 登録完了画面
  def verify
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected
  
  # def set_family
  #   @family = current_user.family
  # end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :user_icon_id, :family_id, :host_user])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname, :email, :user_icon_id])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    if current_user.family_id.nil?
      new_family_path
    else
      verify_path
    end
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    verify_path
  end
end
