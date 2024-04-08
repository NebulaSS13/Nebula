/obj/item/tool
	icon_state          = ICON_STATE_WORLD
	obj_flags           = OBJ_FLAG_CONDUCTIBLE
	slot_flags          = SLOT_LOWER_BODY
	force               = 10
	throwforce          = 4
	w_class             = ITEM_SIZE_HUGE
	origin_tech         = @'{"materials":1,"engineering":1}'
	attack_verb         = list("hit", "pierced", "sliced", "attacked")
	sharp               = 0
	abstract_type       = /obj/item/tool
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC

	/// Material is used for the head, handle is handle(d) below.
	material = /decl/material/solid/metal/steel
	/// Material used for our handle. Set to base material if null.
	var/decl/material/handle_material

/obj/item/tool/examine(mob/user)
	. = ..()
	to_chat(user, "The head is made of [material.use_name] and the handle is made of [handle_material.use_name].")

/obj/item/tool/Initialize(ml, material_key, _handle_material, override_tool_qualities, override_tool_properties)

	// Find out handle material if supplied, default to base material otherwise.
	if(ispath(_handle_material, /decl/material))
		handle_material = GET_DECL(_handle_material)
	else if(istype(_handle_material, /decl/material))
		handle_material = _handle_material
	else if(ispath(handle_material))
		handle_material = GET_DECL(handle_material)
	else if(!istype(handle_material, /decl/material))
		if(istype(material, /decl/material))
			handle_material = material
		else if(ispath(material, /decl/material))
			handle_material = GET_DECL(material)
		else
			handle_material = null

	// Update qualities.
	var/list/tool_qualities = override_tool_qualities || get_initial_tool_qualities()
	if(length(tool_qualities))
		var/datum/extension/tool/tool_data
		if(length(tool_qualities) == 1)
			tool_data = get_or_create_extension(src, /datum/extension/tool, tool_qualities)
		else
			tool_data = get_or_create_extension(src, /datum/extension/tool/variable/simple, tool_qualities)

		// Update properties.
		if(tool_data && IS_PICK(src))
			var/list/tool_properties = override_tool_properties || get_initial_tool_properties()
			for(var/tool_archetype in tool_properties)
				var/list/archetype_properties = tool_properties[tool_archetype]
				for(var/tool_property in archetype_properties)
					tool_data.set_tool_property(tool_archetype, tool_property, archetype_properties[tool_property])

	. = ..()

	if(!handle_material)
		handle_material = material
		update_icon()

/obj/item/tool/create_matter()
	if(handle_material)
		if(material == handle_material)
			LAZYSET(matter, material.type, (MATTER_AMOUNT_PRIMARY + MATTER_AMOUNT_REINFORCEMENT))
		else
			LAZYSET(matter, handle_material.type, MATTER_AMOUNT_REINFORCEMENT)
	return ..()

/obj/item/tool/proc/get_initial_tool_properties()
	return list()

/obj/item/tool/proc/get_initial_tool_qualities()
	return list()

/obj/item/tool/proc/get_handle_color()
	if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
		return handle_material?.color || material?.color || COLOR_WHITE
	return initial(color)

/obj/item/tool/on_update_icon()
	. = ..()
	var/handle_color = get_handle_color()
	if(!isnull(handle_color)) // return COLOR_WHITE instead of null as a way of opting into this behavior
		var/handle_state = "[icon_state]-handle"
		if(check_state_in_icon(handle_state, icon))
			var/image/I = image(icon, handle_state)
			I.color = handle_color
			if(handle_material)
				I.alpha = 100 + handle_material.opacity * 255
				I.appearance_flags |= RESET_ALPHA
			I.appearance_flags |= RESET_COLOR
			add_overlay(I)

/obj/item/tool/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay)
		var/handle_color = get_handle_color()
		if(!isnull(handle_color))
			var/handle_state = "[overlay.icon_state]-handle"
			if(check_state_in_icon(handle_state, overlay.icon))
				var/image/handle = image(overlay.icon, handle_state)
				handle.color = handle_color
				if(handle_material)
					handle.alpha = 100 + handle_material.opacity * 255
					handle.appearance_flags |= RESET_COLOR | RESET_ALPHA
				handle.appearance_flags |= RESET_COLOR
				overlay.overlays += handle
	. = ..()
