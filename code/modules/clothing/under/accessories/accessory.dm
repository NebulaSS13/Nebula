/obj/item/clothing/accessory
	name = "tie"
	desc = "A neosilk clip-on tie."
	icon = 'icons/clothing/accessories/ties/tie.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_TIE
	w_class = ITEM_SIZE_SMALL

	var/slot = ACCESSORY_SLOT_DECOR
	var/high_visibility	//if it should appear on examine without detailed view
	var/slowdown //used when an accessory is meant to slow the wearer down when attached to clothing
	var/removable = TRUE
	var/hide_on_uniform_rolldown = FALSE
	var/hide_on_uniform_rollsleeves = FALSE

/obj/item/clothing/accessory/Destroy()
	on_removed()
	return ..()

/obj/item/clothing/accessory/get_fallback_slot(var/slot)
	if(slot != BP_L_HAND && slot != BP_R_HAND)
		return slot_tie_str

/obj/item/clothing/accessory/proc/on_attached(var/obj/item/clothing/S, var/mob/user)
	if(istype(S))
		forceMove(S)
		if(user)
			to_chat(user, SPAN_NOTICE("You attach \the [src] to \the [S]."))
			src.add_fingerprint(user)

/obj/item/clothing/accessory/proc/on_removed(var/mob/user)
	var/obj/item/clothing/suit = loc
	if(istype(suit))
		if(user)
			usr.put_in_hands(src)
			src.add_fingerprint(user)
		else
			dropInto(loc)

//default attackby behaviour
/obj/item/clothing/accessory/attackby(obj/item/I, mob/user)
	..()

//default attack_hand behaviour
/obj/item/clothing/accessory/attack_hand(mob/user)
	if(istype(loc, /obj/item/clothing))
		return TRUE //we aren't an object on the ground so don't call parent
	return ..()

/obj/item/clothing/accessory/get_pressure_weakness(pressure,zone)
	if(body_parts_covered & zone)
		return ..()
	return 1

/obj/item/clothing/accessory/proc/should_overlay()
	. = istype(loc, /obj/item/clothing)
	if(. && istype(loc, /obj/item/clothing/under))
		var/obj/item/clothing/under/uniform = loc
		if(uniform.rolled_down && hide_on_uniform_rolldown)
			return FALSE
		if(uniform.rolled_sleeves && hide_on_uniform_rollsleeves)
			return FALSE

/obj/item/clothing/accessory/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay && istype(loc, /obj/item/clothing/under))
		var/new_state = overlay.icon_state
		var/obj/item/clothing/under/uniform = loc
		if(uniform.rolled_down)
			new_state = "[new_state]-rolled"
		else if(uniform.rolled_sleeves)
			new_state = "[new_state]-sleeves"
		if(check_state_in_icon(overlay.icon, new_state))
			overlay.icon_state = new_state
	. = ..()

/obj/item/clothing/accessory/proc/get_attached_overlay_state()
	return "attached"

/obj/item/clothing/accessory/proc/get_attached_inventory_overlay(var/base_state)
	var/find_state = "[base_state]-[get_attached_overlay_state()]"
	if(find_state && check_state_in_icon(find_state, icon))
		var/image/ret = image(icon, find_state)
		ret.color = color
		return ret

/obj/item/clothing/accessory/OnDisguise(obj/item/copy, mob/user)
	. = ..()
	if(istype(copy, /obj/item/clothing/accessory))
		var/obj/item/clothing/accessory/tie = copy
		hide_on_uniform_rolldown =    tie.hide_on_uniform_rolldown
		hide_on_uniform_rollsleeves = tie.hide_on_uniform_rollsleeves
	else
		hide_on_uniform_rolldown =    initial(hide_on_uniform_rolldown)
		hide_on_uniform_rollsleeves = initial(hide_on_uniform_rollsleeves)

//Necklaces
/obj/item/clothing/accessory/necklace
	name = "necklace"
	desc = "A simple necklace."
	icon = 'icons/clothing/accessories/jewelry/necklace.dmi'
	slot_flags = SLOT_FACE | SLOT_TIE

//Misc
/obj/item/clothing/accessory/kneepads
	name = "kneepads"
	desc = "A pair of synthetic kneepads. Doesn't provide protection from more than arthritis."
	icon = 'icons/clothing/accessories/armor/kneepads.dmi'

//Scarves
/obj/item/clothing/accessory/scarf
	name = "scarf"
	desc = "A stylish scarf. The perfect winter accessory for those with a keen fashion sense, and those who just can't handle a cold breeze on their necks."
	icon = 'icons/clothing/accessories/clothing/scarf.dmi'

/obj/item/clothing/accessory/scarf/purple
	color = COLOR_PURPLE

/obj/item/clothing/accessory/scarf/red
	color = COLOR_RED

/obj/item/clothing/accessory/scarf/lightblue
	color = COLOR_LIGHT_CYAN

/obj/item/clothing/accessory/scarf/christmas
	name = "\improper Christmas scarf"
	icon = 'icons/clothing/accessories/clothing/scarf_christmas.dmi'


//Bracelets
/obj/item/clothing/accessory/bracelet
	name = "bracelet"
	desc = "A simple bracelet with a clasp."
	icon = 'icons/clothing/accessories/jewelry/bracelet.dmi'
