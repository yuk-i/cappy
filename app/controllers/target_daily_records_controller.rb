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
  
  # カレンダー表示
  def index
    @cat = Cat.find(params[:cat_id])
    @my_records = TargetDailyRecord.where(cat_id: @cat.id)
    @record_types = DailyRecordType.all
    if params[:start_date]
      @start_date = Date.parse("#{params[:start_date]}")
    else
      @start_date = Date.today
    end
  end
  
  # グラフ表示
  def chart
    logger.debug("=============== params[:year][:month] = #{params[:year]},#{params[:month]}")
    @year = params[:year]
    @month = params[:month]
    @display_day = Date.parse("#{@year}-#{@month}-1")
    @cat = Cat.find(params[:cat_id])
    # @cat = Cat.find(1)
        logger.debug("=============== params[:select_type] = #{params[:select_type]}")
        if params[:select_type].present?
          @type = params[:select_type].to_i
        else
          @type = 1
        end
        
        # ↓変数@display_dayと@typeに値が入っているか確認している
        logger.debug("=========== chart set = #{@display_day} type = #{@type}")
        # chart_setメソッドを呼び出す
        chart_set(@cat,@display_day, @type)
        
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
      
      if type == 1 # ご飯(amount, count)
        @all_foods_arr = @all_records.where(daily_records: {daily_record_type_id: 1}).pluck("target_daily_records.target_date, daily_records.amount, daily_records.count").sort
        
        # 月まるまる登録が一度もなければ@chartデータなし
        if @all_foods_arr == []
          @chart = []
        else  
          @chart = []
              compare_array = []
              # 指定の日の月末の日.times ・・・　指定の月末の日までの回数繰り返す　例）31日であれば、0～30までの31回処理を繰り返す　
              display_day.end_of_month.mday.times do |k|
                # 1か月分の配列を作成　※amountとcountの値は0
                compare_array << [Date.parse("#{display_day.year}-#{display_day.month}-#{k+1}"), 0, 0]
              end
              
              logger.debug("========== compare_array  = #{compare_array}")
              
              j = 0
              compare_array.each_with_index do |ca_element, i|
                
                  @all_foods_arr[j..-1].each_with_index do |aa, k|
                    # daily_recordに登録があれば↑で作った値が0の配列は不要。@chartに、登録があるaaを代入
                    if ca_element[0] == aa[0]
                      logger.debug("========== ca_element[0] == aa[0]  = ca_element = #{ca_element[0]} aa[0] = #{aa[0]}")
                      @chart[i] = aa
                      logger.debug("========== @chart_#{i} = #{@chart[i]}")
                      
                      # jの数を増やすことで、次にeachでまわすときの先頭の配列が変わる
                      j = j + 1
                      break
                    # 次のdaily_record登録日と一致するまでは、ひたすら値0の配列を@chartに代入していく
                    elsif ca_element[0] < aa[0]
                      logger.debug("========== ca_element[0] < aa[0] = ca_element = #{ca_element[0]} aa[0] = #{aa[0]}")
                      @chart << ca_element
                      # 確認用に最後尾の配列表示
                      logger.debug("========== @chart_#{i} = #{@chart[-1]}")
                    else
                      # どちらにも一致しなければerror
                      logger.debug("========== ca_element[0] > aa[0] = ca_element = #{ca_element[0]} aa[0] = #{aa[0]}")
                    end
                    # ↑ca_element[0] == aa[0]の条件に当てはまるまでひたすらeachでまわすシステム
                  end
                  
                  # @all_foods_arrの最終レコードが月末でない場合（＝空データの日付の方が大きい場合）空のデータを代入する・・・を月末分まで繰り返す
                  if ca_element[0] > @all_foods_arr[-1][0]
                    @chart[i] = ca_element
                  end
              end
            end
            # countとamountの合計を求める
            @chart.each do |s|
              if s[1] == nil || s[2] == nil
                logger.debug("========== nil  = #{s}")
                s[1,2] = 0,0 
                logger.debug("========== nil  = #{s}")
              end
              s[1] = s[1] * s[2]
              s.delete_at(2)
            end
            
            # 最終配列の中身確認
            logger.debug("========== all_count  = #{@chart}")
            
      elsif type == 5 # 体重 [target_date, weight]
        @all_content_arr = @all_records.where(daily_records: {daily_record_type_id: 5}).pluck("target_daily_records.target_date, daily_records.weight").sort
        logger.debug("========== @all_content_arr = #{@all_content_arr}")
        
        # 月まるまる登録が一度もなければ@chartデータなし
        if @all_content_arr == []
          @chart = []
        else
          @chart = []
            compare_array = []
            display_day.end_of_month.mday.times do |k|
              compare_array << [Date.parse("#{display_day.year}-#{display_day.month}-#{k+1}"), 0]
            end
            
          logger.debug("========== compare_array  = #{compare_array}")  
          
          @all_content_arr.each_with_index do |aa, i|
            compare_array.each_with_index do |c, k|
              if aa[0] == c[0] 
                logger.debug("========== c[0],aa[0] = #{c[0]} = #{aa[0]}") 
                 compare_array[k] = aa
              else
                logger.debug("========== compare_array[k] = #{compare_array[k]} @all_content_arr[i]= #{@all_content_arr[i]}") 
              end
            end
          end
          
          @chart = compare_array
          logger.debug("========== @chart  = #{@chart}")  
          
          # # 月初の登録が0の場合、それ以前の中で最新の情報を取得。無ければCat登録情報から取得。
          # if @chart[0][1] == 0
            
          #   # @display_dayの月初より前に登録があれば…その中で最新の情報を取得し、月初の情報として引き継ぐ。
          #   if @before_day_records = @cat.target_daily_records.joins(:daily_records).where("target_date < ?", display_day.beginning_of_month)
          #     logger.debug("========== @before_day_records = #{@before_day_records}")
          #     @before_day_content = @before_day_records.where(daily_records: {daily_record_type_id: 5}).pluck("target_daily_records.target_date, daily_records.weight").sort.last
          #     logger.debug("========== @before_day_content = #{@before_day_content}")
          #     @chart[0] = @before_day_content
          #   else # @display_dayの月初より前に登録がなければ…Cat情報で登録している体重を月初の情報として引き継ぐ。
          #     @chart[0][1] = @cat.weight
          #     logger.debug("========== @cat.weight  = #{@cat.weight}") 
          #   end
          #   logger.debug("========== @chart  = #{@chart}")
          # end 
          
          # ↓↓入力していない日も過去の数値を引き継ぐ場合
          
          @chart.each_with_index do |ch, s|
            if s == 0 # 月初日
                if ch[1] == 0 
                  # 月初の登録が0の場合、それ以前の中で最新の情報を取得。無ければCat登録情報から取得。
                  if @before_day_records = @cat.target_daily_records.joins(:daily_records).where("target_date < ?", display_day.beginning_of_month)
                    @before_day_content = @before_day_records.where(daily_records: {daily_record_type_id: 5}).pluck("target_daily_records.target_date, daily_records.weight").sort.last
                    logger.debug("========== @before_day_content = #{@before_day_content}")
                    @chart[0][1] = @before_day_content[1]
                  else # @display_dayの月初より前に登録がなければ…Cat情報で登録している体重を月初の情報として引き継ぐ。
                    @chart[0][1] = @cat.weight
                    logger.debug("========== @cat.weight  = #{@cat.weight}") 
                  end
                end  
            else  # 月初以外の日
              logger.debug("========== ch = #{ch[1]}") 
              # 登録がなければ前日の情報を引き継ぐ
              if ch[1] == 0 
                @chart[s][1] = @chart[s-1][1]
                logger.debug("========== @chart[s][1] = #{@chart[s]}#{@chart[s-1]}") 
              end
            end
          end
          
          logger.debug("========== @chart  = #{@chart}")
    
          
        end  
        
      elsif 
        
        # typeによって取得するデータが変わる
        if type == 2 # 水 [target_date, amount]
          @all_content_arr = @all_records.where(daily_records: {daily_record_type_id: 2}).pluck("target_daily_records.target_date, daily_records.amount").sort
        else # 他すべて ※type3.6.7.8.9.10  [target_date, count]
          @all_content_arr = @all_records.where(daily_records: {daily_record_type_id: type}).pluck("target_daily_records.target_date, daily_records.count").sort  
        end
        logger.debug("========== @all_content_arr = #{@all_content_arr}")
        
        # 月まるまる登録が一度もなければ@chartデータなし
        if @all_content_arr == []
          @chart = []
        else
          @chart = []
            compare_array = []
            display_day.end_of_month.mday.times do |k|
              compare_array << [Date.parse("#{display_day.year}-#{display_day.month}-#{k+1}"), 0]
            end
            
          logger.debug("========== compare_array  = #{compare_array}")  
          
          @all_content_arr.each_with_index do |aa, i|
            compare_array.each_with_index do |c, k|
              if aa[0] == c[0] 
                logger.debug("========== c[0],aa[0] = #{c[0]} = #{aa[0]}") 
                 compare_array[k] = aa
              else
                logger.debug("========== compare_array[k] = #{compare_array[k]} @all_content_arr[i]= #{@all_content_arr[i]}") 
              end
            end
          end
          
          logger.debug("========== compare_array  = #{compare_array}")  
          @chart = compare_array
        end  
        
        # あとで実装予定！
        # type == 4 # うんち [target_date, count, status]
        #   @all_content_arr = @all_records.where(daily_records: {daily_record_type_id: 4}).pluck("target_daily_records.target_date, daily_records.count, daily_records.status").sort
      
      end
      
    end    

end
