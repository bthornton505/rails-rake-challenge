module Api::V1
  class RestaurantsController < ApiController
    PER_PAGE_DEFAULT = 24

    def index
      @restaurants = Restaurant.limit(per_page).offset(offset)

      render json: {
        total_entries: Restaurant.count,
        current_page: page,
        per_page: per_page,
        restaurants: @restaurants
      }
    end

    private

    def per_page
      params.fetch('per_page', PER_PAGE_DEFAULT).to_i
    end

    def page
      params.fetch('page', 1).to_i
    end

    def offset
      (page - 1) * per_page
    end
  end
end
