module Ruboty
  module HibariBento
    module Actions
      class Pull < Ruboty::Actions::Base
        FACEBOOK_PAGE_ID = '1585734291650119'.freeze
        REDIS_NAMESPACE = 'hibari_bento'.freeze
        REDIS_KEY = 'id'.freeze

        def call
          message.reply(build_message)
        rescue => e
          backtrace = e.backtrace.join("\n")
          Ruboty.logger.error("Error: #{e.class} - #{e.message}\n#{backtrace}")
        end

        private

        def build_message
          messages = []
          posts.each { |post| messages.push(post_message(post)) }
          messages.reject!(&:empty?)
          messages.slice!(limit..-1) if limit_given?
          return 'There are no posts.' if messages.empty?
          return messages.join("\n--------------------\n")
        end

        def posts
          options = {
            fields: %w(id attachments link message updated_time),
            locale: 'ja_JP'
          }
          return graph.get_connections(FACEBOOK_PAGE_ID, 'posts', options)
        end

        def graph
          return Koala::Facebook::API.new(access_token)
        end

        def access_token
          return ENV['HIBARI_BENTO_FACEBOOK_ACCESS_TOKEN']
        end

        def post_message(post)
          unless limit_given?
            return '' if remember?(post)
            memorize(post)
          end
          return message_content(post)
        end

        def limit_given?
          return !message[:limit].nil?
        end

        def remember?(post)
          return all_memorized_posts.include?(post['id'])
        end

        def all_memorized_posts
          return @all_memorized_posts ||= client.lrange(REDIS_KEY, 0, -1)
        end

        def client
          return @client ||= ::Redis::Namespace.new(REDIS_NAMESPACE, redis: redis)
        end

        def redis
          return ::Redis.new(url: redis_url)
        end

        def redis_url
          return ENV['REDIS_URL'] || ENV['REDISCLOUD_URL'] || ENV['REDISTOGO_URL']
        end

        def memorize(post)
          client.rpush(REDIS_KEY, post['id'])
        end

        def message_content(post)
          messages = []
          messages.push(post['message'])
          messages.push(photo_urls(post))
          messages.push(post['link'])
          messages.compact!
          messages.reject!(&:empty?)

          if messages.any? && updated_time = time_format(post['updated_time'])
            messages.push(updated_time)
          end

          return messages.join("\n")
        end

        def photo_urls(post)
          urls = []

          post['attachments']['data'].each do |attachment|
            subattachments = attachment['subattachments']
            if subattachments.nil?
              urls.push(attachment['media']['image']['src'])
            else
              subattachments['data'].each do |subattachment|
                urls.push(subattachment['media']['image']['src'])
              end
            end
          end

          return urls.join("\n")
        end

        def time_format(time)
          return Time.parse(time).strftime('%Y-%m-%d %H:%M:%S') if time
        end

        def limit
          return [message[:limit].to_i, 0].max
        end
      end
    end
  end
end
