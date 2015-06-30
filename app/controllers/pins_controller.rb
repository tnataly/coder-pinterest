class PinsController < ApplicationController
  before_action :require_login, except: [:show, :show_by_name]

  def index
    @pins = Pin.all

  end
  
  def show
    @pin = Pin.find(params[:id])
    @users = User.joins(:pinnings).where(pinnings: {pin_id: @pin.id})
  end
      
  def show_by_name
  	@pin = Pin.find_by_slug(params[:slug])
    # or just simpler: @user = @pin.users
    @users = User.joins(:pinnings).where(pinnings: {pin_id: @pin.id}) 

  	render :show
  end

  def new
    @pin = Pin.new
    @pin.pinnings.build
  end

  def create
    @pin = Pin.create(pin_params)

    if @pin.valid?
      @pin.save
      #render :show
      redirect_to pin_by_name_path(slug: @pin.slug)
    else
      @errors = @pin.errors
      render :new
    end
  end

  def edit
    @pin = Pin.find(params[:id])
  end

  def update
    @pin = Pin.find(params[:id])
    if @pin.update(pin_params)
      redirect_to pin_path, notice: 'Your pin was successfully updated.'
    else
      @errors = @pin.errors
      render action: 'edit'
   end
  end

  def repin
    @pin = Pin.find(params[:id])
    @pin.pinnings.create( user_id: params[:user_id], 
       board_id: params[:board_id]
       )
    redirect_to user_path(current_user)
  end

private 
  def pin_params
    params.require(:pin).permit(:title, :url, :slug, :text, :category_id, 
      :image_file_name, :image, 
      :user_id, 
      :pinning_ids => [],
      :pinnings_attributes => [:id, :user_id, :board_id]
      )
      
  end

end