class DBType
  extend RDL::Annotate

  def self.fail_tests
    insert_fail_tests
    where_fail_tests
    join_fail_tests
    return true
  end

  ###### AST Tests #######
  type '() -> Person', typecheck: :ast_later, wrap: false
  def self.ast_insert
    Person.new(first_name: 'sankha', last_name: 'guria')
  end

  type '() -> Person', typecheck: :ast_later, wrap: false
  def self.ast_where_test
    Person.where(first_name: 'sankha', last_name: 'guria').first
  end

  type '() -> Person', typecheck: :ast_later, wrap: false
  def self.ast_where_chain_test
    Person.where(first_name: 'sankha').where(last_name: 'guria').first
  end

  type '() -> Person', typecheck: :ast_later, wrap: false
  def self.ast_where_not_test
    Person.where(last_name: 'kaz').not(first_name: 'milod').first
  end

  type '() -> Person', wrap: false, typecheck: :ast_later
  def self.ast_join_test
    Person.joins(:items).first
  end

  type '() -> Person', typecheck: :ast_later, wrap: false
  def self.ast_join_where_not_test
    Person.joins(:items).where(last_name: 'kaz').not(first_name: 'milod').first
  end

  type '() -> Person', typecheck: :ast_later_fail, wrap: false
  def self.ast_where_test_fail1()
    Person.where(blah: 'anything')
  end

  type '() -> Person', wrap: false, typecheck: :ast_later
  def self.ast_joins_fail5()
    Person.joins(:items).where.not(itemsdfs: {name: 'blah'}).first
  end

  ###### INSERTION METHODS #######
  
  type '() -> Person', typecheck: :later, wrap: false
  def self.insert_test
    Person.new(first_name: 'sankha')
    Person.new(first_name: 'sankha', last_name: 'guria')
    Person.new(id: 3)
    Person.new()
    Person.create(first_name: 'sankha')
    Person.create(first_name: 'milod')
    Person.create(first_name: 'sankha', last_name: 'guria')
    Person.create(id: 3)
  end

  type '() -> Person', typecheck: :fail1, wrap: false
  def self.insert_test_fail1
    Person.new(first_name: 'sankha', last_name: 23)
  end

  type '() -> Person', typecheck: :fail1c, wrap: false
  def self.insert_test_fail1c
    Person.create(first_name: 'sankha', last_name: 23)
  end

  type '() -> Person', typecheck: :fail2, wrap: false
  def self.insert_test_fail2
    Person.new(spell: 'abracadabra')
  end

  type '() -> Person', typecheck: :fail2c, wrap: false
  def self.insert_test_fail2c
    Person.create(spell: 'abracadabra')
  end

  type '() -> Person', typecheck: :fail3, wrap: false
  def self.insert_test_fail3
    Person.new(42)
  end

  type '() -> Person', typecheck: :fail3c, wrap: false
  def self.insert_test_fail3c
    Person.create(42)
  end

  def self.insert_fail_tests
    labels = [:fail1, :fail1c, :fail2, :fail2c, :fail3, :fail3c]
    labels.each { |label|
      Minitest::Test.new(nil).assert_raises(RDL::Typecheck::StaticTypeError) { RDL.do_typecheck label }
    }
  end


  ####### QUERY METHODS ########

  type '() -> Person', typecheck: :later
  def self.query_test()
    Person.find(1)
    Person.find(1,2,3)
    Person.first
    Person.last
    Person.take
  end

  type '() -> Array<Person>', typecheck: :later
  def self.find_test2
    Person.find(RDL.type_cast([1,2,3], "Array<Integer>", force: true))
  end    

  type '() -> Array<Person>', typecheck: :later
  def self.find_test3()
    Person.first(3)
  end

  type '() -> Person', typecheck: :later
  def self.find_by_test()
    Person.find_by(first_name: 'milod', last_name: 'kazerounian')
  end

  type '() -> %bool', typecheck: :later
  def self.exists_test()
    Person.exists?(first_name: 'milod')
  end

  type '() -> Array<Person>', typecheck: :later
  def self.take_test()
    Person.take(3)
  end

  type '() -> ActiveRecord_Relation<Person>', typecheck: :later
  def self.all_test()
    Person.all
  end

  type '() -> Array<Person>', typecheck: :later
  def self.all_test2()
    Person.all.each { |p| p }
  end

  type '() -> Person', typecheck: :ffail1
  def self.find_fail_test1()
    Person.find('hi')
  end

  type '() -> Person', typecheck: :ffail2
  def self.find_by_fail_test2()
    Person.find_by(blah: 'milod')
  end

  type '() -> Person', typecheck: :ffail3
  def self.find_by_fail_test3()
    Person.find_by(first_name: 22)
  end

  type '() -> %bool', typecheck: :ffail4
  def self.exists_fail_test4
    Person.exists?(blah: 'milod')
  end

  def self.find_fail_tests
    labels = [:ffail1, :ffail2, :ffail3, :ffail4]
    labels.each { |label|
      Minitest::Test.new(nil).assert_raises(RDL::Typecheck::StaticTypeError) { RDL.do_typecheck label }
    }
  end


  ######## WHERE METHODS ###########

    type '() -> ActiveRecord_Relation<Person>', typecheck: :later, wrap: false
  def self.where_test
    Person.where(first_name: 'sankha')
    Person.where(first_name: 'sankha', last_name: 'guria')
    Person.where(id: 3)
  end

  type '() -> ActiveRecord_Relation<Person>', typecheck: :later, wrap: false
  def self.where_not
    Person.where.not(first_name: 'milod')
  end

  type '() -> ActiveRecord_Relation<Person>', typecheck: :later, wrap: false
  def self.where_not2
    Person.where.not(first_name: 'milod').where(first_name: 'blah')
  end

  type '() -> ActiveRecord_Relation<Person>', typecheck: :wfail1, wrap: false
  def self.where_test_fail1()
    Person.where(blah: 'anything')
  end

  def self.where_fail_tests
    labels = [:wfail1]
    labels.each { |label|
      Minitest::Test.new(nil).assert_raises(RDL::Typecheck::StaticTypeError) { RDL.do_typecheck label }
    }
  end

  
  ######### JOINS ############

    type '() -> ActiveRecord_Relation<JoinTable<Person, Item>>', wrap: false, typecheck: :later
  def joins_test1()
    Person.joins(:items)
  end

  type '() -> Person', wrap: false, typecheck: :later
  def joins_test2()
    Person.joins(:items).first
  end

  type '() -> Array<Person>', wrap: false, typecheck: :later
  def joins_test3()
    Person.joins(:items).take(3)
  end

  type '() -> %bool', wrap: false, typecheck: :later
  def joins_test4()
    Person.joins(:items).exists?(items: {name: 'blah'})
  end

  type '() -> Person', wrap: false, typecheck: :later
  def joins_test5()
    Person.joins(:items).find(1)
  end

  type '() -> Person', wrap: false, typecheck: :later
  def joins_test6()
    Person.joins(:items).find_by(items: {person_id: 1})
  end

  type '() -> Person', wrap: false, typecheck: :later
  def joins_test7()
    Person.joins(:items).find_by(first_name: 'milod')
  end

  type '() -> Person', wrap: false, typecheck: :later
  def joins_test8()
    Person.joins(:items).where(items: {name: 'blah'}).first
  end    

  type '() -> Person', wrap: false, typecheck: :later
  def joins_test9()
    Person.joins(:items).where.not(items: {name: 'blah'}).first
  end

  type '() -> ActiveRecord_Relation<JoinTable<Job, Person or Item>>', wrap: false, typecheck: :later
  def joins_test10()
    Job.joins(:item, :person)
  end

  type '() -> ActiveRecord_Relation<JoinTable<Job, Person or Item>>', wrap: false, typecheck: :later
  def joins_test11()
    Job.joins(:item, :person).where(people: {first_name: 'milod'})
  end

  type '() -> Job', wrap: false, typecheck: :later
  def joins_test12()
    Job.joins(:item, :person).where(people: {first_name: 'milod'}).first
  end
  
  type '() -> ActiveRecord_Relation<JoinTable<Person, Job>>', wrap: false, typecheck: :jfail1
  def joins_fail1()
    Person.joins(:jobs)
  end

  type '() -> %bool', wrap: false, typecheck: :jfail2
  def joins_fail2()
    Person.joins(:items).exists?(animals: {name: 'blah'})
  end

  type '() -> %bool', wrap: false, typecheck: :jfail3
  def join_fail3()
    Person.joins(:items).exists?(items: {fake_column: 'blah'})
  end

  type '() -> Person', wrap: false, typecheck: :jfail4
  def joins_fail4()
    Person.joins(:items).where(itemsdfs: {name: 'blah'}).first
  end    

  type '() -> Person', wrap: false, typecheck: :jfail5
  def joins_fail5()
    Person.joins(:items).where.not(itemsdfs: {name: 'blah'}).first
  end

  type '() -> ActiveRecord_Relation<JoinTable<Person, Item>>', wrap: false, typecheck: :jfail6
  def joins_fail6()
    Job.joins(:person, :itemsss)
  end
  
  def self.join_fail_tests
    labels = [:jfail1, :jfail2, :jfail3, :jfail4, :jfail5, :jfail6]
    labels.each { |label|
      Minitest::Test.new(nil).assert_raises(RDL::Typecheck::StaticTypeError) { RDL.do_typecheck label }
    }
  end
  
end
