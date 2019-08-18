require 'open_table_puller.rb'

namespace :restaurant do
  desc "This will refresh the database with an updated version of open restaurants"

  task :pull => :environment do
    puts "Refreshing the database"
    log = ActiveSupport::Logger.new('log/refresh_database.log')
    start_time = Time.now

    log.info "Task started at #{start_time}"

    request = OpenTablePuller.new
    requested_data = request.pull
    db_data = Restaurant.all

    new_restaurants = 0
    position = 0

    # After making the api request, we iterate through the data and check whether it currently exists in our database
    until position == requested_data.length
      if Restaurant.exists?(name: requested_data[position.to_i][:name])
        position += 1
      else
        Restaurant.create(
          name: requested_data[position.to_i][:name],
          address: requested_data[position.to_i][:address],
          image_url: requested_data[position.to_i][:image_url],
          reserve_url: requested_data[position.to_i][:reserve_url]
        )
        new_restaurants += 1
        position += 1
      end
    end

    end_time = Time.now
    duration = (start_time - end_time) / 1.minute
    log.info "Task finished at #{end_time} and last #{duration} minutes."
    log.close

    puts "#{new_restaurants} new restaurants"
    puts "Refresh Complete!"
  end

end
