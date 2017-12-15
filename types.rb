


class ActiveRecord::Base
  extend RDL::Annotate

  type :initialize, '(``DBType.gen_new_input_type(trec, targs)``) -> self', wrap: false
  type 'self.create', '(``DBType.gen_new_input_type(trec, targs)``) -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :initialize, '() -> self', wrap: false
  type 'self.create', '() -> ``DBType.rec_to_nominal(trec)``', wrap: false

end

module ActiveRecord::Core::ClassMethods
  extend RDL::Annotate
  ## Types from this module are used when receiver is ActiveRecord::Base

  type :find, '(Integer) -> ``DBType.find_output_type(trec, targs)``', wrap: false
  type :find, '(Array<Integer>) -> ``DBType.find_output_type(trec, targs)``', wrap: false
  type :find, '(Integer, Integer, *Integer) -> ``DBType.find_output_type(trec, targs)``', wrap: false
  type :find_by, '(``DBType.find_by_input_type(trec, targs)``) -> ``DBType.rec_to_nominal(trec)``', wrap: false
  ## TODO: find_by's with conditions given as string

end

module ActiveRecord::FinderMethods
  extend RDL::Annotate
  ## Types from this module are used when receiver is ActiveRecord_Relation
  
  type :find, '(Integer) -> ``DBType.find_output_type(trec, targs)``', wrap: false
  type :find, '(Array<Integer>) -> ``DBType.find_output_type(trec, targs)``', wrap: false
  type :find, '(Integer, Integer, *Integer) -> ``DBType.find_output_type(trec, targs)``', wrap: false
  type :find_by, '(``DBType.find_by_input_type(trec, targs)``) -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :first, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :first!, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :first, '(Integer) -> ``DBType.rec_to_array(trec)``', wrap: false
  type :last, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :last!, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :last, '(Integer) -> ``DBType.rec_to_array(trec)``', wrap: false
  type :take, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :take!, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :take, '(Integer) -> ``DBType.rec_to_array(trec)``', wrap: false
  type :exists?, '() -> %bool', wrap: false
  type :exists?, '(Integer or String) -> %bool', wrap: false
  type :exists?, '(``DBType.exists_input_type(trec, targs)``) -> %bool', wrap: false

  ## TODO: find_by's with conditions given as string

end

module ActiveRecord::Querying
  extend RDL::Annotate
  ## Types from this module are used when receiver is ActiveRecord::Base

  
  type :first, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :first!, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :first, '(Integer) -> ``DBType.rec_to_array(trec)``', wrap: false
  type :last, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :last!, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :last, '(Integer) -> ``DBType.rec_to_array(trec)``', wrap: false
  type :take, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :take!, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :take, '(Integer) -> ``DBType.rec_to_array(trec)``', wrap: false
  type :exists?, '() -> %bool', wrap: false
  type :exists?, '(Integer or String) -> %bool', wrap: false
  type :exists?, '(``DBType.exists_input_type(trec, targs)``) -> %bool', wrap: false


  type :where, '(``DBType.where_input_type(trec, targs)``) -> ``RDL::Type::GenericType.new(RDL::Type::NominalType.new(ActiveRecord_Relation), DBType.rec_to_nominal(trec))``', wrap: false
  type :where, '(String, Hash) -> ``RDL::Type::GenericType.new(RDL::Type::NominalType.new(ActiveRecord_Relation), DBType.rec_to_nominal(trec))``', wrap: false
  type :where, '(String, *String) -> ``RDL::Type::GenericType.new(RDL::Type::NominalType.new(ActiveRecord_Relation), DBType.rec_to_nominal(trec))``', wrap: false
  type :where, '() -> ``RDL::Type::GenericType.new(RDL::Type::NominalType.new(ActiveRecord::QueryMethods::WhereChain), DBType.rec_to_nominal(trec))``', wrap: false


  type :joins, '(``DBType.joins_one_input_type(trec, targs)``) -> ``DBType.joins_one_in_output(trec, targs)``', wrap: false
  type :joins, '(``DBType.joins_multi_input_type(trec, targs)``, Symbol, *Symbol) -> ``DBType.joins_multi_output(trec, targs)``', wrap: false


end

module ActiveRecord::QueryMethods
  extend RDL::Annotate
  ## Types from this module are used when receiver is ActiveRecord_relation
  
  type :where, '(``DBType.where_input_type(trec, targs)``) -> ``RDL::Type::GenericType.new(RDL::Type::NominalType.new(ActiveRecord_Relation), trec.params[0])``', wrap: false
  type :where, '(String, Hash) -> ``RDL::Type::GenericType.new(RDL::Type::NominalType.new(ActiveRecord_Relation), trec.params[0])``', wrap: false
  type :where, '(String, *String) -> ``RDL::Type::GenericType.new(RDL::Type::NominalType.new(ActiveRecord_Relation), trec.params[0])``', wrap: false
  type :where, '() -> ``DBType.where_noarg_output_type(trec, targs)``', wrap: false

end


class ActiveRecord::QueryMethods::WhereChain
  extend RDL::Annotate
  type_params [:t], :dummy

  type :not, '(``DBType.not_input_type(trec, targs)``) -> ``RDL::Type::GenericType.new(RDL::Type::NominalType.new(ActiveRecord_Relation), trec.params[0])``', wrap: false

end

class JoinTable
  extend RDL::Annotate
  type_params [:orig, :joined], :dummy
  ## type param :orig will be nominal type of base table in join
  ## type param :joined will be a union type of all joined tables, or just a nominal type if there's only one

  ## this class is meant to only be the type parameter of ActiveRecord_Relation or WhereChain, expressing multiple joined tables instead of just a single table
end



module ActiveRecord::Scoping::Named::ClassMethods
  extend RDL::Annotate
  type :all, '() -> ``RDL::Type::GenericType.new(RDL::Type::NominalType.new(ActiveRecord_Relation), DBType.rec_to_nominal(trec))``', wrap: false

end

class ActiveRecord_Relation
  ## In practice, this is actually a private class nested within
  ## each ActiveRecord::Base, e.g. Person::ActiveRecord_Relation.
  ## Using this class just for type checking.
  extend RDL::Annotate
  include ActiveRecord::QueryMethods
  include ActiveRecord::FinderMethods

  type_params [:t], :dummy

  type :each, '() -> Enumerator<t>', wrap: false
  type :each, '() { (t) -> %any } -> Array<t>', wrap: false
end


class DBType
  def self.rec_to_nominal(t)
    case t
    when RDL::Type::SingletonType
      val = t.val
      raise RDL::Typecheck::StaticTypeError, "Expected class singleton type, got #{val} instead." unless val.is_a?(Class)
      return RDL::Type::NominalType.new(val)
    when RDL::Type::GenericType
      raise RDL::Typecheck::StaticTypeError, "got unexpected type #{t}" unless t.base.klass == ActiveRecord_Relation
      param = t.params[0]
      case param
      when RDL::Type::GenericType
        ## should be JoinTable
        ## When getting an indivual record from a join table, record will be of type of the base table in the join
        raise RDL::Typecheck::StaticTypeError, "got unexpected type #{param}" unless param.base.klass == JoinTable
        return param.params[0]
      when RDL::Type::NominalType
        return param
      else
        raise RDL::Typecheck::StaticTypeError, "got unexpected type #{t.params[0]}"
      end
    end
  end

  def self.rec_to_array(trec)
    RDL::Type::GenericType.new(RDL::Globals.types[:array], rec_to_nominal(trec))
  end

  def self.plural?(s)
    raise "expected string" unless s.instance_of?(String)
    s == s.pluralize
  end

  def self.get_schema_from_type(t)
    case t
    when RDL::Type::SingletonType
      raise RDL::Typecheck::StaticTypeError, "Unexpected receiver type #{t}." unless t.val.is_a?(Class)
      tname = t.val.to_s.to_sym
    when RDL::Type::GenericType
      ## Relation/WhereChain case
      param = t.params[0]
      case param
      when RDL::Type::GenericType
        ## should be JoinTable
        ## When getting an indivual record from a join table, record will be of type of the base table in the join
        raise RDL::Typecheck::StaticTypeError, "got unexpected type #{param}" unless param.base.klass == JoinTable
        klass = param.params[0].klass
      when RDL::Type::NominalType
        klass = param.klass
      else
        raise RDL::Typecheck::StaticTypeError, "got unexpected type #{t.params[0]}"
      end
      tname = klass.to_s.to_sym
    else
      raise RDL::Typecheck::StaticTypeError, "Unexpected receiver type #{t}."
    end
    ttype = RDL::Globals.db_schema[tname]
    raise RDL::Typecheck::StaticTypeError, "No table type for #{tname} found." unless ttype      
    tschema = ttype.params[0].elts
    tschema.except(:__associations)
  end

  def self.check_hash_schema(hash, schema, trec, check_col)
    joined = []
    if trec.is_a?(RDL::Type::GenericType)
      raise "Unexpected type #{trec}." unless (trec.base.klass == ActiveRecord_Relation) || (trec.base.klass == ActiveRecord::QueryMethods::WhereChain) ## Update to handle not/WhereChain
      param = trec.params[0]
      if param.is_a?(RDL::Type::GenericType)
      ## should be JoinTable
        raise "unexpected type #{trec}" unless param.base.klass == JoinTable
        joined << param.params[0].klass.to_s.singularize.to_sym
        case param.params[1]
        when RDL::Type::NominalType
          joined << param.params[1].klass.to_s.singularize.to_sym
        when RDL::Type::UnionType
          param.params[1].types.each { |t| joined << t.klass.to_s.singularize.to_sym }
        else
          raise "unexpected type #{trec}"
        end
      end
    end
    hash.each { |key, value|
      raise RDL::Typecheck::StaticTypeError, "expected symbol, got #{key} of type #{key.class}" unless key.is_a?(Symbol)
      if value.is_a?(RDL::Type::FiniteHashType)
      ## checking joined table case
        table_string_name = key.to_s
        raise RDL::Typecheck::StaticTypeError, "expected plural name, got #{table_string_name}" unless plural?(table_string_name)
        table_name = table_string_name.singularize.camelize.to_sym
        raise RDL::Typecheck::StaticTypeError, "#{key} is not a joined table in #{trec}" unless joined.include?(table_name)
        tschema = RDL::Globals.db_schema[table_name].params[0].elts
        raise "No table schema for #{table_name}." unless tschema
        check_hash_schema(value.elts, tschema, key, false)
      else
        column_type = schema[key]
        raise RDL::Typecheck::StaticTypeError, "No column #{key} in #{trec} table." unless column_type
        raise RDL::Typecheck::StaticTypeError, "Column type #{column_type} from #{trec} table is not compatable with given argument of type #{value}." unless (value <= column_type) || !check_col
      end
    }
  end

  def self.gen_new_input_type(trec, targs)
    return RDL::Globals.types[:top] if targs[0].nil? ## no args provided, this type won't be looked at
    raise RDL::Typecheck::StaticTypeError, "Unexpected argument type #{targs[0]} in call to ActiveRecord::Base initialize/create method." unless targs[0].is_a?(RDL::Type::FiniteHashType)
    tschema = DBType.get_schema_from_type(trec)
    case trec
    when RDL::Type::SingletonType
      DBType.check_hash_schema(targs[0].elts, tschema, trec, true)
      return targs[0]
    else
      raise RDL::Typecheck::StaticTypeError, "Unexpected receiver type #{trec} (#{trec.class}) in call to ActiveRecord::Base initialize/create method."
    end
  end


  def self.where_input_type(trec, targs)
    return RDL::Globals.types[:top] if targs.size != 1 ## this method is for one argument
    tschema = DBType.get_schema_from_type(trec)
    case targs[0]
    when RDL::Type::FiniteHashType
      DBType.check_hash_schema(targs[0].elts, tschema, trec, true)
      return targs[0]
    when RDL::Globals.types[:string]
      return targs[0]
      ## no indepth checking for this case
    when RDL::Globals.types[:array]
      return targs[0]
      ## no indepth checking for this case
    else
      raise RDL::Typecheck::StaticTypeError, "Unexpected Type #{targs[0]} in call to ActiveRecord::Base#where."
    end
    
  end

  def self.where_noarg_output_type(trec, targs)
    return RDL::Globals.types[:top] if targs.size != 0 ## this method is for one argument
    case trec
    when RDL::Type::SingletonType
      ## where called directly on class
      RDL::Type::GenericType.new(RDL::Type::NominalType.new(ActiveRecord::QueryMethods::WhereChain), rec_to_nominal(trec))
    when RDL::Type::GenericType
    ## where called on ActiveRecord_Relation
      raise RDL::Typecheck::StaticTypeError, "Unexpected receiver type #{trec}." unless trec.base.klass == ActiveRecord_Relation
      return RDL::Type::GenericType.new(RDL::Type::NominalType.new(ActiveRecord::QueryMethods::WhereChain), trec.params[0])
    else
      raise RDL::Typecheck::StaticTypeError, "Unexpected receiver type #{trec}."
    end
  end
  
  def self.not_input_type(trec, targs)
    return RDL::Globals.types[:top] if targs.size != 1 ## this method is for one argument
    tschema = DBType.get_schema_from_type(trec)
    case targs[0]
    when RDL::Type::FiniteHashType
      DBType.check_hash_schema(targs[0].elts, tschema, trec, false)
      return targs[0]
    when RDL::Globals.types[:string]
      return targs[0]
      ## no indepth checking for this case
    when RDL::Globals.types[:array]
      return targs[0]
      ## no indepth checking for this case
    else
      raise RDL::Typecheck::StaticTypeError, "Unexpected Type #{targs[0]} in call to ActiveRecord::Base#where."
    end    
  end

  def self.exists_input_type(trec, targs)
    raise "Unexpected number of arguments to ActiveRecord::Base#exists?." unless targs.size <= 1
    return RDL::Globals.types[:top] if targs[0].nil? ## no args provided, this type won't be looked at
    case targs[0]
    when RDL::Type::FiniteHashType
      tschema = DBType.get_schema_from_type(trec)
      DBType.check_hash_schema(targs[0].elts, tschema, trec, false)
      return targs[0]
    else
      ## any type can be accepted, only thing we're intersted in is when a hash is given
      ## TODO: what if we get a nominal Hash type?
      return targs[0]
    end
  end


  def self.find_output_type(trec, targs)
    ### TODO: find can actually take any type and attempts to use to_i, but will just return RecordNotFound for incompatible types. e.g., Person.find('hi') returns RecordNotFound. Account for this?
    ### TODO: Account for non-integer primary keys? Seems rare.
    case targs.size
    when 0
      raise RDL::Typecheck::StaticTypeError, "No arguments given to ActiveRecord::Base#find."
    when 1
      case targs[0]
      when RDL::Globals.types[:integer]
        DBType.rec_to_nominal(trec)
      when RDL::Type::SingletonType
      # expecting symbol or integer here
        case targs[0].val
        when Integer
          DBType.rec_to_nominal(trec)
        when Symbol
        ## TODO
        ## Actually, this is deprecated in later versions
          raise RDL::Typecheck::StaticTypeError, "Unexpected arg type #{targs[0]} in call to ActiveRecord::Base#find."
        else
          raise RDL::Typecheck::StaticTypeError, "Unexpected arg type #{targs[0]} in call to ActiveRecord::Base#find."
        end
      when RDL::Type::GenericType
        #raise RDL::Type::StaticTypeError, "Unexpected arg type #{targs[0]} in call to ActiveRecord::Base#find." unless (targs[0].base == RDL::Globals.types[:array]) && (targs[0].params[0] == RDL::Globals.types[:integer])
        RDL::Type::GenericType.new(RDL::Globals.types[:array], DBType.rec_to_nominal(trec))
      when RDL::Type::TupleType
        RDL::Type::GenericType.new(RDL::Globals.types[:array], DBType.rec_to_nominal(trec))
      else
        raise RDL::Typecheck::StaticTypeError, "Unexpected arg type #{targs[0]} in call to ActiveRecord::Base#find."
      end
    else
      DBType.rec_to_nominal(trec)
    end
  end

  def self.find_by_input_type(trec, targs)
    raise RDL::Typecheck::StaticTypeError, "Unexpected argument type #{targs[0]} in call to ActiveRecord::Base find_by method." unless targs[0].is_a?(RDL::Type::FiniteHashType)
    tschema = DBType.get_schema_from_type(trec)
    DBType.check_hash_schema(targs[0].elts, tschema, trec, true)
    return targs[0]
  end

  def self.joins_one_input_type(trec, targs)
    return RDL::Globals.types[:top] unless targs.size == 1 ## trivial case, won't be matched
    case targs[0]
    when RDL::Type::SingletonType
      sym = targs[0].val
      raise RDL::Typecheck::StaticTypeError, "Unexpected arg type #{trec} in call to joins." unless sym.is_a?(Symbol)
      rec_klass = trec.val ## this method should only be called when trec is a class singleton
      raise RDL::Typecheck::StaticTypeError, "#{trec} has no association to #{targs[0]}, cannot perform joins." unless associated_with?(rec_klass, sym)
      return targs[0]
    else
      raise RDL::Typecheck::StaticTypeError, "Unexpected arg type #{targs[0]} in call to joins."
    end
  end

  def self.joins_multi_input_type(trec, targs)
    return RDL::Globals.types[:top] unless targs.size > 1 ## trivial case, won't be matched
    targs.each { |arg|
      case arg
      when RDL::Type::SingletonType
        sym = arg.val
        raise RDL::Typecheck::StaticTypeError, "Unexpected arg type #{trec} in call to joins." unless sym.is_a?(Symbol)
        rec_klass = trec.val ## this method should only be called when trec is a class singleton
        raise RDL::Typecheck::StaticTypeError, "#{trec} has no association to #{arg}, cannot perform joins." unless associated_with?(rec_klass, sym)
      else
        raise RDL::Typecheck::StaticTypeError, "Unexpected arg type #{targs[0]} in call to joins."
      end
    }
    return targs[0] ## since this method is called as first argument in type
  end

  def self.associated_with?(rec, sym)
    tschema = RDL::Globals.db_schema[rec.to_s.to_sym]
    raise RDL::Typecheck::StaticTypeError, "No table type for #{rec} found." unless tschema
    schema = tschema.params[0].elts
    assoc = schema[:__associations]
    raise RDL::Typecheck::StaticTypeError, "Table #{rec} has no associations, cannot perform joins." unless assoc
    assoc.elts.each { |key, value|
      case value
      when RDL::Type::SingletonType
        return true if value.val == sym ## no need to change any plurality here
      when RDL::Type::UnionType
        ## for when rec has multiple of the same kind of association
        value.types.each { |t|
          raise "Unexpected type #{t}." unless t.is_a?(RDL::Type::SingletonType) && (t.val.class == Symbol)
          return true if t.val == sym
        }
      else
        raise RDL::Typecheck::StaticTypeError, "Unexpected association type #{value}"
      end        
    }
    return false
  end

  def self.joins_one_in_output(trec, targs)
    return RDL::Globals.types[:top] unless targs.size == 1 ## trivial case, won't be matched
    raise RDL::Typecheck::StaticTypeError, "Unexpected joins arg type #{targs[0]}" unless targs[0].is_a?(RDL::Type::SingletonType) && (targs[0].val.class == Symbol)
    arg_kl = targs[0].val.to_s.singularize.camelize
    jt = RDL::Type::GenericType.new(RDL::Type::NominalType.new(JoinTable), rec_to_nominal(trec), RDL::Type::NominalType.new(arg_kl))
    RDL::Type::GenericType.new(RDL::Type::NominalType.new(ActiveRecord_Relation), jt)
  end

  def self.joins_multi_output(trec, targs)
    return RDL::Globals.types[:top] unless targs.size > 1 ## trivial case, won't be matched
    targs.each { |arg| raise RDL::Typecheck::StaticTypeError, "Unexpected joins arg type #{arg}" unless arg.is_a?(RDL::Type::SingletonType) && (arg.val.class == Symbol) }
    ut = RDL::Type::UnionType.new(*targs.map { |arg| RDL::Type::NominalType.new(arg.val.to_s.singularize.camelize)})
    jt = RDL::Type::GenericType.new(RDL::Type::NominalType.new(JoinTable), rec_to_nominal(trec), ut)
    RDL::Type::GenericType.new(RDL::Type::NominalType.new(ActiveRecord_Relation), jt)
  end

end
