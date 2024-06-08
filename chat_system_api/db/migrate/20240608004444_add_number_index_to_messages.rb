class AddNumberIndexToMessages < ActiveRecord::Migration[7.1]
  def change
    add_index :messages, [:chat_id, :number], unique: true
  end
end
