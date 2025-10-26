class Tagging < ApplicationRecord
  belongs_to :movie
  belongs_to :tag
end
