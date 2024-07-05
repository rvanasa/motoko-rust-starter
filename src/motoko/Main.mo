import Prim "mo:prim";

let result = Prim.componentCall(123); // Call Rust function

Prim.debugPrint("Result: " # debug_show result); // Print return value
