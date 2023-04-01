/obj/item/energy_blade/ninja

	anchored =          TRUE    // Never spawned outside of inventory, should be fine.
	armor_penetration = 100
	throw_speed =       1
	throw_range =       1
	w_class = ITEM_SIZE_TINY //technically it's just energy or something, I dunno
	active_attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/blade1.ogg'
	is_spawnable_type = FALSE // Do not manually spawn this, it will runtime/break.

	active =              TRUE
	active_force =        40 //Normal attacks deal very high damage - about the same as wielded fire axe
	active_sharp =        1
	active_edge =         1
	active_throwforce =   1  //Throwing or dropping the item deletes it.
	active_parry_chance = 50

	var/mob/living/creator

/obj/item/energy_blade/ninja/Initialize()
	. = ..()
	if(!ismob(loc))
		return INITIALIZE_HINT_QDEL

/obj/item/energy_blade/ninja/is_special_cutting_tool(var/high_power)
	return active

/obj/item/energy_blade/ninja/get_storage_cost()
	return ITEM_SIZE_NO_CONTAINER

/obj/item/energy_blade/ninja/attack_self(mob/user)
	user.drop_from_inventory(src)

/obj/item/energy_blade/ninja/equipped(mob/user, slot)
	. = ..()
	check_loc()

/obj/item/energy_blade/ninja/dropped()
	. = ..()
	check_loc()

/obj/item/energy_blade/ninja/on_picked_up(mob/user)
	. = ..()
	check_loc()

/obj/item/energy_blade/ninja/Move()
	. = ..()
	if(.)
		check_loc()

/obj/item/energy_blade/ninja/proc/check_loc()
	if(!QDELETED(src) && (loc != creator || !(src in creator?.get_held_items())))
		qdel(src)
