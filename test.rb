require 'minitest/autorun'
require_relative 'curryable'

Proc.prepend(Curryable)

describe Curryable do
  describe "my_curry runs with no arguments" do
    before do
      @fn = proc { |a, b, c| a + b + c }
    end

    it "returns a curried proc" do
      @fn.my_curry.must_be_instance_of Proc, @fn
    end

    it "has the right arity" do
      @fn.my_curry.arity.must_equal 3
    end
  end

  describe "with a proc of one argument" do
    it "my_curry returns the final result" do
      proc { |a| a }.my_curry(1).must_equal 1
    end

    it "call returns the final result" do
      proc { |a| a }.call(1).must_equal 1
    end
  end

  describe "with a proc of four arguments" do
    before do
      @fn = proc { |a, b, c, d| a + b + c + d }
    end

    describe "after my_curry is called with one argument" do
      before do
        @fn = @fn.my_curry(1)
      end

      it "has the right arity" do
        @fn.arity.must_equal 3
      end

      describe "when my_curry is called once more with one argument" do
        it "returns a curried proc" do
          @fn.my_curry(2).must_be_instance_of Proc, @fn
        end

        it "has the right arity" do
          @fn.my_curry(2).arity.must_equal 2
        end
      end

      describe "when my_curry is called once more with two arguments" do
        it "returns a curried proc" do
          @fn.my_curry(2, 3).must_be_instance_of Proc, @fn
        end

        it "has the right arity" do
          @fn.my_curry(2, 3).arity.must_equal 1
        end
      end

      describe "when my_curry is called twice more, each with one argument" do
        it "returns a curried proc" do
          @fn.my_curry(2).my_curry(3).must_be_instance_of Proc, @fn
        end

        it "has the right arity" do
          @fn.my_curry(2).my_curry(3).arity.must_equal 1
        end
      end

      describe "when my_curry is called once more with three arguments" do
        it "returns the final result" do
          @fn.my_curry(2, 3, 4).must_equal 10
        end
      end

      describe "when my_curry is called thrice more, each with one argument" do
        it "returns the final proc result" do
          @fn.my_curry(2).my_curry(3).my_curry(4).must_equal 10
        end
      end
    end

    describe "when my_curry is called with all four arguments" do
      it "returns the final proc result" do
        @fn.my_curry(1, 2, 3, 4).must_equal 10
      end
    end
  end

  describe "once my_curry is triggered once, the call method behaves like my_curry" do
    it do
      fn = proc { |a, b, c, d| a + b + c + d }

      result = fn.my_curry(1).call(2, 3).call(4)
      result.must_equal 10
    end
  end

  describe "when my curry is not triggered" do
    it "the arity method isn't broken" do
      proc { |a, b|    }.arity.must_equal 2
      proc { |a, b, c| }.arity.must_equal 3
    end
  end
end

