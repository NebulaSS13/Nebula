/mob/living/simple_animal/mob_mimic
	natural_weapon = null
	projectiletype = null
	faction        = null

	var/copy_health = TRUE

	var/mob/living/mimic_mob
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_appearance = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_synthetic  = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_overlays   = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_underlays  = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_eyes       = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_eye_color  = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_projectile = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_melee      = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_health     = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_offset_x   = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_offset_y   = alist()
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_bodytype   = alist()

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
		update_icon()
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

/mob/living/simple_animal/mob_mimic/proc/prepare_mimic(mob/living/mimic)
	return

// For some reason mobs like humans do not fully apply their appearance by the time this proc runs without sleep().
// The sleep is only applied the first time this type is created so should not be a big issue in practice.
/mob/living/simple_animal/mob_mimic/proc/cache_and_apply_mimic()
	set waitfor = FALSE
	var/mob/living/mimic = new mimic_mob
	prepare_mimic(mimic)
	sleep(5)
	_mob_mimic_type_to_appearance[mimic_mob] = mimic.appearance
	_mob_mimic_type_to_synthetic[mimic_mob]  = mimic.isSynthetic()
	_mob_mimic_type_to_overlays[mimic_mob]   = mimic.get_all_current_mob_overlays()?.Copy()
	_mob_mimic_type_to_underlays[mimic_mob]  = mimic.get_all_current_mob_underlays()?.Copy()
	_mob_mimic_type_to_eyes[mimic_mob]       = mimic.get_eye_overlay()
	_mob_mimic_type_to_eye_color[mimic_mob]  = mimic.get_eye_colour()
	_mob_mimic_type_to_health[mimic_mob]     = mimic.get_max_health()
	_mob_mimic_type_to_offset_x[mimic_mob]   = mimic.default_pixel_x
	_mob_mimic_type_to_offset_y[mimic_mob]   = mimic.default_pixel_y

	var/decl/bodytype/bodytype = mimic.get_bodytype()
	_mob_mimic_type_to_bodytype[mimic_mob] = bodytype?.simple_variant

	if(isnull(projectiletype))
		var/obj/item/gun/gun = locate() in mimic.get_held_items()
		_mob_mimic_type_to_projectile[mimic_mob] = gun?.consume_next_projectile(mimic)

	if(isnull(natural_weapon))
		var/obj/item/strongest
		for(var/obj/item/thing in mimic.get_held_items())
			if(!strongest || thing.get_base_attack_force() > strongest.get_base_attack_force())
				strongest = thing
		if(strongest)
			_mob_mimic_type_to_melee[mimic_mob] = strongest
			mimic.drop_from_inventory(strongest)

	qdel(mimic)
	update_mob_values()
	update_icon()

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
