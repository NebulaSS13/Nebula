/obj/item/blueprints
	name = "blueprints"
	desc = "Blueprints..."
	icon = 'icons/obj/items/blueprints.dmi'
	icon_state = "blueprints"
	attack_verb = list("attacked", "bapped", "hit")
	material = /decl/material/solid/cardboard
	var/valid_z_levels = list()
	var/area_prefix

/obj/item/blueprints/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/blueprints/LateInitialize()
	. = ..()
	desc = "Blueprints of the [station_name()]. There is a \"Classified\" stamp and several coffee stains on it."

	if(set_valid_z_levels())
		create_blueprint_extension()

/obj/item/blueprints/proc/create_blueprint_extension() // so that subtypes can override
	set_extension(src, /datum/extension/eye/blueprints)

/obj/item/blueprints/proc/get_look_args() // ditto
	return list(valid_z_levels, area_prefix)

/obj/item/blueprints/preserve_in_cryopod(var/obj/machinery/cryopod/pod)
	return TRUE

/obj/item/blueprints/attack_self(mob/user)
	if (!ishuman(user) || !user.check_dexterity(DEXTERITY_COMPLEX_TOOLS)) // Monkeys et al. cannot blueprint.
		to_chat(user, SPAN_WARNING("This stack of blue paper means nothing to you."))
		return

	if(CanInteract(user, global.default_topic_state))
		var/datum/extension/eye/blueprints = get_extension(src, /datum/extension/eye/)
		if(!(user.z in valid_z_levels))
			to_chat(user, SPAN_WARNING("The markings on this are entirely irrelevant to your whereabouts!"))
			return

		if(blueprints)
			if(blueprints.look(user, get_look_args())) // Abandon all peripheral vision, ye who enter here.
				to_chat(user, SPAN_NOTICE("You start peering closely at \the [src]."))
				return
			else
				to_chat(user, SPAN_WARNING("You couldn't get a good look at \the [src]. Maybe someone else is using it?"))
				return

		to_chat(user, SPAN_WARNING("The markings on this are useless!"))

/obj/item/blueprints/proc/set_valid_z_levels()

	var/turf/T = get_turf(src)
	if(istype(T) && length(global.using_map.overmap_ids))
		var/obj/effect/overmap/visitable/sector/S = global.overmap_sectors[num2text(T.z)]
		if(!S) // The blueprints are useless now, but keep them around for fluff.
			desc = "Some dusty old blueprints. The markings are old, and seem entirely irrelevant for your wherabouts."
			return FALSE

		name += " - [S.name]"
		desc = "Blueprints of \the [S.name]. There is a \"Classified\" stamp and several coffee stains on it."
		valid_z_levels += S.map_z
		area_prefix = S.name
		return TRUE

	desc = "Blueprints of the [station_name()]. There is a \"Classified\" stamp and several coffee stains on it."
	area_prefix = station_name()
	valid_z_levels += SSmapping.station_levels
	return TRUE

//For use on exoplanets
/obj/item/blueprints/outpost
	name = "outpost blueprints"
	icon_state = "blueprints2"

/obj/item/blueprints/outpost/attack_self(mob/user)
	var/obj/effect/overmap/visitable/sector/S = global.overmap_sectors[num2text(get_z(user))]
	area_prefix = S.name
	. = ..()

/obj/item/blueprints/outpost/set_valid_z_levels()
	var/turf/T = get_turf(src)
	if(istype(T) && length(global.using_map.overmap_ids))
		var/obj/effect/overmap/visitable/sector/S = global.overmap_sectors[num2text(T.z)]
		if(istype(S))
			T = locate(1, 1, S.z)
			var/area/overmap/map = T && get_area(T)
			if(istype(map))
				desc = "Blueprints for the daring souls wanting to establish a planetary outpost. Has some sketchy looking stains and what appears to be bite holes."
				for(var/obj/effect/overmap/visitable/sector/planetoid/E in map)
					valid_z_levels |= E.map_z
				return TRUE
	desc = "Some dusty old blueprints. The markings are old, and seem entirely irrelevant for your wherabouts."
	return FALSE

//For use on /obj/effect/overmap/visitable/ship/landable ships.
/obj/item/blueprints/shuttle
	var/shuttle_name // If set, use this (modified by map hash). Otherwise, check for a landable ship and use that.

/obj/item/blueprints/shuttle/set_valid_z_levels()
	var/turf/T = get_turf(src)
	if(istype(T) && length(global.using_map.overmap_ids) && global.overmap_sectors[num2text(T.z)])
		var/obj/effect/overmap/visitable/ship/landable/S = global.overmap_sectors[num2text(T.z)]
		if(isnull(shuttle_name))
			shuttle_name = S.shuttle
		update_linked_name(S, null, S.name)
		events_repository.register(/decl/observ/name_set, S, src, .proc/update_linked_name)
		events_repository.register(/decl/observ/destroyed, S, src, .proc/on_shuttle_destroy)
		valid_z_levels += S.map_z
		area_prefix = S.name
		return TRUE
	// The blueprints are useless now, but keep them around for fluff.
	desc = "Some dusty old blueprints. The markings are old, and seem entirely irrelevant for your wherabouts."
	return FALSE

/obj/item/blueprints/shuttle/proc/update_linked_name(atom/namee, old_name, new_name)
	name = "\improper [new_name] blueprints"
	desc = "Blueprints of \the [new_name]. There are several coffee stains on it."

/obj/item/blueprints/shuttle/proc/on_shuttle_destroy(datum/destroyed)
	events_repository.unregister(/decl/observ/name_set, destroyed, src, .proc/update_linked_name)
	events_repository.unregister(/decl/observ/destroyed, destroyed, src, .proc/on_shuttle_destroy)
	name = initial(name)
	desc = "Some dusty old blueprints. The markings are old, and seem entirely irrelevant for your wherabouts."
	valid_z_levels = list()
	area_prefix = null

/obj/item/blueprints/shuttle/create_blueprint_extension()
	set_extension(src, /datum/extension/eye/blueprints/shuttle)

/obj/item/blueprints/shuttle/get_look_args() // ditto
	return list(valid_z_levels, area_prefix, shuttle_name)