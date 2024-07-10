import { debugPrint; componentCall = call } "mo:prim";

let result = call("abc"); // Call Rust function

debugPrint("Result: " # debug_show result); // Print return value
