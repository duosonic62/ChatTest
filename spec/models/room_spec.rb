require 'rails_helper'

RSpec.describe Room, type: :model do
  context 'roomモデルに正常な値を渡す' do
    before do
      create(:room01)
    end

    # room01と被っていない正常な情報を準備
    let(:room) { Room.new(room_id: 'testroom') }

    it 'vvalidationにかからないこと' do
      room.valid?
      expect(room).to be_valid
    end
   end

   context 'roomモデルに異常な値を渡す' do
    context 'room_idへのvalidationの確認'do
      it 'uniquenessが効くこと' do
        create(:room01)
        room = build_stubbed(:room01)
        room.valid?
        expect(room.errors.messages[:room_id]).to include('has already been taken')
      end

      it 'presenceが効くこと' do
        room = Room.new()
        room.valid?
        expect(room.errors.messages[:room_id]).to include("can't be blank")
      end

      it 'lengthが効くこと' do
        room = Room.new(room_id: '1234567')
        room.valid?
        expect(room.errors.messages[:room_id]).to include("is the wrong length (should be 8 characters)")
      end
    end
   end
end