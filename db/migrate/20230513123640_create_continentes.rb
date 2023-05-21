class CreateContinentes < ActiveRecord::Migration[5.2]
  def change
    create_table :continentes do |t|
      t.string :nome

      t.timestamps
    end
  end
end
