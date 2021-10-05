class DailyRecord < ApplicationRecord
    belongs_to :daily_record_type
    # belongs_to :cat
    # belongs_to :user
    
    validates :daily_record_type_id, presence: true
    validates :memo, length: {maximum: 20}

    
    # ↓選択するタイプに応じて必要なカラムだけpresence:true↓
    
    # if daily_record_type_id == 1 || daily_record_type_id == 12 # ご飯、フード(購入)
    #     validates_presence_of :count, :amount
    # elsif daily_record_type_id == 2 # 水
    #     validates_presence_of :amount
    # elsif daily_record_type_id == 3 || daily_record_type_id == 6 || daily_record_type_id == 7 || daily_record_type_id == 13
    #     # オシッコ、毛玉、おやつ、サンド(購入)
    #     validates_presence_of :count
    # elsif daily_record_type_id == 4 # ウンチ
    #     validates_presence_of :count, :status
    # elsif daily_record_type_id == 5 # 体重
    #     validates_presence_of :weight
    # else  # 8お風呂、9ブラシ、10病院、11ワクチン
    #     # なし
    # end
    
        
end
