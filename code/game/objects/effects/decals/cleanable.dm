/obj/effect/decal/cleanable
	density = FALSE
	anchored = TRUE

	var/persistent = FALSE
	var/generic_filth = FALSE
	var/age = 0
	var/list/random_icon_states
	var/image/hud_overlay/hud_overlay
	var/cleanable_scent
	var/scent_type = /datum/extension/scent/custom
	var/scent_intensity = /decl/scent_intensity/normal
	var/scent_descriptor = SCENT_DESC_SMELL
	var/scent_range = 2

/obj/effect/decal/cleanable/Initialize(var/ml, var/_age)
	if(random_icon_states && length(src.random_icon_states) > 0)
		src.icon_state = pick(src.random_icon_states)
	if(!ml)
		if(!isnull(_age))
			age = _age
		SSpersistence.track_value(src, /datum/persistent/filth)

	. = ..()

	hud_overlay = new /image/hud_overlay('icons/effects/hud_tile.dmi', src, "caution")
	hud_overlay.plane = ABOVE_LIGHTING_PLANE
	hud_overlay.layer = ABOVE_LIGHTING_LAYER
	set_cleanable_scent()

	if(isspaceturf(loc))
		animate(src, alpha = 0, time = 5 SECONDS)
		QDEL_IN(src, 5 SECONDS)

/obj/effect/decal/cleanable/Destroy()
	SSpersistence.forget_value(src, /datum/persistent/filth)
	. = ..()

/obj/effect/decal/cleanable/clean_blood(var/ignore = 0)
	if(!ignore)
		qdel(src)
		return TRUE
	. = ..()

/obj/effect/decal/cleanable/proc/set_cleanable_scent()
	if(cleanable_scent)
		set_extension(src, scent_type, cleanable_scent, scent_intensity, scent_descriptor, scent_range)

/obj/effect/decal/cleanable/fluid_act(var/datum/reagents/fluid)
	reagents?.trans_to(fluid, reagents.total_volume)
	qdel(src)
