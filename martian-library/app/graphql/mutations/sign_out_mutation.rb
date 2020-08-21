module Mutations
  class SignOutMutation < Mutations::BaseMutation
    argument :token, String, required: true

    field :ok, String, null: true

    def resolve(token:)
      p token
      return {
        ok: true
      }
    end
  end
end
