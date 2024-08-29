//** Shield Helpers
//These are shared by various items that have shield-like behaviour

//bad_arc is the ABSOLUTE arc of directions from which we cannot block. If you want to fix it to e.g. the user's facing you will need to rotate the dirs yourself.
/proc/check_shield_arc(mob/user, var/bad_arc, atom/damage_source = null, mob/attacker = null)
	//check attack direction
	var/attack_dir = 0 //direction from the user to the source of the attack
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		attack_dir = get_dir(get_turf(user), P.starting)
	else if(attacker)
		attack_dir = get_dir(get_turf(user), get_turf(attacker))
	else if(damage_source)
		attack_dir = get_dir(get_turf(user), get_turf(damage_source))

	if(!(attack_dir && (attack_dir & bad_arc)))
		return 1
	return 0

/proc/default_parry_check(mob/user, mob/attacker, atom/damage_source)
	//parry only melee attacks
	if(istype(damage_source, /obj/item/projectile) || (attacker && get_dist(user, attacker) > 1) || user.incapacitated())
		return 0

	//block as long as they are not directly behind us
	var/bad_arc = user.dir && global.reverse_dir[user.dir] //arc of directions from which we cannot block
	if(!check_shield_arc(user, bad_arc, damage_source, attacker))
		return 0

	return 1

/obj/item/shield
	name = "abstract shield"
	abstract_type = /obj/item/shield
	var/base_block_chance = 60

/obj/item/shield/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(user.incapacitated())
		return 0
	//block as long as they are not directly behind us
	var/bad_arc = user.dir && global.reverse_dir[user.dir] //arc of directions from which we cannot block
	if(check_shield_arc(user, bad_arc, damage_source, attacker))
		var/block_chance = get_block_chance(user, damage, damage_source, attacker)
		if(attacker)
			block_chance = max(0, block_chance - 10 * attacker.get_skill_difference(SKILL_COMBAT, user))
		if(prob(block_chance))
			user.visible_message("<span class='danger'>\The [user] blocks [attack_text] with \the [src]!</span>")
			if(max_health != ITEM_HEALTH_NO_DAMAGE)
				take_damage(damage)
			return 1
	return 0

/obj/item/shield/proc/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	return base_block_chance

/obj/item/shield/riot
	name = "riot shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon = 'icons/obj/items/shield/riot.dmi'
	icon_state = ICON_STATE_WORLD
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	throw_speed = 1
	throw_range = 4
	w_class = ITEM_SIZE_HUGE
	origin_tech = @'{"materials":2}'
	material = /decl/material/solid/fiberglass
	matter = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT)
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time
	var/max_block = 15
	var/can_block_lasers = FALSE

/obj/item/shield/riot/handle_shield(mob/user)
	. = ..()
	if(.) playsound(user.loc, 'sound/weapons/Genhit.ogg', 50, 1)

/obj/item/shield/riot/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		//plastic shields do not stop bullets or lasers, even in space. Will block beanbags, rubber bullets, and stunshots just fine though.
		if(is_sharp(P) && damage >= max_block)
			return 0
		if(istype(P, /obj/item/projectile/beam) && (!can_block_lasers || (P.armor_penetration >= max_block)))
			return 0
	return base_block_chance

/obj/item/shield/riot/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/baton))
		if(cooldown < world.time - 25)
			user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
	else
		..()

/obj/item/shield/riot/metal
	name = "plasteel combat shield"
	icon = 'icons/obj/items/shield/metal.dmi'
	icon_state = ICON_STATE_WORLD
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	throw_range = 3
	w_class = ITEM_SIZE_HUGE
	material = /decl/material/solid/metal/plasteel
	max_block = 50
	can_block_lasers = TRUE
	slowdown_general = 1.5
	_base_attack_force = 6

/obj/item/shield/riot/metal/security //A cosmetic difference.
	icon = 'icons/obj/items/shield/metal_security.dmi'

/obj/item/shield/buckler
	name = "buckler"
	desc = "A wooden buckler used to block sharp things from entering your body back in the day."
	icon = 'icons/obj/items/shield/buckler.dmi'
	icon_state = "buckler"
	slot_flags = SLOT_BACK
	base_block_chance = 60
	throw_speed = 10
	throw_range = 20
	w_class = ITEM_SIZE_HUGE
	origin_tech = @'{"materials":1}'
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/organic/wood = MATTER_AMOUNT_REINFORCEMENT)
	attack_verb = list("shoved", "bashed")
	_base_attack_force = 8
	max_health = 250

/obj/item/shield/buckler/handle_shield(mob/user)
	. = ..()
	if(.) playsound(user.loc, 'sound/weapons/Genhit.ogg', 50, 1)

/obj/item/shield/buckler/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/item/projectile/bullet))
		return 0 //No blocking bullets, I'm afraid.
	return base_block_chance

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
		if((is_sharp(P) && damage > 10) || istype(P, /obj/item/projectile/beam))
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
		w_class = ITEM_SIZE_TINY
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