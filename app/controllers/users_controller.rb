class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  
  # Connects to Bing Translator API
  @@translator = BingTranslator.new('qb_translate', 'EYU0DbmY3bSbJZVtDwp0fTDUNJxgZeiT5Qww4MedYfQ=')
 
  # Translates inout text
  def translate_data (input_data, input_from, input_to)
    @@translator.translate "#{input_data}", :from => "#{input_from}", :to => "#{input_to}"
  
  end

  # Returns Language name corresponding to the Language code passed
  def find_lang (lang_code)
    LANGUAGE_LIST.each do |element|
      if element[1] == lang_code 
        return element[0] 
      end
    end
  end

  # GET /users/1
  # Displays Translated Output with input details
  def show
    if @user.from == "" then @user.from = @@translator.detect(@user.input)  end  
    @user.from = find_lang(@user.from.to_s)
    @user.to = find_lang(@user.to)
  end

  # GET /users/new
  def new
    @user = User.new
  end


  # POST /users
  # POST /users.json
  def create
    @user = User.create(user_params)
    @user.output = translate_data(@user.input, @user.from, @user.to )
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:input, :from, :to, :output)
    end
end
