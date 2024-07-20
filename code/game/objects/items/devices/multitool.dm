/**
 * Multitool -- A multitool is used for hacking electronic devices.
 *
 */

/obj/item/multitool
	name = "multitool"
	desc = "This small, handheld device is made of durable, insulated plastic, and tipped with electrodes, perfect for interfacing with numerous machines."
	icon = 'icons/obj/items/device/multitool.dmi'
	icon_state = "multitool"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	throw_range = 15
	throw_speed = 3
	material = /decl/material/solid/organic/plastic
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/steel = MATTER_AMOUNT_TRACE
	)

	origin_tech = @'{"magnets":1,"engineering":1}'

	var/buffer_name
	var/atom/buffer_object

/obj/item/multitool/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_MULTITOOL = TOOL_QUALITY_DEFAULT))

/obj/item/multitool/Destroy()
	unregister_buffer(buffer_object)
	return ..()

/obj/item/multitool/proc/get_buffer(var/typepath)
	// Only allow clearing the buffer name when someone fetches the buffer.
	// Means you cannot be sure the source hasn't been destroyed until the very moment it's needed.
	get_buffer_name(TRUE)
	if(buffer_object && (!typepath || istype(buffer_object, typepath)))
		return buffer_object

/obj/item/multitool/proc/get_buffer_name(var/null_name_if_missing = FALSE)
	if(buffer_object)
		buffer_name = buffer_object.name
	else if(null_name_if_missing)
		buffer_name = null
	return buffer_name

/obj/item/multitool/proc/set_buffer(var/atom/buffer)
	if(!buffer || istype(buffer))
		buffer_name = buffer ? buffer.name : null
		if(buffer != buffer_object)
			unregister_buffer(buffer_object)
			buffer_object = buffer
			if(buffer_object)
				events_repository.register(/decl/observ/destroyed, buffer_object, src, TYPE_PROC_REF(/obj/item/multitool, unregister_buffer))

/obj/item/multitool/proc/unregister_buffer(var/atom/buffer_to_unregister)
	// Only remove the buffered object, don't reset the name
	// This means one cannot know if the buffer has been destroyed until one attempts to use it.
	if(buffer_to_unregister == buffer_object && buffer_object)
		events_repository.unregister(/decl/observ/destroyed, buffer_object, src)
		buffer_object = null

/obj/item/multitool/resolve_attackby(atom/A, mob/user)
	if(!isobj(A))
		return ..(A, user)

	var/obj/O = A
	var/datum/extension/interactive/multitool/MT = get_extension(O, /datum/extension/interactive/multitool)
	if(!MT)
		return ..(A, user)

	user.AddTopicPrint(src)
	MT.interact(src, user)
	return 1
