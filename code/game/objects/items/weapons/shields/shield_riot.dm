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
		if((P.is_sharp() || P.has_edge()) && damage >= max_block)
			return 0
		if(istype(P, /obj/item/projectile/beam) && (!can_block_lasers || (P.armor_penetration >= max_block)))
			return 0
	return base_block_chance

/obj/item/shield/riot/attackby(obj/item/used_item, mob/user)
	if(istype(used_item, /obj/item/baton))
		if(cooldown < world.time - 25)
			user.visible_message("<span class='warning'>[user] bashes [src] with [used_item]!</span>")
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
		return TRUE
	else
		return ..()

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
