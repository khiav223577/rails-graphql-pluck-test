# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  rescue NoMethodError => e
    next puts("Warning: catch #{e.message}") if e.message == %(undefined method `rollback' for nil:NilClass)
    raise e
  end
end
