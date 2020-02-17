/obj/item/material/twohanded/spear/attackby(obj/item/W, mob/user) // make a javelin from a spear
	. = ..()
	if(istype(W, /obj/item/wirecutters))
		visible_message(SPAN_NOTICE("[user] cuts off a length of \the [src], making it shorter."), blind_message = SPAN_NOTICE("You hear the snipping of wirecutters."))
		playsound(user.loc,'sound/items/Wirecutter.ogg', 100, 1)
		user.put_in_hands(new /obj/item/material/twohanded/spear/javelin(get_turf(user), material.type))
		qdel(src)

/obj/item/material/twohanded/spear/javelin //short spears for short folks; can be wielded two handed even when mob_small
	icon_state = "spearglass0"
	base_icon = "spearglass"
	name = "javelin"
	desc = "A short spear good for throwing and okay for stabbing. Favoured by yinglets because they can wield it more easily than a longer spear."
	max_force = 20 
	material_force_multiplier = 0.29 //17 with steel, 14 with glass. 
	unwielded_material_force_multiplier = 0.22 //13 with steel, 11 with glass. 
	thrown_material_force_multiplier = 1.8 //better for throwing than spear
	//result for humans: Still better to wield a regular spear with two hands, but if you want to use it one handed a javelin is better.
	// result for yinglets and other small mobs: A javelin is a better choice.

/obj/item/material/twohanded/spear/javelin/update_twohanding() //overrides to allow two hands
	var/mob/living/M = loc
	if(istype(M) && is_held_twohanded(M))
		wielded = 1
		force = force_wielded
	else
		wielded = 0
		force = force_unwielded
	update_icon()

/datum/codex_entry/spear
	associated_paths = list(/obj/item/material/twohanded/spear, /obj/item/material/twohanded/spear/javelin)
	associated_strings = list("spear","javelin")
	mechanics_text = "Spears are automatically held with two hands if the other hand is free to do so. Holding with both hands increases damage dealt. Using wirecutters on a spear turns it into a javelin, which can be held by small mobs and does more throwing damage, but less damage overall. \
	<BR><BR>You can start crafting a spear by making cable cuffs and applying them to a rod. After, examining the spear assembly will give details on how to proceed."
