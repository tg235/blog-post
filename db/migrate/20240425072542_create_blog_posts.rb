class CreateBlogPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :blog_posts do |t|
      t.string :title
      t.text :content
      t.datetime :publication_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
