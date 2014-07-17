module Curryable
  def my_curry(*curry_args)
    return call(*curry_args) if trigger_call? curry_args

    proc { |*args| call(*curry_args, *args) }.tap do |new_proc|
      new_proc.arity = arity - curry_args.length
      new_proc.curried = true
    end
  end

  def call(*args)
    return my_curry(*args) if curry?(args)

    super
  end

  def arity
    @arity || super
  end

  def curried?
    !!@curried
  end

  protected

  attr_writer :arity
  attr_writer :curried

  private

  def trigger_call?(curry)
    curry.length >= arity
  end

  def curry?(args)
    curried? && !trigger_call?(args)
  end
end

Proc.prepend Curryable
