# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  room_id    :string
#

class Room < ApplicationRecord
  has_many :messages

  validates :room_id, presence: true, uniqueness: true
end
