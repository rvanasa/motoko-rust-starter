wit_bindgen::generate!({
    path: "src/wit/rust.wit",
    world: "component",
});

struct Component;
export!(Component);

impl Guest for Component {
    fn call(value: Vec<u8>) -> u32 {
        value.len() as u32 * 2
    }
}
