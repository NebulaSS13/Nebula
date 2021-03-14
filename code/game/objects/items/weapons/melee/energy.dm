/obj/item/energy_blade
	var/active = 0
	var/active_force
	var/active_throwforce
	var/active_icon
	var/lighting_color
	var/active_attack_verb
	var/inactive_attack_verb = list()
	sharp = 0
	edge = 0
	armor_penetration = 50
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_BLOOD

/obj/item/energy_blade/get_heat()
	. = max(..(), 3500)

/obj/item/energy_blade/get_autopsy_descriptors()
	. = ..()
	if(active)
		. += "made of pure energy"

/obj/item/energy_blade/can_embed()
	return FALSE

/obj/item/energy_blade/Initialize()
	. = ..()
	if(active)
		active = FALSE
		activate()
	else
		active = TRUE
		deactivate()

/obj/item/energy_blade/on_update_icon()
	. = ..()
	if(active)
		icon_state = active_icon
	else
		icon_state = initial(icon_state)

/obj/item/energy_blade/proc/activate(mob/living/user)
	if(active)
		return
	active = TRUE
	force = active_force
	throwforce = active_throwforce
	sharp = 1
	edge = 1
	w_class = max(w_class, ITEM_SIZE_NORMAL)
	slot_flags &= ~SLOT_POCKET
	attack_verb = active_attack_verb
	update_icon()
	if(user)
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")
	set_light(0.8, 1, 2, 4, lighting_color)

/obj/item/energy_blade/proc/deactivate(mob/living/user)
	if(!active)
		return
	active = FALSE
	force = initial(force)
	throwforce = initial(throwforce)
	sharp = initial(sharp)
	edge = initial(edge)
	w_class = initial(w_class)
	slot_flags = initial(slot_flags)
	attack_verb = inactive_attack_verb
	update_icon()
	if(user)
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, "<span class='notice'>\The [src] deactivates!</span>")
	set_light(0)

/obj/item/energy_blade/attack_self(mob/user)
	if(active)
		if((MUTATION_CLUMSY in user.mutations) && prob(50))
			user.visible_message( \
				SPAN_DANGER("\The [user] accidentally cuts \himself with \the [src]."), \
				SPAN_DANGER("You accidentally cut yourself with \the [src]."))
			if(isliving(user))
				var/mob/living/M = user
				M.take_organ_damage(5,5)
		deactivate(user)
	else
		activate(user)

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_hands()

	add_fingerprint(user)
	return

/obj/item/energy_blade/get_storage_cost()
	. = active ? ITEM_SIZE_NO_CONTAINER : ..()

/*
 * Energy Axe
 */
/obj/item/energy_blade/axe
	name = "energy axe"
	desc = "An energised battle axe."
	icon = 'icons/obj/items/weapon/e_axe.dmi'
	icon_state = "axe0"
	active_icon = "axe1"
	lighting_color = COLOR_SABER_AXE
	active_force = 60
	active_throwforce = 35
	force = 20
	throwforce = 10
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_BLOOD
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	origin_tech = "{'magnets':3,'combat':4}"
	active_attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	inactive_attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	sharp = 1
	edge = 1
	melee_accuracy_bonus = 15

/obj/item/energy_blade/axe/deactivate(mob/living/user)
	. = ..()
	to_chat(user, "<span class='notice'>\The [src] is de-energised. It's just a regular axe now.</span>")

/*
 * Energy Sword
 */
/obj/item/energy_blade/sword
	name = "energy sword"
	desc = "May the force be within you."
	icon = 'icons/obj/items/weapon/e_sword.dmi'
	icon_state = "sword0"
	active_force = 30
	active_throwforce = 20
	force = 3
	throwforce = 5
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_BLOOD
	origin_tech = "{'magnets':3,'esoteric':4}"
	sharp = 1
	edge = 1
	base_parry_chance = 50
	active_attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/blade1.ogg'
	var/blade_color

/obj/item/energy_blade/sword/Initialize()
	if(!blade_color)
		blade_color = pick("red","blue","green","purple")
	if(!active_icon)
		active_icon = "sword[blade_color]"
	if(!lighting_color)
		var/color_hex = list("red" = COLOR_SABER_RED,  "blue" = COLOR_SABER_BLUE, "green" = COLOR_SABER_GREEN, "purple" = COLOR_SABER_PURPLE)
		lighting_color = color_hex[blade_color]
	
	. = ..()

/obj/item/energy_blade/sword/green
	blade_color = "green"

/obj/item/energy_blade/sword/red
	blade_color = "red"

/obj/item/energy_blade/sword/red/activated/Initialize()
	. = ..()
	activate()

/obj/item/energy_blade/sword/blue
	blade_color = "blue"

/obj/item/energy_blade/sword/purple
	blade_color = "purple"

/obj/item/energy_blade/sword/dropped(var/mob/user)
	..()
	if(!istype(loc,/mob))
		deactivate(user)

/obj/item/energy_blade/sword/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(.)
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)

/obj/item/energy_blade/sword/get_parry_chance(mob/user)
	return active ? ..() : 0

/obj/item/energy_blade/sword/pirate
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon = 'icons/obj/items/weapon/e_cutlass.dmi'
	icon_state = "cutlass0"
	active_icon = "cutlass1"
	lighting_color = COLOR_SABER_CUTLASS

/obj/item/energy_blade/sword/pirate/activated/Initialize()
	. = ..()
	activate()
/*
 *Energy Blade
 */

/obj/item/energy_blade/blade
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon = 'icons/obj/items/weapon/energy_blade.dmi'
	icon_state = "blade"
	active_icon = "blade"	//It's all energy, so it should always be visible.
	lighting_color = COLOR_SABER_GREEN
	active_force = 40 //Normal attacks deal very high damage - about the same as wielded fire axe
	active = 1
	armor_penetration = 100
	sharp = 1
	edge = 1
	anchored = 1    // Never spawned outside of inventory, should be fine.
	active_throwforce = 1  //Throwing or dropping the item deletes it.
	throw_speed = 1
	throw_range = 1
	w_class = ITEM_SIZE_TINY //technically it's just energy or something, I dunno
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_BLOOD
	active_attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/blade1.ogg'
	var/mob/living/creator
	var/datum/effect/effect/system/spark_spread/spark_system

/obj/item/energy_blade/blade/Initialize()
	. = ..()
	spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	START_PROCESSING(SSobj, src)

/obj/item/energy_blade/blade/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/energy_blade/blade/is_special_cutting_tool(var/high_power)
	return TRUE

/obj/item/energy_blade/blade/get_storage_cost()
	return ITEM_SIZE_NO_CONTAINER

/obj/item/energy_blade/blade/attack_self(mob/user)
	user.drop_from_inventory(src)

/obj/item/energy_blade/blade/dropped()
	..()
	QDEL_IN(src, 0)

/obj/item/energy_blade/blade/Process()
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

/obj/item/energy_blade/machete
	name = "energy machete"
	desc = "A machete handle that extends out into a long, purple machete blade."
	icon = 'icons/obj/items/weapon/e_machete.dmi'
	icon_state = "machete_skrell_x"
	active_icon = "machete_skrell"
	active_force = 16		//In line with standard machetes at time of creation.
	active_throwforce = 17.25
	lighting_color = "#6600cc"
	force = 3
	throwforce = 1
	w_class = ITEM_SIZE_SMALL
	origin_tech = "{'magnets':3}"
	active_attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	hitsound = 'sound/weapons/blade1.ogg'