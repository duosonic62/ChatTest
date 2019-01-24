require "securerandom"

class RoomsController < ApplicationController
  before_action :sign_in_required
  def show
    # ルームが存在するか確認
    if Room.exists?(room_id: params[:room][:room_id]) 
      @room = Room.find_by(room_id: params[:room][:room_id])
      @messages = @room.messages
    else
      # ルームが存在しなければ、エラーメッセージをインデックスでレンダリング
      @room = Room.new()
      flash.now[:alert] = 'Not a valid room id.'
      render 'index'
    end
  end

  def index
    @room = Room.new()
  end

  def new
    # ランダムなルームIDを割り振る
    random_room_id = SecureRandom.urlsafe_base64(8)

    # もしルームIDが被ったら新たにユニークなルームIDを発行する
    while Room.exists?(room_id:random_room_id) do
      random_room_id = SecureRandom.urlsafe_base64(8)
    end

    # ルームIDを発行する
    @room = Room.new(room_id: random_room_id)
    if @room.save
      # indexをレンダリング(flashで新規に作成されたIDを渡す)
      flash.now[:created_room_id] = @room.room_id
      render 'index'
    else
      # TODO:
      # エラーが発生した際の処理
    end
  end
  
end
