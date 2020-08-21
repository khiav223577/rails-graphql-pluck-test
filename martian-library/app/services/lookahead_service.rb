class LookaheadService
  def initialize(lookahread)
    @lookahread = lookahread
  end

  def to_query_params
    @lookahread.selections.map do |selection|
      next selection.name if selection.selections.empty?
      next { selection.name => LookaheadService.new(selection).to_query_params }
    end
  end
end
