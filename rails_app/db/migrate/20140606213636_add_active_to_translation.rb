class AddActiveToTranslation < ActiveRecord::Migration[4.2]
  def change
    add_column :translations, :active, :boolean, :default => true
  end
end
