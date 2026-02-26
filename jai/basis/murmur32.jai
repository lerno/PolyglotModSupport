// Murmur32 implementation by @shwa
// https://discord.com/channels/661732390355337246/1057205060876128278/1224419896973070477

murmur32 :: (key: *void, len: s64, h: u32) -> u32 #no_context {
    // main body, work on 32-bit blocks at a time
    for i: 0..(len/4) - 1 {
        k := (cast(*u32) key)[i]*0xcc9e2d51;
        k = ((k << 15) | (k >> 17))*0x1b873593;
        h = (((h^k) << 13) | ((h^k) >> 19))*5 + 0xe6546b64;
    }

    // load/mix up to 3 remaining tail bytes into a tail block
    t: u32;
    tail := (cast(*u8) key) + 4*(len/4);
    if (len & 3) == {
        case 3; t ^= cast(u32)((cast(s32)tail[2]) << 16); #through;
        case 2; t ^= cast(u32)((cast(s32)tail[1]) <<  8); #through;
        case 1; {
            t ^= tail[0];
            h ^= ((((0xcc9e2d51*t) << 15) | ((0xcc9e2d51*t) >> 17))*0x1b873593);
        }
    }

    // finalization mix, including key length
    h = ((h^cast(u32)len) ^ ((h^cast(u32)len) >> 16))*0x85ebca6b;
    h = (h ^ (h >> 13))*0xc2b2ae35;
    return h ^ (h >> 16);
}
