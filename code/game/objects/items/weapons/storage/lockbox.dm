//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/lockbox
	name = "lockbox"
	desc = "A locked box."
	icon = 'icons/obj/items/storage/lockbox.dmi'
	icon_state = "lockbox+l"
	item_state = "syringe_kit"
	w_class = ITEM_SIZE_HUGE
	storage = /datum/storage/lockbox
	req_access = list(access_armory)
	material = /decl/material/solid/metal/stainlesssteel

	var/locked = 1
	var/broken = 0
	var/icon_locked = "lockbox+l"
	var/icon_closed = "lockbox"
	var/icon_broken = "lockbox+b"


/obj/item/lockbox/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/card/id))
		if(src.broken)
			to_chat(user, "<span class='warning'>It appears to be broken.</span>")
			return
		if(src.allowed(user))
			src.locked = !( src.locked )
			if(src.locked)
				src.icon_state = src.icon_locked
				to_chat(user, "<span class='notice'>You lock \the [src]!</span>")
				storage?.close_all()
				return
			else
				src.icon_state = src.icon_closed
				to_chat(user, "<span class='notice'>You unlock \the [src]!</span>")
				return
		else
			to_chat(user, "<span class='warning'>Access Denied</span>")
	else if(istype(W, /obj/item/energy_blade))
		var/obj/item/energy_blade/blade = W
		if(blade.is_special_cutting_tool() && emag_act(INFINITY, user, W, "The locker has been sliced open by [user] with an energy blade!", "You hear metal being sliced and sparks flying."))
			spark_at(src.loc, amount=5)
			playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
	if(!locked)
		..()
	else
		to_chat(user, "<span class='warning'>It's locked!</span>")
	return

/obj/item/lockbox/emag_act(var/remaining_charges, var/mob/user, var/emag_source, var/visual_feedback = "", var/audible_feedback = "")
	if(!broken)
		if(visual_feedback)
			visual_feedback = "<span class='warning'>[visual_feedback]</span>"
		else
			visual_feedback = "<span class='warning'>The locker has been sliced open by [user] with an electromagnetic card!</span>"
		if(audible_feedback)
			audible_feedback = "<span class='warning'>[audible_feedback]</span>"
		else
			audible_feedback = "<span class='warning'>You hear a faint electrical spark.</span>"

		broken = 1
		locked = 0
		desc = "It appears to be broken."
		icon_state = src.icon_broken
		visible_message(visual_feedback, audible_feedback)
		return 1

/obj/item/lockbox/loyalty
	name = "lockbox of loyalty implants"
	req_access = list(access_security)

/obj/item/lockbox/loyalty/WillContain()
	return list(
		/obj/item/implantcase/loyalty = 3,
		/obj/item/implanter/loyalty
	)

/obj/item/lockbox/clusterbang
	name = "lockbox of clusterbangs"
	desc = "You have a bad feeling about opening this."
	req_access = list(access_security)

/obj/item/lockbox/clusterbang/WillContain()
	return list(/obj/item/grenade/flashbang/clusterbang)
