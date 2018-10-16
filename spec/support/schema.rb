require 'active_record'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

ActiveRecord::Schema.define version: 0 do
  create_table :teams do |t|
    t.string :name
    t.string :uuid

    t.timestamps
  end

  create_table :teams_users, foreign_key: false do |t|
    t.integer :user_id, null: false
    t.integer :team_id, null: false
  end

  create_table :users do |t|
    t.string :name
    t.string :uuid

    t.timestamps
  end

  create_table :pets_users, foreign_key: false do |t|
    t.integer :user_id, null: false
    t.integer :pet_id, null: false
  end

  create_table :pets do |t|
    t.string :name
    t.string :uuid

    t.timestamps
  end

  create_table :posts do |t|
    t.belongs_to :user, foreign_key: { on_delete: :cascade }
    t.string     :uuid
    t.string     :content

    t.timestamps
  end

  create_table :comments do |t|
    t.belongs_to :post, foreign_key: { on_delete: :cascade }
    t.string     :uuid
    t.string     :body

    t.timestamps
  end
end
