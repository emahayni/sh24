class PostcodesController < ApplicationController
	def index
    @postcodes = Postcode.all
  end

	def show
    @postcode = Postcode.find(params[:id])
  end

  def new
    @postcode = Postcode.new
  end
 
	def create
		@postcode = Postcode.new(postcode_params)

    if @postcode.save
		  redirect_to @postcode
    else 
      render 'new'
    end
	end

  def edit
    @postcode = Postcode.find(params[:id])
  end

  def update
    params[:code].capitalize!
    @postcode = Postcode.find(params[:id])

    if @postcode.update(postcode_params)
      redirect_to @postcode
    else 
      render 'edit'
    end
  end

  def destroy
    @postcode = Postcode.find(params[:id])
    
    @postcode.destroy

    redirect_to postcodes_path 
  end

private
  def postcode_params
    params.require(:postcode).permit(:code, :description)
  end
end