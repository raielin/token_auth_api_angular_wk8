class UsersController < ApplicationController
  # POST /login
  def login
    # We use find_by_email to match our user login form
    user = User.find_by(email: params[:email])

    # if user AND user.authenticate return true then return the
    # the token and render it in json
    if user && user.authenticate(params[:password])
      render json: {"token" => user.token}
    else
      head :unauthorized
    end
  end

  # GET /logout
  def logout
    head :ok
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    render json: @users, :include => [:title, :skills]
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    render json: @user, :include => [:title, :skills]
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    head :no_content
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :role, :title_id, :skill_ids, :email, :password, :password_confirmation, :token)
    end
end
