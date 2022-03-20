class AddShopNameToReviews < ActiveRecord::Migration[6.1]
  def change
    add_column :reviews, :shop_name, :string, null: false
  end
end
