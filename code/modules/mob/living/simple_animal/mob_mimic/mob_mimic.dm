/mob/proc/get_armor_for_mimic()
	RETURN_TYPE(/list)
	return null

/mob/living/human/get_armor_for_mimic()
	return get_bodytype()?.natural_armour_values

/mob/living/simple_animal/get_armor_for_mimic()
	return natural_armor

/mob/living/exosuit/get_armor_for_mimic()
	if(body?.m_armour)
		var/datum/extension/armor/armor = get_extension(body.m_armour, /datum/extension/armor)
		return armor?.armor_values

/mob/proc/get_movement_delay_for_mimic()
	return 0

/mob/living/simple_animal/get_movement_delay_for_mimic()
	return base_movement_delay

/mob/living/human/get_movement_delay_for_mimic()
	return get_config_value(/decl/config/num/movement_run)

/mob/living/exosuit/get_movement_delay_for_mimic()
	return legs?.move_delay || /obj/item/mech_component/propulsion::move_delay

/mob/living/simple_animal/mob_mimic
	natural_weapon = null
	projectiletype = null
	faction        = null

	var/copy_health = TRUE
	var/mob/living/mimic_mob

	VAR_PRIVATE/static/alist/_mob_mimic_being_prepared      = alist()

	VAR_PRIVATE/static/alist/_mob_mimic_type_to_appearance  = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_synthetic   = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_overlays    = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_underlays   = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_eyes        = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_eye_color   = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_projectile  = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_melee       = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_health      = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_offset_x    = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_offset_y    = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_slowdown    = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_turn_sound  = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_step_sound  = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_bodytype    = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_bump_flags  = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_swap_flags  = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_push_flags  = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_always_swap = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_anchored    = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_armor       = alist()

/mob/living/simple_animal/mob_mimic/isSynthetic()
	return !!_mob_mimic_type_to_synthetic[mimic_mob]

/mob/living/simple_animal/mob_mimic/Initialize()
	if(!ispath(mimic_mob, /mob/living))
		return INITIALIZE_HINT_QDEL
	..()
	return INITIALIZE_HINT_LATELOAD

/mob/living/simple_animal/mob_mimic/LateInitialize()
	. = ..()
	if(_mob_mimic_type_to_appearance[mimic_mob])
		update_mob_values()
	else
		cache_and_apply_mimic()

/mob/living/simple_animal/mob_mimic/add_additional_visible_overlays(list/accumulator)
	SHOULD_CALL_PARENT(FALSE)

/mob/living/simple_animal/mob_mimic/set_current_mob_overlay(var/overlay_layer, var/image/overlay, var/redraw_mob = TRUE)
	SHOULD_CALL_PARENT(FALSE)

/mob/living/simple_animal/mob_mimic/set_current_mob_underlay(var/underlay_layer, var/image/underlay, var/redraw_mob = TRUE)
	SHOULD_CALL_PARENT(FALSE)

/mob/living/simple_animal/mob_mimic/update_equipment_overlay(var/slot, var/redraw_mob = TRUE)
	SHOULD_CALL_PARENT(FALSE)

/mob/living/simple_animal/mob_mimic/apply_visible_overlays()
	mob_overlays  = _mob_mimic_type_to_overlays[mimic_mob]
	mob_underlays = _mob_mimic_type_to_underlays[mimic_mob]
	return ..()

/mob/living/simple_animal/mob_mimic/get_eye_overlay()
	return _mob_mimic_type_to_eyes[mimic_mob]

/mob/living/simple_animal/mob_mimic/on_update_icon()
	SHOULD_CALL_PARENT(FALSE)
	if(!_mob_mimic_type_to_appearance[mimic_mob])
		cache_and_apply_mimic()
		return
	appearance = _mob_mimic_type_to_appearance[mimic_mob]
	eye_color  = _mob_mimic_type_to_eye_color[mimic_mob]
	cut_overlays()
	try_refresh_visible_overlays()

// These procs use get_effective_obj() so they can mimic mechs.
/mob/living/simple_animal/mob_mimic/proc/get_best_projectile(mob/living/mimic)
	for(var/obj/item/thing in mimic.get_held_items())
		var/obj/item/gun/gun = thing.get_effective_obj()
		var/proj = istype(gun) && gun.consume_next_projectile(mimic)
		if(proj)
			return proj

/mob/living/simple_animal/mob_mimic/proc/get_best_melee_weapon(mob/living/mimic)
	var/obj/item/strongest
	for(var/obj/item/thing in mimic.get_held_items())
		var/obj/item/weapon = thing.get_effective_obj()
		if(!strongest || weapon.get_base_attack_force() > strongest.get_base_attack_force())
			strongest = thing
	if(strongest)
		mimic.drop_from_inventory(strongest)
		strongest.forceMove(null)
		return strongest.get_effective_obj()

/mob/living/simple_animal/mob_mimic/proc/prepare_mimic(mob/living/mimic)
	return

/mob/living/simple_animal/mob_mimic/proc/handle_additional_mimic(mob/living/mimic)
	return

// For some reason mobs like humans do not fully apply their appearance by the time this proc runs without a delay.
// The delay is only applied the first time this type is created so should not be a big issue in practice.
// Atoms initialising in parallel will defer their update until hopefully the first one has completed.
/mob/living/simple_animal/mob_mimic/proc/cache_and_apply_mimic()
	if(_mob_mimic_being_prepared[mimic_mob])
		addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/simple_animal/mob_mimic, update_mob_values)), 10)
	else
		_mob_mimic_being_prepared[mimic_mob] = TRUE
		var/mob/living/mimic = new mimic_mob
		prepare_mimic(mimic)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/simple_animal/mob_mimic, process_mimic), mimic), 5)

/mob/living/simple_animal/mob_mimic/proc/process_mimic(mob/living/mimic)

	handle_additional_mimic(mimic)

	_mob_mimic_type_to_appearance[mimic_mob]  = mimic.appearance
	_mob_mimic_type_to_synthetic[mimic_mob]   = mimic.isSynthetic()
	_mob_mimic_type_to_overlays[mimic_mob]    = mimic.get_all_current_mob_overlays()?.Copy()
	_mob_mimic_type_to_underlays[mimic_mob]   = mimic.get_all_current_mob_underlays()?.Copy()
	_mob_mimic_type_to_eyes[mimic_mob]        = mimic.get_eye_overlay()
	_mob_mimic_type_to_eye_color[mimic_mob]   = mimic.get_eye_colour()
	_mob_mimic_type_to_health[mimic_mob]      = mimic.get_max_health()
	_mob_mimic_type_to_offset_x[mimic_mob]    = mimic.default_pixel_x
	_mob_mimic_type_to_offset_y[mimic_mob]    = mimic.default_pixel_y
	_mob_mimic_type_to_slowdown[mimic_mob]    = mimic.get_movement_delay_for_mimic()
	_mob_mimic_type_to_step_sound[mimic_mob]  = mimic.get_footstep_sound()
	_mob_mimic_type_to_turn_sound[mimic_mob]  = mimic.get_turn_sound()
	_mob_mimic_type_to_bump_flags[mimic_mob]  = mimic.mob_bump_flag
	_mob_mimic_type_to_swap_flags[mimic_mob]  = mimic.mob_swap_flags
	_mob_mimic_type_to_push_flags[mimic_mob]  = mimic.mob_push_flags
	_mob_mimic_type_to_always_swap[mimic_mob] = mimic.mob_always_swap
	_mob_mimic_type_to_anchored[mimic_mob]    = mimic.anchored
	_mob_mimic_type_to_armor[mimic_mob]       = mimic.get_armor_for_mimic()?.Copy()

	var/decl/bodytype/bodytype = mimic.get_bodytype()
	_mob_mimic_type_to_bodytype[mimic_mob] = bodytype?.simple_variant

	if(isnull(projectiletype))
		_mob_mimic_type_to_projectile[mimic_mob] = get_best_projectile(mimic)

	if(isnull(natural_weapon))
		var/obj/item/strongest = get_best_melee_weapon(mimic)
		if(strongest)
			_mob_mimic_type_to_melee[mimic_mob] = strongest

	qdel(mimic)
	update_mob_values()

/mob/living/simple_animal/mob_mimic/get_turn_sound()
	return _mob_mimic_type_to_turn_sound[mimic_mob] || ..()

/mob/living/simple_animal/mob_mimic/get_footstep_sound(turf/step_turf)
	return _mob_mimic_type_to_step_sound[mimic_mob] || ..()

/mob/living/simple_animal/mob_mimic/proc/update_mob_values()

	if(isnull(faction))
		faction = mimic_mob::faction

	if(_mob_mimic_type_to_bodytype[mimic_mob])
		set_bodytype(_mob_mimic_type_to_bodytype[mimic_mob])

	if(copy_health)
		max_health = _mob_mimic_type_to_health[mimic_mob]
		current_health = max_health
		update_health()

	default_pixel_x = _mob_mimic_type_to_offset_x[mimic_mob]
	default_pixel_y = _mob_mimic_type_to_offset_y[mimic_mob]
	reset_offsets()

	mob_bump_flag       = _mob_mimic_type_to_bump_flags[mimic_mob]
	mob_swap_flags      = _mob_mimic_type_to_swap_flags[mimic_mob]
	mob_push_flags      = _mob_mimic_type_to_push_flags[mimic_mob]
	mob_always_swap     = _mob_mimic_type_to_always_swap[mimic_mob]
	anchored            = _mob_mimic_type_to_anchored[mimic_mob]
	base_movement_delay = _mob_mimic_type_to_slowdown[mimic_mob]
	natural_armor       = _mob_mimic_type_to_armor[mimic_mob]

	var/obj/item/projectile/proj = _mob_mimic_type_to_projectile[mimic_mob]
	if(istype(proj))
		projectilesound = proj.fire_sound
		projectiletype  = proj.type

	var/obj/item/melee = _mob_mimic_type_to_melee[mimic_mob]
	if(melee && !istype(natural_weapon))
		natural_weapon = new(src)
		natural_weapon.show_in_message = TRUE
		natural_weapon.appearance = melee
		natural_weapon.set_base_attack_force(melee.get_base_attack_force())
		natural_weapon.atom_damage_type = melee.atom_damage_type
		UNLINT(natural_weapon.attack_verb = melee.attack_verb)

	update_icon()

/mob/living/simple_animal/mob_mimic/death(gibbed)

	if(gibbed)
		return ..()

	if(mimic_mob)
		var/mob/living/corpse = new mimic_mob(loc)
		corpse.death()
		corpse.take_overall_damage(brute_damage, burn_damage)
		if(gene_damage)
			corpse.adjustCloneLoss(gene_damage)

	forceMove(null)
	..() // Remove from mob lists, etc. in a way that isn't visible and leaves no debris
	qdel(src) // Clean ourselves up
