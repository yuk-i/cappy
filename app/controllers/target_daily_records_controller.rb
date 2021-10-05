class TargetDailyRecordsController < ApplicationController
  require 'date'
  before_action :target_record_set, except: [:index, :chart]
  before_action :type_set
  

  def show
    if @target_daily_record = TargetDailyRecord.find_by(cat_id: @cat.id, target_date: @display_day)
      @days = @target_daily_record.daily_records
    else  # showデータがなければNewへ飛ぶ
      redirect_to cat_new_record_path(@cat,@display_day)
      
    end
  end
  
  def index
    @cat = Cat.find(params[:cat_id])
  end
  
  # グラフ表示
  def chart
    logger.debug("=============== params[:year][:month] = #{params[:year]},#{params[:month]}")
    @year = params[:year]
    @month = params[:month]
    @display_day = Date.parse("#{@year}-#{@month}-1")
    # @cat = Cat.find(params[:cat_id])
    @cat = Cat.find(1)
    
        # 2021/9/30 add for chart.html.erb search pamams by matsushita ↓
        logger.debug("=============== params[:select_type] = #{params[:select_type]}")
        if params[:select_type].present?
          @type = params[:select_type]
        else
          @type = "1"
        end
        
        # ↓変数@display_dayと@typeに値が入っているか確認している
        logger.debug("=========== chart set = #{@display_day} type = #{@type}")
        # chart_setメソッドを呼び出す
        chart_set(@cat,@display_day, @type)
        # ------------------------------------------------------------- ↑
  end
  
  def new
    @target_daily_record = TargetDailyRecord.new
    @target_daily_record.daily_records.build
    
    
  end

  def create
    
    # record_params[:daily_records_attributes].each do |daily_record|
    #   logger.debug("============== target_daily_record create = #{daily_record[1][:daily_record_type_id]}")
    #     {daily_record[1][:daily_record_type_id]
    #   if daily_record[1][:daily_record_type_id] === "1"
    #     if daily_record[1][:count] != ""
    #       DailyRecord.create()
    #     end
    # end
    @target_daily_record = TargetDailyRecord.new(record_params)
    
    if @target_daily_record.save
      
      @target_daily_record.daily_records.each do |daily_record|
        if daily_record.count == nil && daily_record.amount == nil && daily_record.weight == nil
          daily_record.destroy
        end
      end

      redirect_to cat_record_path(@cat,@display_day)
    else
      render :new
    end

  end

  def edit
    @target_daily_record = TargetDailyRecord.find_by(cat_id: @cat.id, target_date: @display_day)
    @days = @target_daily_record.daily_records
  end

  def update
  end

  def destroy
    @target_daily_record = TargetDailyRecord.find_by(cat_id: @cat.id, target_date: @display_day)
    @target_daily_record.daily_records.destroy_all
    @target_daily_record.destroy
    redirect_to cat_new_record_path(@cat,@display_day)
    
  end
  
  
  
  private
  
    def target_record_set
      @cat = Cat.find(params[:cat_id])
      logger.debug("=============== params[:display_day] = #{params[:display_day]}")
      @display_day = Date.parse(params[:display_day])
      @week = %w(日 月 火 水 木 金 土)[@display_day.wday]    
    end
    
    def record_params 
      params.require(:target_daily_record).permit(:cat_id, :user_id, :target_date, 
      daily_records_attributes: [:daily_record_type_id, :count, :amount, :status, :weight, :memo, :target_daily_record_id])
    end
    
    def type_set
      @record_types = DailyRecordType.all
      @type_image = @record_types.pluck(:image)
    end
    
    def chart_set(cat, display_day, type)
      # 2021/9/30 modify by matsushita ↓
      logger.debug("======== chart_set")
      # 指定のCatのターゲットレコード＆デイリーレコードの中から、@display_dayの日を含む「月」のもの全てを取得
      @all_records = @cat.target_daily_records.joins(:daily_records).where(target_date: display_day.in_time_zone.all_month)
      # ------------------------------ ↑
      
      # データがない日に0のデータを作成する
      
      if type == "1"
        # パターン１（food） ----------------------
        @all_foods_arr = @all_records.where(daily_records: {daily_record_type_id: 1}).pluck("target_daily_records.target_date, daily_records.amount, daily_records.count").sort
        @chart = []
            compare_array = []
            # 指定の日の月末の日.times ・・・　指定の月末の日までの回数繰り返す　例）31日であれば、0～30までの31回処理を繰り返す　
            display_day.end_of_month.mday.times do |k|
              # 1か月分の配列を作成　※amountとcountの値は0
              compare_array << [Date.parse("#{display_day.year}-#{display_day.month}-#{k+1}"), 0, 0]
            end
            
            logger.debug("========== compare_array  = #{compare_array}")
            logger.debug("========== @all_foods_arr     = #{@all_foods_arr}")
            
            j = 0
            # compare_arrayと@all_foods_arrを同時にeachで回転させることで、一致すればafaを代入、しなければca_elementを代入するメソッド
            compare_array.each_with_index do |ca_element, i|
              
               @all_foods_arr[j..-1].each_with_index do |aa, k|
                    # daily_recordに登録があれば↑で作った値が0の配列は不要。@all_foodsの配列に、登録があるafaを代入
                    if ca_element[0] == aa[0]
                      logger.debug("========== ca_element[0] == aa[0]  = ca_element = #{ca_element[0]} aa[0] = #{aa[0]}")
                      @chart[i] = aa
                      logger.debug("========== @chart_#{i} = #{@chart[i]}")
                      j = j + 1
                      # breakでループを脱出
                      break
                    # 次のdaily_record登録日と一致するまでは、ひたすら値0の配列を@all_foodsに代入していく
                    elsif ca_element[0] < aa[0]
                      logger.debug("========== ca_element[0] < aa[0] = ca_element = #{ca_element[0]} aa[0] = #{aa[0]}")
                      @chart << ca_element
                      # 確認用に最後尾の配列表示
                      logger.debug("========== @chart_#{i} = #{@chart[-1]}")

                    else
                      # @chart << ca_element
                      # どちらにも一致しなければerrorとし、配列を空に戻す＆エラーメッセージ
                      logger.debug("========== ca_element[0] > aa[0] = ca_element = #{ca_element[0]} aa[0] = #{aa[0]}")
                      # @chart = []
                      # flash[:alert] = "データに問題があるためグラフが表示できません。"
                    end
              end
              
              # 追加しました 最終レコードが月末でない場合　月末までのデータをゼロで追加する
              if ca_element[0] > @all_foods_arr[-1][0]
                @chart[i] = ca_element
              end
              
              
            end
            # 最終配列の中身確認
            logger.debug("========== all_count  = #{@chart}")
            
            # フードのみcountとamountの合計を求める
            @chart.each do |s|
              s[1] = s[1] * s[2]
              s.delete_at(2)
            end
            
      elsif 
        if type == "2" # 水 [target_date, amount]
          @all_content_arr = @all_records.where(daily_records: {daily_record_type_id: 2}).pluck("target_daily_records.target_date, daily_records.amount").sort
        elsif type == "5" # 体重 [target_date, weight]
          @all_content_arr = @all_records.where(daily_records: {daily_record_type_id: 5}).pluck("target_daily_records.target_date, daily_records.weight").sort
        else # 他すべて ※仮で水にしてる
          @all_content_arr = @all_records.where(daily_records: {daily_record_type_id: 2}).pluck("target_daily_records.target_date, daily_records.amount").sort  
        end
        
        @chart = []
            compare_array = []
            display_day.end_of_month.mday.times do |k|
              compare_array << [Date.parse("#{display_day.year}-#{display_day.month}-#{k+1}"), 0]
            end
            
            logger.debug("========== compare_array  = #{compare_array}")
            logger.debug("========== @all_content_arr     = #{@all_content_arr}")
            
            compare_array.each_with_index do |ca_element, i|
              @all_content_arr.each_with_index do |aa, k|
                    if ca_element[0] == aa[0]
                      logger.debug("========== ca_element[0] == aa[0]  = ca_element = #{ca_element[0]} aa[0] = #{aa[0]}")
                      @chart[i] = aa
                      logger.debug("========== @all_waters[#{k}} = #{@chart[i]}")
                      break
                    elsif ca_element[0] < aa[0]
                      logger.debug("========== ca_element[0] !== aa[0] = ca_element = #{ca_element[0]} aa[0] = #{aa[0]}")
                      @chart << ca_element
                      logger.debug("========== @chart_#{k} = #{@chart[-1]}")
                      break
                    elsif ca_element[0] > aa[0]
                      logger.debug("========== ca_element[0] !== aa[0] = ca_element = #{ca_element[0]} aa[0] = #{aa[0]}")
                      @chart << ca_element
                      # 確認用に最後尾の配列表示
                      logger.debug("========== @chart_#{k} = #{@chart[-1]}")
                      break
                    else
                      # どちらにも一致しなければerrorとし、配列を空に戻す＆エラーメッセージ
                      logger.debug("========== error = #{aa}")
                      @chart = []
                      flash[:alert] = "データに問題があるためグラフが表示できません。"
                    end
              end
            end
            # 最終配列の中身確認
            logger.debug("========== all_count  = #{@chart}")
      
      end    
      # -----------------------------------------------------------
      
      
      
      
      
      # @all_pees = @all_records.where(daily_records: {daily_record_type_id: 3}).pluck("target_daily_records.target_date, daily_records.count").sort
      # @all_poops = @all_records.where(daily_records: {daily_record_type_id: 4}).pluck("target_daily_records.target_date, daily_records.count").sort
      # @all_weights = @all_records.where(daily_records: {daily_record_type_id: 5}).pluck("target_daily_records.target_date, daily_records.weight").sort
      # @all_hairballs = @all_records.where(daily_records: {daily_record_type_id: 6}).pluck("target_daily_records.target_date, daily_records.count").sort
      # @all_snacks = @all_records.where(daily_records: {daily_record_type_id: 7}).pluck("target_daily_records.target_date, daily_records.count").sort
      # @all_baths = @all_records.where(daily_records: {daily_record_type_id: 8}).pluck("target_daily_records.target_date, daily_records.count").sort
      # @all_brushing = @all_records.where(daily_records: {daily_record_type_id: 9}).pluck("target_daily_records.target_date, daily_records.count").sort
      # @all_hospitals = @all_records.where(daily_records: {daily_record_type_id: 10}).pluck("target_daily_records.target_date, daily_records.count").sort
      
      
      
      
    end

end
