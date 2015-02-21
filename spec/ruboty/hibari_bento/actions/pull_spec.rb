require 'spec_helper'

describe Ruboty::HibariBento::Actions::Pull do
  describe '#call' do
    let(:message) do
      class Message < Hash
        def reply(message)
          return message
        end
      end
      Message.new
    end
    let(:pull) { Ruboty::HibariBento::Actions::Pull.new(message) }

    describe 'reply message' do
      let(:facebook_graph_api_url) { Ruboty::HibariBento::Actions::Pull::FACEBOOK_GRAPH_API_URL }
      let(:request_url) { "#{facebook_graph_api_url}/#{Ruboty::HibariBento::Actions::Pull::FACEBOOK_PAGE_ID}/posts" }
      let(:access_token) { 'token' }
      let(:request_query) do
        {
          access_token: access_token,
          fields: 'id,object_id,link,message,updated_time',
          locale: 'ja_JP'
        }
      end

      let(:post_id) { '1234567890123456' }
      let(:post_object_id) { '2345678901234567' }
      let(:expected_message) { /こんにちは！\n新規配達先受付中！/ }
      let(:expected_picture_url) { Regexp.new(Regexp.escape("#{facebook_graph_api_url}/#{post_object_id}/picture")) }
      let(:expected_link) { Regexp.new(Regexp.escape("https://www.facebook.com/#{post_id}/photos/a.3456789012345678.1234567890.#{post_id}/#{post_object_id}/?type=1")) }
      let(:expected_updated_time) { /2015-02-20 08:30:05/ }
      let(:expected_separator) { /\n--------------------\n/ }

      let(:post_id_2) { '9876543210987654' }
      let(:post_object_id_2) { '8765432109876543' }
      let(:expected_message_2) { /本日のお昼の弁当です。\nおかずのみ350円・ご飯250gとセットで440円。/ }
      let(:expected_picture_url_2) { Regexp.new(Regexp.escape("#{facebook_graph_api_url}/#{post_object_id_2}/picture")) }
      let(:expected_link_2) { Regexp.new(Regexp.escape("https://www.facebook.com/#{post_id_2}/photos/a.3456789012345678.1234567890.#{post_id_2}/#{post_object_id_2}/?type=1")) }
      let(:expected_updated_time_2) { /2015-02-19 08:50:10/ }

      before do
        stub_const('ENV', { 'HIBARI_BENTO_FACEBOOK_ACCESS_TOKEN' => access_token })
      end

      subject { pull.call }

      context 'when get a post' do
        context 'with all fields' do
          before do
            stub_request(:get, request_url)
              .with(query: request_query)
              .to_return(body: File.new('spec/fixtures/a_post_with_all_fields.json'), status: 200)
          end

          it { is_expected.to match(expected_message) }
          it { is_expected.to match(expected_picture_url) }
          it { is_expected.to match(expected_link) }
          it { is_expected.to match(expected_updated_time) }
          it { is_expected.not_to match(expected_separator) }
        end

        context 'with no message' do
          before do
            stub_request(:get, request_url)
              .with(query: request_query)
              .to_return(body: File.new('spec/fixtures/a_post_with_no_message.json'), status: 200)
          end

          it { is_expected.not_to match(expected_message) }
          it { is_expected.to match(expected_picture_url) }
          it { is_expected.to match(expected_link) }
          it { is_expected.to match(expected_updated_time) }
          it { is_expected.not_to match(expected_separator) }
        end

        context 'with empty message' do
          before do
            stub_request(:get, request_url)
              .with(query: request_query)
              .to_return(body: File.new('spec/fixtures/a_post_with_empty_message.json'), status: 200)
          end

          it { is_expected.not_to match(expected_message) }
          it { is_expected.to match(expected_picture_url) }
          it { is_expected.to match(expected_link) }
          it { is_expected.to match(expected_updated_time) }
          it { is_expected.not_to match(expected_separator) }
        end

        context 'with no object_id' do
          before do
            stub_request(:get, request_url)
              .with(query: request_query)
              .to_return(body: File.new('spec/fixtures/a_post_with_no_object_id.json'), status: 200)
          end

          it { is_expected.to match(expected_message) }
          it { is_expected.not_to match(expected_picture_url) }
          it { is_expected.to match(expected_link) }
          it { is_expected.to match(expected_updated_time) }
          it { is_expected.not_to match(expected_separator) }
        end

        context 'with no link' do
          before do
            stub_request(:get, request_url)
              .with(query: request_query)
              .to_return(body: File.new('spec/fixtures/a_post_with_no_link.json'), status: 200)
          end

          it { is_expected.to match(expected_message) }
          it { is_expected.to match(expected_picture_url) }
          it { is_expected.not_to match(expected_link) }
          it { is_expected.to match(expected_updated_time) }
          it { is_expected.not_to match(expected_separator) }
        end

        context 'with empty link' do
          before do
            stub_request(:get, request_url)
              .with(query: request_query)
              .to_return(body: File.new('spec/fixtures/a_post_with_empty_link.json'), status: 200)
          end

          it { is_expected.to match(expected_message) }
          it { is_expected.to match(expected_picture_url) }
          it { is_expected.not_to match(expected_link) }
          it { is_expected.to match(expected_updated_time) }
          it { is_expected.not_to match(expected_separator) }
        end
      end

      context 'when get some posts' do
        context 'with all fields' do
          before do
            stub_request(:get, request_url)
              .with(query: request_query)
              .to_return(body: File.new('spec/fixtures/some_posts_with_all_fields.json'), status: 200)
          end

          it { is_expected.to match(expected_message) }
          it { is_expected.to match(expected_picture_url) }
          it { is_expected.to match(expected_link) }
          it { is_expected.to match(expected_updated_time) }
          it { is_expected.to match(expected_separator) }
          it { is_expected.to match(expected_message_2) }
          it { is_expected.to match(expected_picture_url_2) }
          it { is_expected.to match(expected_link_2) }
          it { is_expected.to match(expected_updated_time_2) }
        end
      end

      context 'when limit the number of posts' do
        before do
          stub_request(:get, request_url)
            .with(query: request_query)
            .to_return(body: File.new('spec/fixtures/some_posts_with_all_fields.json'), status: 200)
          allow(message).to receive(:[]).with(:limit).and_return(1)
        end

        it { is_expected.to match(expected_message) }
        it { is_expected.to match(expected_picture_url) }
        it { is_expected.to match(expected_link) }
        it { is_expected.to match(expected_updated_time) }
        it { is_expected.not_to match(expected_separator) }
        it { is_expected.not_to match(expected_message_2) }
        it { is_expected.not_to match(expected_picture_url_2) }
        it { is_expected.not_to match(expected_link_2) }
        it { is_expected.not_to match(expected_updated_time_2) }
      end

      context 'when get no posts' do
        before do
          stub_request(:get, request_url)
            .with(query: request_query)
            .to_return(body: File.new('spec/fixtures/no_posts.json'), status: 200)
        end

        it { is_expected.to eq('There are no posts.') }
      end
    end

    context 'when an error occurs' do
      let(:redis_error_message) { 'Error connecting to Redis on 127.0.0.1:6379 (Errno::ECONNREFUSED)' }
      let(:error_message) { Regexp.new(Regexp.escape("Error: Redis::CannotConnectError - #{redis_error_message}") + '.*') }

      before do
        allow(message).to receive(:reply).and_raise(Redis::CannotConnectError, redis_error_message)
        allow_any_instance_of(Ruboty::HibariBento::Actions::Pull).to receive(:build_message)
      end

      after do
        pull.call
      end

      subject { Ruboty.logger }
      it { is_expected.to receive(:error).with(error_message) }
    end
  end
end
