module dynamic_matrix_traversal::matrix {

    use std::vector;
    use sui::event;
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    const TARGET_VALUE_1: u64 = 2794155;
    const TARGET_VALUE_2: u64 = 14365;

    const ERROR_RESULT_1: u64 = 1;
    const ERROR_RESULT_2: u64 = 2;
    const ERROR_PARAM_1: u64 = 3;
    const ERROR_PARAM_2: u64 = 4;

    struct Flag has copy, drop {
        user: address,
        flag: bool
    }

    struct Record has key {
        id: UID,
        count_1: u64,
        count_2: u64,
        count_3: u64,
        count_4: u64
    }


    fun init(ctx: &mut sui::tx_context::TxContext) {
        let record = Record {
            id: object::new(ctx),
            count_1: 0,
            count_2: 0,
            count_3: 0,
            count_4: 0
        };

        transfer::share_object(record);
    }

    fun up(m: u64, n: u64): u64 {
        let f: vector<vector<u64>> = vector::empty();
        let i: u64 = 0;
        while (i < m) {
            let row: vector<u64> = vector::empty();
            let j: u64 = 0;
            while (j < n) {
                if (j == 0 || i == 0) {
                    vector::push_back(&mut row, 1);
                } else {
                    let f1 = *vector::borrow(&f, i - 1);
                    let j1 = *vector::borrow(&row, j - 1);
                    let val = *vector::borrow(&f1, j) + j1;
                    vector::push_back(&mut row, val);
                };
                j = j + 1;
            };
            vector::push_back(&mut f, row);
            i = i + 1;
        };
        let fr = *vector::borrow(&f, m - 1);
        let result = *vector::borrow(&fr, n-1);
        result
    }

    public entry fun execute(record: &mut Record, m: u64, n: u64) {
        if (record.count_1 == 0) {
            let result: u64 = up(m, n);
            assert!(result == TARGET_VALUE_1, ERROR_RESULT_1);
            record.count_1 = m;
            record.count_2 = n;
        } else if (record.count_3 == 0) {
            let result: u64 = up(m, n);
            assert!(result == TARGET_VALUE_2, ERROR_RESULT_2);
            record.count_3 = m;
            record.count_4 = n;
        }
    }

    public entry fun get_flag(record: &Record, ctx: &mut TxContext) {
        assert!(record.count_1 < record.count_3, ERROR_PARAM_1);
        assert!(record.count_2 > record.count_4, ERROR_PARAM_2);
        event::emit(Flag { user: tx_context::sender(ctx), flag: true });
    }

    #[test_only]
    public fun init2(ctx: &mut sui::tx_context::TxContext) {
        init(ctx)
    }
}
