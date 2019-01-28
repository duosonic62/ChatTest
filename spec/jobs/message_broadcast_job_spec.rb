require 'rails_helper'

RSpec.describe MessageBroadcastJob, type: :job do
  ActiveJob::Base.queue_adapter = :test

  describe '#perform' do
    # let(:message) { build_stubbed(:message_to_bob) }

    before do
      # ActionCable.server.broadcastメソッドのモックを作成
      # allow(ActionCable).to receive_message_chain(:server,:broadcast)
    end

    it 'Queuにジョブが追加されること' do
      message = build_stubbed(:message_to_bob)
      expect {MessageBroadcastJob.perform_later(message)}.to have_enqueued_job(MessageBroadcastJob)
    end

    it 'ActionCable.server.broadcastを呼び出していること' do
      message = create(:message_to_bob)
      # 呼び出しを確認するモックを作成しておく
      expect(ActionCable).to receive_message_chain(:server, :broadcast)

      # 呼び出す
      perform_enqueued_jobs do
        MessageBroadcastJob.perform_later(message)
      end
    end
  end
end
