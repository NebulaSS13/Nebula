#define GLOBAL_GETTER(NAME, TYPE, INIT)         \
var/global##TYPE/##NAME;                        \
/proc/get_global_##NAME() {                     \
	if(!global.##NAME) { global.##NAME = INIT } \
	return global.##NAME;                       \
}
