FactoryBot.define do
  factory :alice, class: User do
    username { 'alice' }
    password { 'password' }
    password_confirmation { 'password' }
    email { 'alice@test.com' }
  end
end