toInteropString :: (str: string) -> InteropString #no_context {
    return InteropString.{ str.data, cast(u32)str.count };
}

makeStringHash :: (str: string) -> StringHash #no_context {
    HASH_SEED :: 0;
    return murmur32(str.data, str.count, HASH_SEED);
}