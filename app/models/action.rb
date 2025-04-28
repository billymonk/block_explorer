class Action < ApplicationRecord
  belongs_to :near_transaction

  validates :action_type, presence: true
end
