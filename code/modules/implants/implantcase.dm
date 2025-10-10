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

// TODO: the name stuff here probably doesn't work, this needs an update_name override
/obj/item/implantcase/attackby(obj/item/used_item, mob/user)
	if (IS_PEN(used_item))
		var/label = input(user, "What would you like the label to be?", src.name, null)
		// As input() blocks, we need to do some sanity checks
		if (user.get_active_held_item() != used_item)
			return TRUE
		if(!CanPhysicallyInteract(user))
			return TRUE
		label = sanitize_safe(label, MAX_NAME_LEN)
		if(label)
			SetName("glass case - '[label]'")
			desc = "A case containing \a [label] implant."
		else
			SetName(initial(name))
			desc = "A case containing an implant."
		return TRUE
	else if(istype(used_item, /obj/item/chems/syringe) && istype(imp,/obj/item/implant/chem))
		return imp.attackby(used_item,user)
	else if (istype(used_item, /obj/item/implanter))
		var/obj/item/implanter/M = used_item
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
		return TRUE
	else if (istype(used_item, /obj/item/implant) && user.try_unequip(used_item, src))
		to_chat(user, SPAN_NOTICE("You slide \the [used_item] into \the [src]."))
		imp = used_item
		update_description()
		update_icon()
		return TRUE
	return ..()