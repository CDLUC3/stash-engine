# This migration comes from stash_engine (originally 20160203010036)
class ChangeTenantAbbrevToId < ActiveRecord::Migration
  def change
    remove_column :stash_engine_users, :tenant_abbrev
    add_column :stash_engine_users, :tenant_id, :string
    add_index :stash_engine_users, :tenant_id
  end
end
