GravityDex Competition Arbitrage
---

Running `bundle exec ruby main.rb -t 5` will show something like the below

```
Opportunity - Triples to Trade
106.44%  uluna => udvpn => udsm
106.32%  ubtsg => xrun => ugcyb
106.08%  uregen => xrun => ugcyb
105.79%  uakt => udvpn => udsm
105.60%  udsm => ucom => udvpn
105.44%  uakt => uiris => udsm
105.05%  uxprt => xrun => ugcyb
```

Arbitrage Opportunity Profit during the GravityDex competition can be made by swapping between the listed triples, given minimal price slippage and swapping fees

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
