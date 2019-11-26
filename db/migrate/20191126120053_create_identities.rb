class CreateIdentities < ActiveRecord::Migration[5.2]
  def change
    create_table :identities do |t|
      t.string :user_name
      t.string :user_id

      t.timestamps
    end
  end
end
