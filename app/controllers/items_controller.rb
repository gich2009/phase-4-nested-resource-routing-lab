class ItemsController < ApplicationController
  wrap_parameters format: []
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def index
    if params[:user_id]
      items = User.find(params[:user_id]).items
    else
      items = Item.all
    end

    render json: items, except: [:created_at, :updated_at], include: {user: {except: [:created_at, :updated_at]}}
  end

  def show
    if params[:user_id]
      item = User.find(params[:user_id]).items.find(params[:id])
    else
      item = Item.find(params[:id])
    end
    
    render json: item, except: [:created_at, :updated_at]
  end


  def create
    item = Item.create(item_params)

    if params[:user_id]
      User.find(params[:user_id]).items << item
    end

    render json: item, except: [:created_at, :updated_at], status: :created
  end

  private
  def item_params
    params.permit(:name, :description, :price)
  end

  def find_item
    Item.find(params[:id])
  end

  def render_unprocessable_entity exception
    render json: {errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def render_not_found exception
    render json: {error: "#{exception.model.humanize} not found" }, status: :not_found
  end

end
