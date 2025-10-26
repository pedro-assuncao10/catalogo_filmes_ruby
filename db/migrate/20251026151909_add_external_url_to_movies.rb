class AddExternalUrlToMovies < ActiveRecord::Migration[8.1]
  def change
    add_column :movies, :external_url, :string
  end
end
