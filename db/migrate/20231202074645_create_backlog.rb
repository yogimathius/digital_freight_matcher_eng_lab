class CreateBacklog < ActiveRecord::Migration[7.0]
  def change
    create_table :backlogs do |t|
      t.references :route, foreign_key: true
      t.timestamps
    end
  end
end
