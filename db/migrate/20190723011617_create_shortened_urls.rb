class CreateShortenedUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :shortened_urls do |t|
      t.string :original_url, null: false
      t.string :slug, null: false
      t.string :title, null: true, default: nil
      t.integer :hit_count, default: 0

      t.timestamps
    end
  end
end
