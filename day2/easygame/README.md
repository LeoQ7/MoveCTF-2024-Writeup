# EasyGame

```move
module solve::m {
    use sui::tx_context::{Self, TxContext};
    use std::vector;
    use movectf::easy_game::{Self, Challenge};

    public entry fun solve(chall: &mut easy_game::Challenge, ctx: &mut TxContext) {
        easy_game::submit_solution(vector[9], chall, ctx);
    }
}
```