/obj/item/disk
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	item_state = "card-id"
	w_class = ITEM_SIZE_SMALL
	matter = list(/decl/material/solid/plastic = 30, /decl/material/solid/metal/steel = 30, /decl/material/solid/glass = 10)

/obj/item/disk/tech_disk
	name = "fabricator data disk"
	desc = "A disk for storing fabricator learning data for backup."
	var/list/stored_tech

/obj/item/disk/design_disk
	name = "component design disk"
	desc = "A disk for storing device design data for construction in lathes."
	var/datum/fabricator_recipe/blueprint

/obj/item/disk/design_disk/attack_hand(mob/user)
	if(user.a_intent == I_HURT && blueprint)
		blueprint = null
		SetName(initial(name))
		to_chat(user, SPAN_DANGER("You flick the erase switch and wipe \the [src]."))
		return TRUE
	. = ..()
