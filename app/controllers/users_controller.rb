class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # 以下の2つには:createも追加
  before_action :redirect_to_top_when_logged_in, only: [:new, :create, :login_form, :login]
  before_action :authenticate_user, except: [:new, :create, :login_form, :login]

  def index
    @users = User.all
  end

  def show
  end

  def mypage
    @locations = current_user.locations
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def login_form
  end

  def login
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "ログインに成功しました"
      redirect_to root_path
    else
      flash[:notice] = "メールアドレスまたはパスワードが間違っています"
      render :login_form
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to login_path
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def redirect_to_top_when_logged_in
      if session[:user_id]
        flash[:notice] = "既にログインしています"
        redirect_to root_path
      end
    end
end
