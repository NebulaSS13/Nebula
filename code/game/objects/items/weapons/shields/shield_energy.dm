/*
 * Energy Shield
 */

/obj/item/shield/energy
	name = "energy combat shield"
	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
	icon = 'icons/obj/items/shield/e_shield.dmi'
	icon_state = "eshield0" // eshield1 for expanded
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	throw_speed = 1
	throw_range = 4
	w_class = ITEM_SIZE_SMALL
	origin_tech = @'{"materials":4,"magnets":3,"esoteric":4}'
	attack_verb = list("shoved", "bashed")
	material = /decl/material/solid/metal/titanium
	matter = list(
		/decl/material/solid/fiberglass       = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/gold       = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/silicon          = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE,
	)
	_base_attack_force = 3
	var/active = 0
	var/shield_light_color = "#006aff"

/obj/item/shield/energy/Initialize()
	set_extension(src, /datum/extension/base_icon_state, copytext(initial(icon_state), 1, length(initial(icon_state))))
	. = ..()
	update_icon()

/obj/item/shield/energy/handle_shield(mob/user)
	if(!active)
		return 0 //turn it on first!
	. = ..()

	if(.)
		spark_at(user.loc, amount=5)
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)

/obj/item/shield/energy/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		if(((P.is_sharp() || P.has_edge()) && damage > 10) || istype(P, /obj/item/projectile/beam))
			return (base_block_chance - round(damage / 2.5)) //block bullets and beams using the old block chance
	return base_block_chance

/obj/item/shield/energy/attack_self(mob/user)
	if(user.has_genetic_condition(GENE_COND_CLUMSY) && prob(50))
		to_chat(user, SPAN_DANGER("You beat yourself in the head with [src]."))
		if(isliving(user))
			var/mob/living/M = user
			M.take_organ_damage(5, 0)
	active = !active
	if (active)
		set_base_attack_force(10)
		update_icon()
		w_class = ITEM_SIZE_HUGE
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("\The [src] is now active."))

	else
		set_base_attack_force(3)
		update_icon()
		w_class = ITEM_SIZE_SMALL
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("\The [src] can now be concealed."))

	if(ishuman(user))
		var/mob/living/human/H = user
		H.update_inhand_overlays()

	add_fingerprint(user)
	return

/obj/item/shield/energy/on_update_icon()
	. = ..()
	var/datum/extension/base_icon_state/base_name = get_extension(src, /datum/extension/base_icon_state)
	icon_state = "[base_name.base_icon_state][active]" 	//Replace 0 with current state
	if(active)
		set_light(1.5, 1.5, shield_light_color)
	else
		set_light(0)
