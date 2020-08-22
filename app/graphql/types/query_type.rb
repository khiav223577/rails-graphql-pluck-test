module Types
  class QueryType < Types::BaseObject
    field :items, [Types::ItemType], null: false, description: "Returns a list of items in the martian library", extras: [:lookahead]
    field :me, Types::UserType, null: true

    def items(lookahead:)
      Item.deep_pluck(*LookaheadService.new(lookahead).to_query_params)
    end

    def me
      context[:current_user]
    end
  end
end
