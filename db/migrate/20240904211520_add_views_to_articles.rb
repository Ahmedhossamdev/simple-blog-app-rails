class AddViewsToArticles < ActiveRecord::Migration[7.2]
  def change
    add_column :articles, :views, :integer
  end
end
