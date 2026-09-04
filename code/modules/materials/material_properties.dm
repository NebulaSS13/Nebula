// Currently used for weapons and objects made of uranium to irradiate things.
/decl/material/proc/products_need_process()
	return (radioactivity>0) //todo

// Used by walls and weapons to determine if they break or not.
/decl/material/proc/is_brittle()
	return !!(flags & MAT_FLAG_BRITTLE)

/decl/material/proc/can_hold_sharpness()
	return hardness > MAT_VALUE_FLEXIBLE

/decl/material/proc/can_hold_edge()
	return hardness > MAT_VALUE_FLEXIBLE

// TODO: expand this to more than just Actual Poison.
/decl/material/proc/is_unsafe_to_drink(mob/user)
	return toxicity > 0