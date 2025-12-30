// Cut up from https://freesound.org/people/MrAuralization/sounds/274846/ (Avil, MrAuralization) (CC-BY-4)
/datum/composite_sound/anvil_strike
	mid_sounds = list(
		'sound/effects/anvil1.ogg',
		'sound/effects/anvil2.ogg',
		'sound/effects/anvil3.ogg',
		'sound/effects/anvil4.ogg',
		'sound/effects/anvil5.ogg',
	)
	mid_length = 1.5 SECONDS
	var/mob/user

/datum/composite_sound/anvil_strike/Destroy()
	user = null
	return ..()

// This is a bit evil, but it should be cleaner than trying to run a second timing loop for the hammer strikes.
/datum/composite_sound/anvil_strike/play(soundfile)
	. = ..()
	for(var/obj/structure/anvil/anvil in output_atoms)
		if(user)
			user.do_attack_animation(anvil, user.get_active_held_item())
		anvil.shake_animation()
		for(var/obj/item/thing in anvil.loc?.get_contained_external_atoms())
			thing.shake_animation()
		spark_at(get_turf(anvil), amount = 1, spark_type = /datum/effect/effect/system/spark_spread/silent)

/obj/structure/anvil
	name                = "anvil"
	desc                = "A heavy block of material used as support for hammering things into shape."
	icon                = 'mods/content/blacksmithy/icons/anvil.dmi'
	icon_state          = ICON_STATE_WORLD
	anchored            = TRUE
	density             = TRUE
	opacity             = FALSE
	atom_flags          = ATOM_FLAG_CLIMBABLE
	w_class             = ITEM_SIZE_STRUCTURE //_LARGE
	material            = /decl/material/solid/metal/iron
	color               = /decl/material/solid/metal/iron::color
	max_health          = 1000
	structure_flags     = STRUCTURE_FLAG_SURFACE
	material_alteration = MAT_FLAG_ALTERATION_ALL
	hitsound            = 'sound/effects/anvil1.ogg'
	var/datum/composite_sound/anvil_strike/clang

/obj/structure/anvil/Initialize()
	. = ..()
	clang = new(list(src), FALSE)

/obj/structure/anvil/Destroy()
	QDEL_NULL(clang)
	return ..()

/obj/structure/anvil/proc/start_working(mob/user)
	if(clang)
		clang.user = user
		if(!clang.started)
			clang.start()

/obj/structure/anvil/proc/stop_working()
	if(clang)
		clang.user = null
		if(clang.started)
			clang.stop()

/obj/structure/anvil/on_update_icon()
	. = ..()
	icon_state = initial(icon_state)
	switch(get_health_percent())
		if(0 to 0.35)
			icon_state = "[icon_state]-damage-heavy"
		if(0.35 to 0.65)
			icon_state = "[icon_state]-damage-light"

/obj/structure/anvil/attackby(obj/item/used_item, mob/user, click_params)

	// Put the bar from tongs onto the anvil.
	if(istype(used_item, /obj/item/tongs))
		var/obj/item/tongs/tongs = used_item
		if(tongs.holding_bar)
			used_item = tongs.holding_bar
			tongs.holding_bar.dropInto(loc)
			// Flow through into procs below.

	// Put the bar onto the anvil (need to do this to avoid repairs in ..())
	if(istype(used_item, /obj/item/stack/material/bar) && used_item.is_forgable())
		var/obj/item/stack/material/bar/bar = used_item
		if(used_item.material != material || current_health >= get_max_health())
			if(bar.get_amount() > 1)
				bar = bar.split(1)
			if(bar.loc == user)
				if(!user.try_unequip(bar, get_turf(src)))
					return TRUE
			else
				bar.dropInto(get_turf(src))
			qdel(bar)
			used_item = new /obj/item/billet(loc, used_item.material?.type)
			// Flow through to billet placement below.

	// Place things onto the anvil.
	if(!user.check_intent(I_FLAG_HARM) && (istype(used_item, /obj/item/tool/hammer/forge) || istype(used_item, /obj/item/tongs) || istype(used_item, /obj/item/billet)))
		if(used_item.loc == user)
			if(!user.try_unequip(used_item, get_turf(src)))
				return TRUE
		else
			used_item.dropInto(get_turf(src))
		auto_align(used_item, click_params)
		return TRUE

	. = ..()

// Chipped out of a boulder with a pick.
/obj/structure/anvil/boulder
	name_prefix         = "crude"
	icon                = 'mods/content/blacksmithy/icons/anvil_crude.dmi'
	desc                = "A crude anvil chipped out of a chunk of stone. It probably won't last very long."
	material            = /decl/material/solid/stone/granite
	max_health          = 500

/obj/structure/anvil/boulder/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	if(prob(50))
		set_icon('mods/content/blacksmithy/icons/anvil_crude_alt.dmi')

// Improvised with spaceman materials.
/obj/structure/anvil/improvised
	name_prefix         = "improvised"
	icon                = 'mods/content/blacksmithy/icons/anvil_improvised.dmi'
	desc                = "A anvil roughly improvised out of scrap metal. It probably won't last very long."
	material            = /decl/material/solid/metal/steel
	max_health          = 500

/decl/stack_recipe/steel/furniture
	result_type       = /obj/structure/anvil/improvised
	difficulty        = MAT_VALUE_HARD_DIY
