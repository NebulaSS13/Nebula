// TODO: Maybe generalize this to handle any sort of component-composition that can have a separate material and painting?
/// An extension that unifies padding state and interactions.
/datum/extension/padding
	abstract_type = /datum/extension/padding
	base_type = /datum/extension/padding
	expected_type = /obj
	flags = EXTENSION_FLAG_IMMEDIATE // logic must run on creation
	/// The paint color for the padding represented by this extension.
	/// '#FFFFFF' is treated as 'painted white', while 'null' is treated as 'unpainted'.
	VAR_PROTECTED/padding_color
	VAR_PROTECTED/decl/material/padding_material
	// TODO: Add some better way of determining if a stack is usable, for more extensibility in modpacks.
	/// What stack types can be used to add padding?
	VAR_PRIVATE/static/padding_stack_types = list(
		/obj/item/stack/material/skin, // leather, fur
		/obj/item/stack/material/bolt, // cloth
	)
	/// An internal variable used to hold a typecache for the above list.
	VAR_PRIVATE/static/_padding_stack_typecache

/datum/extension/padding/New(datum/holder, _padding_material, _padding_color)
	. = ..()
	if(!_padding_stack_typecache)
		_padding_stack_typecache = typecacheof(padding_stack_types)

// Must be here so our holder's get_extension calls work.
/datum/extension/padding/post_construction(_padding_material, _padding_color)
	. = ..()
	add_padding(_padding_material, _padding_color)

/// Returns an object's padding material.
/datum/extension/padding/proc/get_padding_material()
	RETURN_TYPE(/decl/material)
	return padding_material

/// Returns the color of the padding, either the painted/dyed color or (optionally) the underlying material color.
/datum/extension/padding/proc/get_padding_color(use_material_color = TRUE)
	var/decl/material/padding_material = get_padding_material()
	return padding_color || (use_material_color ? padding_material?.color : null)

/// Used to change just the paint color on padding.
/datum/extension/padding/proc/set_padding_color(new_color)
	padding_color = new_color

/datum/extension/padding/proc/handle_use_item(obj/item/used_item, mob/user)
	if(isstack(used_item))
		if(padding_material)
			to_chat(user, SPAN_NOTICE("\The [holder] is already padded."))
			return TRUE
		var/decl/material/new_padding_material = used_item.material
		if(!is_type_in_typecache(used_item, _padding_stack_typecache) || !(new_padding_material.flags & MAT_FLAG_PADDING))
			to_chat(user, SPAN_NOTICE("You cannot pad \the [holder] with that."))
			return TRUE
		var/obj/item/stack/used_stack = used_item
		if(!used_stack.can_use(1))
			to_chat(user, SPAN_NOTICE("You need at least [used_stack.get_string_for_amount(1)] to pad \the [holder]."))
			return TRUE
		if(!used_item.user_can_attack_with(user, holder))
			return TRUE
		to_chat(user, SPAN_NOTICE("You pad \the [holder] with [used_stack.get_string_for_amount(1)]."))
		used_stack.use(1)
		if(new_padding_material.sound_manipulate)
			playsound(get_turf(holder), new_padding_material.sound_manipulate, 50, TRUE)
		add_padding(new_padding_material.type, used_stack.paint_color)
		return TRUE
	else if(IS_SHEARS(used_item)) // can use shears or wirecutters
		if(!padding_material)
			to_chat(user, SPAN_NOTICE("\The [holder] has no padding to remove."))
			return TRUE
		if(!used_item.user_can_attack_with(user, holder))
			return TRUE
		to_chat(user, SPAN_NOTICE("You remove \the [padding_material.adjective_name] padding from \the [holder]."))
		var/use_tool_sound = used_item.get_tool_sound(TOOL_SHEARS)
		if(use_tool_sound)
			playsound(get_turf(holder), use_tool_sound, 100, TRUE)
		remove_padding()
		return TRUE
	return FALSE

// TODO: Unify this somewhere on /obj, maybe?
/datum/extension/padding/proc/update_holder_name()
	if(QDELETED(src) || QDELETED(holder))
		return
	if(istype(holder, /obj/structure))
		var/obj/structure/structure_holder = holder
		structure_holder.update_materials() // update name and description if needed
	else if(isitem(holder))
		var/obj/item/item_holder = holder
		item_holder.update_name()

/datum/extension/padding/proc/add_padding(padding_type, new_padding_color, do_icon_update = TRUE)
	ASSERT(padding_type)
	var/old_padding_material = padding_material
	padding_material = ispath(padding_type) ? GET_DECL(padding_type) : padding_type
	padding_color = new_padding_color
	update_matter(old_padding_material, padding_material)
	if(do_icon_update)
		var/obj/obj_holder = holder
		addtimer(CALLBACK(src, PROC_REF(update_holder_name)), 0, TIMER_UNIQUE) // Update at the end of the tick.
		obj_holder.queue_icon_update()

/datum/extension/padding/proc/remove_padding(do_icon_update = TRUE)
	if(padding_material)
		var/list/res = padding_material.create_object(get_turf(holder))
		if(padding_color)
			for(var/obj/item/thing in res)
				thing.set_color(padding_color)
	var/old_padding_material = padding_material
	padding_material = null
	padding_color = null
	update_matter(old_padding_material, padding_material)
	if(do_icon_update)
		var/obj/obj_holder = holder
		if(istype(obj_holder, /obj/structure))
			var/obj/structure/structure_holder = obj_holder
			structure_holder.update_materials() // update name and description if needed
		else if(isitem(obj_holder))
			var/obj/item/item_holder = obj_holder
			item_holder.update_name()
		obj_holder.queue_icon_update()

/datum/extension/padding/proc/update_matter(decl/material/old_padding, decl/material/new_padding)
	var/obj/obj_holder = holder
	var/matter_mult = obj_holder.get_matter_amount_modifier()
	if(LAZYLEN(obj_holder.matter) && old_padding)
		obj_holder.matter[old_padding.type] -= MATTER_AMOUNT_TRACE * matter_mult
		if(!obj_holder.matter[old_padding.type])
			obj_holder.matter -= old_padding.type
	if(new_padding)
		LAZYINITLIST(obj_holder.matter)
		obj_holder.matter[new_padding.type] += MATTER_AMOUNT_TRACE * matter_mult
	UNSETEMPTY(obj_holder.matter)