/obj/item/flame/match
	name               = "match"
	desc               = "A simple match stick, used for lighting fine smokables."
	icon               = 'icons/obj/items/flame/match.dmi'
	obj_flags          = OBJ_FLAG_HOLLOW // so that it's not super overpriced compared to lighters
	slot_flags         = SLOT_EARS
	attack_verb        = list("burnt", "singed")
	randpixel          = 10
	_fuel              = 5
	_base_attack_force = 1
	var/burnt          = FALSE

/obj/item/flame/match/Initialize()
	. = ..()
	set_color(null) // clear our scent color

/obj/item/flame/match/get_available_scents()
	var/static/list/available_scents = list(
		/decl/scent_type/woodsmoke
	)
	return available_scents

/obj/item/flame/match/light(mob/user, no_message)
	. = !burnt && ..()

/obj/item/flame/match/extinguish(var/mob/user, var/no_message)
	. = ..()
	if(. && !burnt)
		_fuel = 0
		burnt = TRUE
		name = "burnt match"
		desc = "A match. This one has seen better days."
		update_icon()

/obj/item/flame/match/on_update_icon()
	. = ..()
	if(burnt)
		icon_state = "[get_world_inventory_state()]_burnt"
	else if(lit)
		icon_state = "[get_world_inventory_state()]_lit"
