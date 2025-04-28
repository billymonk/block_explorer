class CreateNearTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :near_transactions do |t|
      t.datetime :external_time
      t.bigint :external_height
      t.string :external_hash
      t.string :external_block_hash
      t.string :external_sender
      t.string :external_receiver
      t.string :external_gas_burnt
      t.integer :external_actions_count
      t.boolean :external_success

      t.timestamps
    end
  end
end
