// Defined here due to being used immediately below.
#define GET_DECL(D) (ispath(D, /decl) ? (decls_repository.fetched_decls[D] || decls_repository.get_decl(D)) : null)

// Defined here due to compile order; overrides in macros make the compiler complain.
/decl/global_vars
	var/static/list/protected_vars = list("protected_vars") // No editing the protected list!
/decl/global_vars/proc/mark_protected_vars()
	return
/hook/startup/proc/mark_protected_vars()
	var/decl/global_vars/global_vars = GET_DECL(/decl/global_vars)
	global_vars.mark_protected_vars()
	return TRUE

#define GLOBAL_GETTER(NAME, TYPE, VAL)           \
var/global##TYPE/##NAME;                         \
/proc/get_global_##NAME() {                      \
	if(!global.##NAME) { global.##NAME = VAL }   \
	return global.##NAME;                        \
}

#define GLOBAL_GETTER_PROTECTED(NAME, TYPE, VAL) \
GLOBAL_GETTER(NAME, TYPE, VAL)                   \
/decl/global_vars/mark_protected_vars() { ..(); protected_vars += #NAME }

#define GLOBAL_PROTECTED(NAME, TYPE, VAL)       \
var/global##TYPE/##NAME = VAL;                  \
/decl/global_vars/mark_protected_vars() { ..(); protected_vars += #NAME }

#define GLOBAL_PROTECTED_UNTYPED(NAME, VAL)     \
var/global/##NAME = VAL;                        \
/decl/global_vars/mark_protected_vars() { ..(); protected_vars += #NAME }
