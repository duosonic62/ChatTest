FactoryBot.define do
  factory :message_to_bob, class: Message do
    content { "Hello Bob!" }
    association :room, factory: :alice_bob_room
    association :user, factory: :bob
  end
end
