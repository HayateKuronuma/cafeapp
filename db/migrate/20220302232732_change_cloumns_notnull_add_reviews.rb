class ChangeCloumnsNotnullAddReviews < ActiveRecord::Migration[6.1]
  def change
    change_column :reviews, :comment, :text, null: false
    change_column :reviews, :user_id, :integer, null: false
    change_column :reviews, :shop_id, :string, null: false
    change_column :reviews, :title, :string, default: "", null: false
  end
end
