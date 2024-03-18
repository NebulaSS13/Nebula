/obj/screen/storage
	name = "storage"
	icon = 'icons/mob/screen/storage.dmi'
	user_incapacitation_flags = INCAPACITATION_DISRUPTED
	screen_loc = ui_storage_default
	layer = HUD_BASE_LAYER
	requires_owner = FALSE
	requires_ui_style = FALSE
	var/weakref/storage_master_ref

/obj/screen/storage/Initialize(mapload, mob/_owner, ui_style, ui_color, ui_alpha, ui_cat, datum/storage/_storage_master)
	. = ..()
	storage_master_ref = _storage_master && weakref(_storage_master)

/obj/screen/storage/handle_click(mob/user, params)
	var/datum/storage/storage_master = storage_master_ref?.resolve()
	if(istype(storage_master) && !QDELETED(storage_master) && isatom(storage_master.holder))
		var/obj/item/I = user.get_active_held_item()
		if(I)
			user.ClickOn(storage_master.holder)
		return TRUE
	return FALSE

/obj/screen/storage/start
	icon_state = "storage_start"

/obj/screen/storage/cont
	icon_state = "storage_continue"

/obj/screen/storage/boxes
	icon_state = "block"

/obj/screen/storage/end
	icon_state = "storage_end"

/obj/screen/storage/close
	name       = "close"
	icon       = 'icons/effects/markers.dmi'
	icon_state = "x"
	layer      = HUD_BASE_LAYER

/obj/screen/storage/close/handle_click(mob/user, params)
	var/datum/storage/storage_master = storage_master_ref?.resolve()
	if(istype(storage_master) && !QDELETED(storage_master))
		storage_master.close(user)
		return TRUE
	return FALSE

/obj/screen/stored
	layer = HUD_BASE_LAYER
	requires_owner = FALSE
	requires_ui_style = FALSE

/obj/screen/stored/start
	icon_state = "stored_start"

/obj/screen/stored/cont
	icon_state = "stored_continue"

/obj/screen/stored/end
	icon_state = "stored_end"
