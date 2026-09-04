/decl/mob_modifier/restrained
	name                     = "Restrained"
	desc                     = "You are restrained and need to resist to get out of your bindings."
	hud_icon_state           = "restrained"
	show_indefinite_duration = FALSE

/decl/mob_modifier/restrained/on_modifier_datum_click(mob/living/_owner, decl/mob_modifier/modifier, params)
	_owner.resist()
	return TRUE
