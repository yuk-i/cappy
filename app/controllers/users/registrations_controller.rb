#★ユーザーの登録・編集・削除を行う

# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  # after_action :invite_user_destroy, only: [:create]
  
  
  def show
    @user = current_user
  end

  # GET /resource/sign_up
  # 新規登録画面
  def new
    logger.debug("----------------- sesion faimly_id = #{session[:family_id]}")
    @family = Family.find(session[:family_id])
    @user_icons = UserIcon.all
    super
  end
  
  # 招待者のユーザー登録
  def invite_user_new
    if current_user
      flash[:alert] = "別のユーザーがログインしています。ログアウトしてからお試しください。"
      redirect_to root_path
    else
      logger.debug("----------------- params[faimly_id] = #{params[:family_id]}")
      if Invitation.find_by(family_id: params[:family_id])
        @family = Family.find(params[:family_id])
        @user_icons = UserIcon.all
        @user = User.new
        session[:family_id] = @family.id
      else
        redirect_to root_path
        flash[:alert] = "権限がありません。"
      end
    end  
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
    logger.debug("==================== user update nickname #{params[:user][:nickname]}")
    super
  #   @user = current_user
  #   if @user.update
  #     redirect_to root_path
  #   else
  #     render :edit
  #   end
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

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :user_icon_id, :family_id, :host_user])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname, :user_icon_id, :family_id, :host_user])
  end
  
  # パスワード認証なしで更新できる
  def update_resource(resource, params)
    resource.update_without_password(params)
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
    # メール認証時に招待者であれば招待者リストから削除する
    if @invite = Invitation.find_by(family_id: params[:user][:family_id], email: params[:user][:email])
      logger.debug("==================== @invite_params[family_id] #{params[:user][:family_id]}")
      @invite.destroy
    else
      logger.debug("==================== invite_user_destroy = error #{params[:user][:family_id]}")
    end
    verify_path
  end
  
  
end
