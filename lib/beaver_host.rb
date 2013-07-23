require 'socket'
require 'timeout'

class BeaverHost
  def self.pick(*hosts)
    return hosts.first if hosts.length == 1

    hosts.map do |host|
      host if self.new(host).available?
    end.compact
  end

  def initialize(hostname)
    @hostname = hostname
  end

  def available?
    begin
      Timeout::timeout(1) do
        sock = Socket.tcp(@hostname, 80)
      end
    rescue Timeout::Error
      return true
    rescue
    end
  end
end
