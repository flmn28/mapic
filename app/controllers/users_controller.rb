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
    params_array = [params[:scenery], params[:building], params[:nature],
                    params[:food], params[:amusement], params[:others]]

    if params_array == Array.new(6) && params[:condition] == "1"
      @title = "#{current_user.name}さんの投稿"
      return @locations = current_user.locations.order(created_at: :desc)
    elsif params_array == Array.new(6) && params[:condition] == "2"
      @title = "#{current_user.name}さんがいいねした投稿"
      return @locations = current_user.like_locations.order(created_at: :desc)
    end

    if params[:condition] == "1"
      @title = "#{current_user.name}さんの投稿"
      selected_location_ids = current_user.locations.pluck(:id)
    elsif params[:condition] == "2"
      @title = "#{current_user.name}さんがいいねした投稿"
      selected_location_ids = current_user.like_locations.pluck(:id)
    end

    tagged_location_ids_array = []
    params_array.each_with_index do |param, i|
      if param
        ids = Tag.find_by(id: i + 1).locations.pluck(:id)
        tagged_location_ids_array.concat(ids)
      end
    end
    tagged_location_ids = tagged_location_ids_array.uniq

    location_ids = selected_location_ids & tagged_location_ids
    unsorted_locations = location_ids.map { |id| Location.find_by(id: id) }
    @locations = unsorted_locations.sort_by { |location| location.created_at }
    @locations.reverse!
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
        format.html { redirect_to root_path }
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
      redirect_to root_path
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

    def redirect_to_top_when_logged_in
      if session[:user_id]
        flash[:danger] = "既にログインしています"
        redirect_to root_path
      end
    end
end
