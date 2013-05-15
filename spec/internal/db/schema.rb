ActiveRecord::Schema.define do
  create_table(:users, :force => true) do |t|
    t.string :name
    t.timestamps
  end
  create_table(:items, :force => true) do |t|
    t.string :name
    t.timestamps
  end
end