use candid::{CandidType, Decode, Deserialize};
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
    fn call(value: Vec<u8>) -> u32 {
        Decode!(&value, SignedMessage)
            .map(|message| match ecdsa_verify(message) {
                Some(true) => 0,  // valid
                Some(false) => 1, // invalid
                _ => 2,           // verification error
            })
            .unwrap_or(3) // deserialization error
    }
}

/// Converts a hexadecimal string (prefixed with `0x`) to bytes.
pub fn hex_to_bytes(hex: &str) -> Option<Vec<u8>> {
    if !hex.starts_with("0x") {
        return None;
    }
    hex::decode(&hex[2..]).ok()
}

/// Verifies an Ethereum message signature using ECDSA.
fn ecdsa_verify(message: SignedMessage) -> Option<bool> {
    let eth_address = hex_to_bytes(&message.eth_address)?;
    let signature = hex_to_bytes(&message.signature)?;
    let message = match message.message {
        Message::Data(data) => RecoveryMessage::Data(data),
        Message::Hash(hash) => RecoveryMessage::Hash(H256::from_slice(&hash)),
    };

    let eth_address_bytes: [u8; 20] = eth_address.try_into().expect("expected 20-byte address");
    if signature.len() != 65 {
        return None;
    }
    Some(
        Signature {
            r: signature[..32].into(),
            s: signature[32..64].into(),
            v: signature[64].into(),
        }
        .verify(message, eth_address_bytes)
        .is_ok(),
    )
}
