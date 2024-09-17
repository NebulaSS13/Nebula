/obj/item/mech_equipment/mounted_system/rcd
	icon_state = "mech_rcd"
	holding = /obj/item/rcd/mounted
	origin_tech = @'{"engineering":4,"materials":3,"powerstorage":1}'
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_ENGINEERING)
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE
	)

/obj/item/rcd/mounted/get_hardpoint_maptext()
	var/obj/item/mech_equipment/mounted_system/MS = loc
	if(istype(MS) && MS.owner)
		var/obj/item/cell/C = MS.owner.get_cell()
		if(istype(C))
			return "[round(C.charge)]/[round(C.maxcharge)]"
	return null

/obj/item/rcd/mounted/get_hardpoint_status_value()
	var/obj/item/mech_equipment/mounted_system/MS = loc
	if(istype(MS) && MS.owner)
		var/obj/item/cell/C = MS.owner.get_cell()
		if(istype(C))
			return C.charge/C.maxcharge
	return null

/obj/item/chems/spray/extinguisher/mech
	volume = 4000 //Good is gooder
	icon_state = "mech_exting"

/obj/item/chems/spray/extinguisher/mech/get_hardpoint_maptext()
	return "[reagents.total_volume]/[reagents.maximum_volume]"

/obj/item/chems/spray/extinguisher/mech/get_hardpoint_status_value()
	return reagents.total_volume/reagents.maximum_volume

/obj/item/mech_equipment/mounted_system/extinguisher
	icon_state = "mech_exting"
	holding = /obj/item/chems/spray/extinguisher/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_ENGINEERING)
	origin_tech = @'{"engineering":1,"materials":1}'

/obj/item/mech_equipment/atmos_shields
	icon_state = "mech_atmoshield_off"
	name = "exosuit airshield"
	desc = "A 'Zephyros' portable Atmospheric Isolation and Retention Screen. It keeps air where it should be... most of the time. Press ctrl-click to switch modes."
	restricted_hardpoints = list(HARDPOINT_BACK)
	restricted_software = list(MECH_SOFTWARE_ENGINEERING)
	equipment_delay = 0.25 SECONDS
	origin_tech = @'{"engineering":2,"powerstorage":2,"materials":3}'
	var/list/segments
	var/current_mode = 0  //0 barrier, 1 bubble
	var/shield_range = 2

/obj/item/mech_equipment/atmos_shields/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/mech_equipment/adjust_atmos_shields)

/decl/interaction_handler/mech_equipment/adjust_atmos_shields
	name = "Adjust Atmos Shields"
	expected_target_type = /obj/item/mech_equipment/atmos_shields

/decl/interaction_handler/mech_equipment/adjust_atmos_shields/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/item/mech_equipment/atmos_shields/shields = target
	if (shields.active)
		to_chat(user, SPAN_WARNING("You cannot modify the projection mode while the shield is active."))
	else
		shields.current_mode = !shields.current_mode
		to_chat(user, SPAN_NOTICE("You set the shields to [shields.current_mode ? "bubble" : "barrier"] mode."))
	return TRUE

/obj/effect/mech_shield
	name = "energy shield"
	desc = "A thin energy shield. It doesn't look like it could stop much."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "shield_normal"
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER
	density = FALSE
	invisibility = INVISIBILITY_NONE
	atmos_canpass = CANPASS_NEVER
	var/obj/item/mech_equipment/atmos_shields/shields
	color = COLOR_SABER_BLUE

/obj/effect/mech_shield/Initialize()
	. = ..()
	set_light(0.8, 0.1, 1, 2, COLOR_SABER_BLUE)
	update_nearby_tiles(need_rebuild=1)

/obj/effect/mech_shield/Destroy()
	if(shields)
		if(LAZYLEN(shields.segments))
			shields.segments -= src
		shields = null
	atmos_canpass = CANPASS_ALWAYS
	update_nearby_tiles(need_rebuild=1)

	. = ..()

/obj/item/mech_equipment/atmos_shields/get_hardpoint_maptext()
	return "[current_mode ? "BUBBLE" : "BARRIER"]\n[active ? "ONLINE" : "OFFLINE"]"

/obj/item/mech_equipment/atmos_shields/proc/on_moved()
	if(active)
		deactivate()

/obj/item/mech_equipment/atmos_shields/proc/on_turned()
	if(active && !current_mode)
		deactivate()

/obj/item/mech_equipment/atmos_shields/proc/activate()
	owner.visible_message(SPAN_WARNING("\The [src] starts glowing as it becomes energized!"), blind_message = SPAN_WARNING("You hear the crackle of electricity."))
	owner.setClickCooldown(2.5 SECONDS)
	if (do_after(owner, 0.5 SECONDS, get_turf(owner)) && owner)
		owner.visible_message(SPAN_WARNING("The air shimmers as energy shields form in front of \the [owner]!"))
		playsound(src ,'sound/effects/phasein.ogg',35,1)
		active = TRUE
		var/list/turfs = list()

		if(current_mode) //Generate a bubble
			var/turf/T = null
			for (var/x_offset = -shield_range +1; x_offset <= shield_range -1; x_offset++)
				T = locate(owner.x + x_offset, owner.y - shield_range, owner.z)
				if(T)
					turfs += T
				T = locate(owner.x + x_offset, owner.y + 2, owner.z)
				if(T)
					turfs += T

			for (var/y_offset = -shield_range+1; y_offset < shield_range; y_offset++)
				T = locate(owner.x - shield_range, owner.y + y_offset, owner.z)
				if(T)
					turfs += T
				T = locate(owner.x + shield_range, owner.y + y_offset, owner.z)
				if(T)
					turfs += T
		else
			var/front = get_step(get_turf(owner), owner.dir)
			turfs += front
			turfs += get_step(front, turn(owner.dir, -90))
			turfs += get_step(front, turn(owner.dir,  90))

		segments = list()
		for(var/turf/T in turfs)
			var/obj/effect/mech_shield/MS = new(T)
			if(istype(MS))
				MS.shields = src
				segments += MS
				events_repository.register(/decl/observ/moved, MS, src, PROC_REF(on_moved))

		passive_power_use = 0.8 KILOWATTS * segments.len

		update_icon()
		owner.update_icon()
		events_repository.register(/decl/observ/moved, owner, src, PROC_REF(on_moved))
		events_repository.register(/decl/observ/dir_set, owner, src, PROC_REF(on_turned))

/obj/item/mech_equipment/atmos_shields/on_update_icon()
	. = ..()
	icon_state = "mech_atmoshield[active ? "_on" : "_off"]"

/obj/item/mech_equipment/atmos_shields/deactivate()
	for(var/obj/effect/mech_shield/MS in segments)
		if(istype(MS))
			events_repository.unregister(/decl/observ/moved, MS, src, PROC_REF(on_moved))
	if(segments.len)
		owner.visible_message(SPAN_WARNING("The energy shields in front of \the [owner] disappear!"))
	QDEL_NULL_LIST(segments)
	passive_power_use = 0
	events_repository.unregister(/decl/observ/moved, owner, src, PROC_REF(on_moved))
	events_repository.unregister(/decl/observ/dir_set, owner, src, PROC_REF(on_turned))
	. = ..()
	update_icon()
	owner.update_icon()

/obj/item/mech_equipment/atmos_shields/attack_self(mob/user)
	. = ..()
	if(.)
		if(active)
			deactivate()
		else
			activate()
		to_chat(user, SPAN_NOTICE("You toggle \the [src] [active ? "on" : "off"]"))
