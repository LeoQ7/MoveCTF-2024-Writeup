module movectf::checkin {
    use sui::event;
    use sui::tx_context::{Self, TxContext};

    const ESTRING:u64 = 0;

    struct Flag has copy, drop {
        sender: address,
        flag: bool,
    }

    public entry fun get_flag(string: vector<u8>, ctx: &mut TxContext) {
        assert!(string == b"MoveBitCTF",ESTRING);
        event::emit(Flag {
            sender: tx_context::sender(ctx),
            flag: true,
        });
    }
}