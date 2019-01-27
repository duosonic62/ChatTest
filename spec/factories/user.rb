FactoryBot.define do
  factory :alice, class: User do
    username { 'alice' }
    password { 'password' }
    password_confirmation { 'password' }
    email { 'alice@test.com' }
  end

  factory :bob, class: User do
    username { 'bob' }
    password { 'password' }
    password_confirmation { 'password' }
    email { 'bob@test.com' }
  end
  
end