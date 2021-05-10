GravityDex Competition Triangular Arbitrage
---

This script exploits [Triangular Arbitrage](https://en.wikipedia.org/wiki/Triangular_arbitrage) on the GravityDex for their testnet competition.  Arbitrage Opportunity Profit during the GravityDex competition can be made by swapping between the listed triples, given minimal price slippage and swapping fees.

Running `bundle exec ruby main.rb` will show something like the below

```
Opportunity - Triples to Trade
113.49%  ucom => uregen => udvpn
112.20%  ucom => ubtsg => udvpn
111.01%  ucom => uiris => udvpn
110.08%  ucom => ungm => udvpn
110.05%  uakt => udvpn => ucom
```

## Usage
```
bundle exec ruby main.rb help arbitrage
Usage:
  main.rb arbitrage

Options:
  t, [--threshold=N]
                        # Default: 10
  f, [--filter=FILTER]

Calculates arbitrage opportunites for the GravityDex competition
```
