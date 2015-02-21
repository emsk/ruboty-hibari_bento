require 'spec_helper'

describe Ruboty::Handlers::HibariBento do
  describe '#pull' do
    let(:pull) { double('Pull') }
    let(:robot) { Ruboty::Robot.new }
    let(:sender) { 'user1' }
    let(:channel) { '#general' }

    shared_examples_for 'common pull' do
      it { is_expected.to receive(:call).with(no_args) }
    end

    before do
      allow(Ruboty::HibariBento::Actions::Pull).to receive(:new).and_return(pull)
      stub_const('ENV', { 'HIBARI_BENTO_FACEBOOK_ACCESS_TOKEN' => 'token'})
    end

    subject { pull }

    %w(pull fetch show).each do |method|
      context %Q(given "bento #{method}") do
        after do
          robot.receive(body: "@ruboty bento #{method}", from: sender, to: channel)
        end
        it_behaves_like 'common pull'
      end

      context %Q(given "bento #{method} 1") do
        after do
          robot.receive(body: "@ruboty bento #{method} 1", from: sender, to: channel)
        end
        it_behaves_like 'common pull'
      end
    end
  end
end
