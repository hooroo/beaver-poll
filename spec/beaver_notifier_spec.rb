# encoding utf-8

require 'spec_helper'

describe BeaverNotifier do

  describe '.notify' do
    it 'sends a message to TerminalNotifier' do
      TerminalNotifier.should_receive(:notify).with('the message',
                                                    title: 'Beaver Build',
                                                    subtitle: 'the status',
                                                    group: 'Beaver Build',
                                                    open: 'the link')

      BeaverNotifier.new.notify(status: 'the status',
                                message: 'the message',
                                link: 'the link')
    end
  end
end
