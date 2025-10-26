class CreateMovies < ActiveRecord::Migration[8.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :synopsis
      t.integer :release_year
      t.string :duration
      t.string :director
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
