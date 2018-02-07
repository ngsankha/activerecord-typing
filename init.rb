require 'active_record'
require 'rdl'
require 'types/core'
require 'minitest/autorun'

include ActiveSupport::Inflector # needed to rails automatic pluralization

module RDL::Globals
  # Map from table names (symbols) to their schema types, which should be a Table type
  @db_schema = {}
end

class << RDL::Globals
  attr_accessor :db_schema
end


ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'test.db'
)

class Person < ActiveRecord::Base
  has_many :items
end

class Item < ActiveRecord::Base
  belongs_to :person
end

class Job < ActiveRecord::Base
  belongs_to :item
  belongs_to :person
end

### The below files must be loaded *after* model class definitions above.
require './types'
require './tests'

## Migrations were written by hand here, but are auto-generated in a railsapp
class CreatePersonsTable < ActiveRecord::Migration[5.0]
  def up
    create_table Person.to_s.underscore.pluralize.to_sym do |t|
      t.string   "first_name"
      t.string   "last_name"
      t.string "item_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
    puts 'ran person up method'
  end 

  def down
    drop_table Person.to_s.underscore.pluralize.to_sym
    puts 'ran person down method'
  end
end

class CreateItemsTable < ActiveRecord::Migration[5.0]
  def up
    create_table Item.to_s.underscore.pluralize.to_sym do |t|
      t.integer  "person_id"
      t.string   "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["person_id"], name: "index_items_on_person_id"
    end
    puts 'ran item up method'
  end 

  def down
    drop_table Item.to_s.underscore.pluralize.to_sym
    puts 'ran item down method'
  end
end

class CreateJobsTable < ActiveRecord::Migration[5.0]
  def up
    create_table Job.to_s.underscore.pluralize.to_sym do |t|
      t.string "job"
      t.string "name"
      t.string "item_id"
      t.string "person_id"
    end
    puts "ran job up method"
  end

  def down
    drop_table Job.to_s.underscore.pluralize.to_sym
    puts 'ran job down method'
  end

end

# Feeding the types in manually for now
RDL::Globals.db_schema[:Person] = RDL::Globals.parser.scan_str "#T Person<{id: Integer, first_name: String, last_name: String, created_at: DateTime, updated_at: DateTime, item_id: String, __associations: {has_many: :items}}>"
RDL::Globals.db_schema[:Item] = RDL::Globals.parser.scan_str "#T Item<{id: Integer, person_id: Integer, name: String, created_at: DateTime, updated_at: DateTime, __associations: {belongs_to: :person}}>"
RDL::Globals.db_schema[:Job] = RDL::Globals.parser.scan_str "#T Job<{id: Integer, name: String, job: String, __associations: {belongs_to: :person or :item}}>"



def run
  File.delete 'test.db'
  CreatePersonsTable.migrate(:up)
  CreateItemsTable.migrate(:up)
  CreateJobsTable.migrate(:up)

  # puts Person.joins(:items).where.not(items: {name: 'blah'}).to_sql
  # DBType.insert_test
  #DBType.insert_test_fail1

  i = Item.new(name: 'pen')
  p = Person.new(first_name: 'sankha', last_name: 'guria')
  p.items << i
  p.save
  i.save
  puts Person.includes(:items).all[0].methods


  CreatePersonsTable.migrate(:down)
  CreateItemsTable.migrate(:down)
  CreateJobsTable.migrate(:down)
end

RDL.do_typecheck :ast_later
# run

# labels = [:ast_later_fail]
# labels.each { |label|
#   Minitest::Test.new(nil).assert_raises(RDL::Typecheck::StaticTypeError) { RDL.do_typecheck label }
# }

