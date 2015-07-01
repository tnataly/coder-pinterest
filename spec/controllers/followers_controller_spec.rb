require 'spec_helper'
RSpec.describe FollowersController do
	before(:each) do
		@user = FactoryGirl.create(:user_with_followees)
		@board = @user.boards.first
		login(@user)
	end
	after(:each) do
		unless @user.destroyed?
			Follower.where("follower_id=?",@user.id).destroy_all
			@user.destroy
		end
	end

	describe "GET index" do 
		it 'renders the index template' do 
			get :index
			expect(response).to render_template("index")
		end

		it 'populates @followed with all followed users' do
			get :index
			expect(assigns[:followed]).to eq(@user.followed)
		end

		it 'redirects to the login page if user is not logged in' do
			logout(@user)
      		get :index
      		expect(response).to redirect_to(:login)
		end

	end

  	describe "GET new" do
    	it 'responds with successfully' do
    		get :new
     		expect(response.success?).to be(true)
    	end
 	
    	it 'renders the new view' do
    		get :new      
     		expect(response).to render_template(:new)
    	end
 
    	it 'assigns an instance variable to a new follower' do
    		get :new
      		expect(assigns(:follower)).to be_a_new(Follower)
    	end
 
    	it 'assigns @users to equal the users not followed by @user' do
    		get :new
      		expect(assigns(:users)).to eq(@user.not_followed)
    	end      
 
    	it 'redirects to the login page if user is not logged in' do
    		logout(@user)
     		get :new
      		expect(response).to redirect_to(:login)
    	end    
  end

  describe "POST create" do
    before(:each) do
      @follower_user = FactoryGirl.create(:user)
      @follower_hash = {
        user_id: @user.id,
        follower_id: @follower_user.id
      }    
    end
 
    after(:each) do
      follower = Follower.where("user_id=? AND follower_id=?", @user.id, @follower_user.id)
      if !follower.empty?
        follower.destroy_all
        @follower_user.destroy
      end
    end
 
    it 'responds with a redirect' do
    	post :create, follower: @follower_hash
      	expect(response.redirect?).to be(true)
    end
 
    it 'creates a follower' do
    	post :create, follower: @follower_hash  
      	expect(Follower.where("user_id = ? AND follower_id = ?", @user.id, @follower_user.id).present?).to be(true)
    end
 
    it 'redirects to the index view' do
    	post :create, follower: @follower_hash
      	expect(response).to redirect_to(followers_path)
    end
 
    it 'redirects to the login page if user is not logged in' do
    	logout(@user)
      	post :create, follower: @follower_hash
      	expect(response).to redirect_to(:login)
    end 
  
  end


end