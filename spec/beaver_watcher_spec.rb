# encoding utf-8

require 'spec_helper'

describe BeaverWatcher do

  describe '.watch' do
    context 'when a build is successful' do
      it 'sends a message of success to the nofifier' do
        Net::HTTP.stub(:post_form).and_return(mock(body: '{"jobs": {}}'))
        BeaverWatcher.any_instance.stub(:is_done?).and_return(true)
        BeaverWatcher.any_instance.stub(:is_closed?).and_return(true)

        BeaverNotifier.any_instance.should_receive(:notify).with(status: 'SUCCESS',
                                                                 message: 'the hash',
                                                                 link: 'http://paperboy.jqdev.net/view/Beaver%20Pipeline/')

        BeaverWatcher.new('the hash').watch
      end
    end
  end
end
