class FamiliesController < ApplicationController
  
  def new
    @family = Family.new
  end
  
  def create 
    @family = Family.new(family_params)
    if @family.save
      # current_user.update(host_user: true, family_id: @family.id)
      session[:family_id] = @family.id
      redirect_to signup_path
    else
      render :new
    end
  end
  
  private 
    def family_params
      params.require(:family).permit(:name, :family_unique_id)
    end
  
end
