require 'spec_helper'

describe "StaticPages" do

  subject { page }

  describe "Home page" do

    before { visit root_path }

    it { should have_content('Sample App') }

    it { should have_selector('h1', text: "Sample App") }
  
    it { should have_selector('title', text: full_title('')) }

    it { should_not have_selector('title', text: "| Home") }

    describe "for signed in users" do
      let(:user){ FactoryGirl.create(:user) }
      before {
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      }

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end

  describe "Help Page" do

    before { visit help_path }

  	it { should have_content('Help') }

  	it { should have_selector('h1', text: "Help") }

    it { should have_selector('title', text: full_title('')) }
  end

  describe "About Page" do

    before { visit about_path } 

  	it { should have_content('About') }

  	it { should have_selector('h1', text: "About Us") }

    it { should have_selector('title', text: full_title('')) }
  end
end
