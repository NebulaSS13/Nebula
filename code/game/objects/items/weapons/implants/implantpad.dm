/obj/item/implantpad
	name = "implant pad"
	desc = "Used to reprogramm implants."
	icon = 'icons/obj/items/implant/implantpad.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/metal/steel
	var/obj/item/implant/imp

/obj/item/implantpad/on_update_icon()
	. = ..()
	if(imp)
		add_overlay("[icon_state]-imp")

/obj/item/implantpad/attack_hand(mob/user)
	if(!imp || (src in user.get_held_items()) || !user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return ..()
	user.put_in_active_hand(imp)
	imp.add_fingerprint(user)
	add_fingerprint(user)
	imp = null
	update_icon()
	return TRUE

/obj/item/implantpad/attackby(obj/item/I, mob/user)
	..()
	if(istype(I, /obj/item/implantcase))
		var/obj/item/implantcase/C = I
		if(!imp && C.imp)
			C.imp.forceMove(src)
			imp = C.imp
			C.imp = null
		else if (imp && !C.imp)
			imp.forceMove(C)
			C.imp = imp
			imp = null
		C.update_icon()
	else if(istype(I, /obj/item/implanter))
		var/obj/item/implanter/C = I
		if(!imp && C.imp)
			C.imp.forceMove(src)
			imp = C.imp
			C.imp = null
		else if (imp && !C.imp)
			imp.forceMove(C)
			C.imp = imp
			imp = null
		C.update_icon()
	else if(istype(I, /obj/item/implant) && user.try_unequip(I, src))
		imp = I
	update_icon()

/obj/item/implantpad/attack_self(mob/user)
	if (imp)
		imp.interact(user)
	else
		to_chat(user,"<span class='warning'>There's no implant loaded in \the [src].</span>")