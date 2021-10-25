require "date"

class CatsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_category, only: [:new, :edit]
  before_action :set, only: [:home, :show]
  before_action :set_messages, only: [:home]
  
  def new
    @family = current_user.family
    @cat = Cat.new(family_id: @family.id)
    @cat_personalities = @cat.cat_personalities.build
    session[:family_id] = nil
  end
  
  def create
    @cat = Cat.new(cat_params)
    logger.debug("============== cat create cat_personalities_id  = #{params[:cat_personalities][:cat_personality_category_id]}")
    @cat_personalities_array = [params[:cat_personalities][:cat_personality_category_id][1], params[:cat_personalities][:cat_personality_category_id][2]]
    logger.debug("============== cat create cat_personalities_id delete at (1) = #{@cat_personalities_array}")
    if @cat.save
      cat_personality_save_flag = true
      @cat_personalities_array.each do |cat_personality|
         unless @cat.cat_personalities.create(cat_personality_category_id: cat_personality.to_i)
           cat_personality_save_flag = false
         end
      end
      
      if cat_personality_save_flag === true
      # if CatPersonality.create(cat_id: @cat.id, cat_personality_category_id: params[:cat_personalities][:cat_personality_category_id])
        if params[:commit] == "登録する"
          flash[:notice] = "猫ちゃんの登録が完了しました"
          redirect_to home_cat_path(@cat)
        else
          redirect_to new_cat_path
        end
      else
        render :new
      end
    else 
      render :new
    end
    
  end
  
  def home
    @first_cat = Cat.find_by(family_id: @family.id)
    if @cat.family_id != @family.id
      flash[:notice] = "権限がありません"
      redirect_to("/")
    end
  end
  
  def show
    @cat_age = (Date.today.strftime('%Y%m%d').to_i - @cat.birthday.strftime('%Y%m%d').to_i) / 10000
  end
  
  def edit
    @cat = Cat.find(params[:id])
    # CatPersonalityモデルのcat_personality_category_idの値を配列にするためにpluckを使った。(2021/9/17 松下)
    @cat_personality_ids = @cat.cat_personalities.pluck(:cat_personality_category_id)
  end
  
  def update
    @cat = Cat.find(params[:id])
    @cat.update(cat_params)
    flash[:notice] = "更新が完了しました"
    redirect_to cat_path(@cat)
  end
  
  # 実装未
  def destroy
    @cat = Cat.find(params[:id])
    redirect_to("/")
  end
  
  # 猫アイコン選択で他の猫ページに飛ぶ為の一覧
  # def index
  #   @family_id = current_user.family_id
  #   @family_cats = Cat.where(id: @family_id)
  # end
  
  private
  
    def get_category
      @cat_categories = CatCategory.all
      @cat_sands = CatSandCategory.all
      @cat_personality_categories = CatPersonalityCategory.all
    end
  
    def cat_params 
      params.require(:cat).permit(:name, :birthday, :gender, :weight, :food_amount, 
                                  :pee_count, :poop_count, :favorite_snack, :favorite_toy, :characteristic, 
                                  :family_id, :cat_category_id, :cat_sand_category_id, :hospital, :memo, :image, :main_image,
                                  cat_personalities_attributes: [:cat_personality_category_id])
    end
    
    #フラッシュメッセージ実装 => 状況に応じたメッセージ自動表示を実装予定
    def set_messages
      @cat_age = (Date.today.strftime('%Y%m%d').to_i - @cat.birthday.strftime('%Y%m%d').to_i) / 10000
      @cat_before_birthday = (@cat.birthday) -7
      @one_week_ago = (Date.today) -7
      
      if  @cat.birthday.month == Date.today.month && @cat.birthday.day  == Date.today.day # 誕生日
        flash[:cat_home] = "今日は#{@cat.name}ちゃんのお誕生日ですね。おめでとうございます。"
        
      elsif @cat.birthday.month == Date.today.month && @cat_before_birthday.day == @one_week_ago.day # 誕生日1週間前
        flash[:cat_home] = "もうすぐ#{@cat.name}ちゃんのお誕生日です。#{(@cat_age) +1}歳になりますね。"
          
      else 
        flash[:cat_home] = "おかえりなさい#{@user.nickname}さん"
      end
        
    end
    
    def set
      @cat = Cat.find(params[:id])
      @family = current_user.family
      @user = current_user
      
      unless @cat = Cat.find(params[:id])
        @cat = Cat.find_by(family_id: @family.id)
      end
        
    end

    
end
