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

/obj/item/arrow/rod
	name = "metal rod"
	desc = "Don't cry for me, Orithena."
	icon_state = "metal-rod"

/obj/item/arrow/rod/removed(mob/user)
	if(throwforce == 15) // The rod has been superheated - we don't want it to be useable when removed from the bow.
		to_chat(user, "[src] shatters into a scattering of overstressed metal shards as it leaves the crossbow.")
		var/obj/item/shard/shrapnel/S = new()
		S.dropInto(loc)
		qdel(src)

/obj/item/gun/long/crossbow
	name = "powered crossbow"
	desc = "A modern twist on an old classic. Pick up that can."
	icon = 'icons/obj/guns/launcher/crossbow.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_BACK
	barrel = /obj/item/firearm_component/barrel/launcher/crossbow
	receiver = /obj/item/firearm_component/receiver/launcher/crossbow

/*////////////////////////////
//	Rapid Crossbow Device	//
*/////////////////////////////

/obj/item/arrow/rapidcrossbowdevice
	name = "flashforged bolt"
	desc = "The ultimate ghetto deconstruction implement."
	throwforce = 4

/obj/item/gun/long/crossbow/rapidcrossbowdevice
	name = "rapid crossbow device"
	desc = "A hacked RCD turns an innocent construction tool into the penultimate deconstruction tool. Flashforges bolts using matter units when the string is drawn back."
	icon = 'icons/obj/guns/launcher/rcd_bow.dmi'
	slot_flags = null
	receiver = /obj/item/firearm_component/receiver/launcher/crossbow/matter
