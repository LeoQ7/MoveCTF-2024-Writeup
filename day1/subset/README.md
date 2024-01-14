# Subset

LLL

```move
module solve::m {
    use sui::tx_context::{Self, TxContext};
    use subset::subset_sum::{Self, Status};
    use std::vector;

    public entry fun solve(ctx: &mut TxContext) {
        let status = subset_sum::get_status(ctx);
        subset_sum::solve_subset1(vector[1,0,0,1,1], &mut status);
        subset_sum::solve_subset2(vector[0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0], &mut status);
        subset_sum::solve_subset3(vector[0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], &mut status);
        subset_sum::get_flag(&status, ctx);
    }
}
```