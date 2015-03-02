RSpec.describe Heartcheck::Checks::Sidekiq do
  let(:connection) { Redis.new }
  let(:pool) { ConnectionPool.new(size: 1, timeout: 5) { connection } }
  let(:check_errors) { subject.instance_variable_get(:@errors) }

  describe '#validate' do
    before do
      Sidekiq.redis = pool
    end

    context 'when nothing fails' do
      it 'calls set get and delete' do
        subject.validate
        expect(check_errors).to be_empty
      end
    end

    context 'when actions fails' do
      before do
        allow(connection).to receive(:set).and_return('error')
        allow(connection).to receive(:get).and_return(nil)
        allow(connection).to receive(:del).and_return(0)
      end

      context 'with default error message' do
        before do
          subject.validate
        end

        it { expect(check_errors).to include('Sidekiq fails to set') }
        it { expect(check_errors).to include('Sidekiq fails to get') }
        it { expect(check_errors).to include('Sidekiq fails to delete') }
      end

      context 'with custom error message' do
        before do
          subject.on_error do |errors, key_error|
            errors << "Sidekiq can't #{key_error} a value"
          end
          subject.validate
        end

        it { expect(check_errors).to include('Sidekiq can\'t set a value') }
        it { expect(check_errors).to include('Sidekiq can\'t get a value') }
        it { expect(check_errors).to include('Sidekiq can\'t delete a value') }
      end
    end

    context 'when connection fails' do
      let(:connection) { Redis.new(port: 11_211) }

      it 'sets error for each action' do
        subject.validate
        expect(check_errors).to include('Sidekiq fails to connect to redis')
      end
    end

    context 'when an exception is raised' do
      let(:msg) { 'Lorem ipsum dolor' }
      before do
        allow(connection).to receive(:set)
          .and_raise(RuntimeError, msg)
        subject.validate
      end

      context 'get' do
        it { expect(check_errors).to include("Sidekiq error: #{msg}") }
      end
    end

  end
end
