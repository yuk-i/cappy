class InvitationMailer < ApplicationMailer
# ユーザー登録招待者に送付するメール
    
    def welcome_email(family_id, email)
    @family = Family.find(family_id)
    @host_user = @family.users.find_by(host_user: true)
    @email = email
    # @url  = invite_signup_url(@family.id)
    mail(to: @email, subject: 'cappyへようこそ')
    # toが送信先メアド、subjectはメールタイトル
    end


end