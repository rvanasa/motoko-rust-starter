wit_bindgen::generate!({
    path: "src/wit/rust.wit",
    world: "component",
});

struct Component;
export!(Component);

impl Guest for Component {
    fn call(value: u32) -> u32 {
        value * 2
    }
}
