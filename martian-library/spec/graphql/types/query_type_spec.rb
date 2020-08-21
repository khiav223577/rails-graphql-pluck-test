require 'rails_helper'

RSpec.describe Types::QueryType do
  subject do
    MartianLibrarySchema.execute(query).to_h
  end

  before(:all) do
    @users = [
      create(:user, email: 'nick.wilde@example.com', first_name: 'Nick', last_name: 'Wilde'),
      create(:user, email: 'judy.hopps@example.com', first_name: 'Judy', last_name: 'Hopps'),
    ]

    @items = [
      create(:item, title: 'Item A', description: 'AAA', user: @users[1]),
      create(:item, title: 'Item B', description: 'BBB', user: @users[1]),
      create(:item, title: 'Item C', description: 'CCC', user: @users[0]),
    ]
  end

  describe 'items' do
    context 'when query without user' do
      let(:query) do <<~QUERY
        query {
          items {
            title
          }
        }
      QUERY
      end
      it do
        expect_queries_num(1){ subject }
        is_expected.to eq(
          'data' => {
            'items' => [
              { 'title' => 'Item A' },
              { 'title' => 'Item B' },
              { 'title' => 'Item C' },
            ],
          },
        )
      end
    end

    context 'when query with user' do
      let(:query) do <<~QUERY
        query {
          items {
            title
            user {
              fullName
            }
          }
        }
      QUERY
      end
      it do
        expect_queries_num(4){ subject }
        is_expected.to eq(
          'data' => {
            'items' => [
              { 'title' => 'Item A', 'user' => { 'fullName' => 'Judy Hopps' } },
              { 'title' => 'Item B', 'user' => { 'fullName' => 'Judy Hopps' } },
              { 'title' => 'Item C', 'user' => { 'fullName' => 'Nick Wilde' } },
            ],
          },
        )
      end
    end
  end
end
