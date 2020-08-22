module Types
  class BaseObject < GraphQL::Schema::Object
    FIELD_NEED_COLUMNS = {}

    field_class Types::BaseField
  end
end
