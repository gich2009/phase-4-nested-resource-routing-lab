class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def show
    user = User.find(params[:id])
    render json: user, except: [:created_at, :updated_at], include: {items: {except: [:created_at, :updated_at]}}
  end


  def render_not_found exception
    render json: {error: "#{exception.model.humanize} not found" }, status: :render_not_found
  end
  
end
