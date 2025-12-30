/obj/item
	/// Assoc list of decoration instances to metadata, ie.
	/// decorations[GET_DECL(/decl/item_decoration/inset)] = list("color" = COLOR_RED, "material" = GET_DECL(/decl/material/foo))
	var/list/decorations

/obj/item/proc/add_item_decoration(decl/item_decoration/decoration_type, decoration_color, decl/material/decoration_material, obj/item/associated_object)
	LAZYINITLIST(decorations)
	if(ispath(decoration_type))
		decoration_type = GET_DECL(decoration_type)
	if(!istype(decoration_type))
		CRASH("Invalid decoration_type.")
	. = list()
	if(decoration_color)
		// TODO: validate color?
		.["color"] = decoration_color
	if(decoration_material)
		if(ispath(decoration_material))
			decoration_material = GET_DECL(decoration_material)
		if(istype(decoration_material))
			.["material"] = decoration_material
			if(!associated_object) // Object holds matter, no need to add it to parent.
				var/decoration_matter_amount = MATTER_AMOUNT_TRACE * get_matter_amount_modifier()
				if(decoration_material.type in matter)
					matter[decoration_material.type] += decoration_matter_amount
				else
					LAZYSET(matter, decoration_material.type, decoration_matter_amount)
		else
			PRINT_STACK_TRACE("Invalid decoration_material.")
	if(associated_object)
		.["object"] = associated_object
	decorations[decoration_type] = .
	queue_icon_update()
	update_name()

/obj/item/proc/get_decoration_icon(default_icon, obj/item/thing, on_mob = FALSE)
	return default_icon || icon

/obj/item/proc/get_decoration_overlays(decoration_state, decoration_icon, on_mob = FALSE)
	for(var/decl/item_decoration/decoration as anything in decorations)
		var/list/decoration_metadata = decorations[decoration]
		if(!islist(decoration_metadata))
			continue
		var/obj/item/decoration_object = decoration_metadata["object"]
		if(decoration_object)
			decoration_icon = get_decoration_icon(decoration_icon, decoration_object, on_mob)
		if(!decoration_icon)
			continue
		decoration_state = "[decoration_state]-[decoration.icon_state_modifier]"
		if(check_state_in_icon(decoration_state, decoration_icon))
			LAZYADD(., overlay_image(decoration_icon, decoration_state, decoration.resolve_color(src), RESET_COLOR|RESET_ALPHA))

/obj/item/attackby(obj/item/used_item, mob/user)
	. = ..()
	if(.)
		return

	if(user.check_intent(I_FLAG_HELP))
		var/list/possible_decorations = get_decoration_types_for(user, src, used_item)
		if(!length(possible_decorations))
			return FALSE
		var/decl/item_decoration/decoration
		if(length(possible_decorations) == 1)
			decoration = possible_decorations[1]
		else
			decoration = input(user, "Which decoration would you like to apply?", "Item Decoration") as null|anything in possible_decorations
			if(!decoration || QDELETED(src) || QDELETED(user) || QDELETED(used_item) || !CanPhysicallyInteract(user) || user.get_active_held_item() != used_item)
				return TRUE
		if(istype(decoration) && decoration.apply_to_item(user, src, used_item))
			add_item_decoration(decoration, used_item.paint_color, used_item.material, istype(used_item, /obj/item/stack) ? null : used_item)
		return TRUE

	for(var/decl/item_decoration/decoration as anything in decorations)
		if(decoration.attempt_removal(user, src, used_item))
			return TRUE

/obj/item/get_single_monetary_worth()
	. = ..()
	var/base_value = .
	for(var/decl/item_decoration/decoration as anything in decorations)
		. += decoration.get_decoration_value(src, base_value)

/obj/item/on_update_icon()
	. = ..()
	var/list/decoration_overlays = get_decoration_overlays(icon_state)
	if(length(decoration_overlays))
		add_overlay(decoration_overlays)

/obj/item/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing)
	if(overlay)
		var/list/decoration_overlays = get_decoration_overlays(overlay.icon_state, overlay.icon, on_mob = TRUE)
		if(length(decoration_overlays))
			overlay.overlays += decoration_overlays
	return ..()

// Except decorations from storage datums.
/obj/item/get_stored_inventory()
	. = ..()
	if(length(.) && length(decorations))
		for(var/decl/item_decoration/decoration in decorations)
			var/list/decoration_data = decorations[decoration]
			var/thing = decoration_data?["object"]
			if(isitem(thing))
				. -= thing
