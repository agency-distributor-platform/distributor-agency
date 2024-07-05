class ContactUsController < ApplicationController

  def index
    render json: {data: ContactUs.all}
  end

  def create
    @contact_us = ContactUs.new(contact_us_params)
    if @contact_us.save
      render status: :created
    else
      render json: {errors: @contact_us.errors}, status: :unprocessable_entity
    end
  end 

  private
  def contact_us_params
    params.require(:data).permit(:name, :email, :phone, :message)
  end
end 
