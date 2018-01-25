class AdminNotifier < ApplicationMailer
  default :from => 'application@free_hot_tub.com'

  def free_hot_tub_notification(count)
    @count = count
    mail(
      to: ENV['ADMIN_EMAIL'],
      subject: 'NEW FREE HOT TUB NOTIFICATION'
    )
  end
end
