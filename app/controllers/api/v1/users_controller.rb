class Api::V1::UsersController < ApplicationController

    # skip_before_action :authorized, only: [:create]
 
  def profile
    render json: current_user, status: :accepted
  end
 
  def create
    # byebug
    user = User.new(user_params)

    if user.valid?
      user.save
      render json: {user: user}, status: :created
    else
      render json: {error: "Failed to create a user"}, status: :not_acceptable
    end
  end

  def index
    users = User.all
    render json: users, except: [:created_at, :updated_at], include: [:daily_logs =>{except: [:created_at, :updated_at], include: [:food_items => {except: [:created_at, :updated_at]}]}], methods: [:log_per_day, :calories_per_day]
  end

  def show 
    user = User.find_by(id: params[:id])
    render json: user, except: [:created_at, :updated_at], include: [:daily_logs =>{except: [:created_at, :updated_at], include: [:food_items => {except: [:created_at, :updated_at]}]}]

    # render json: teachers, include: [:students => {include: [:student_assignments => {include: [:assignment]}]}]
  end

  def update
    user = User.find_by(id: params[:id])
    # byebug
    user.update(user_params)
    render json: user, except: [:created_at, :updated_at], include: [:daily_logs =>{except: [:created_at, :updated_at], include: [:food_items => {except: [:created_at, :updated_at]}]}]
end


  private
  def user_params
    params.permit(:name, :email, :password, :weight, :bank, :image, :city)
  end

end
