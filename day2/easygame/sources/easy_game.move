module movectf::easy_game {
    use std::vector;
    use sui::math;
    use sui::transfer;
    use sui::tx_context::TxContext;
    use sui::object::{Self,UID};
    use sui::event;

    struct Challenge has key, store {
        id: UID,
        initial_part: vector<u64>, 
        target_amount: u64, 
    }

    struct Flag has copy, drop {
        user: address,
        flag: bool
    }

    fun init( ctx: &mut sui::tx_context::TxContext) {
        let initial_part = vector::empty<u64>();
        vector::push_back(&mut initial_part, 1);
        vector::push_back(&mut initial_part, 2);
        vector::push_back(&mut initial_part, 4);
        vector::push_back(&mut initial_part, 5);
        vector::push_back(&mut initial_part, 1);
        vector::push_back(&mut initial_part, 3);
        vector::push_back(&mut initial_part, 6);
        vector::push_back(&mut initial_part, 7);

        let challenge = Challenge {
            id: object::new(ctx),
            initial_part: initial_part,
            target_amount: 22,
        };
        transfer::share_object(challenge);
    
    }

    public fun submit_solution(user_input: vector<u64>,rc: &mut Challenge,ctx: &mut TxContext ){
        let sender = sui::tx_context::sender(ctx);
       
        let houses = rc.initial_part;
        vector::append(&mut houses, user_input);

        let amount_robbed = rob(&houses);

        let result = amount_robbed == rc.target_amount;
        if  (result) {
            event::emit(Flag { user: sender, flag: true });
        };
    }
    public fun rob(houses: &vector<u64>):u64{
        let n = vector::length(houses);
        if (n ==0){
            0;
        };
        let v = vector::empty<u64>();
        vector::push_back(&mut v, *vector::borrow(houses, 0));
        if (n>1){
            vector::push_back(&mut v, math::max(*vector::borrow(houses, 0), *vector::borrow(houses, 1)));
        };
        let i = 2;
        while (i < n) {
            let dp_i_1 = *vector::borrow(&v, i - 1);
            let dp_i_2_plus_house = *vector::borrow(&v, i - 2) + *vector::borrow(houses, i);
            vector::push_back(&mut v, math::max(dp_i_1, dp_i_2_plus_house));
            i = i + 1;
        }
        ;
        *vector::borrow(&v, n - 1)
    }
}

