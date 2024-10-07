/atom/proc/get_null_rod()
	for(var/atom/movable/thing as anything in get_contained_external_atoms())
		var/result = thing.get_null_rod()
		if(result)
			return result

/obj/item/nullrod/get_null_rod()
	return src

//////////////////////Scrying orb//////////////////////
/obj/item/scrying
	name = "scrying orb"
	desc = "An incandescent orb of otherworldly energy, staring into it gives you vision beyond mortal means."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bluespace"
	throw_speed = 3
	throw_range = 7
	atom_damage_type =  BURN
	_base_attack_force = 10
	hitsound = 'sound/magic/forcewall.ogg'
	max_health = ITEM_HEALTH_NO_DAMAGE

/obj/item/scrying/attack_self(mob/user)
	var/decl/special_role/wizard/wizards = GET_DECL(/decl/special_role/wizard)
	if((user.mind && !wizards.is_antagonist(user.mind)))
		to_chat(user, SPAN_NOTICE("You stare into the orb and see nothing but your own reflection."))
		return TRUE
	to_chat(user, "<span class='info'>You can see... everything!</span>") // This never actually happens.
	visible_message("<span class='danger'>[user] stares into [src], their eyes glazing over.</span>")
	user.teleop = user.ghostize(1)
	announce_ghost_joinleave(user.teleop, 1, "You feel that they used a powerful artifact to [pick("invade","disturb","disrupt","infest","taint","spoil","blight")] this place with their presence.")
	return TRUE

/////////////////////////Cursed Dice///////////////////////////
/obj/item/dice/d20/cursed
	desc = "A dice with twenty sides said to have an ill effect on those that are unlucky..."

/datum/trader/ship/toyshop/New()
	LAZYSET(possible_trading_items, /obj/item/dice/d20/cursed, TRADER_BLACKLIST)
	..()

/obj/item/dice/d20/cursed/attack_self(mob/user)
	..()
	if(isliving(user))
		var/mob/living/M = user
		if(icon_state == "[name][sides]")
			M.heal_damage(BRUTE, 30)
		else if(icon_state == "[name]1")
			M.take_damage(30)

/////////////////////////Magic rock///////////////////////////
/obj/item/magic_rock
	name = "magical rock"
	desc = "Legends say that this rock will unlock the true potential of anyone who touches it."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "magic rock"
	w_class = ITEM_SIZE_SMALL
	throw_speed = 1
	throw_range = 3
	_base_attack_force = 15
	material = /decl/material/solid/stone/basalt
	var/list/potentials = list(
		SPECIES_HUMAN = /obj/item/bag/cash/infinite
	)

/obj/item/magic_rock/attack_self(mob/user)

	var/species_name = user.get_species_name()
	if(!species_name)
		to_chat(user, SPAN_WARNING("\The [src] can do nothing for such a simple being."))
		return TRUE

	var/reward = potentials[species_name]
	if(ispath(reward, /decl/ability))
		if(user.has_ability(reward))
			to_chat(user, SPAN_WARNING("\The [src] can do nothing more for you."))
			return TRUE
		user.add_ability(reward)

	else if(ispath(reward, /obj/item))
		user.put_in_hands(new reward(get_turf(user)))

	else
		to_chat(user, SPAN_WARNING("\The [src] does not know what to make of you."))
		return TRUE

	to_chat(user, SPAN_NOTICE("\The [src] crumbles in your hands."))
	qdel(src)
	return TRUE
