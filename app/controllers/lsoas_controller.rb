class LsoasController < ApplicationController
	def index
    @lsoas = Lsoa.all
  end

	def show
    @lsoa = Lsoa.find(params[:id])
  end

  def new
    @lsoa = Lsoa.new
  end
 
	def create
		@lsoa = Lsoa.new(lsoa_params)

    if @lsoa.save
		  redirect_to @lsoa
    else 
      render 'new'
    end
	end

  def edit
    @lsoa = Lsoa.find(params[:id])
  end

  def update
    @lsoa = Lsoa.find(params[:id])

    if @lsoa.update(lsoa_params)
      redirect_to @lsoa
    else 
      render 'edit'
    end
  end

  def destroy
    @lsoa = Lsoa.find(params[:id])
    
    @lsoa.destroy

    redirect_to lsoas_path 
  end

private
  def lsoa_params
    params.require(:lsoa).permit(:value, :description)
  end
end