# encoding utf-8
require_relative 'settings'
require 'terminal-notifier'

class BeaverNotifier
  def notify_failure(message)
    BeaverNotifier.new.notify(status: 'FAILURE', message: message, link: "#{web_host}/view/Beaver%20Pipeline/")
  end

  def notify_closed(message)
    BeaverNotifier.new.notify(status: 'SUCCESS', message: message, link: "#{web_host}/view/Beaver%20Pipeline/")
  end

  def notify(options)
    status  = options.fetch(:status)
    message = options.fetch(:message, "Something happened!")
    link    = options.fetch(:link, "")

    TerminalNotifier.notify(message,
                            title: 'Beaver Build',
                            subtitle: status,
                            group: 'Beaver Build',
                            open: link)
  end

  private

  def settings
    @settings = Settings.new
  end

  def web_host
    "http://#{settings.host}"
  end
end
