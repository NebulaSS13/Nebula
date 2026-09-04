/obj/item/modular_computer/laptop
	anchored = TRUE
	name = "laptop computer"
	desc = "A portable clamshell computer."
	icon = 'icons/obj/modular_computers/modular_laptop.dmi'
	icon_state = "laptop-open"
	w_class = ITEM_SIZE_NORMAL
	light_strength = 3
	interact_sounds = list("keyboard", "keystroke")
	interact_sound_volume = 20
	computer_type = /datum/extension/assembly/modular_computer/laptop
	matter = list(
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/silicon         = MATTER_AMOUNT_REINFORCEMENT,
	)
	var/icon_state_closed = "laptop-closed"

/obj/item/modular_computer/laptop/on_update_icon()
	if(anchored)
		..()
		icon_state = initial(icon_state)
	else
		cut_overlays()
		icon_state = icon_state_closed

/obj/item/modular_computer/laptop/preset
	anchored = FALSE

/obj/item/modular_computer/laptop/get_alt_interactions(var/mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/laptop_open)

/decl/interaction_handler/laptop_open
	name = "Open Laptop"
	expected_target_type = /obj/item/modular_computer/laptop
	interaction_flags = INTERACTION_NEEDS_PHYSICAL_INTERACTION | INTERACTION_NEEDS_TURF
	examine_desc = "open or close $TARGET_THEM$"

/decl/interaction_handler/laptop_open/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/item/modular_computer/laptop/L = target
	L.anchored = !L.anchored
	var/datum/extension/assembly/modular_computer/assembly = get_extension(L, L.computer_type)
	if(assembly)
		assembly.screen_on = L.anchored
	L.update_icon()
