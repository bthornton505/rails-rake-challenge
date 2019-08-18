class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :phone
      t.integer :price
      t.string :reserve_url
      t.string :image_url

      t.timestamps
    end
  end
end
