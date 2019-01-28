class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast "room_channel_#{message.room_id}", read_message: read_render_message(message),
      write_message: write_render_message(message), write_user_id: message.user.id
  end

  private
    def read_render_message(message)
      # ApplicationController.renderer.renderでは、deviceのwarden proxyが無視されるため、独自メソッドを使用
      # ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message, current_user: message.user })
      ApplicationController.render_with_signed_in_user(message.user, partial: 'messages/read_message', locals: { message: message })
    end

    def write_render_message(message)
      # ApplicationController.renderer.renderでは、deviceのwarden proxyが無視されるため、独自メソッドを使用
      # ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message, current_user: message.user })
      ApplicationController.render_with_signed_in_user(message.user, partial: 'messages/write_message', locals: { message: message })
    end
end
