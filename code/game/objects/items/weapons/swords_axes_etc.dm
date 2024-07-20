/* Weapons
 * Contains:
 *		Sword
 *		Classic Baton
 */

/*
 * Classic Baton
 */
/obj/item/classic_baton
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon = 'icons/obj/items/weapon/old_baton.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY
	item_flags = ITEM_FLAG_IS_WEAPON
	material = /decl/material/solid/organic/wood
	_base_attack_force = 10

/obj/item/classic_baton/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if (user.has_genetic_condition(GENE_COND_CLUMSY) && prob(50))
		var/force = get_attack_force(user)
		to_chat(user, SPAN_WARNING("You club yourself over the head."))
		SET_STATUS_MAX(user, STAT_WEAK, (3 * force))
		if(ishuman(user))
			var/mob/living/human/H = user
			H.apply_damage(2*force, BRUTE, BP_HEAD)
		else
			user.take_organ_damage(2*force)
		return TRUE
	return ..()

//Telescopic baton
/obj/item/telebaton
	name = "telescopic baton"
	desc = "A compact yet rebalanced personal defense weapon. Can be concealed when folded."
	icon = 'icons/obj/items/weapon/telebaton.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_SMALL
	_base_attack_force = 3
	item_flags = ITEM_FLAG_IS_WEAPON
	material = /decl/material/solid/metal/aluminium
	var/on = 0

/obj/item/telebaton/attack_self(mob/user)
	on = !on
	if(on)
		user.visible_message("<span class='warning'>With a flick of their wrist, [user] extends their telescopic baton.</span>",\
		"<span class='warning'>You extend the baton.</span>",\
		"You hear an ominous click.")
		w_class = ITEM_SIZE_NORMAL
		set_base_attack_force(15) //quite robust
		attack_verb = list("smacked", "struck", "slapped")
	else
		user.visible_message("<span class='notice'>\The [user] collapses their telescopic baton.</span>",\
		"<span class='notice'>You collapse the baton.</span>",\
		"You hear a click.")
		w_class = ITEM_SIZE_SMALL
		set_base_attack_force(3) //not so robust now
		attack_verb = list("hit", "punched")

	playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
	add_fingerprint(user)
	update_icon()
	update_held_icon()

/obj/item/telebaton/on_update_icon()
	if(length(blood_DNA))
		generate_blood_overlay(TRUE) // Force recheck.
	. = ..()
	if(on)
		icon = 'icons/obj/items/weapon/telebaton_extended.dmi'
	else
		icon = 'icons/obj/items/weapon/telebaton.dmi'

/obj/item/telebaton/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(on && user.has_genetic_condition(GENE_COND_CLUMSY) && prob(50))
		var/force = get_attack_force(user)
		to_chat(user, SPAN_DANGER("You club yourself over the head."))
		SET_STATUS_MAX(user, STAT_WEAK, (3 * force))
		if(ishuman(user))
			var/mob/living/human/H = user
			H.apply_damage(2*force, BRUTE, BP_HEAD)
		else
			user.take_organ_damage(2*force)
		return TRUE
	return ..()
