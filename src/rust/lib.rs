use candid::{CandidType, Decode, Deserialize, Encode};
use ethers_core::types::{RecoveryMessage, Signature, H256};

wit_bindgen::generate!({
    path: "src/wit/rust.wit",
    world: "component",
});

struct Component;
export!(Component);

#[derive(Clone, Debug, CandidType, Deserialize)]
struct SignedMessage {
    eth_address: String,
    message: Message,
    signature: String,
}

#[derive(Clone, Debug, CandidType, Deserialize)]
enum Message {
    #[serde(rename = "data")]
    Data(Vec<u8>),
    #[serde(rename = "hash")]
    Hash([u8; 32]),
}

impl Guest for Component {
    fn call(arg: Vec<u8>) -> Vec<u8> {
        let result = Decode!(&arg, SignedMessage)
            .map(ecdsa_verify)
            .unwrap_or(Err("invalid message"));
        Encode!(&result).unwrap()
    }
}

/// Converts a hexadecimal string (prefixed with `0x`) to bytes.
pub fn hex_to_bytes(hex: &str) -> Result<Vec<u8>, &'static str> {
    if !hex.starts_with("0x") {
        return Err("hex literal requires `0x` prefix");
    }
    hex::decode(&hex[2..]).or(Err("invalid hex literal"))
}

/// Verifies an Ethereum message signature using ECDSA.
fn ecdsa_verify(message: SignedMessage) -> Result<bool, &'static str> {
    let eth_address = hex_to_bytes(&message.eth_address)?;
    let signature = hex_to_bytes(&message.signature)?;
    let message = match message.message {
        Message::Data(data) => RecoveryMessage::Data(data),
        Message::Hash(hash) => RecoveryMessage::Hash(H256::from_slice(&hash)),
    };

    let eth_address_bytes: [u8; 20] = eth_address.try_into().or(Err("expected 20-byte address"))?;
    if signature.len() != 65 {
        return Err("unexpected signature length");
    }
    Ok(Signature {
        r: signature[..32].into(),
        s: signature[32..64].into(),
        v: signature[64].into(),
    }
    .verify(message, eth_address_bytes)
    .is_ok())
}
