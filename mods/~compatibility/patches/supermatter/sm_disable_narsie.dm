// Disable Narsie when a supermatter cascade begins.
/datum/universal_state/supermatter_cascade/OnEnter()
	var/decl/special_role/cultist/cult = GET_DECL(/decl/special_role/cultist)
	cult.allow_narsie = 0