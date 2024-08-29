/obj/item/gun/launcher/bow/crossbow/powered
	name                = "powered crossbow"
	desc                = "A modern twist on an old classic."
	string              = /obj/item/bowstring/copper // made from wire when crafted
	bow_ammo_type       = /obj/item/stack/material/bow_ammo/rod
	material_alteration = MAT_FLAG_ALTERATION_NONE

	/// Used for firing superheated rods.
	var/obj/item/cell/cell

/obj/item/gun/launcher/bow/crossbow/powered/can_load_arrow(obj/item/ammo)
	return istype(ammo, /obj/item/stack/material/rods) || ..()

/obj/item/gun/launcher/bow/crossbow/powered/add_base_bow_overlays()
	add_overlay(overlay_image(icon, "[icon_state]-cell_mount", COLOR_WHITE, RESET_COLOR))

/obj/item/gun/launcher/bow/crossbow/powered/physically_destroyed()
	if(cell)
		cell.dropInto(loc)
		cell = null
	return ..()

/obj/item/gun/launcher/bow/crossbow/powered/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/item/gun/launcher/bow/crossbow/powered/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/rcd))
		var/obj/item/rcd/rcd = W
		if(rcd.crafting && user.try_unequip(rcd) && user.try_unequip(src))
			new /obj/item/gun/launcher/bow/crossbow/powered/rapidcrossbowdevice(get_turf(src))
			qdel(rcd)
			qdel_self()
		else
			to_chat(user, SPAN_WARNING("\The [rcd] is not prepared for installation in \the [src]."))
		return TRUE

	if(istype(W, /obj/item/cell))
		if(!cell)
			if(user.try_unequip(W, src))
				cell = W
				to_chat(user, SPAN_NOTICE("You jam [cell] into [src] and wire it to the firing coil."))
				superheat_rod(user)
		else
			to_chat(user, SPAN_NOTICE("[src] already has a cell installed."))
		return TRUE

	if(IS_SCREWDRIVER(W))
		if(cell)
			var/obj/item/C = cell
			C.dropInto(user.loc)
			to_chat(user, SPAN_NOTICE("You jimmy [cell] out of [src] with [W]."))
			cell = null
		else
			to_chat(user, SPAN_WARNING("[src] doesn't have a cell installed."))
		return TRUE

	return ..()

/obj/item/gun/launcher/bow/crossbow/powered/proc/superheat_rod(var/mob/user)
	if(!user || !cell || !get_loaded_arrow(user))
		return
	if(cell.charge < 500)
		return
	if(_loaded.get_thrown_attack_force() >= 15)
		return
	if(!istype(_loaded, /obj/item/stack/material/bow_ammo))
		return
	to_chat(user, SPAN_NOTICE("\The [_loaded] plinks and crackles as it begins to glow red-hot."))
	var/obj/item/stack/material/bow_ammo/loaded_arrow = _loaded
	loaded_arrow.make_superheated()
	cell.use(500)

/obj/item/gun/launcher/bow/crossbow/powered/load_arrow(mob/user, obj/item/ammo)
	if(istype(ammo, /obj/item/stack/material/rods))
		var/obj/item/stack/material/rods/rods = ammo
		if(rods.use(1))
			ammo = new /obj/item/stack/material/bow_ammo/rod(src, 1, rods.material?.type)
	. = ..()
	if(.)
		superheat_rod(user)

/*////////////////////////////
//	Rapid Crossbow Device	//
*/////////////////////////////
/obj/item/stack/material/bow_ammo/bolt/rcd
	name = "flashforged bolt"
	desc = "The ultimate ghetto deconstruction implement."
	material = /decl/material/solid/slag

/obj/item/gun/launcher/bow/crossbow/powered/rapidcrossbowdevice
	name = "rapid crossbow device"
	desc = "A hacked RCD turns an innocent construction tool into the penultimate deconstruction tool. Flashforges bolts using matter units when the string is drawn back."
	icon = 'icons/obj/guns/launcher/rcd_bow.dmi'
	slot_flags = null
	draw_time = 10
	bow_ammo_type = /obj/item/stack/material/bow_ammo/bolt/rcd
	require_loaded_to_draw = TRUE
	var/stored_matter = 0
	var/max_stored_matter = 120
	var/boltcost = 30

/obj/item/gun/launcher/bow/crossbow/powered/rapidcrossbowdevice/proc/generate_bolt(var/mob/user)
	if(stored_matter >= boltcost && !_loaded)
		_loaded = new/obj/item/stack/material/bow_ammo/bolt/rcd(src)
		stored_matter -= boltcost
		to_chat(user, SPAN_NOTICE("The RCD flashforges a new bolt!"))
		queue_icon_update()
	else
		to_chat(user, SPAN_WARNING("The \'Low Ammo\' light on the device blinks yellow."))
		flick("[icon_state]-empty", src)

/obj/item/gun/launcher/bow/crossbow/powered/rapidcrossbowdevice/get_loaded_arrow(mob/user)
	if(!_loaded)
		generate_bolt(user)
	return ..()

/obj/item/gun/launcher/bow/crossbow/powered/rapidcrossbowdevice/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/rcd_ammo))
		var/obj/item/rcd_ammo/cartridge = W
		if((stored_matter + cartridge.remaining) > max_stored_matter)
			to_chat(user, SPAN_NOTICE("The RCD can't hold that many additional matter-units."))
			return
		stored_matter += cartridge.remaining
		qdel(W)
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("The RCD now holds [stored_matter]/[max_stored_matter] matter-units."))
		update_icon()

	if(istype(W, /obj/item/stack/material/bow_ammo/bolt/rcd))
		var/obj/item/stack/material/bow_ammo/bolt/rcd/A = W
		if((stored_matter + 10) > max_stored_matter)
			to_chat(user, SPAN_NOTICE("Unable to reclaim flashforged bolt. The RCD can't hold that many additional matter-units."))
			return
		stored_matter += 10
		qdel(A)
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("Flashforged bolt reclaimed. The RCD now holds [stored_matter]/[max_stored_matter] matter-units."))
		update_icon()

/obj/item/gun/launcher/bow/crossbow/powered/rapidcrossbowdevice/on_update_icon()
	. = ..()
	var/ratio = 0
	if(stored_matter < boltcost)
		ratio = 0
	else
		ratio = stored_matter / max_stored_matter
		ratio = max(round(ratio, 0.25) * 100, 25)
	add_overlay("[get_world_inventory_state()][ratio]")

/obj/item/gun/launcher/bow/crossbow/powered/rapidcrossbowdevice/examine(mob/user)
	. = ..()
	to_chat(user, "It currently holds [stored_matter]/[max_stored_matter] matter-units.")
