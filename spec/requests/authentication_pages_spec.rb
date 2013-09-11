require 'spec_helper'

describe "AuthenticationPages" do
  subject { page }

  describe "authorization" do

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }        
      end
    end

    describe "for non signed in user" do
      let(:user){ FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before {
          visit edit_user_path(user)
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password
          click_button "Sign in"
        }

        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit user')
          end
        end

        describe "in micropost controller" do
          describe "submitting to create action" do
            before { post microposts_path }
            specify { response.should redirect_to(signin_path)}
          end

          describe "submitting to destroy action" do
            before { delete micropost_path(FactoryGirl.create(:micropost))}
            specify { response.should redirect_to(signin_path)}
          end
        end
      end

      describe "in the Relationships controller" do
        describe "submitting to the create action" do
          before { post relationships_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete relationship_path(1) }
          specify { response.should redirect_to(signin_path) }          
        end
      end

      describe "in the user controller" do

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'Sign in')}
        end

        describe "visiting the edit page" do
          before { visit edit_user_path(user)}
          it { should have_selector('title', text: 'Sign in')}
        end

        describe "submitting to user action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path)}
        end

        describe "visiting the following page" do
          before { visit following_user_path(user) }
          it { should have_selector('title', text: "Sign in")}
        end

        describe "visiting the follower path" do
          before { visit followers_user_path(user) }
          it { should have_selector('title', text: "Sign in") }
        end

      end
    end

    describe "as wrong user" do
      let(:user){ FactoryGirl.create(:user)}
      let(:wrong_user){ FactoryGirl.create(:user, email: "wrong@example.com")}

      before { sign_in user}

      describe "visiting user#edit page" do
        before { visit edit_user_path(user) }
        it { should_not have_selector('title', text: full_title('Edit user'))}
      end

      describe "submitting a put request to user#update action" do
        before { put user_path(wrong_user)}
        specify { response.should redirect_to(root_path)}
      end
    end
  end

  describe "with valid information" do
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user}

    it { should have_selector('title', text: user.name)}
    it { should have_link('Users',    href: users_path) }
    it { should have_link('profile', href: user_path(user)) }
    it { should have_link('Settings', href: edit_user_path(user))}
    it { should have_link('Sign out', href: signout_path)}
    it { should_not have_link('Sign in', href: signin_path)}
  end

  describe "signin page" do
  	before { visit signin_path }

  	it { should have_selector('h1', text: 'Sign in')}

  	describe "invalid signin" do
  	  before { click_button "Sign in"}

  	  it { should have_selector('title', text: 'Sign in')}
  	  it { should have_selector('div.alert.alert-error', text: 'Invalid')}

  	  describe "after visiting another page" do
  	  	before { click_button 'Home'}
  	  	it { should_not have_selector('div.alert.alert-error') }
  	  end
  	end

  	describe "with valid inofrmation" do
  		let(:user) { FactoryGirl.create(:user) }

  		before {
  			fill_in "Email", with: user.email.upcase
  			fill_in "Password", with: user.password
  			click_button "Sign in"	
  		}

  		it { should have_selector('title', text: user.name)}
  		it { should have_link('Profile', href: user_path(user)) }
  		it { should have_link('Sign out', href: signout_path)}
  		it { should_not have_link('Sign in', href: signin_path) }
  	end

  end
end
