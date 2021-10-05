class InvitationMailer < ActionMailer::Base
# ユーザー登録招待者に送付するメール
    
    def welcome_email
    @family = Family.find(params[:family_id])
    @host_user = @family.users.find_by(host_user: true)
    @email = params[:email]
    @url  = '#'
    mail(to: @email, subject: 'cappyへようこそ')
    # toが送信先メアド、subjectはメールタイトル
    end


end