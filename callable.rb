require_relative 'curryable'

module Callable
  prepend Curryable

  def self.included(parent)
    parent.extend ClassMethods
  end

  def call(*args)
    callable = self.class.callable

    if callable.nil?
      fail StandardError, 'Must define a call delegator'
    end

    send callable, *args
  end

  module ClassMethods
    attr_reader :callable

    def delegate_call(method_name)
      @callable = method_name
      setup
    end

    private

    def setup
      instance_method(@callable).arity.tap do |arity|
        define_method(:arity) { arity }
      end
    end
  end
end
