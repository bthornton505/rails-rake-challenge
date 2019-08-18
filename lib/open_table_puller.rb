class OpenTablePuller
  MAX_PER_PAGE = 100
  API_URL = 'https://opentable.herokuapp.com/api/restaurants'

  class << self
    def pull(page = 1, data = [])
      fetch_page(page)
      data.push(*restaurants)

      if page < last_page
        pull page + 1, data
      else
        data
      end
    end

    private

    attr_reader :restaurants, :last_page

    def fetch_page(page)
      json = fetch_json_on(page)
      process(json)
    end

    def fetch_json_on(page)
      conn = Faraday.new(API_URL)
      response = conn.get do |req|
        req.params[:per_page] = MAX_PER_PAGE
        req.params[:page] = page
        req.params[:city] = 'denver'
        req.params[:state] = 'co'
      end

      JSON.parse(response.body, symbolize_names: true)
    end

    def process(json)
      @restaurants = json[:restaurants]
      @last_page ||= (json[:total_entries].to_i / json[:per_page].to_f).ceil
    end
  end
end
