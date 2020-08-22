module Mutations
  class DestroyItemMutation < Mutations::BaseMutation
    argument :id, ID, required: true

    field :errors, [String], null: true

    def resolve(id:)
      if context[:current_user].nil?
        raise GraphQL::ExecutionError,
          "You need to authenticate to perform this action"
      end

      item = Item.find(id)

      if item.destroy
        { errors: nil }
      else
        { errors: item.errors.full_messages }
      end
    end
  end
end
