class Emailer < ActionMailer::Base
  default from: 'no-reply@brainbox.com'

   def max_bbs(user)
      @user = user
      mail(to: @user.email, subject: 'Attention : nombre maximal de brainboxes atteint !')
   end

  def warning_bbs(user)
      @user = user
      mail(to: @user.email, subject: 'Attention : nombre maximal de brainboxes bientôt atteint !')
   end

  def max_users(user)
      @user = user
      mail(to: @user.email, subject: 'Attention : nombre maximal d\'utilisateurs atteint !')
   end

  def warning_users(user)
      @user = user
      mail(to: @user.email, subject: 'Attention : nombre maximal d\'utilisateurs bientôt atteint !')
   end
end