//Inhalers
//Just like hypopsray code
/obj/item/chems/inhaler
	name = "autoinhaler"
	desc = "A rapid and safe way to administer small amounts of drugs into the lungs by untrained or trained personnel."
	icon = 'icons/obj/syringe.dmi'
	item_state = "autoinjector"
	icon_state = "autoinhaler"
	center_of_mass = @"{'x':16,'y':11}"
	unacidable = TRUE
	amount_per_transfer_from_this = 5
	volume = 5
	w_class = ITEM_SIZE_SMALL
	possible_transfer_amounts = null
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	slot_flags = SLOT_LOWER_BODY
	origin_tech = "{'materials':2,'biotech':2}"
	var/used = FALSE
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)
	var/list/starts_with = null /// A lazylist of starting reagents. Example: list(/decl/material/liquid/adrenaline = 5)
	var/band_color = COLOR_GREEN

/obj/item/chems/inhaler/Initialize()
	. = ..()
	for(var/T in starts_with)
		reagents.add_reagent(T, starts_with[T])
	update_icon()

/obj/item/chems/inhaler/on_update_icon()
	cut_overlays()
	if(ATOM_IS_OPEN_CONTAINER(src))
		add_overlay("[icon_state]_loaded")
	if(reagents.total_volume > 0)
		add_overlay("[icon_state]_reagents")
	add_overlay(overlay_image(icon,"[icon_state]_band",band_color,RESET_COLOR))

/obj/item/chems/inhaler/attack(var/mob/living/carbon/human/target, var/mob/user, var/proximity)
	if (!istype(target))
		return ..()

	if(!proximity)
		return TRUE

	if(!reagents.total_volume)
		to_chat(user, SPAN_WARNING("\The [src] is empty."))
		return TRUE

	// This properly handles mouth coverage/presence, but should probably be replaced later.
	if(user == target)
		if(!target.can_eat(src))
			return TRUE
	else
		if(!target.can_force_feed(user, src))
			return TRUE

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(target)

	if(user == target)
		user.visible_message(SPAN_NOTICE("\The [user] inhales from \the [src]."), SPAN_NOTICE("You stick the \the [src] in your mouth and press the injection button."))
	else
		user.visible_message(SPAN_WARNING("\The [user] attempts to administer \the [src] to \the [target]..."), SPAN_NOTICE("You attempt to administer \the [src] to \the [target]..."))
		if (!do_after(user, 1 SECONDS, target))
			to_chat(user, SPAN_NOTICE("You and the target need to be standing still in order to inject \the [src]."))
			return TRUE

		user.visible_message(SPAN_NOTICE("\The [user] administers \the [src] to \the [target]."), SPAN_NOTICE("You stick \the [src] in \the [target]'s mouth and press the injection button."))

	var/contained = REAGENT_LIST(src)
	var/trans = reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_INHALE)
	if(trans)
		admin_inject_log(user, target, src, contained, trans)
		playsound(src.loc, 'sound/effects/hypospray.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("[trans] units administered. [reagents.total_volume] units remaining in \the [src]."))
		used = TRUE

	update_icon()

	return TRUE

/obj/item/chems/inhaler/attack(mob/M as mob, mob/user as mob)
	if(ATOM_IS_OPEN_CONTAINER(src))
		to_chat(user, SPAN_NOTICE("You must secure the reagents inside \the [src] before using it!"))
		return FALSE
	. = ..()

/obj/item/chems/inhaler/attack_self(mob/user as mob)
	if(ATOM_IS_OPEN_CONTAINER(src))
		if(reagents.total_volume > 0)
			to_chat(user, SPAN_NOTICE("With a quick twist of \the [src]'s lid, you secure the reagents inside."))
			atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER
			update_icon()
		else
			to_chat(user, SPAN_NOTICE("You can't secure \the [src] without putting reagents in!"))
	else
		to_chat(user, SPAN_NOTICE("The reagents inside \the [src] are already secured."))
	return TRUE

/obj/item/chems/inhaler/attackby(obj/item/tool, mob/user)
	if(IS_SCREWDRIVER(tool) && !ATOM_IS_OPEN_CONTAINER(src))
		to_chat(user, SPAN_NOTICE("Using \the [tool], you unsecure the inhaler's lid.")) // it locks shut after being secured
		atom_flags |= ATOM_FLAG_OPEN_CONTAINER
		update_icon()
		return TRUE
	. = ..()

/obj/item/chems/inhaler/examine(mob/user)
	. = ..(user)
	if(reagents.total_volume > 0)
		to_chat(user, SPAN_NOTICE("It is currently loaded."))
	else
		to_chat(user, SPAN_NOTICE("It is spent."))
