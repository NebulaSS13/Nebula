// Used on machine frames to hold parts on deconstruct.

/datum/extension/parts_stash
	base_type = /datum/extension/parts_stash
	expected_type = /obj
	var/list/parts

/datum/extension/parts_stash/Destroy()
	QDEL_NULL_LIST(parts)
	. = ..()

/datum/extension/parts_stash/proc/install_into(var/obj/machinery/machine)
	for(var/thing in parts)
		machine.install_component(thing, refresh_parts = FALSE)
	parts = null
	machine.apply_component_presets()
	machine.RefreshParts()

/datum/extension/parts_stash/proc/stash(list/components)
	for(var/obj/O in components)
		O.forceMove(null)
	LAZYADD(parts, components)