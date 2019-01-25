# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  room_id    :integer
#

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :content, presence: true
  # messageが作成されたら、ジョブのキューに送信するメッセージを追加
  after_create_commit { MessageBroadcastJob.perform_later self }
end
