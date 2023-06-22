/obj/item/implanter
	name = "implanter"
	icon = 'icons/obj/items/implant/implanter.dmi'
	icon_state = "implanter0"
	item_state = "syringe_0"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/metal/aluminium
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	var/obj/item/implant/imp = null

/obj/item/implanter/Initialize()
	. = ..()
	if(ispath(imp))
		imp = new imp(src)
	update_icon()

/obj/item/implanter/Destroy()
	QDEL_NULL(imp)
	. = ..()

/obj/item/implanter/on_update_icon()
	. = ..()
	icon_state = "implanter[imp == TRUE]"

/obj/item/implanter/verb/remove_implant()
	set category = "Object"
	set name = "Remove implant"
	set src in usr

	if(issilicon(usr))
		return

	if(can_use(usr))
		if(!imp)
			to_chat(usr, "<span class='notice'>There is no implant to remove.</span>")
			return
		imp.forceMove(get_turf(src))
		usr.put_in_hands(imp)
		to_chat(usr, "<span class='notice'>You remove \the [imp] from \the [src].</span>")
		name = "implanter"
		imp = null
		update_icon()
		return
	else
		to_chat(usr, "<span class='notice'>You cannot do this in your current condition.</span>")

/obj/item/implanter/proc/can_use()

	if(!ismob(loc))
		return 0

	var/mob/M = loc

	if(M.incapacitated())
		return 0
	if((src in M.contents) || (isturf(loc) && in_range(src, M)))
		return 1
	return 0

/obj/item/implanter/attackby(obj/item/I, mob/user)
	if(!imp && istype(I, /obj/item/implant) && user.try_unequip(I,src))
		to_chat(usr, "<span class='notice'>You slide \the [I] into \the [src].</span>")
		imp = I
		update_icon()
	else
		..()

/obj/item/implanter/attack(mob/M, mob/user)
	if (!istype(M, /mob/living/carbon))
		return
	if (user && src.imp)
		M.visible_message("<span class='warning'>[user] is attemping to implant [M].</span>")

		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		user.do_attack_animation(M)

		var/target_zone = user.get_target_zone()
		if(src.imp.can_implant(M, user, target_zone))
			var/imp_name = imp.name

			if(do_after(user, 50, M) && src.imp.implant_in_mob(M, target_zone))
				M.visible_message("<span class='warning'>[M] has been implanted by [user].</span>")
				admin_attack_log(user, M, "Implanted using \the [src] ([imp_name])", "Implanted with \the [src] ([imp_name])", "used an implanter, \the [src] ([imp_name]), on")

				src.imp = null
				update_icon()
