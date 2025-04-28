# frozen_string_literal: true

class CreateActions < ActiveRecord::Migration[8.0]
  def change
    create_table :actions do |t|
      t.references :near_transaction, null: false, foreign_key: true
      t.string :action_type
      t.jsonb :data, default: {}, null: false

      t.timestamps
    end
  end
end
