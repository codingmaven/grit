##
# Allows attributes to be declared as lazy, meaning that they won't be
# computed until they are asked for. 
#
# Works by delegating each lazy_reader to a cached lazy_source method.
#
# class Person
#   lazy_reader :eyes
#
#   def lazy_source
#     OpenStruct.new(:eyes => 2)
#   end
# end
#
# >> Person.new.eyes
# => 2
#
module Lazy
  def lazy_reader(*args)
    args.each do |arg|
      ivar = "@#{arg}"
      define_method(arg) do
        val = instance_variable_get(ivar) 
        return val if val
        instance_variable_set(ivar, (@lazy_source ||= lazy_source).send(arg))
      end
    end
  end
end

Object.extend Lazy unless Object.ancestors.include? Lazy
