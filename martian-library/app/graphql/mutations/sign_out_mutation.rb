module Mutations
  class SignOutMutation < Mutations::BaseMutation
    argument :token, String, required: true

    field :ok, Boolean, null: true

    def resolve(token:)
      p token
      return {
        ok: true
      }
    end
  end
end
