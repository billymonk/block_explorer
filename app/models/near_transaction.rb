class NearTransaction < ApplicationRecord
  has_many :actions, dependent: :destroy
end
