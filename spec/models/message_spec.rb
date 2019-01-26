require 'rails_helper'

RSpec.describe Message, type: :model do
  context 'messageモデルに正常な値を渡す' do

    let(:hash_message) {[
      content: 'hello Bob!',
      user_id: User.all.first[:id],
      room_id: Room.all.first[:id]
    ]}

    let(:message) { Message.new(content: 'hello Bob!', user_id: User.all.first[:id], room_id: Room.all.first[:id]) }

    it '登録完了後にMessageBroadcastJob.perform_laterを呼び出すこと' do
      create(:alice_bob_room)
      create(:alice)
      # messageをDBに保存した後に、MessageBroadcastJob.perform_laterが呼び出されていることを確認
      expect(MessageBroadcastJob).to receive(:perform_later).once
      Message.create!(hash_message)
    end

    it 'validationにかからないこと' do
      create(:alice_bob_room)
      create(:alice)
      message.valid?
      expect(message).to be_valid
    end
  end

  context 'messageモデルに異常な値を渡す' do
    context 'contentへのvalidationの確認'do
    
      it 'presenceが効くこと' do
        message = Message.new()
        message.valid?
        expect(message.errors.messages[:content]).to include("can't be blank")
      end

      it 'lengthが効くこと' do
        message = Message.new(content: 'a' * 1001 )
        message.valid?
        expect(message.errors.messages[:content]).to include('is too long (maximum is 1000 characters)')

        message = Message.new(content: 'a' * 1000 )
        message.valid?
        expect(message.errors.messages[:content]).not_to include('is too long (maximum is 1000 characters)')
      end
    end
   end
end
