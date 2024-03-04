class CheckOut
  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    @cart = Hash.new(0)
  end

  def scan(item)
    @cart[item] += 1
  end

  def total
    total_price = 0

    @cart.each do |item, quantity|
      total_price += calculate_item_price(item, quantity)
    end

    total_price
  end

  private

  def calculate_item_price(item, quantity)
    rule = @pricing_rules[item]

    if rule
      if rule[:quantity] && quantity >= rule[:quantity]
        special_price_count = quantity / rule[:quantity]
        regular_price_count = quantity % rule[:quantity]

        return (special_price_count * rule[:special_price]) + (regular_price_count * rule[:unit_price])
      else
        return quantity * rule[:unit_price]
      end
    else
      puts "Pricing rule not defined for item #{item}."
      return 0
    end
  end
end

pricing_rules = {
  'A' => { unit_price: 50, special_price: 130, quantity: 3 },
  'B' => { unit_price: 30, special_price: 45, quantity: 2 },
  'C' => { unit_price: 20 },
  'D' => { unit_price: 15 }
}

co= CheckOut.new(pricing_rules)
puts "Scan items one by one (type 'done' when finished):"
loop do
  print "Scan item: "
  input = gets.chomp.upcase

  break if input.upcase == 'DONE'

  co.scan(input)
end
puts "Total Price: $#{co.total}"
