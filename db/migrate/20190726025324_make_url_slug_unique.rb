class MakeUrlSlugUnique < ActiveRecord::Migration[5.2]
  def change
    change_column :shortened_urls, :slug, :string, unique: true
    add_index :shortened_urls, :slug, unique: true
  end
end
