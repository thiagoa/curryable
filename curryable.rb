module Curryable
  def my_curry(*curry_args)
    return call(*curry_args) if trigger_call? curry_args

    proc { |*args| call(*curry_args, *args) }.tap do |new_proc|
      new_proc.arity = arity - curry_args.length
    end
  end

  def call(*args)
    if trigger_call? args
      super(*args)
    else
      my_curry(*args)
    end
  end

  def arity
    @arity || super
  end

  protected

  attr_writer :arity

  private

  def trigger_call?(curry)
    curry.length >= arity
  end
end
