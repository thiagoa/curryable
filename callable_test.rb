require 'minitest/autorun'
require_relative 'callable'

describe Callable do
  Fixture = Class.new do
    include Callable

    delegate_call def trigger(arg1, arg2, arg3)
      'assert_me'
    end
  end

  describe 'delegates call to trigger' do
    describe 'use call method with arity equal to trigger method' do
      it 'returns the result' do
        Fixture.new.call(1, 2, 3).must_equal 'assert_me'
      end
    end

    describe 'use call method with arity lower than trigger method' do
      it 'breaks' do
        proc { Fixture.new.call(1, 2) }.must_raise ArgumentError
      end
    end
  end

  it 'is curryable' do
    curried = Fixture.new.my_curry(1)
    curried.call(2, 3).must_equal 'assert_me'
  end

  describe 'delegate_call setup is required in parent class' do
    it "breaks if parent class isn't setup" do
      fixture = Class.new { include Callable }.new
      proc { fixture.call }.must_raise StandardError
    end
  end
end
