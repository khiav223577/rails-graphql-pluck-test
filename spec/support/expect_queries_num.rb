# frozen_string_literal: true

def expect_queries_num(expected_count, event_key = 'sql.active_record')
  sqls = []
  subscriber = ActiveSupport::Notifications.subscribe(event_key) do |_, _, _, _, payload|
    sqls << "  ● #{payload[:sql]}" if payload[:sql] =~ /\A(?:SELECT|INSERT INTO|UPDATE|DELETE|DROP|CREATE)/i
  end

  yield

  if expected_count != sqls.size # show all sql queries if query count doesn't equal to expected count.
    expect("\n#{sqls.join("\n").tr('"', "'")}\n").to eq "expect #{expected_count} queries, but have #{sqls.size}"
  end
  expect(sqls.size).to eq expected_count
ensure
  ActiveSupport::Notifications.unsubscribe(subscriber)
end
