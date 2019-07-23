class CreateShortenedUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :shortened_urls do |t|
      t.string :original_url
      t.string :slug
      t.string :title
      t.string :hit_count
      t.integer :hits

      t.timestamps
    end
  end
end
