// Add special mercenary-mode handling to the nuke disk
/obj/item/disk/nuclear/Initialize()
	. = ..()
	// Can never be quite sure that a game mode has been properly initiated or not at this point, so always register
	events_repository.register(/decl/observ/moved, src, src, TYPE_PROC_REF(/obj/item/disk/nuclear, check_z_level))

/obj/item/disk/nuclear/proc/check_z_level()
	if(!(istype(SSticker.mode, /decl/game_mode/mercenary)))
		events_repository.unregister(/decl/observ/moved, src, src, TYPE_PROC_REF(/obj/item/disk/nuclear, check_z_level)) // However, when we are certain unregister if necessary
		return
	var/turf/T = get_turf(src)
	if(!T || isNotStationLevel(T.z))
		qdel(src)

/obj/item/disk/nuclear/Destroy()
	events_repository.unregister(/decl/observ/moved, src, src, TYPE_PROC_REF(/obj/item/disk/nuclear, check_z_level))
	. = ..()