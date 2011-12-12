FactoryGirl.define do
  factory :site do
    name "marsz"
    domain "wretch"
    url "http://www.marsz.tw"
    factory :site_another do
      domain "pixnet"
    end
  end

  factory :user do
    site_user_id "marsz"
    name "MarsZ Chen"
    url "http://blog.marsz.tw"
    is_enabled true
    factory :user_disabled do
      site_user_id "user-disabled"
      is_enabled false
    end
    factory :user_should_disabled do
      site_user_id "marsz0330marsz"
      is_enabled false
    end
  end

  factory :post do
    site_post_id "12345678"
    title "hahahah"
    date Time.now.to_date
    url "http://blog.marsz.tw/12345678"
  end

  factory :users_monitor_url do
    url "http://www.google.com"
    label "google"
    is_enabled true
  end

  factory :users_monitor_parser do
    regex "/href=\"([^\"]+)\"/m"
    label "google"
  end
end