module Heartcheck
  module Monitoring
    class Redis
      def self.run_checks(redis_conn)
        new(redis_conn).run_checks
      end

      def initialize(redis_conn)
        @redis_conn = redis_conn
        @errors = []
      end

      def run_checks
        begin
          @errors << "Sidekiq fails to set" unless can_store?
          @errors << "Sidekiq fails to get" unless can_fetch?
          @errors << "Sidekiq fails to delete" unless can_delete?
        rescue ::Redis::BaseError
          @errors << "Sidekiq fails to connect to redis"
        rescue => e
          @errors << "Sidekiq error: #{e.message}"
        end

        @errors
      end

      private

      def can_store?
        @redis_conn.set("check_test", "heartcheck") == "OK"
      end

      def can_fetch?
        @redis_conn.get("check_test") == "heartcheck"
      end

      def can_delete?
        @redis_conn.del("check_test") == 1
      end
    end
  end
end
