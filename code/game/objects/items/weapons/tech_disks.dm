/obj/item/disk
	name = "data disk"
	icon = 'icons/obj/items/device/diskette.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_TINY
	material = /decl/material/solid/plastic
	matter = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_TRACE)
	var/label = "label_blank"
	
/obj/item/disk/on_update_icon()
	. = ..()
	cut_overlays()
	var/list/details = list()
	details += mutable_appearance(icon, "slider", flags = RESET_COLOR)
	if(label)
		details += mutable_appearance(icon, label, flags = RESET_COLOR)
	add_overlay(details)

/obj/item/disk/random/Initialize(ml, material_key)
	color = get_random_colour()
	. = ..()
/obj/item/disk/tech_disk
	name = "fabricator data disk"
	desc = "A disk for storing fabricator learning data for backup."
	color = COLOR_BOTTLE_GREEN
	var/list/stored_tech

/obj/item/disk/design_disk
	name = "component design disk"
	desc = "A disk for storing device design data for construction in lathes."
	color = COLOR_BLUE_GRAY
	var/datum/fabricator_recipe/blueprint

/obj/item/disk/design_disk/attack_hand(mob/user)
	if(user.a_intent == I_HURT && blueprint)
		blueprint = null
		SetName(initial(name))
		to_chat(user, SPAN_DANGER("You flick the erase switch and wipe \the [src]."))
		return TRUE
	. = ..()
