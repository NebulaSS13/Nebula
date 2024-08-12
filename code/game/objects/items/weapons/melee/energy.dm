/obj/item/energy_blade

	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon = 'icons/obj/items/weapon/energy_blade.dmi'

	icon_state = ICON_STATE_WORLD
	atom_flags = ATOM_FLAG_NO_BLOOD
	item_flags = ITEM_FLAG_IS_WEAPON
	w_class = ITEM_SIZE_SMALL
	hitsound = 'sound/weapons/genhit.ogg'

	force =             3 // bonk
	throwforce =        3
	throw_speed =       1
	throw_range =       5
	sharp =             0
	edge =              0
	armor_penetration = 0

	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic          = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/glass            = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/copper     = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/plutonium  = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_REINFORCEMENT,
	)

	var/lighting_color = COLOR_SABER_GREEN

	var/active = FALSE
	var/active_parry_chance = 15
	var/active_force =        30
	var/active_throwforce =   20
	var/active_armour_pen =   50
	var/active_edge =         1
	var/active_sharp =        1
	var/active_descriptor =   "energized"
	var/active_hitsound =     'sound/weapons/blade1.ogg'
	var/active_sound =        'sound/weapons/saberon.ogg'
	var/inactive_sound =      'sound/weapons/saberoff.ogg'

	attack_verb =                   list("hit")
	var/list/active_attack_verb	=   list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	var/list/inactive_attack_verb = list("hit")

/obj/item/energy_blade/get_max_weapon_value()
	return active_force

/obj/item/energy_blade/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	. = ..()
	if(.)
		spark_at(src, amount = 5, holder = src)
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)

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
		obj_flags &= ~OBJ_FLAG_NO_STORAGE
		toggle_active(ismob(loc) && loc)
	if(active_sharp || active_edge)
		set_extension(src, /datum/extension/tool, list(TOOL_SCALPEL = TOOL_QUALITY_WORST))

/obj/item/energy_blade/get_tool_quality(archetype)
	if(archetype == TOOL_SCALPEL && !active)
		return 0
	return ..()

/obj/item/energy_blade/proc/toggle_active(var/mob/user)

	active = !active
	if(active)

		obj_flags |= OBJ_FLAG_NO_STORAGE
		force =             active_force
		throwforce =        active_throwforce
		sharp =             active_sharp
		edge =              active_edge
		base_parry_chance = active_parry_chance
		armor_penetration = active_armour_pen
		hitsound =          active_hitsound
		attack_verb =       active_attack_verb

		w_class = max(w_class, ITEM_SIZE_NORMAL)
		slot_flags &= ~SLOT_POCKET
		if(active_sound)
			playsound(loc, active_sound, 50, 1)

	else

		obj_flags &= ~OBJ_FLAG_NO_STORAGE
		force =             initial(force)
		throwforce =        initial(throwforce)
		sharp =             initial(sharp)
		edge =              initial(edge)
		base_parry_chance = initial(base_parry_chance)
		armor_penetration = initial(armor_penetration)
		hitsound =          initial(hitsound)
		attack_verb =       inactive_attack_verb

		w_class = initial(w_class)
		slot_flags = initial(slot_flags)
		if(inactive_sound)
			playsound(loc, inactive_sound, 50, 1)

	if(lighting_color)
		if(active)
			set_light(2, 0.8, lighting_color)
		else
			set_light(0)

	update_icon()
	update_held_icon()

	if(user && active_descriptor)
		to_chat(user, SPAN_NOTICE("\The [src] is [active ? "now" : "no longer"] [active_descriptor]."))

/obj/item/energy_blade/dropped(mob/user)
	. = ..()
	if(active)
		update_icon()

/obj/item/energy_blade/equipped(mob/user, slot)
	. = ..()
	if(active)
		update_icon()

/obj/item/energy_blade/attack_self(mob/user)
	if(active)
		if(user.has_genetic_condition(GENE_COND_CLUMSY) && prob(50))
			var/decl/pronouns/G = user.get_pronouns()
			user.visible_message( \
				SPAN_DANGER("\The [user] accidentally cuts [G.self] with \the [src]."), \
				SPAN_DANGER("You accidentally cut yourself with \the [src]."))
			if(isliving(user))
				var/mob/living/M = user
				M.take_organ_damage(5,5)
	toggle_active(user)
	add_fingerprint(user)
	return TRUE

/obj/item/energy_blade/on_update_icon()
	. = ..()
	z_flags &= ~ZMM_MANGLE_PLANES
	icon_state = get_world_inventory_state()
	if(active && check_state_in_icon("[icon_state]-extended", icon))
		if(plane == HUD_PLANE)
			add_overlay(image(icon, "[icon_state]-extended"))
		else
			add_overlay(emissive_overlay(icon, "[icon_state]-extended"))
			z_flags |= ZMM_MANGLE_PLANES

/obj/item/energy_blade/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && active && check_state_in_icon("[overlay.icon_state]-extended", overlay.icon))
		overlay.overlays += emissive_overlay(overlay.icon, "[overlay.icon_state]-extended")
	. = ..()
