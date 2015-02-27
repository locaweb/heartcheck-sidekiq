RSpec.describe Heartcheck::Checks::Sidekiq do
  describe '#validate' do
    before do
      Sidekiq.instance_variable_set('@redis', nil)
      Sidekiq.redis = { namespace: 'heartcheck', url: "redis://localhost:#{port}/0" }
    end

    context 'with success' do
      let(:port) { 6379 }

      it 'calls set get and delete' do
        subject.validate
        expect(subject.instance_variable_get(:@errors)).to be_empty
      end
    end

    context 'with error' do
      let(:port) { 11_211 }

      it 'sets error for each action' do
        expect { subject.validate }.to raise_error
      end
    end
  end
end
