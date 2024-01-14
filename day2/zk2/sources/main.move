#[lint_allow(coin_field, self_transfer)]
module zk::zk2 {
    use sui::groth16;
    use sui::event;
    use sui::tx_context;
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::table::{Table, Self};
    use sui::hash::keccak256;

    use std::option;

    struct Flag has copy, drop {
        user: address
    }

    struct ZK2 has drop {}

    struct Protocol has key {
        id: UID,
        vault: Coin<ZK2>,
        cap: TreasuryCap<ZK2>,
        proof_talbe: Table<vector<u8>, bool>,
        balance: Table<address, u64>
    }
    
    fun init(witness: ZK2, ctx: &mut sui::tx_context::TxContext) {
        let (treasury_cap, metadata) = coin::create_currency(
            witness,
            3,
            b"zk2",
            b"zk2",
            b"zk2",
            option::none(),
            ctx,
        );

        transfer::share_object(Protocol {
            id: object::new(ctx),
            vault: coin::mint(&mut treasury_cap, 100_000, ctx),
            cap: treasury_cap,
            proof_talbe: table::new<vector<u8>, bool>(ctx),
            balance: table::new<address, u64>(ctx)
        });

        transfer::public_freeze_object(metadata);
    }

    public entry fun faucet(protocol: &mut Protocol, ctx: &mut tx_context::TxContext) {
        table::add(&mut protocol.balance, tx_context::sender(ctx), 60_000);
    }

    public entry fun verify_proof(public_inputs_bytes: vector<u8>, proof_points_bytes: vector<u8>) {
        let vk = x"0f1c7379da47a90f6ee346b32e0aa58111a0bbfebd82f86ff5b524f71e44e8a7d97844896c657e4df2b40b4806e58bdbbb2a2c209b6a8d52586eb4c65b18f80c06b9ea9c0e4f1e48e6dbbb4305f8665f1d5a9f71127aeb9f8737b0728cf8e7a1c36ffe38d5ed428b4c321193359ec06c3c685b05d09c85ed2e7c2663a49d7d2217dcc6ea1a873177bbf10997051d0eb334158bf516fd7ebff332e2939867e71f18ccaacbe4d9882b22ef5886d5f2b6a8fbef91d29ae7beb90fc94029ebf27e215ad066c4f4d8a74e4703ccda8e6181970e150ee683736ba8eb488ad127907b290200000000000000a4f36767b43c914494487f92d14f279f169c739d21bce1db15a5065c063f0f3079bdbd36be713a109f6fb8f9ba0083c3e4932cf730152d58c061c94f3425028e";
        let pvk = groth16::prepare_verifying_key(&groth16::bn254(), &vk);
        let public_inputs = groth16::public_proof_inputs_from_bytes(public_inputs_bytes);
        let proof_points = groth16::proof_points_from_bytes(proof_points_bytes);
        assert!(groth16::verify_groth16_proof(&groth16::bn254(), &pvk, &public_inputs, &proof_points), 0);
    }

    public entry fun withdraw(amount: u64, public_inputs_bytes: vector<u8>, proof_points_bytes: vector<u8>, protocol: &mut Protocol, ctx: &mut tx_context::TxContext) {
        verify_proof(public_inputs_bytes, proof_points_bytes);
        assert!(*table::borrow(&protocol.balance, tx_context::sender(ctx)) >= amount, 0);
        table::add(&mut protocol.proof_talbe, keccak256(&proof_points_bytes), true);
        let coin = coin::split(&mut protocol.vault, amount, ctx);
        transfer::public_transfer(coin, tx_context::sender(ctx));
    }

    public entry fun get_flag(protocol: &mut Protocol, ctx: &mut tx_context::TxContext) {
        assert!(coin::value<ZK2>(&protocol.vault) == 0, 0);
        event::emit(Flag { user: tx_context::sender(ctx) });
    }

    #[test_only]
    public fun init_test(ctx: &mut tx_context::TxContext) {
        init(ZK2{}, ctx);
    }
}
