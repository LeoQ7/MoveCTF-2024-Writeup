# ZK2

```rust
use ark_bn254::Bn254;
use ark_circom::CircomBuilder;
use ark_circom::CircomConfig;
use ark_groth16::Groth16;
use ark_serialize::CanonicalDeserialize;
use ark_serialize::CanonicalSerialize;
use ark_snark::SNARK;

fn main() {
    // Load the WASM and R1CS for witness and proof generation
    let cfg = CircomConfig::<Bn254>::new("zk2.wasm", "zk2.r1cs").unwrap();

    // Insert our secret inputs as key value pairs. G on the Baby Jubjub Curve
    let mut builder = CircomBuilder::new(cfg);
    builder.push_input("x", num_bigint::BigInt::parse_bytes(b"995203441582195749578291179787384436505546430278305826713579947235728471134", 10).unwrap());
    builder.push_input("delta", num_bigint::BigInt::parse_bytes(b"5472060717959818805561601436314318772137091100104008585924551046643952123905", 10).unwrap());

    let mut rng = rand::thread_rng();

    let pk_bytes = hex::decode(include_str!("pk.txt")).unwrap();
    let params = ark_groth16::ProvingKey::<Bn254>::deserialize_compressed(&pk_bytes[..]).unwrap();

    let circom = builder.build().unwrap();

    // There's only one public input, namely the hash digest.
    let inputs = circom.get_public_inputs().unwrap();

    // Generate the proof
    let proof = Groth16::<Bn254>::prove(&params, circom, &mut rng).unwrap();

    let vk_bytes = hex::decode(include_str!("vk.txt")).unwrap();

    let vk = ark_groth16::VerifyingKey::<Bn254>::deserialize_compressed(&vk_bytes[..]).unwrap();

    // Check that the proof is valid
    let pvk = Groth16::<Bn254>::process_vk(&vk).unwrap();
    let verified = Groth16::<Bn254>::verify_with_processed_vk(&pvk, &inputs, &proof).unwrap();
    assert!(verified);

    let mut proof_inputs_bytes = Vec::new();

    for input in inputs.iter() {
        input.serialize_compressed(&mut proof_inputs_bytes).unwrap();
    }

    let mut proof_points_bytes = Vec::new();

    proof.serialize_compressed(&mut proof_points_bytes).unwrap();

    println!("Proof inputs: {:?}", proof_inputs_bytes);
    println!("Proof points: {:?}", proof_points_bytes);
}
```