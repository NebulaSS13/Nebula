/obj/item/modular_computer/laptop
	anchored = TRUE
	name = "laptop computer"
	desc = "A portable clamshell computer."
	icon_state_unpowered = "laptop-open"
	icon = 'icons/obj/modular_computers/modular_laptop.dmi'
	icon_state = "laptop-open"
	w_class = ITEM_SIZE_NORMAL
	light_strength = 3
	var/icon_state_closed = "laptop-closed"
	interact_sounds = list("keyboard", "keystroke")
	interact_sound_volume = 20
	computer_type = /datum/extension/assembly/modular_computer/laptop
	
/obj/item/modular_computer/laptop/AltClick(var/mob/user)
// Prevents carrying of open laptops inhand.
// While they work inhand, i feel it'd make tablets lose some of their high-mobility advantage they have over laptops now.
	if(!CanPhysicallyInteract(user))
		return
	if(!istype(loc, /turf/))
		to_chat(usr, "\The [src] has to be on a stable surface first!")
		return
	var/datum/extension/assembly/modular_computer/assembly = get_extension(src, computer_type)
	anchored = !anchored
	assembly.screen_on = anchored
	update_icon()

/obj/item/modular_computer/laptop/on_update_icon()
	if(anchored)
		..()
	else
		overlays.Cut()
		icon_state = icon_state_closed

/obj/item/modular_computer/laptop/preset
	anchored = FALSE