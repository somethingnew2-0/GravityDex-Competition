require "http"

# pools_resp = HTTP.get("https://competition.bharvest.io:1317/tendermint/liquidity/v1beta1/pools?pagination.limit=100")
# prices_resp = HTTP.get("https://competition.bharvest.io:8081/prices")
# if pools_resp.status.success? && prices_resp.status.success?
#   pools = JSON.parse(pools_resp.to_s)["pools"]
#   prices = JSON.parse(prices_resp.to_s)["prices"]

#   pairs = {}
#   pools.each do |pool|
#     first = pool["reserve_coin_denoms"][0]
#     second = pool["reserve_coin_denoms"][1]
#     pair = pairs.fetch(first, {})
#     pair[second] = prices[pool["pool_coin_denom"]]
#     pairs[first] = pair

#     pair = pairs.fetch(second, {})
#     pair[first] = 1 / prices[pool["pool_coin_denom"]]
#     pairs[second] = pair
#   end

#   pairs.each do |first, first_swap|
#     first_swap.each do |second, first_swap_price|
#       if pairs.key?(second)
#         second_swap = pairs[second]
#         if second_swap.key?(first)
#           second_swap_price = second_swap[first]
#           opportunity = second_swap_price / first_swap_price
#           puts "Found arbitrage #{first} #{second} #{opportunity}" # if opportunity > 1.1
#         end
#       end
#     end
#   end
# end

while true

  pools_resp = HTTP.get("https://competition.bharvest.io:8081/pools")
  if pools_resp.status.success?
    pools = JSON.parse(pools_resp.to_s)["pools"]

    pairs = {}
    pools.each do |pool|
      first = pool["reserveCoins"][0]["denom"]
      second = pool["reserveCoins"][1]["denom"]
      pair = pairs.fetch(first, {})
      pair[second] = pool["reserveCoins"][0]["amount"].to_f / pool["reserveCoins"][1]["amount"]
      pairs[first] = pair

      pair = pairs.fetch(second, {})
      pair[first] = pool["reserveCoins"][1]["amount"].to_f / pool["reserveCoins"][0]["amount"]
      pairs[second] = pair
    end

    # Generate all the asset triples for an arbitrage triangle
    # Since there are two ways around the perimeter of a triangle include the triple and its reverse
    triples = pairs.keys.combination(3).flat_map {|triple| [triple, triple.reverse] }

    system("clear")

    opportunities = triples.map do |triple|
      first, second, third = triple
      first_swap_price = pairs[first][second]
      second_swap_price = pairs[second][third]
      third_swap_price = pairs[third][first]
      opportunity = first_swap_price * second_swap_price * third_swap_price
      # puts "#{sprintf("%.2f", opportunity * 100)}%  #{third} => #{second_swap_price} <= #{second} => #{first_swap_price} <= #{first} => #{third_swap_price}" if opportunity > 1.1
      [opportunity, triple]
    end.to_h.sort.reverse.to_h

    opportunities.each do |opportunity, triple|
      first, second, third = triple
      puts "#{sprintf("%.2f", opportunity * 100)}%  #{third} => #{second} => #{first}" if opportunity > 1
    end

  end

  sleep 5
end
