class CreateDocs < ActiveRecord::Migration[7.0]
  def change
    create_table :docs do |t|
      t.string :title, null: false
      t.text :content
      t.string :password_digest
      t.string :slug

      t.timestamps
    end
  end
end
