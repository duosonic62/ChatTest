class RoomChannel < ApplicationCable::Channel
  def subscribed
    # ストリーミングを開始(room_idが存在したら)
    if !params['room_id'].nil?
      stream_from "room_channel_#{params['room_id']}"
    else
      reject
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    # ストリーミングを停止
    stop_all_streams
  end

  def speak(data)
    Message.create!(content: data['message'], user_id: connection.current_user.id, room_id: params['room_id'])
  end
end
