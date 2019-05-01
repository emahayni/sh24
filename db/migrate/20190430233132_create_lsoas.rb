class CreateLsoas < ActiveRecord::Migration[5.2]
  def change
    create_table :lsoas do |t|
      t.string :value
      t.string :description

      t.timestamps
    end
  end
end
