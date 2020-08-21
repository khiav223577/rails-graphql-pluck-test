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
      context 'when query title' do
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

      context 'when query id and description' do
        let(:query) do <<~QUERY
          query {
            items {
              id
              description
            }
          }
         QUERY
        end
        it do
          expect_queries_num(1){ subject }
          is_expected.to eq(
            'data' => {
              'items' => [
                { 'id' => @items[0].id.to_s, 'description' => 'AAA' },
                { 'id' => @items[1].id.to_s, 'description' => 'BBB' },
                { 'id' => @items[2].id.to_s, 'description' => 'CCC' },
              ],
            },
          )
        end
      end
    end

    context 'when query with user' do
      context 'when query full_name' do
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

      context 'when query id and email' do
        let(:query) do <<~QUERY
          query {
            items {
              title
              user {
                id
                email
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
                { 'title' => 'Item A', 'user' => { 'id' => @users[1].id.to_s, 'email' => 'judy.hopps@example.com' } },
                { 'title' => 'Item B', 'user' => { 'id' => @users[1].id.to_s, 'email' => 'judy.hopps@example.com' } },
                { 'title' => 'Item C', 'user' => { 'id' => @users[0].id.to_s, 'email' => 'nick.wilde@example.com' } },
              ],
            },
          )
        end
      end
    end
  end
end
