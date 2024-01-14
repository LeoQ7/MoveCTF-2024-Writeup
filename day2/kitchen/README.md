# Kitchen

```rust
module solve::m {
    use sui::tx_context::{Self, TxContext};
    use kitchen::kitchen::{Self, Status, Olive_oil, Yeast, Flour, Salt, get_Olive_oil, get_Yeast, get_Flour, get_Salt};
    use std::vector;

    public entry fun solve(ctx: &mut TxContext) {
        let status = kitchen::get_status(ctx);
        let olive_oils = vector<Olive_oil>[
            get_Olive_oil(0xa515),
            get_Olive_oil(0xa6b8),
            get_Olive_oil(0xc9f8),
            get_Olive_oil(0xbb46),
        ];
        let yeast = vector<Yeast>[
            get_Yeast(0xbd00),
            get_Yeast(0x999d),
            get_Yeast(0xb77e),
        ];
        let flour = vector<Flour>[
            get_Flour(0xd78a),
            get_Flour(0xfa84),
            get_Flour(0xb8f2),
        ];
        let salt = vector<Salt>[
            get_Salt(0xf1c5),
            get_Salt(0xe122),
        ];
        kitchen::cook(olive_oils, yeast, flour, salt, &mut status);
        kitchen::recook(vector[6, 217, 185, 84, 235, 104, 146, 247, 197, 236, 161, 132, 208, 4, 0, 189, 129, 252, 157, 153, 126, 183, 5, 199, 220, 122, 204, 25, 143, 177, 150, 109, 138, 3, 1, 139, 197, 241, 236, 198], &mut status);
        kitchen::get_flag(&status, ctx);
    }
}
```