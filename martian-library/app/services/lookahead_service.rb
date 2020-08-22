class LookaheadService
  def initialize(lookahread)
    @lookahread = lookahread
    @type_to_custom_fields = {}
  end

  def to_query_params
    @lookahread.selections.map do |selection|
      next if selection.name.in?(custom_fields_of(selection.owner_type))
      next selection.name if selection.selections.empty?
      next { selection.name => LookaheadService.new(selection).to_query_params }
    end.compact
  end

  def custom_fields_of(type)
    @type_to_custom_fields[type] ||= type.instance_methods & type.fields.keys.map{|s| s.underscore.to_sym }
  end
end
