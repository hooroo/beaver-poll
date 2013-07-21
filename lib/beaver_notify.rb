# encoding utf-8

class BeaverNotifier
  def self.notify(options)
    status  = options.fetch(:status)
    message = options.fetch(:message, "Something happened!")
    link    = options.fetch(:link, "")

    TerminalNotifier.notify(message,
                            title: 'Beaver Build',
                            subtitle: status,
                            group: 'Beaver Build',
                            open: link)
  end
end
