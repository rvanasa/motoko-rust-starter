import {
    componentCall = call;
    decodeUtf8;
    debugPrint;
} "mo:prim";

let result = call("abc"); // Call Rust function

debugPrint("Result: " # debug_show (decodeUtf8(result))); // Print return value
