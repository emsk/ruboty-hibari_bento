require 'ruboty/hibari_bento/actions/pull'

module Ruboty
  module Handlers
    class HibariBento < Base
      env(:HIBARI_BENTO_FACEBOOK_ACCESS_TOKEN, 'Facebook API access token')
      env(:REDIS_URL, 'Redis URL (e.g. redis://:p4ssw0rd@example.com:6379/)', optional: true)
      env(:REDISCLOUD_URL, 'Redis URL of Redis Cloud', optional: true)
      env(:REDISTOGO_URL, 'Redis URL of Redis To Go', optional: true)

      on(
        /bento\s+(pull|fetch|show)(\s*|\s+(?<limit>\d+))\z/,
        name: 'pull',
        description: 'Fetch posts from the Hibari Bento Facebook page.'
      )

      def pull(message)
        Ruboty::HibariBento::Actions::Pull.new(message).call
      end
    end
  end
end
