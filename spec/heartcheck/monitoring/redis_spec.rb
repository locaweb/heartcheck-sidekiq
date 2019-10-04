require "spec_helper"

describe Heartcheck::Monitoring::Redis do
  describe "#run_checks" do
    it "returns no errors when everything is ok" do
      redis_conn = instance_double(Redis)
      allow(redis_conn).to receive(:set).and_return "OK"
      allow(redis_conn).to receive(:get).and_return "heartcheck"
      allow(redis_conn).to receive(:del).and_return(1)

      expect(described_class.run_checks(redis_conn)).to eq []
    end

    it "returns an error when cannot call set on redis" do
      redis_conn = instance_double(Redis).as_null_object
      allow(redis_conn)
        .to receive(:set)
        .with("check_test", "heartcheck")
        .and_return "ERROR"

      expect(described_class.run_checks(redis_conn))
        .to include "Sidekiq fails to set"
    end

    it "returns an error when cannot call get on redis" do
      redis_conn = instance_double(Redis).as_null_object
      allow(redis_conn).to receive(:set) { "OK" }

      allow(redis_conn)
        .to receive(:get)
        .with("check_test")
        .and_return "unexpected key"

      expect(described_class.run_checks(redis_conn))
        .to include "Sidekiq fails to get"
    end

    it "returns an error when cannot delete key on redis" do
      redis_conn = instance_double(Redis).as_null_object
      allow(redis_conn).to receive(:set) { "OK" }
      allow(redis_conn).to receive(:get) { "heartcheck" }
      allow(redis_conn).to receive(:del).with("check_test").and_return(0)

      expect(described_class.run_checks(redis_conn))
        .to include "Sidekiq fails to delete"
    end

    it "fails gently when cannot connect on redis" do
      redis_conn = instance_double(Redis).as_null_object
      allow(redis_conn).to receive(:set).and_raise(Redis::CannotConnectError)

      expect(described_class.run_checks(redis_conn))
        .to eq ["Sidekiq fails to connect to redis"]
    end

    it "fails gently when another exception occurs" do
      redis_conn = instance_double(Redis).as_null_object
      allow(redis_conn).to receive(:set).and_raise(StandardError, "BOOOM")

      expect(described_class.run_checks(redis_conn))
        .to eq ["Sidekiq error: BOOOM"]
    end
  end
end
