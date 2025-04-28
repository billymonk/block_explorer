# frozen_string_literal: true

class NearTransaction < ApplicationRecord
  has_many :actions, dependent: :destroy
end
