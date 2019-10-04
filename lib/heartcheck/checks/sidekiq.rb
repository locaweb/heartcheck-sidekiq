require "heartcheck/monitoring/redis"

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
          errors = Monitoring::Redis.run_checks(connection)
          errors.each { |error| append_error(error) }
        end
      end

      private

      # customize the error message
      # It's called in Heartcheck::Checks::Base#append_error
      #
      # @param key_error [Symbol] name of action
      #
      # @return [void]
      def custom_error(key_error)
        @errors << key_error
        ##@errors << "Sidekiq fails to #{key_error}"
      end
    end
  end
end
