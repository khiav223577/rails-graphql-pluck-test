class LookaheadService
  def initialize(lookahread)
    @lookahread = lookahread
  end

  def to_query_params
    @lookahread.selections.flat_map do |selection|
      next need_columns_for(selection.owner_type, selection.name) if selection.selections.empty?
      next { selection.name => LookaheadService.new(selection).to_query_params }
    end.uniq.compact
  end

  def need_columns_for(type_klass, field_name)
    field_need_columns = type_klass::FIELD_NEED_COLUMNS || {}
    return field_need_columns[field_name] if field_need_columns.key?(field_name)
    return field_name
  end
end
