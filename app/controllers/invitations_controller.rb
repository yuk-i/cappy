class InvitationsController < ApplicationController
  before_action :host_user?, only: [:new, :create]
  before_action :invite_user?, only: [:destroy]
  
  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invite_params)
    if User.find_by(email: params[:invitation][:email])
      flash.now[:alert] = "そのメールアドレスはすでに招待済みです。"
      render :new
    else
      if @invitation.save
        flash[:notice] = "招待メールを送信しました。"
        redirect_to root_path
      else
        render :new
      end
    end
  end

  def destroy
    @invite.destroy
    redirect_to root_path
  end


private

  def invite_params
    params.require(:invitation).permit(:family_id, :email)
  end

  def host_user?
    # ホストユーザーでなければルートに戻る
    if current_user.host_user
      @user = current_user
    else
      flash[:alert] = "権限がありません。"
      redirect_to root_path
    end
  end
  
  def invite_user?
    # 招待者本人かどうかの確認
    @invite = Invitation.find_by(family_id: current_user.family_id, email: current_user.email)
  end
  # ↑registrationのアフターアクションにもってく？


end
