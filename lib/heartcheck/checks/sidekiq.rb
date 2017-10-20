module Heartcheck
  module Checks
    # Check for a sidekiq service
    # Base is set in heartcheck gem
    class Sidekiq < Base
      # validate service connection
      #
      # @retun [void]
      def validate
        ::Sidekiq.redis do |connection|
          append_error(:set) unless set?(connection)
          append_error(:get) unless get?(connection)
          append_error(:delete) unless del?(connection)
        end
      rescue ::Redis::BaseError
        append_error('connect to redis')
      rescue => e
        @errors << "Sidekiq error: #{e.message}"
      end

      private

      # test if can write on redis
      #
      # @param con [Redis] an instance of redis
      #
      # @return [Bollean]
      def set?(con)
        con.set('check_test', 'heartcheck') == 'OK'
      end

      # test if can read on redis
      #
      # @param con [Redis] an instance of redis
      #
      # @return [Bollean]
      def get?(con)
        con.get('check_test') == 'heartcheck'
      end

      # test if can delete on redis
      #
      # @param con [Redis] an instance of redis
      #
      # @return [Bollean]
      def del?(con)
        con.del('check_test') == 1
      end

      # customize the error message
      # It's called in Heartcheck::Checks::Base#append_error
      #
      # @param key_error [Symbol] name of action
      #
      # @return [void]
      def custom_error(key_error)
        @errors << "Sidekiq fails to #{key_error}"
      end
    end
  end
end
