class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.text :comment
      t.string :title
      t.integer :user_id
      t.string :shop_id

      t.timestamps
    end
  end
end
