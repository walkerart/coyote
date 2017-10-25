# Manages creation of links for a subset of paginated ActiveRecord objects. Depends on Kaminari
# having already been mixed-into ActiveRecord.
# @see https://github.com/kaminari/kaminari
class RecordPaginator
  def initialize(params,records)
    @params = params
    @records = records
  end

  def query
    @quer ||= begin
                records.
                page(pagination_number).
                per(pagination_size).
                without_count
              end
  end

  # @param base_link_params [Hash]
  # @return [Hash<Symbol,String>] named link parameters suitable for rendering in the UI or API
  def pagination_links_for(base_link_params)
    base_page_params = { size: pagination_size }
    first_page = base_page_params.merge(number: 1)

    first_page_params = base_link_params.merge(page: first_page)

    links = { 
      first: first_page_params
    }

    unless query.first_page?
      previous_page_params = base_page_params.merge(number: query.prev_page)
      links[:previous] = base_link_params.merge(page: previous_page_params)
    end

    unless query.last_page?
      next_page_params = base_page_params.merge(number: query.next_page)
      links[:next] = base_link_params.merge(page: next_page_params)
    end

    links
  end

  private

  attr_reader :params, :records

  def pagination_params
    params.fetch(:page,{}).permit(:number,:size)
  end

  def pagination_number
    pagination_params.fetch(:number,1)
  end

  def pagination_size
    pagination_params.fetch(:size,records.default_per_page)
  end
end
