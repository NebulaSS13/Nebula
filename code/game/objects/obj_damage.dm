///Returns whether the item can take damages or if its invulnerable
/obj/proc/can_take_damage()
	return simulated && health != OBJ_HEALTH_NO_DAMAGE && max_health != OBJ_HEALTH_NO_DAMAGE

///Return a multiplier to apply to the material integrity when setting the health of the obj from the material
/obj/proc/get_material_health_modifier()
	return 1

///Basic damage handling for items. Returns the amount of damage taken after armor if the item was damaged.
/obj/take_damage(damage, damage_type = BRUTE, damage_flags = 0, inflicter = null, armor_pen = 0, target_zone = null, quiet = FALSE)
	if(!can_take_damage()) // This object does not take damage.
		return 0 //Must return a number
	if(damage < 0)
		CRASH("Item '[type]' take_damage proc was called with negative damage.") //Negative damage are an implementation issue.
	
	//Apply armor
	var/datum/extension/armor/A = get_extension(src, /datum/extension/armor)
	if(A)
		var/list/dam_after_armor = A.apply_damage_modifications(damage, damage_type, damage_flags, null, armor_pen, TRUE)
		damage       = dam_after_armor[1]
		damage_type  = dam_after_armor[2]
		damage_flags = dam_after_armor[3]
		armor_pen    = dam_after_armor[5]

	if(damage <= 0)
		return 0 //must return a number

	//Apply damage
	health = clamp(health - damage, 0, max_health)
	check_health(damage, damage_type, damage_flags)
	return damage

///Give back some health to the object
/obj/proc/heal(var/amount)
	if(!can_take_damage())
		return 0 //Healed 0 damage
	//Figure out how much we actually healed
	. = health
	health = clamp(health + amount, 0, max_health)
	. = health - .
	check_health()

///Returns a text string to describe the current damage level of the item, or null if non-applicable.
/obj/proc/get_examined_damage_string(var/health_ratio)
	if(!can_take_damage())
		return
	if(health_ratio >= 1)
		return SPAN_NOTICE("It looks fully intact.")
	else if(health_ratio > 0.75)
		return SPAN_NOTICE("It has a few cracks.")
	else if(health_ratio > 0.5)
		return SPAN_WARNING("It looks slightly damaged.")
	else if(health_ratio > 0.25)
		return SPAN_WARNING("It looks moderately damaged.")
	else
		return SPAN_DANGER("It looks heavily damaged.")

///Updates the state of the obj from the current value of its health
/obj/proc/check_health(var/lastdamage = null, var/lastdamtype = null, var/lastdamflags = 0)
	//The base implementation only checks if we hit 0 health and destroys us
	if(health > 0 || !can_take_damage())
		return //If invincible, or if we're not dead yet, skip
	
	//Call a different proc depending on what was the last type of damage inflicted
	if(lastdamtype == BRUTE && material?.is_brittle())
		shatter()
	else if(lastdamtype == BURN)
		melt()
	else 
		physically_destroyed()

///Setup and populate the armor extensions from the armor list in the obj definition.
/obj/proc/update_armor()
	if(!length(armor_resistances))
		return
	for(var/type in armor_resistances)
		if(armor_resistances[type]) // Don't set it if it gives no armor anyway, which is many items.
			set_extension(src, armor_type, armor_resistances, armor_degradation_speed)
			break

/obj/acid_act()
	if(QDELETED(src))
		return TRUE
	if(throwing || !can_take_damage())
		return
	. = ..()

/obj/lava_act()
	if(QDELETED(src))
		return TRUE
	if(throwing || !can_take_damage())
		return
	. = ..()

/obj/explosion_act(severity)
	if(QDELETED(src) || !can_take_damage())
		return
	. = ..()
	take_damage(explosion_severity_damage(severity), BURN, DAM_EXPLODE | DAM_DISPERSED, "explosion", 0, null, TRUE)

/obj/bullet_act(obj/item/projectile/P, def_zone)
	var/expected = P.get_structure_damage() //#TODO: Maybe a more universal way to get projectile damage would be nice?
	var/taken = 0
	if(can_take_damage())
		taken = take_damage(expected, P.damtype, P.damage_flags(), P, P.armor_penetration)
	
	var/blocked = (expected - taken) * 100 / expected
	P.on_hit(src, blocked, def_zone)

	//#TODO: It might be interesting at one point to figure penetration via material. But the physics for that is a bit out of my league rn.
	//If the projectile didn't get blocked at all, and inflicted damage, let it through. Otherwise return how much damage was blocked.
	return (blocked <= 0 && taken > 0)? PROJECTILE_CONTINUE : blocked 

/obj/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	. = ..()
	var/dmg = 0
	if(istype(material) && material.ignition_point && (exposed_temperature >= material.ignition_point))
		dmg = round(dmg * material.combustion_effect(get_turf(src), temperature))
	if(dmg)
		take_damage(dmg, BURN, DAM_DISPERSED, "fire", 0, null, TRUE)

/obj/melt()
	for(var/mat in matter)
		var/decl/material/M = GET_DECL(mat)
		if(!M)
			log_warning("[src] ([type]) has a bad material path in its matter var.")
			continue
		var/turf/T = get_turf(src)
		//TODO: Would be great to just call a proc to do that, like "Material.place_burn_product(loc, amount_matter)" so no need to care if its a gas or something else
		var/datum/gas_mixture/environment = T?.return_air()
		if(M.burn_product)
			environment.adjust_gas(M.burn_product, M.fuel_value * (matter[mat] / SHEET_MATERIAL_AMOUNT))

	new /obj/effect/decal/cleanable/molten_item(src)
	qdel(src)

///Handles shattering the object after it took enough brute damage
/obj/proc/shatter(var/consumed = FALSE)
	var/turf/T = get_turf(src)
	T?.visible_message(SPAN_DANGER("\The [src] [material ? material.destruction_desc : "shatters"]!"))
	playsound(src, "shatter", 70, 1)
	if(!consumed && material && w_class > ITEM_SIZE_SMALL && T)
		material.place_shards(T)
	dump_contents()
	qdel(src)

/obj/proc/explosion_severity_damage(var/severity)
	var/mult = explosion_severity_damage_multiplier()
	return (mult * (4 - severity)) + (severity != 1? rand(-(mult / severity), (mult / severity)) : 0 )

/obj/proc/explosion_severity_damage_multiplier()
	return CEILING(max_health / 3)

/obj/proc/damage_flags()
	. = 0
	if(has_edge(src))
		. |= DAM_EDGE
	if(is_sharp(src))
		. |= DAM_SHARP
		if(damtype == BURN)
			. |= DAM_LASER

/obj/can_burn()
	return simulated

/obj/proc/can_embed()
	return is_sharp(src)

/obj/hitby(atom/movable/AM, var/datum/thrownthing/TT)
	. = ..()
	if(hitsound)
		var/hit_volume = 75
		if(isobj(AM))
			var/obj/O = AM
			hit_volume = O.get_throw_impact_sound_volume()
		playsound(loc, hitsound, hit_volume, TRUE)

/obj/throw_impact(atom/movable/hit_atom, datum/thrownthing/TT)
	. = ..() //throw_impact() calls hitby() on the target
	if(.)
		//Apply damge in hitby to avoid having to typecast
		hit_atom.take_damage(throwforce, damtype, damage_flags(), TT.thrower, armor_penetration)

/obj/bash(obj/item/W, mob/user)
	. = ..()
	if(!.)
		return
	if(hitsound)
		playsound(loc, hitsound, 75, TRUE)
	take_damage(W.force, W.damtype, W.damage_flags(), user, W.armor_penetration)

///Returns the volume at which the hitsound should play assuming the src object is being thrown
/obj/proc/get_impact_sound_volume()
	if(throwforce && w_class)
		return clamp((throwforce + w_class) * 5, 30, 100)// Add the item's throwforce to its weight class and multiply by 5, then clamp the value between 30 and 100
	else if(w_class)
		return clamp(w_class * 8, 20, 100) // Multiply the item's weight class by 8, then clamp the value between 20 and 100
	else
		return 0