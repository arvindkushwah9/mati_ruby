class AddIdentityidsToIdentities < ActiveRecord::Migration[5.2]
  def change
    add_column :identities, :identity_id, :string
  end
end
