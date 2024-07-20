//#TODO: Maybe get the surface area of something instead of using sizes since they're not very accurate
///Returns the amount of sheets of wrapping paper that the given object would need to be wrapped.
/atom/movable/proc/wrapping_paper_needed_to_wrap()
	CRASH("Tried to get the amount of paper sheets needed to wrap invalid object type '[type]'.")

/obj/wrapping_paper_needed_to_wrap()
	return min(w_class, 8) //At most, since 20 sheets is a bit much for structures

/mob/living/wrapping_paper_needed_to_wrap()
	//Mob size is scaled weirdly, so we have to slap it through a switch
	var/nb_sheets = 1
	switch(mob_size)
		if(MOB_SIZE_LARGE)
			nb_sheets = 15
		if(MOB_SIZE_MEDIUM)
			nb_sheets = 10
		if(MOB_SIZE_SMALL)
			nb_sheets = 5
		if(MOB_SIZE_TINY)
			nb_sheets = 2
	return nb_sheets

///////////////////////////////////////////////////////////////////////////////////////
// Parcel Wrapper
///////////////////////////////////////////////////////////////////////////////////////
/obj/item/stack/package_wrap
	name               = "package wrapper roll"
	desc               = "Heavy duty brown paper used to wrap packages to protect them during shipping."
	icon               = 'icons/obj/items/gift_wrapper.dmi'
	icon_state         = "deliveryPaper"
	singular_name      = "sheet"
	w_class            = ITEM_SIZE_NORMAL
	max_amount         = 50
	material           = /decl/material/solid/organic/paper
	throw_range        = 5
	throw_speed        = 3
	item_flags         = ITEM_FLAG_NO_BLUDGEON
	_base_attack_force = 1
	/// Check to prevent people from wrapping something multiple times at once.
	var/tmp/currently_wrapping = FALSE
	/// The type of wrapped item that will be produced
	var/tmp/wrapped_result_type = /obj/item/parcel

/obj/item/stack/package_wrap/twenty_five
	amount = 25
/obj/item/stack/package_wrap/fifty
	amount = 50

/obj/item/stack/package_wrap/can_split()
	return FALSE //Don't allow splitting the stacks, because it would create cardboard tubes out of nowhere

/obj/item/stack/package_wrap/proc/can_wrap(var/atom/movable/AM)
	return istype(AM) && AM.simulated && !AM.anchored && !is_type_in_list(AM, get_blacklist()) && (isobj(AM) || ishuman(AM))

///Attempts wrapping the given object. Returns the wrapper object containing the wrapped object.
/obj/item/stack/package_wrap/proc/wrap(var/atom/movable/AM, var/mob/user)
	if(currently_wrapping && user)
		return
	if(AM == user)
		to_chat(user, SPAN_WARNING("You cannot wrap yourself!"))
		return
	if(ishuman(AM))
		var/mob/living/human/H = AM
		if(!H.incapacitated(INCAPACITATION_DISABLED | INCAPACITATION_RESTRAINED))
			if(user)
				to_chat(user, SPAN_WARNING("\The [H] is moving around too much. Restrain or incapacitate them first."))
			return

	var/paper_to_use = AM.wrapping_paper_needed_to_wrap()
	if(!can_use(paper_to_use))
		if(user)
			to_chat(user, SPAN_WARNING("There isn't enough [plural_name] in \the [src] to wrap \the [AM]!"))
		return

	currently_wrapping = TRUE
	if(user && !user.do_skilled(clamp(paper_to_use, 2, 6) SECONDS, SKILL_HAULING, AM))
		currently_wrapping = FALSE
		return
	. = create_wrapper(AM, user)
	if(.)
		use(paper_to_use)
	else if(user)
		to_chat(user, SPAN_WARNING("You cannot wrap \the [AM]!"))
	currently_wrapping = FALSE

///Create the wrapper object and put the wrapped thing inside of it.
/obj/item/stack/package_wrap/proc/create_wrapper(var/atom/movable/target, var/mob/user)
	if(isobj(target))
		var/obj/item/parcel/wrapper = new wrapped_result_type(get_turf(target))
		if(wrapper.make_parcel(target, user)) //Call this directly so it applies our fingerprints
			. = wrapper
		else
			log_warning("Failed to create_wrapper() on \the '[target]'('[target.type]')([target.x], [target.y], [target.z]) with \the '[src]'('[type]')([x], [y], [z]).")
			qdel(wrapper)

	else if(ishuman(target))
		var/mob/living/human/H = target
		if(H.incapacitated(INCAPACITATION_DISABLED | INCAPACITATION_RESTRAINED))
			var/obj/item/parcel/wrapper = new wrapped_result_type(get_turf(target))
			if(wrapper.make_parcel(target, user)) //Call this directly so it applies our fingerprints
				admin_attack_log(user, H, "Used \a [src] to wrap their victim", "Was wrapepd with \a [src]", "used \the [src] to wrap")
				. = wrapper
			else
				log_warning("Failed to create_wrapper() on \the '[target]'('[target.type]')([target.x], [target.y], [target.z]) with \the '[src]'('[type]')([x], [y], [z]).")
				qdel(wrapper)

		else if(user)
			to_chat(user, SPAN_WARNING("\The [target] moving around too much. Restrain or incapacitate them first."))

/obj/item/stack/package_wrap/afterattack(var/obj/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag || !can_wrap(target) || (user.isEquipped(target) && !user.canUnEquip(target)))
		return
	user.setClickCooldown(attack_cooldown)
	return wrap(target, user) || ..()

/obj/item/stack/package_wrap/on_used_last()
	var/mob/M = loc
	. = ..()
	//Drop the cardboard tube after we're emptied out
	var/obj/item/c_tube/tube = new(get_turf(M))
	if(istype(M))
		M.put_in_active_hand(tube)

/obj/item/stack/package_wrap/create_matter()
	. = ..()
	//Cardboard for the tube, isn't in the matter_per_piece list, has to be added after that's been initialized
	LAZYSET(matter, /decl/material/solid/organic/cardboard, MATTER_AMOUNT_PRIMARY * HOLLOW_OBJECT_MATTER_MULTIPLIER)

/obj/item/stack/package_wrap/update_matter()
	//Keep track of the cardboard amount to prevent it creating infinite cardboard matter each times the stack changes
	var/cardboard_amount = LAZYACCESS(matter, /decl/material/solid/organic/cardboard)
	matter = list()
	for(var/mat in matter_per_piece)
		matter[mat] = (matter_per_piece[mat] * amount)
	matter[/decl/material/solid/organic/cardboard] = cardboard_amount

///Types that the wrapper cannot wrap, ever
/obj/item/stack/package_wrap/proc/get_blacklist()
	var/static/list/wrap_blacklist = list(
		/obj/item/parcel,
		/obj/item/parcel/gift,
		/obj/item/evidencebag,
		/obj/item/stack/package_wrap,
	)
	return wrap_blacklist

///////////////////////////////////////////////////////////////////////////////////////
// Gift Wrapper
///////////////////////////////////////////////////////////////////////////////////////
/**
 * Variant of the wrapping paper that result in gift wrapped items.
 */
/obj/item/stack/package_wrap/gift
	name                = "gift wrapping paper roll"
	desc                = "You can use this to wrap items in."
	icon_state          = "wrap_paper"
	wrapped_result_type = /obj/item/parcel/gift

/obj/item/stack/package_wrap/gift/twenty_five
	amount = 25
/obj/item/stack/package_wrap/gift/fifty
	amount = 50

///////////////////////////////////////////////////////////////////////////////////////
// Borg Wrapping Paper Synthesizer
///////////////////////////////////////////////////////////////////////////////////////
/obj/item/stack/package_wrap/cyborg
	name              = "package wrapper synthesizer"
	gender            = NEUTER
	material          = null
	matter            = null
	uses_charge       = TRUE
	charge_costs      = list(1)
	stack_merge_type  = /obj/item/stack/package_wrap
	is_spawnable_type = FALSE

///////////////////////////////////////////////////////////////////////////////////////
// Cardboard Tube
///////////////////////////////////////////////////////////////////////////////////////
/**
 * Basically a trash item left from using paper rolls.
 */
/obj/item/c_tube
	name        = "cardboard tube"
	desc        = "A tube... of cardboard."
	icon        = 'icons/obj/items/gift_wrapper.dmi'
	icon_state  = "c_tube"
	w_class     = ITEM_SIZE_NORMAL
	throw_speed = 4
	throw_range = 5
	material    = /decl/material/solid/organic/cardboard
	obj_flags   = OBJ_FLAG_HOLLOW
