//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/implantcase
	name = "glass case"
	desc = "A case containing an implant."
	icon = 'icons/obj/items/implant/implantcase.dmi'
	icon_state = "implantcase-0"
	item_state = "implantcase"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_TINY
	material = /decl/material/solid/metal/aluminium
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	var/obj/item/implant/imp = null

/obj/item/implantcase/Initialize()
	. = ..()
	if(ispath(imp))
		imp = new imp(src)
		update_description()
	update_icon()

/obj/item/implantcase/Destroy()
	QDEL_NULL(imp)
	. = ..()

/obj/item/implantcase/proc/update_description()
	if (imp)
		desc = "A case containing \a [imp]."
		origin_tech = imp.get_origin_tech()
	else
		desc = "A case for implants."
		origin_tech = null

/obj/item/implantcase/on_update_icon()
	. = ..()
	if (imp)
		icon_state = "implantcase-[imp.implant_color]"
	else
		icon_state = "implantcase-0"

/obj/item/implantcase/attackby(obj/item/I, mob/user)
	if (IS_PEN(I))
		var/t = input(user, "What would you like the label to be?", src.name, null)
		if (user.get_active_hand() != I)
			return
		if((!in_range(src, usr) && loc != user))
			return
		t = sanitize_safe(t, MAX_NAME_LEN)
		if(t)
			SetName("glass case - '[t]'")
			desc = "A case containing \a [t] implant."
		else
			SetName(initial(name))
			desc = "A case containing an implant."
	else if(istype(I, /obj/item/chems/syringe))
		if(istype(imp,/obj/item/implant/chem))
			imp.attackby(I,user)
	else if (istype(I, /obj/item/implanter))
		var/obj/item/implanter/M = I
		if (M.imp && !imp && !M.imp.implanted)
			M.imp.forceMove(src)
			imp = M.imp
			M.imp = null
		else if (imp && !M.imp)
			imp.forceMove(M)
			M.imp = src.imp
			imp = null
		update_description()
		update_icon()
		M.update_icon()
	else if (istype(I, /obj/item/implant) && user.try_unequip(I, src))
		to_chat(usr, "<span class='notice'>You slide \the [I] into \the [src].</span>")
		imp = I
		update_description()
		update_icon()
	else
		return ..()