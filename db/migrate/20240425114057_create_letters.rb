class CreateLetters < ActiveRecord::Migration[7.0]
  def change
    create_table :letters do |t|
      t.string :title

      t.timestamps
    end
  end
end
