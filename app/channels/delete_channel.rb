class DeleteChannel < ApplicationCable::Channel
  def subscribed
    stream_from "delete_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def delete(data)
    # チャネルへのリクエストは正しいか確認
    if Message.find(data['id']).user_id == current_user.id
      Message.destroy(data['id'])
      ActionCable.server.broadcast 'delete_channel', id: data['id']
    else
      # TODO:
      # 不正なリクエストの処理
    end
  end
end
