require "http"
require "thor"

class Commands < Thor
  desc "arbitrage", "Calculates arbitrage opportunites for the GravityDex competition"
  option :threshold, type: :numeric, default: 10, aliases: :t
  option :filter, type: :string, aliases: :f
  def arbitrage
    triples = {}

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
        triples = pairs.keys.combination(3).flat_map {|triple| [triple, triple.reverse] } if triples.empty?
        system("clear")

        puts "Opportunity - Triples to Trade"

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
          next if !options[:filter].nil? && !triple.include?(options[:filter])
          first, second, third = triple
          puts "#{sprintf("%.2f", opportunity * 100)}%  #{third} => #{second} => #{first}" if opportunity > 1 + (options[:threshold] / 100.0)
        end

      end

      sleep 5
    end
  end
  default_task :arbitrage
end

Commands.start

