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
	var/icon_state_closed = "laptop-closed"
	
/obj/item/modular_computer/laptop/on_update_icon()
	if(anchored)
		..()
		icon_state = initial(icon_state)
	else
		cut_overlays()
		icon_state = icon_state_closed

/obj/item/modular_computer/laptop/get_alt_interactions(var/mob/user)
	. = ..() | /decl/interaction_handler/laptop_open

/obj/item/modular_computer/laptop/preset
	anchored = FALSE