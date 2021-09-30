/obj/item/energy_blade/ninja

	anchored =          TRUE    // Never spawned outside of inventory, should be fine.
	armor_penetration = 100
	throw_speed =       1
	throw_range =       1
	w_class = ITEM_SIZE_TINY //technically it's just energy or something, I dunno
	active_attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/blade1.ogg'

	active =              TRUE
	active_force =        40 //Normal attacks deal very high damage - about the same as wielded fire axe
	active_sharp =        1
	active_edge =         1
	active_throwforce =   1  //Throwing or dropping the item deletes it.
	active_parry_chance = 50

	var/mob/living/creator

/obj/item/energy_blade/ninja/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/energy_blade/ninja/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/energy_blade/ninja/is_special_cutting_tool(var/high_power)
	return TRUE

/obj/item/energy_blade/ninja/get_storage_cost()
	return ITEM_SIZE_NO_CONTAINER

/obj/item/energy_blade/ninja/attack_self(mob/user)
	user.drop_from_inventory(src)

/obj/item/energy_blade/ninja/dropped()
	..()
	QDEL_IN(src, 0)

/obj/item/energy_blade/ninja/Process()
	if(!creator || loc != creator || !(src in creator.get_held_items()))
		// Tidy up a bit.
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		QDEL_IN(src, 0)
