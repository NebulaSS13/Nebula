//AMMUNITION

/obj/item/arrow
	name = "bolt"
	desc = "It's got a tip for you - get the point?"
	icon = 'icons/obj/items/weapon/crossbow_bolt.dmi'
	icon_state = "bolt"
	item_state = "bolt"
	throwforce = 8
	w_class = ITEM_SIZE_NORMAL
	sharp = 1
	edge = 0
	lock_picking_level = 3
	material = /decl/material/solid/wood

/obj/item/arrow/proc/removed() //Helper for metal rods falling apart.
	return

/obj/item/spike
	name = "alloy spike"
	desc = "It's about a foot of weird silver metal with a wicked point."
	sharp = 1
	edge = 0
	throwforce = 5
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/items/weapon/crossbow_bolt.dmi'
	icon_state = "metal-rod"
	item_state = "bolt"
	material = /decl/material/solid/metal/alienalloy

/obj/item/arrow/rod
	name = "metal rod"
	desc = "Don't cry for me, Orithena."
	icon_state = "metal-rod"
	material = /decl/material/solid/metal/steel

/obj/item/arrow/rod/removed(mob/user)
	if(throwforce == 15) // The rod has been superheated - we don't want it to be useable when removed from the bow.
		to_chat(user, "[src] shatters into a scattering of overstressed metal shards as it leaves the crossbow.")
		var/obj/item/shard/shrapnel/S = new()
		S.dropInto(loc)
		qdel(src)

/obj/item/gun/launcher/crossbow
	name = "powered crossbow"
	desc = "A modern twist on an old classic. Pick up that can."
	icon = 'icons/obj/guns/launcher/crossbow.dmi'
	icon_state = ICON_STATE_WORLD
	fire_sound = 'sound/weapons/punchmiss.ogg' // TODO: Decent THWOK noise.
	fire_sound_text = "a solid thunk"
	fire_delay = 25
	slot_flags = SLOT_BACK
	has_safety = FALSE

	var/obj/item/bolt
	var/tension = 0                         // Current draw on the bow.
	var/max_tension = 3                     // Highest possible tension.
	var/release_speed = 10                  // Speed per unit of tension.
	var/obj/item/cell/cell = null    // Used for firing superheated rods.
	var/current_user                        // Used to check if the crossbow has changed hands since being drawn.
	var/draw_time = 20						// Time needed to draw the bow back by one "tension"

/obj/item/gun/launcher/crossbow/toggle_safety(var/mob/user)
	to_chat(user, SPAN_WARNING("There's no safety on \the [src]!"))

/obj/item/gun/launcher/crossbow/update_release_force()
	release_force = tension*release_speed

/obj/item/gun/launcher/crossbow/consume_next_projectile(atom/movable/firer)
	if(tension <= 0 && isliving(firer))
		to_chat(firer, SPAN_WARNING("\The [src] is not drawn back!"))
		return null
	return bolt

/obj/item/gun/launcher/crossbow/handle_post_fire(atom/movable/firer, atom/target)
	bolt = null
	tension = 0
	update_icon()
	..()

/obj/item/gun/launcher/crossbow/attack_self(mob/user)
	if(tension)
		if(bolt)
			user.visible_message("[user] relaxes the tension on [src]'s string and removes [bolt].","You relax the tension on [src]'s string and remove [bolt].")
			bolt.dropInto(loc)
			var/obj/item/arrow/A = bolt
			bolt = null
			A.removed(user)
		else
			user.visible_message("[user] relaxes the tension on [src]'s string.","You relax the tension on [src]'s string.")
		tension = 0
		update_icon()
	else
		draw(user)

/obj/item/gun/launcher/crossbow/proc/draw(var/mob/user)

	if(!bolt)
		to_chat(user, "You don't have anything nocked to [src].")
		return

	if(user.restrained())
		return

	current_user = user
	user.visible_message("[user] begins to draw back the string of [src].",SPAN_NOTICE("You begin to draw back the string of [src]."))
	tension = 1

	while(bolt && tension && loc == current_user)
		if(!do_after(user, draw_time, src)) //crossbow strings don't just magically pull back on their own.
			user.visible_message("[usr] stops drawing and relaxes the string of [src].",SPAN_WARNING("You stop drawing back and relax the string of [src]."))
			tension = 0
			update_icon()
			return

		//double check that the user hasn't removed the bolt in the meantime
		if(!(bolt && tension && loc == current_user))
			return

		tension++
		update_icon()

		if(tension >= max_tension)
			tension = max_tension
			to_chat(usr, "[src] clunks as you draw the string to its maximum tension!")
			return

		user.visible_message("[usr] draws back the string of [src]!",SPAN_NOTICE("You continue drawing back the string of [src]!"))

/obj/item/gun/launcher/crossbow/proc/increase_tension(var/mob/user)

	if(!bolt || !tension || current_user != user) //Arrow has been fired, bow has been relaxed or user has changed.
		return


/obj/item/gun/launcher/crossbow/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/rcd))
		var/obj/item/rcd/rcd = W
		if(rcd.crafting && user.try_unequip(rcd) && user.try_unequip(src))
			new /obj/item/gun/launcher/crossbow/rapidcrossbowdevice(get_turf(src))
			qdel(rcd)
			qdel_self()
		else
			to_chat(user, SPAN_WARNING("\The [rcd] is not prepared for installation in \the [src]."))
		return

	if(!bolt)
		if (istype(W,/obj/item/arrow) && user.try_unequip(W, src))
			bolt = W
			user.visible_message("[user] slides [bolt] into [src].","You slide [bolt] into [src].")
			update_icon()
			return
		else if(istype(W,/obj/item/stack/material/rods))
			var/obj/item/stack/material/rods/R = W
			if (R.use(1))
				bolt = new /obj/item/arrow/rod(src)
				bolt.fingerprintslast = src.fingerprintslast
				bolt.dropInto(loc)
				update_icon()
				user.visible_message("[user] jams [bolt] into [src].","You jam [bolt] into [src].")
				superheat_rod(user)
			return

	if(istype(W, /obj/item/cell))
		if(!cell)
			if(!user.try_unequip(W, src))
				return
			cell = W
			to_chat(user, SPAN_NOTICE("You jam [cell] into [src] and wire it to the firing coil."))
			superheat_rod(user)
		else
			to_chat(user, SPAN_NOTICE("[src] already has a cell installed."))

	else if(IS_SCREWDRIVER(W))
		if(cell)
			var/obj/item/C = cell
			C.dropInto(user.loc)
			to_chat(user, SPAN_NOTICE("You jimmy [cell] out of [src] with [W]."))
			cell = null
		else
			to_chat(user, SPAN_WARNING("[src] doesn't have a cell installed."))

	else
		..()

/obj/item/gun/launcher/crossbow/proc/superheat_rod(var/mob/user)
	if(!user || !cell || !bolt) return
	if(cell.charge < 500) return
	if(bolt.throwforce >= 15) return
	if(!istype(bolt,/obj/item/arrow/rod)) return

	to_chat(user, SPAN_NOTICE("[bolt] plinks and crackles as it begins to glow red-hot."))
	bolt.throwforce = 15
	bolt.icon_state = "metal-rod-superheated"
	cell.use(500)

/obj/item/gun/launcher/crossbow/on_update_icon()
	. = ..()
	if(tension > 1)
		icon_state = "[get_world_inventory_state()]-drawn"
	else if(bolt)
		icon_state = "[get_world_inventory_state()]-nocked"
	else
		icon_state = "[get_world_inventory_state()]"

/*////////////////////////////
//	Rapid Crossbow Device	//
*/////////////////////////////

/obj/item/arrow/rapidcrossbowdevice
	name = "flashforged bolt"
	desc = "The ultimate ghetto deconstruction implement."
	throwforce = 4
	material = /decl/material/solid/slag

/obj/item/gun/launcher/crossbow/rapidcrossbowdevice
	name = "rapid crossbow device"
	desc = "A hacked RCD turns an innocent construction tool into the penultimate deconstruction tool. Flashforges bolts using matter units when the string is drawn back."
	icon = 'icons/obj/guns/launcher/rcd_bow.dmi'
	slot_flags = null
	draw_time = 10
	var/stored_matter = 0
	var/max_stored_matter = 120
	var/boltcost = 30

/obj/item/gun/launcher/crossbow/rapidcrossbowdevice/proc/generate_bolt(var/mob/user)
	if(stored_matter >= boltcost && !bolt)
		bolt = new/obj/item/arrow/rapidcrossbowdevice(src)
		stored_matter -= boltcost
		to_chat(user, SPAN_NOTICE("The RCD flashforges a new bolt!"))
		queue_icon_update()
	else
		to_chat(user, SPAN_WARNING("The \'Low Ammo\' light on the device blinks yellow."))
		flick("[icon_state]-empty", src)


/obj/item/gun/launcher/crossbow/rapidcrossbowdevice/attack_self(mob/user)
	if(tension)
		user.visible_message("[user] relaxes the tension on [src]'s string.","You relax the tension on [src]'s string.")
		tension = 0
		update_icon()
	else
		generate_bolt(user)
		draw(user)

/obj/item/gun/launcher/crossbow/rapidcrossbowdevice/attackby(obj/item/W, mob/user)
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

	if(istype(W, /obj/item/arrow/rapidcrossbowdevice))
		var/obj/item/arrow/rapidcrossbowdevice/A = W
		if((stored_matter + 10) > max_stored_matter)
			to_chat(user, SPAN_NOTICE("Unable to reclaim flashforged bolt. The RCD can't hold that many additional matter-units."))
			return
		stored_matter += 10
		qdel(A)
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("Flashforged bolt reclaimed. The RCD now holds [stored_matter]/[max_stored_matter] matter-units."))
		update_icon()

/obj/item/gun/launcher/crossbow/rapidcrossbowdevice/on_update_icon()
	. = ..()

	if(bolt)
		add_overlay("[get_world_inventory_state()]-bolt")

	var/ratio = 0
	if(stored_matter < boltcost)
		ratio = 0
	else
		ratio = stored_matter / max_stored_matter
		ratio = max(round(ratio, 0.25) * 100, 25)
	add_overlay("[get_world_inventory_state()][ratio]")

	if(tension > 1)
		icon_state = "[get_world_inventory_state()]-drawn"
	else
		icon_state = "[get_world_inventory_state()]"

/obj/item/gun/launcher/crossbow/rapidcrossbowdevice/examine(mob/user)
	. = ..()
	to_chat(user, "It currently holds [stored_matter]/[max_stored_matter] matter-units.")
