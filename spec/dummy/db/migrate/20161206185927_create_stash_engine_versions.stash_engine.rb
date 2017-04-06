# This migration comes from stash_engine (originally 20160425163609)
class CreateStashEngineVersions < ActiveRecord::Migration
  def change
    create_table :stash_engine_versions do |t|
      t.integer :version
      t.string :zip_filename
      t.integer :resource_id

      t.timestamps null: false
    end
  end
end