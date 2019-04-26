class PostcodesController < ApplicationController
	def index
    @postcodes = Postcode.all
  end

	def show
    @postcode = Postcode.find(params[:id])
  end

  def new
  end
 
	def create
		@postcode = Postcode.new(params.require(:postcode).permit(:code, :description))

		@postcode.save
		redirect_to @postcode
	end

	private
  def postcode_params
    params.require(:postcode).permit(:code, :description)
  end
end