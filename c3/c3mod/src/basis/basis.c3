module basis;

alias IntPtr = uptr;
alias IntPtr64 = ulong;
alias CppPtr = ulong;
alias WasmFuncPtr = uint;

macro printf(...)
{
	@pool()
	{
		String str = string::tformat($vasplat);
		InteropString is = { str, str.len };
		funcPtr_Core_printOnHost(&is);
	}; // Temp allocator reset
}
