/obj/item/core_sampler
	name = "core sampler"
	desc = "Used to extract geological core samples."
	icon = 'icons/obj/items/geologic_sampler.dmi'
	icon_state = "sampler0"
	item_state = "screwdriver_brown"
	w_class = ITEM_SIZE_TINY

	var/obj/item/sample

/obj/item/core_sampler/examine(mob/user, distance)
	. = ..(user)
	if(distance <= 2)
		to_chat(user, SPAN_NOTICE("This one is [sample ? "full" : "empty"]"))

/obj/item/core_sampler/proc/sample_item(var/item_to_sample, var/mob/user)
	var/datum/extension/geological_data/GD = get_extension(item_to_sample, /datum/extension/geological_data)
	if(GD)
		if(sample)
			to_chat(user, SPAN_WARNING("The core sampler is full."))
		else
			sample = new /obj/item/rocksliver(src, null, GD.geodata)
			update_icon()
			to_chat(user, SPAN_NOTICE("You take a core sample of the [item_to_sample]."))
	else
		to_chat(user, SPAN_WARNING("You are unable to take a geological sample of [item_to_sample]."))

/obj/item/core_sampler/on_update_icon()
	icon_state = "sampler[!!sample]"

/obj/item/core_sampler/attack_self(var/mob/user)
	if(sample)
		to_chat(user, SPAN_NOTICE("You eject the sample."))
		user.put_in_hands(sample)
		sample = null
		update_icon()
	else
		to_chat(user, SPAN_WARNING("The core sampler is empty."))

/obj/item/core_sampler/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(proximity_flag)
		sample_item(target, user)
	
/obj/item/rocksliver
	name = "rock sliver"
	desc = "It looks extremely delicate."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "sliver1"
	randpixel = 8
	w_class = ITEM_SIZE_TINY
	sharp = 1
	
/obj/item/rocksliver/Initialize(ml, material_key, geodata)
	. = ..()
	icon_state = "sliver[rand(1, 3)]"
	set_extension(src, /datum/extension/geological_data, geodata)
