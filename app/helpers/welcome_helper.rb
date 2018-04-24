module WelcomeHelper
  def currency_amount(plan)
    money(plan).to_f.ceil
  end

  def currency_symbol(plan)
    money(plan).symbol
  end

  def interval(plan)
    "/#{plan.interval} per #{plan.product.unit_label}"
  end

  private

  def money(plan)
    Money.new(plan.amount, plan.currency)
  end
end
