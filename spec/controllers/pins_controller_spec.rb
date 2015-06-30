require 'spec_helper'
RSpec.describe PinsController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login(@user)
  end

  after(:each) do
    unless @user.destroyed?
      @user.destroy
    end
  end

	describe "GET index" do
		it 'renders the index template' do
			get :index
			expect(response).to render_template("index")
		end
		it 'populate @pins with all the pins in the database' do
			get :index
			expect(assigns[:pins]).to eq(Pin.all)
		end
    it 'can\'t be accessed when a user is not logged in' do
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
    
    it 'assigns an instance variable to a new pin' do
      get :new
      expect(assigns(:pin)).to be_a_new(Pin)
    end
    
    it 'can\'t be accessed when a user is not logged in' do
      logout(@user)
      get :new
      expect(response).to redirect_to(:login)
    end

  end
  
  describe "POST create" do
    before(:each) do
      @pin_hash = { 
        title: "Rails Wizard", 
        url: "http://railswizard.org", 
        slug: "rails-wizard", 
        text: "A fun and helpful Rails Resource",
        category_id: "rails"}    
    end
    
    after(:each) do
      pin = Pin.find_by_slug("rails-wizard")
      if !pin.nil?
        pin.destroy
      end
    end
    
    it 'responds with a redirect' do
      post :create, pin: @pin_hash
      expect(response.redirect?).to be(true)
    end
    
    it 'creates a pin' do
      post :create, pin: @pin_hash  
      expect(Pin.find_by_slug("rails-wizard").present?).to be(true)
    end
    
    it 'redirects to the show view' do
      post :create, pin: @pin_hash
      #expect(response).to redirect_to(pin_url(assigns(:pin)))
      expect(response).to redirect_to(pin_by_name_path(slug: @pin_hash[:slug]))
    end
    
    it 'redisplays new form on error' do
      # The title is required in the Pin model, so we'll
      # delete the title from the @pin_hash in order
      # to test what happens with invalid parameters
      @pin_hash.delete(:title)
      post :create, pin: @pin_hash
      expect(response).to render_template(:new)
    end
    
    it 'assigns the @errors instance variable on error' do
      # The title is required in the Pin model, so we'll
      # delete the title from the @pin_hash in order
      # to test what happens with invalid parameters
      @pin_hash.delete(:title)
      post :create, pin: @pin_hash
      expect(assigns[:errors].present?).to be(true)
    end    
    
    it 'can\'t be accessed when a user is not logged in' do
      logout(@user)
      post :create, pin: @pin_hash
      expect(response).to redirect_to(:login)
    end

  end

  describe "GET /pins/:id/edit" do
 	before (:each) do
		@pin = Pin.create(title: 'Learn RUBY hard way', 
			url: 'http://google.com', 
			text: "Some super text",
    		slug: "ruby-hard",
  			category_id: "ruby")
	end
  
  after(:each) do
    pin = Pin.find_by_slug("ruby-hard")
    if pin.present?
      pin.delete
    end    
  end

    it 'responds with success' do
      get :edit, id: @pin.id
      expect(response.success?).to be(true)
    end
 
    it 'renders the edit template' do
      get :edit, id: @pin.id      
      expect(response).to render_template(:edit)
    end
    
    it 'assigns an instance variable @pin to the Pin with appropriate id' do
      get :edit, id: @pin.id
      expect(assigns(:pin)).to eq(@pin)
    end

    it 'can\'t be accessed when a user is not logged in' do
      logout(@user)
      get :edit, id: @pin.id
      expect(response).to redirect_to(:login)
    end

  end

  describe "PUT update" do  
  		before (:all) do
     		@pin = Pin.create(title: "Learn RUBY hard way", 
      		url: "http://google.com", 
      		text: "Some super text",
        	slug: "ruby-hard",
        	category_id: "ruby") 
		end

    it 'can\'t be accessed when a user is not logged in' do
      logout(@user)
      put :update, :id => @pin.id, :pin => {title: "111"}
      expect(response).to redirect_to(:login)
    end

  	context "request to /pins with valid parameters" do
		let(:attr) do
        	{ :title => "Learn Rails", 
          	:url => "New url",
          	:text => "The new text",
          	:slug => "ruby-hard"
           }
      	end      

		before(:each) do
        	put :update, :id => @pin.id, :pin => attr
        	@pin.reload
		end

      it 'updates a pin' do
        puts "===================\n" + response.body        
        expect(@pin.title).to eql attr[:title] 
        expect(@pin.url).to eql attr[:url]
        expect(@pin.text).to eql attr[:text]
        expect(@pin.slug).to eql attr[:slug]

     end
    
      it 'redirects to the show view' do
          #puts "===================\n" + response.body        
          expect(response).to redirect_to(pin_path(assigns(:pin)))

      end
    end

    context "request to /pins with invalid parameters" do
		let(:attr) do
        	{ :title => "", 
          	:url => "",
          	:text => "The new text",
          	:slug => "ruby-hard"
           }
      	end      



		before(:each) do
        	put :update, :id => @pin.id, :pin => attr
        	@pin.reload
		end

		it "assigns an @errors instance variable" do
			#puts "===================\n" + response.body
			expect(assigns[:errors].present?).to be(true)
		end

		it "renders the edit view" do
			#puts "===================\n" + response.body
			expect(response).to render_template(:edit)
		end
	end

  end

  describe "POST /pins/repin/:id" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      login(@user)
      @pin = FactoryGirl.create(:pin)

      post :repin, id: @pin.id
    end

    after(:each) do
      pin = Pin.find_by_slug("rails-wizard")
      unless pin.nil?
        pin.destroy
      end
      logout(@user)
    end 

    it "responds with a redirect" do
      expect(response).to have_http_status(:redirect)
    end

    it "creates a pinning (the pin is now in the user's pins)" do 
      #expect(@user.pins).to include(@pin)
    end

    it "redirects to the user show page" do
      expect(response).to redirect_to(user_path(assigns(:user)))
    end

  end

end

