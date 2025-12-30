// Bladed weapon with composite material makeup class.
/obj/item/bladed
	icon_state                        = "preview"
	abstract_type                     = /obj/item/bladed
	material_alteration               = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	origin_tech                       = @'{"materials":1,"combat":1}'
	attack_verb                       = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	obj_flags                         = OBJ_FLAG_CONDUCTIBLE
	sharp                             = TRUE
	edge                              = TRUE
	item_flags                        = ITEM_FLAG_IS_WEAPON
	pickup_sound                      = 'sound/foley/knife1.ogg'
	drop_sound                        = 'sound/foley/knifedrop3.ogg'
	hitsound                          = 'sound/weapons/bladeslice.ogg'
	slot_flags                        = SLOT_LOWER_BODY
	material                          = /decl/material/solid/metal/steel
	_base_attack_force                = 10

	var/decl/material/hilt_material   = /decl/material/solid/organic/wood/oak
	var/decl/material/guard_material  = /decl/material/solid/organic/wood/oak
	var/decl/material/pommel_material = /decl/material/solid/organic/wood/oak

	/// Cache var for blade material shine calculation.
	var/tmp/shine

/obj/item/bladed/Initialize(ml, material_key, _hilt_mat, _guard_mat, _pommel_mat)

	if(_hilt_mat)
		hilt_material = _hilt_mat
	if(_guard_mat)
		guard_material = _guard_mat
	if(_pommel_mat)
		pommel_material = _pommel_mat

	if(ispath(hilt_material))
		hilt_material = GET_DECL(hilt_material)
	if(ispath(guard_material))
		guard_material = GET_DECL(guard_material)
	if(ispath(pommel_material))
		pommel_material = GET_DECL(pommel_material)

	LAZYINITLIST(matter)
	if(istype(hilt_material))
		matter[hilt_material.type] += MATTER_AMOUNT_SECONDARY
	else
		hilt_material = null
	if(istype(guard_material))
		matter[guard_material.type] += MATTER_AMOUNT_REINFORCEMENT
	else
		guard_material = null
	if(istype(pommel_material))
		matter[guard_material.type] += MATTER_AMOUNT_TRACE
	else
		pommel_material = null
	UNSETEMPTY(matter)

	. = ..()

	if(!has_extension(src, /datum/extension/tool))
		// If this were an `/obj/item/tool` subtype, we could get away with just doing this in `get_initial_tool_qualities()`.
		var/list/initial_tool_qualities = list(
			TOOL_SCALPEL =     TOOL_QUALITY_MEDIOCRE,
			TOOL_SAW =         TOOL_QUALITY_BAD,
			TOOL_RETRACTOR =   TOOL_QUALITY_BAD,
			TOOL_SCREWDRIVER = TOOL_QUALITY_BAD,
		)
		switch(w_class)
			if(0 to ITEM_SIZE_SMALL)
				pass()
			if(ITEM_SIZE_SMALL to ITEM_SIZE_NORMAL) // Since ITEM_SIZE_SMALL was already covered, this is just ITEM_SIZE_NORMAL.
				initial_tool_qualities[TOOL_HATCHET] = TOOL_QUALITY_WORST
			if(ITEM_SIZE_NORMAL to ITEM_SIZE_LARGE)
				initial_tool_qualities[TOOL_HATCHET] = TOOL_QUALITY_BAD
			else
				initial_tool_qualities[TOOL_HATCHET] = TOOL_QUALITY_MEDIOCRE
		set_extension(src, /datum/extension/tool/variable/simple, initial_tool_qualities)

	shine = istype(material) ? clamp((material.reflectiveness * 0.01) * 255, 10, (0.6 * rgb2num(material.color, COLORSPACE_HSV)[3])) : null
	icon_state = ICON_STATE_WORLD
	on_update_icon()

/obj/item/bladed/proc/update_base_icon_state()
	icon_state = get_world_inventory_state()

/obj/item/bladed/proc/get_hilt_color()
	return istype(hilt_material) ? hilt_material.color : COLOR_WHITE

/obj/item/bladed/proc/get_guard_color()
	return istype(guard_material) ? guard_material.color : COLOR_WHITE

/obj/item/bladed/proc/get_pommel_color()
	return istype(pommel_material) ? pommel_material.color : COLOR_WHITE

/obj/item/bladed/on_update_icon()
	. = ..()
	update_base_icon_state()
	if(istype(hilt_material))
		var/check_state = "[icon_state]-hilt"
		if(check_state_in_icon(check_state, icon))
			add_overlay(overlay_image(icon, check_state, get_hilt_color(), RESET_COLOR))
	if(istype(guard_material))
		var/check_state = "[icon_state]-guard"
		if(check_state_in_icon(check_state, icon))
			add_overlay(overlay_image(icon, check_state, get_guard_color(), RESET_COLOR))
	if(istype(pommel_material))
		var/check_state = "[icon_state]-pommel"
		if(check_state_in_icon(check_state, icon))
			add_overlay(overlay_image(icon, check_state, get_pommel_color(), RESET_COLOR))
	if(shine)
		var/check_state = "[icon_state]-shine"
		if(check_state_in_icon(check_state, icon))
			var/image/I = overlay_image(icon, check_state, COLOR_WHITE, (RESET_COLOR | RESET_ALPHA))
			I.alpha = shine
			add_overlay(I)
	update_held_icon()

// We handle this in the post-proc so wielding status is updated for polearms/broadswords/etc
/obj/item/bladed/apply_additional_mob_overlays(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay)
		if(istype(hilt_material))
			var/check_state = "[overlay.icon_state]-hilt"
			if(check_state_in_icon(check_state, overlay.icon))
				overlay.overlays += overlay_image(overlay.icon, check_state, get_hilt_color(), RESET_COLOR)
		if(istype(guard_material))
			var/check_state = "[overlay.icon_state]-guard"
			if(check_state_in_icon(check_state, overlay.icon))
				overlay.overlays += overlay_image(overlay.icon, check_state, get_guard_color(), RESET_COLOR)
		if(istype(pommel_material))
			var/check_state = "[overlay.icon_state]-pommel"
			if(check_state_in_icon(check_state, overlay.icon))
				overlay.overlays += overlay_image(overlay.icon, check_state, get_pommel_color(), RESET_COLOR)
		if(shine)
			var/check_state = "[overlay.icon_state]-shine"
			if(check_state_in_icon(check_state, overlay.icon))
				var/image/I = overlay_image(overlay.icon, check_state, COLOR_WHITE, (RESET_COLOR | RESET_ALPHA))
				I.alpha = shine
				overlay.overlays += I
	return ..()
