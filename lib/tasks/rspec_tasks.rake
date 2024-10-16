# frozen_string_literal: true

namespace :rspec do
  def prod_protection
    ENV.delete('DATABASE_URL')
    abort("The Rails environment is running in production mode!") if Rails.env.production? || ENV['DATABASE_URL'].present?
    ENV['RAILS_ENV'] = 'test'
  end

  task setup: :environment do
    prod_protection
    system("rails db:reset db:migrate")
  end

  task run: :environment do
    prod_protection
    system("bundle exec rspec")
  end

  namespace :run do
    task verbose: :environment do
      prod_protection
      system("bundle exec rspec -fd")
    end

    task models: :environment do
      prod_protection
      system("bundle exec rspec spec/models")
    end

    task controllers: :environment do
      prod_protection
      system("bundle exec rspec spec/controllers")
    end

    task requests: :environment do
      prod_protection
      system("bundle exec rspec spec/requests")
    end
  end
end
