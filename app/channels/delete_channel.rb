class DeleteChannel < ApplicationCable::Channel
  def subscribed
    stream_from "delete_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end

  def delete(data)
    # チャネルへのリクエストは正しいか確認
    if Message.find(data['id']).user_id == connection.current_user.id
      Message.destroy(data['id'])
      ActionCable.server.broadcast 'delete_channel', id: data['id']
    else
      # 不正なリクエストの処理
      reject
    end
  end
end
