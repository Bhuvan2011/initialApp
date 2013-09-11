FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "Person#{n}@test.com" } 
    password "foo"
    password_confirmation "foo"

    factory :admin do
      admin true
    end
  end

  #factory :micropost do
  #	content "Lorem Ipsum"
  #	user
  #end
end