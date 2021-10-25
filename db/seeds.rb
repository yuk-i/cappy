# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# $ rails db:seed


# Cat カテゴリーデータ挿入処理
CatCategory.all.delete_all

cats = ["日本猫(サバトラ)", "日本猫(キジトラ)", "日本猫(茶トラ)", "日本猫(ミケ)", "日本猫(サビ)",
        "日本猫(黒)", "日本猫(白)", "日本猫(グレー)", "日本猫(ブチ)", "アビシニアン",
        "アメリカンカール", "アメリカンショートヘア", "エキゾチックショートヘア",
        "サイベリアン","ジャパニーズボブテイル", "シャム", "シャルトリュー","シンガプーラ",
        "スコティッシュフォールド", "スフィンクス", "ソマリ", "トンキニーズ","ノルウェージャンフォレストキャット",
        "バーマン", "ヒマラヤン", "ブリティッシュショートヘア","ペルシャ", "ベンガル",
        "マンチカン", "ミヌエット", "メインクーン", "ラガマフィン","ラグドール",
        "ラパーマ", "ロシアンブルー", "その他"]


cats.each_with_index do |cat, i|
  CatCategory.create(id: i+1, name: cat)
end

# CatSand カテゴリーデータ挿入処理
CatSandCategory.all.delete_all

cat_sands = ["おから", "紙", "鉱物", "シリカゲル", "木製", "システムトイレ用", "その他"]

cat_sands.each_with_index do |sand, i|
  CatSandCategory.create(id: i+1, name: sand)
end


# CatPersonality カテゴリーデータ挿入処理
CatPersonalityCategory.all.delete_all

cat_personalities = ["甘えん坊", "おっとり", "おしゃべり", "綺麗好き",
                        "食いしん坊", "クール", "個性的", "怖がり",
                        "神経質","人懐っこい", "よく寝る", "やんちゃ", "わがまま"]

cat_personalities.each_with_index do |personal, i|
  CatPersonalityCategory.create(id: i+1, name: personal)
end

# UserIcon カテゴリーデータ挿入処理
UserIcon.all.delete_all

user_icons = ["siro.png", "kuro.png", "grey.png", "nezumi.png", "orange.png", "akatya.png",
                "siro_kuro.png", "siro_grey.png", "siro_nezumi.png", "siro_orange.png",
                "siro_brown.png", "siro_orange_kuro.png",
                "point1.png", "point2.png", "point3.png", "point4.png", "point5.png",
                "maeble1.png", "maeble2.png", "maeble3.png", "maeble4.png",
                "maeble20.png", "maeble30.png",
                "sabi1.png", "sabi2.png", "sabi10.png", "sabi11.png", 
                "saba1.png", "saba2.png", "tyatora1.png", 
                  ]
user_icons.each_with_index do |icon, i|
    UserIcon.create(id: i+1, images: icon)
end



--------------------ここから先はseedコマンド実行していない分-------------------

# DailyRecordType データ挿入処理
DailyRecordType.all.delete_all

record_types = ["ご飯.svg", "水.svg", "おしっこ.svg", "うんち.svg", "体重.svg",
                "毛玉.svg", "おやつ.svg", "お風呂.svg", "ブラシ.svg", "病院.svg",
                "ワクチン.svg", "フード.svg", "サンド.svg"]
                       
record_types.each_with_index do |type, i|
  DailyRecordType.create(id: i+1, image: type)
end

# HospitalPostType データの挿入処理
HospitalPostType.all.delete_all

post_types = ["病院.svg", "注射.svg", "薬1.svg", "薬2.svg"]

post_types.each_with_index do |type, i|
  HospitalPostType.create(id: i+1, image: type)
end
