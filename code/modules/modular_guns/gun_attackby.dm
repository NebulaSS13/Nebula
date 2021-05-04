/obj/item/gun/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/firearm_component))
		var/obj/item/firearm_component/comp = W
		if(comp.can_install(src, user) && user.unEquip(comp, src))
			to_chat(user, SPAN_NOTICE("You install \the [comp] into \the [src]."))
			comp.installed(src, TRUE)
		return TRUE

	var/list/firearm_components = get_modular_component_list()
	if(isScrewdriver(W) || W.edge || W.sharp)
		var/list/components
		for(var/fcomp in firearm_components)
			var/obj/item/firearm_component/comp = firearm_components[fcomp]
			if(istype(comp))
				var/image/radial_button = image(null)
				radial_button.appearance = comp
				radial_button.plane = FLOAT_PLANE
				radial_button.layer = FLOAT_LAYER
				radial_button.name = "Remove \the [comp]"
				LAZYSET(components, comp, radial_button)
		if(!LAZYLEN(components))
			to_chat(user, SPAN_WARNING("You can't find any components to remove."))
			return TRUE
		var/obj/item/firearm_component/comp = show_radial_menu(user, W, components, radius = 42, require_near = TRUE, use_labels = TRUE, check_locs = list(W))
		if(QDELETED(comp) || QDELETED(src) || QDELETED(user) || user.incapacitated() || (loc != user && !user.Adjacent(src)) || comp.holder != src)
			return TRUE
		if(comp.can_uninstall())
			to_chat(user, SPAN_NOTICE("You remove \the [comp] from \the [src]."))
			comp.uninstalled()
			comp.dropInto(loc)
		return TRUE

	for(var/fcomp in firearm_components)
		var/obj/item/firearm_component/comp = firearm_components[fcomp]
		if(istype(comp) && comp.holder_attackby(W, user))
			return TRUE

	. = ..()
