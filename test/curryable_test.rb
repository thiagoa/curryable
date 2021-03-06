require 'minitest/autorun'
require_relative '../curryable'

describe "a curried proc" do
  describe "when my_curry isn't called on a proc" do
    before do
      @fn = proc { |a, b, c, d| a + b + c + d }
    end

    it "isn't curried" do
      @fn.curried?.must_equal false
    end

    it 'has the right arity' do
      @fn.arity.must_equal 4
    end
  end

  describe "when my_curry is called on a proc, with no arguments" do
    before do
      @fn = proc { |a, b, c| a + b + c }.my_curry
    end

    it "returns a new curried proc" do
      @fn.curried?.must_equal true
    end

    it "has the right arity" do
      @fn.arity.must_equal 3
    end
  end

  describe "with a proc of one argument" do
    before do
      @fn = proc { |a| a }
    end

    it "my_curry returns the final result" do
      @fn.my_curry(1).must_equal 1
    end

    it "call returns the final result" do
      @fn.call(1).must_equal 1
    end
  end

  describe "with a proc of four arguments" do
    before do
      @fn = proc { |a, b, c, d| a + b + c + d }
    end

    describe "when my_curry is called with one argument" do
      before do
        @fn = @fn.my_curry(1)
      end

      it 'returns a new curried proc' do
        @fn.curried?.must_equal true
      end

      it "has the right arity" do
        @fn.arity.must_equal 3
      end

      describe "when my_curry is called once more, with one argument" do
        it "returns a new curried proc" do
          @fn.my_curry(2).curried?.must_equal true
        end

        it "has the right arity" do
          @fn.my_curry(2).arity.must_equal 2
        end
      end

      describe "when my_curry is called once more, with two arguments" do
        it "returns a new curried proc" do
          @fn.my_curry(2, 3).curried?.must_equal true
        end

        it "has the right arity" do
          @fn.my_curry(2, 3).arity.must_equal 1
        end
      end

      describe "when my_curry is called twice more, each with one argument" do
        it "returns a new curried proc" do
          @fn.my_curry(2).my_curry(3).curried?.must_equal true
        end

        it "has the right arity" do
          @fn.my_curry(2).my_curry(3).arity.must_equal 1
        end
      end

      describe "when my_curry is called once more, with three arguments" do
        it "returns the final result" do
          @fn.my_curry(2, 3, 4).must_equal 10
        end
      end

      describe "when my_curry is called thrice more, each with one argument" do
        it "returns the final result" do
          @fn.my_curry(2).my_curry(3).my_curry(4).must_equal 10
        end
      end
    end

    describe "when my_curry is called with all four arguments" do
      it "returns the final result" do
        @fn.my_curry(1, 2, 3, 4).must_equal 10
      end
    end
  end

  describe "when my_curry is triggered once" do
    it "subsequent invocation of call behaves like my_curry" do
      fn = proc { |a, b, c, d| a + b + c + d }

      result = fn.my_curry(1).call(2, 3).call(4)
      result.must_equal 10
    end
  end

  describe "subsequent mixed invocations of my_curry and call" do
    it "have the same curry effect" do
      fn = proc { |a, b, c, d, e, f| a + b + c + d + e + f }

      result = fn.my_curry(1).call(2).my_curry(4).call(3).my_curry(2).call(3)
      result.must_equal 15
    end
  end

  describe "when my curry is not triggered" do
    it "the arity method isn't broken" do
      proc { |a, b| }.arity.must_equal 2
    end

    it "call method doesn't return a curried proc" do
      result = proc { |a, b, c| }.call(1)

      result.wont_respond_to :curried?
      result.must_be_nil
    end
  end
end

