Factory.define :site do |f|
  f.name "marsz"
  f.domain "www.marsz.tw"
  f.url "http://www.marsz.tw"
end

Factory.define :user do |f|
  f.site_user_id "marsz"
  f.name "MarsZ Chen"
  f.url "http://blog.marsz.tw"
end

Factory.define :post do |f|
  f.site_post_id "12345678"
  f.title "hahahah"
  f.date Time.now.to_date
  f.url "http://blog.marsz.tw/12345678"
end

