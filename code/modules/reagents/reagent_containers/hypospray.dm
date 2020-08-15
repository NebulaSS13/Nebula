////////////////////////////////////////////////////////////////////////////////
/// HYPOSPRAY
////////////////////////////////////////////////////////////////////////////////

/obj/item/chems/hypospray //obsolete, use hypospray/vial for the actual hypospray item
	name = "hypospray"
	desc = "A sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "hypo"
	origin_tech = "{'materials':4,'biotech':5}"
	amount_per_transfer_from_this = 5
	unacidable = 1
	volume = 30
	possible_transfer_amounts = null
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	slot_flags = SLOT_LOWER_BODY

	// autoinjectors takes less time than a normal syringe (overriden for hypospray).
	// This delay is only applied when injecting concious mobs, and is not applied for self-injection
	// The 1.9 factor scales it so it takes the following number of seconds:
	// NONE   1.47
	// BASIC  1.00
	// ADEPT  0.68
	// EXPERT 0.53
	// PROF   0.39
	var/time = (1 SECONDS) / 1.9
	var/single_use = TRUE // autoinjectors are not refillable (overriden for hypospray)

/obj/item/chems/hypospray/attack(mob/living/M, mob/user)
	if(!reagents.total_volume)
		to_chat(user, "<span class='warning'>[src] is empty.</span>")
		return
	if (!istype(M))
		return

	var/allow = M.can_inject(user, check_zone(user.zone_sel.selecting, M))
	if(!allow)
		return

	if (allow == INJECTION_PORT)
		if(M != user)
			user.visible_message(SPAN_WARNING("\The [user] begins hunting for an injection port on \the [M]'s suit!"))
		else
			to_chat(user, SPAN_NOTICE("You begin hunting for an injection port on your suit."))
		if(!user.do_skilled(INJECTION_PORT_DELAY, SKILL_MEDICAL, M))
			return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(M)

	if(user != M && !M.incapacitated() && time) // you're injecting someone else who is concious, so apply the device's intrisic delay
		to_chat(user, SPAN_WARNING("\The [user] is trying to inject \the [M] with \the [name]."))
		if(!user.do_skilled(time, SKILL_MEDICAL, M))
			return

	if(single_use && reagents.total_volume <= 0) // currently only applies to autoinjectors
		atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER // Prevents autoinjectors to be refilled.

	to_chat(user, "<span class='notice'>You inject [M] with [src].</span>")
	to_chat(M, "<span class='notice'>You feel a tiny prick!</span>")
	playsound(src, 'sound/effects/hypospray.ogg',25)
	user.visible_message("<span class='warning'>[user] injects [M] with [src].</span>")

	if(M.reagents)
		var/contained = REAGENT_LIST(src)
		var/trans = reagents.trans_to_mob(M, amount_per_transfer_from_this, CHEM_INJECT)
		admin_inject_log(user, M, src, contained, trans)
		to_chat(user, "<span class='notice'>[trans] units injected. [reagents.total_volume] units remaining in \the [src].</span>")

	return

/obj/item/chems/hypospray/vial
	name = "hypospray"
	item_state = "autoinjector"
	desc = "A sterile, air-needle autoinjector for rapid administration of drugs to patients. Uses a replacable 30u vial."
	possible_transfer_amounts = @"[1,2,5,10,15,20,30]"
	amount_per_transfer_from_this = 5
	volume = 0
	time = 0 // hyposprays are instant for conscious people
	single_use = FALSE
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE
	)
	var/obj/item/chems/glass/beaker/vial/loaded_vial

/obj/item/chems/hypospray/vial/Initialize()
	. = ..()
	loaded_vial = new /obj/item/chems/glass/beaker/vial(src)
	volume = loaded_vial.volume
	reagents.maximum_volume = loaded_vial.reagents.maximum_volume

/obj/item/chems/hypospray/vial/proc/remove_vial(mob/user, swap_mode)
	if(!loaded_vial)
		return
	reagents.trans_to_holder(loaded_vial.reagents,volume)
	reagents.maximum_volume = 0
	loaded_vial.update_icon()
	user.put_in_hands(loaded_vial)
	loaded_vial = null
	if (swap_mode != "swap") // if swapping vials, we will print a different message in another proc
		to_chat(user, "You remove the vial from the [src].")

/obj/item/chems/hypospray/vial/attack_hand(mob/user)
	if(user.is_holding_offhand(src))
		if(!loaded_vial)
			to_chat(user, "<span class='notice'>There is no vial loaded in the [src].</span>")
			return
		remove_vial(user)
		update_icon()
		playsound(loc, 'sound/weapons/flipblade.ogg', 50, 1)
		return
	return ..()

/obj/item/chems/hypospray/vial/attackby(obj/item/W, mob/user)
	var/usermessage = ""
	if(istype(W, /obj/item/chems/glass/beaker/vial))
		if(!do_after(user,10) || !(W in user))
			return 0
		if(!user.unEquip(W, src))
			return
		if(loaded_vial)
			remove_vial(user, "swap")
			usermessage = "You load \the [W] into \the [src] as you remove the old one."
		else
			usermessage = "You load \the [W] into \the [src]."
		if(ATOM_IS_OPEN_CONTAINER(W))
			W.atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
			W.update_icon()
		loaded_vial = W
		reagents.maximum_volume = loaded_vial.reagents.maximum_volume
		loaded_vial.reagents.trans_to_holder(reagents,volume)
		user.visible_message("<span class='notice'>[user] has loaded [W] into \the [src].</span>","<span class='notice'>[usermessage]</span>")
		update_icon()
		playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
		return
	..()

/obj/item/chems/hypospray/vial/afterattack(obj/target, mob/user, proximity) // hyposprays can be dumped into, why not out? uses standard_pour_into helper checks.
	if(!proximity)
		return
	standard_pour_into(user, target)

/obj/item/chems/hypospray/autoinjector
	name = "autoinjector"
	desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	icon_state = "injector"
	item_state = "autoinjector"
	amount_per_transfer_from_this = 5
	volume = 5
	origin_tech = "{'materials':2,'biotech':2}"
	slot_flags = SLOT_LOWER_BODY | SLOT_EARS
	w_class = ITEM_SIZE_TINY
	var/list/starts_with = list(/decl/material/liquid/adrenaline = 5)
	var/band_color = COLOR_CYAN

/obj/item/chems/hypospray/autoinjector/Initialize()
	. = ..()
	for(var/T in starts_with)
		reagents.add_reagent(T, starts_with[T])
	update_icon()

/obj/item/chems/hypospray/autoinjector/attack(mob/M as mob, mob/user as mob)
	..()
	update_icon()

/obj/item/chems/hypospray/autoinjector/on_update_icon()
	overlays.Cut()
	if(reagents.total_volume > 0)
		icon_state = "[initial(icon_state)]1"
	else
		icon_state = "[initial(icon_state)]0"
	overlays+= overlay_image(icon,"injector_band",band_color,RESET_COLOR)

/obj/item/chems/hypospray/autoinjector/examine(mob/user)
	. = ..(user)
	if(reagents?.total_volume)
		to_chat(user, "<span class='notice'>It is currently loaded.</span>")
	else
		to_chat(user, "<span class='notice'>It is spent.</span>")

/obj/item/chems/hypospray/autoinjector/detox
	name = "autoinjector (antitox)"
	band_color = COLOR_GREEN
	starts_with = list(/decl/material/liquid/antitoxins = 5)

/obj/item/chems/hypospray/autoinjector/pain
	name = "autoinjector (painkiller)"
	band_color = COLOR_PURPLE
	starts_with = list(/decl/material/liquid/painkillers = 5)

/obj/item/chems/hypospray/autoinjector/antirad
	name = "autoinjector (anti-rad)"
	band_color = COLOR_AMBER
	starts_with = list(/decl/material/liquid/antirads = 5)

/obj/item/chems/hypospray/autoinjector/hallucinogenics
	name = "autoinjector"
	band_color = COLOR_DARK_GRAY
	starts_with = list(/decl/material/liquid/hallucinogenics = 5)

/obj/item/chems/hypospray/autoinjector/empty
	name = "autoinjector"
	band_color = COLOR_WHITE
	starts_with = list()
	material = /decl/material/solid/plastic
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)