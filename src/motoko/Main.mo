import {
    debugPrint;
    componentCall = callRust;
} "mo:prim";

// Types used in Rust component
type SignedMessage = {
    eth_address : Text;
    message : { #data : Blob; #hash : Blob };
    signature : Text;
};
type VerifyError = { #verify; #candid; #unknown };

// Wrapper around Rust function
func verifySignature(message : SignedMessage) : {
    #ok : Bool;
    #err : VerifyError;
} {
    switch (callRust(to_candid (message))) {
        // TODO: use `from_candid` in place of numeric return codes (work in progress)
        case 0 #ok true;
        case 1 #ok false;
        case 2 #err(#verify);
        case 3 #err(#candid);
        case _ #err(#unknown);
    };
};

// Verify Ethereum ECDSA signature in Motoko
let result = verifySignature({
    eth_address = "0xc9b28dca7ea6c5e176a58ba9df53c30ba52c6642";
    message = #data "hello";
    signature = "0x5c0e32248c10f7125b32cae1de9988f2dab686031083302f85b0a82f78e9206516b272fb7641f3e8ab63cf9f3a9b9220b2d6ff2699dc34f0d000d7693ca1ea5e1c";
});
debugPrint("Verified signature: " # debug_show result);
