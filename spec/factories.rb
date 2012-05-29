FactoryGirl.define do
  factory :site do
    name "marsz"
    sequence(:domain) { |n| "wretch#{n}" }
    url "http://www.marsz.tw"
    factory :site_another do
      domain "pixnet"
    end
  end

  factory :user do
    site do
      FactoryGirl.create :site
    end
    sequence(:site_user_id) { |n| "marsz#{n}" }
    name "MarsZ Chen"
    url "http://blog.marsz.tw"
    is_enabled true
    check_state "idle"
    factory :user_for_check do
      check_state "idle"
      checked_at Time.now-(User::CHECK_WITHIN_DAYS+10).days
    end
    factory :user_disabled do
      site_user_id "user-disabled"
      is_enabled false
    end
    factory :user_black do
      is_enabled false
      is_black true
    end
    factory :user_should_disabled do
      site_user_id "marsz0330marsz"
      is_enabled false
    end
  end

  factory :post do
    user do
      FactoryGirl.create(:user)
    end
    sequence(:site_post_id) {|n| "123#{n}"}
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