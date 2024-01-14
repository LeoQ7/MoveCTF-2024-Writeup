module kitchen::kitchen {

    use sui::tx_context::{Self};
    use sui::event;

    use std::bcs;
    use std::vector;

    struct Olive_oil has copy, drop, store {amount: u16}
    struct Yeast has copy, drop, store {amount: u16}
    struct Flour has copy, drop, store {amount: u16}
    struct Salt has copy, drop, store {amount: u16}

    struct Cook<T> has copy, drop, store {
        source: vector<T>
    }

    struct Pizza has copy, drop, store {
        olive_oils: Cook<Olive_oil>,
        yeast: Cook<Yeast>,
        flour: Cook<Flour>,
        salt: Cook<Salt>,
    }

    struct Flag has copy, drop {
        user: address
    }

    struct Status has store, drop {
        status1: bool,
        status2: bool,
        user: address
    }


    public fun get_Olive_oil (amount: u16) : Olive_oil {
        Olive_oil { amount }
    }

    public fun get_Yeast (amount: u16) : Yeast {
        Yeast { amount }
    }
    
    public fun get_Flour (amount: u16) : Flour {
        Flour { amount }
    }
    
    public fun get_Salt (amount: u16) : Salt {
        Salt { amount }
    }

    public fun cook(olive_oils: vector<Olive_oil>, yeast: vector<Yeast>, flour: vector<Flour>, salt: vector<Salt>, status: &mut Status) {
        let l1 = vector::length<Olive_oil>(&olive_oils);
        let l2 = vector::length<Yeast>(&yeast);
        let l3 = vector::length<Flour>(&flour);
        let l4 = vector::length<Salt>(&salt);

        let cook1 = Cook {source : vector::empty<Olive_oil>()};
        let cook2 = Cook {source : vector::empty<Yeast>()};
        let cook3 = Cook {source : vector::empty<Flour>()};
        let cook4 = Cook {source : vector::empty<Salt>()};

        let i = 0;
        while(i < l1) {
            vector::push_back(&mut cook1.source, *vector::borrow(&olive_oils, i));
            i = i + 1;
        };
        i = 0;
        while(i < l2) {
            vector::push_back(&mut cook2.source, *vector::borrow(&yeast, i));
            i = i + 1;
        };
        i = 0;
        while(i < l3) {
            vector::push_back(&mut cook3.source, *vector::borrow(&flour, i));
            i = i + 1;
        };
        i = 0;
        while(i < l4) {
            vector::push_back(&mut cook4.source, *vector::borrow(&salt, i));
            i = i + 1;
        };

        let p = Pizza {
            olive_oils: cook1,
            yeast: cook2,
            flour: cook3,
            salt: cook4,
        };
        assert!( bcs::to_bytes(&p) == x"0415a5b8a6f8c946bb0300bd9d997eb7038ad784faf2b802c5f122e1", 0);
        status.status1 = true;
    }

    public fun recook (out: vector<u8>, status: &mut Status) {
        let p = Pizza {
            olive_oils: Cook<Olive_oil> {
                source: vector<Olive_oil>[
                    get_Olive_oil(0xb9d9),
                    get_Olive_oil(0xeb54),
                    get_Olive_oil(0x9268),
                    get_Olive_oil(0xc5f7),
                    get_Olive_oil(0xa1ec),
                    get_Olive_oil(0xd084),
                ]
            },
            yeast: Cook<Yeast> {
                source: vector<Yeast>[
                    get_Yeast(0xbd00),
                    get_Yeast(0xfc81),
                    get_Yeast(0x999d),
                    get_Yeast(0xb77e),
                ]
            },
            flour: Cook<Flour> {
                source: vector<Flour>[
                    get_Flour(0xdcc7),
                    get_Flour(0xcc7a),
                    get_Flour(0x8f19),
                    get_Flour(0x96b1),
                    get_Flour(0x8a6d),
                ]
            },
            salt: Cook<Salt> {
                source: vector<Salt>[
                    get_Salt(0x8b01),
                    get_Salt(0xf1c5),
                    get_Salt(0xc6ec),
                ]
            },
        };

        assert!( bcs::to_bytes(&p) == out, 0);
        status.status2 = true;

    }

    public fun get_status(ctx: &mut tx_context::TxContext): Status {
        Status {
            status1: false,
            status2: false,
            user: tx_context::sender(ctx)
        }
    }

    public fun get_flag(status: &Status, ctx: &mut tx_context::TxContext) {
        let user = tx_context::sender(ctx);
        assert!(status.user == user, 0);
        assert!(status.status1 && status.status2, 0);
        event::emit(Flag { user: user });
    }    
}