module zk::zk1 {
    use sui::groth16;
    use sui::event;
    use sui::tx_context;

    struct Flag has copy, drop {
        user: address
    }

    public entry fun verify_proof(public_inputs_bytes: vector<u8>, proof_points_bytes: vector<u8>, ctx: &mut tx_context::TxContext) {
        let vk = x"8065f63af6c9930afbadc7ff0a07c7fdc88b7690b3693ad0b5f2ad3f69e02c87b092c72d57ac9a76e62b2c6a0a3eaf495ba40d3ecead25864047ab652956d403437aafe91567f72132a4ed6462cb23994b4e7a4f1110a1a3b85776a7a50ac68b03faaf3bca41fa2eb1aa7d30a41b8e8ff0786fd446ab8f55ca4270b0d16022223e809542c46780d10007c2935333d196e17c6a5a0a025036ed4bfa4756d459a2a30b484a764a0cdc27450b90fe7be4403c092a55b7cef6af9cc6913978ece82dbe2d4bf6039236894905aee196a224736eb8113744dca217e26fdea38ea05825020000000000000088a97edf2b88106d6474552a09e7298f2772f58c4315c216dd62cf2393d6f5886f44a01680fb996936b30f23c1b8f03ad7f0343bdd04bc2ad56a432785a9d220";
        let pvk = groth16::prepare_verifying_key(&groth16::bn254(), &vk);
        let public_inputs = groth16::public_proof_inputs_from_bytes(public_inputs_bytes);
        let proof_points = groth16::proof_points_from_bytes(proof_points_bytes);
        assert!(groth16::verify_groth16_proof(&groth16::bn254(), &pvk, &public_inputs, &proof_points), 0);
        event::emit(Flag { user: tx_context::sender(ctx) });
    }
}
