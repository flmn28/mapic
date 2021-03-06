class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :redirect_to_top_when_logged_in, only: [:new, :create, :login_form, :login]
  before_action :authenticate_user, except: [:new, :create, :login_form, :login]

  def index
    @users = User.all
  end

  def show
  end

  def mypage
    @title = "#{current_user.name}さんの投稿"
    @locations = current_user.locations.order(created_at: :desc)
  end

  def mypage_option
    params_array = Tag.all.map { |tag| params["tag" + tag.id.to_s] }
    @title = params[:condition] == "1" ? "#{current_user.name}さんの投稿" : "いいねした投稿"
    @locations = Location.select_by_mypage_option(params[:condition], params_array, current_user)
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
        session[:user_id] = @user.id
        flash[:success] = "アカウントを作成しました"
        format.html { redirect_to map_path }
        format.json { render :show, status: :created, location: @user }
      else
        modify_password_error_message
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        flash[:success] = "アカウントを編集しました"
        format.html { redirect_to mypage_path }
        format.json { render :show, status: :ok, location: @user }
      else
        modify_password_error_message
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
      flash[:success] = "ログインに成功しました"
      redirect_to map_path
    else
      flash[:danger] = "メールアドレスまたはパスワードが間違っています"
      render :login_form
    end
  end

  def logout
    session[:user_id] = nil
    flash[:warning] = "ログアウトしました"
    redirect_to login_path
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def modify_password_error_message
      if @user.errors.messages[:password][0] == "can't be blank"
        @user.errors.messages.shift
        @user.errors.messages[:password].push('パスワードを入力してください')
      elsif @user.errors.messages[:password_confirmation][0] == "doesn't match Password"
        @user.errors.messages.shift
        @user.errors.messages[:password].push('パスワードが一致していません')
      end
    end
end
