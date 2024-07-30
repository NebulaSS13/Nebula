/obj/effect/decal/cleanable
	density = FALSE
	anchored = TRUE

	var/weather_sensitive = TRUE
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
		if(persistent)
			SSpersistence.track_value(src, /decl/persistence_handler/filth)

	. = ..()

	hud_overlay = new /image/hud_overlay('icons/effects/hud_tile.dmi', src, "caution")
	hud_overlay.plane = ABOVE_LIGHTING_PLANE
	hud_overlay.layer = ABOVE_LIGHTING_LAYER
	set_cleanable_scent()

	if(isspaceturf(loc))
		animate(src, alpha = 0, time = 5 SECONDS)
		QDEL_IN(src, 5 SECONDS)

	if(weather_sensitive)
		SSweather_atoms.weather_atoms += src

/obj/effect/decal/cleanable/Destroy()
	if(weather_sensitive)
		SSweather_atoms.weather_atoms -= src
	if(persistent)
		SSpersistence.forget_value(src, /decl/persistence_handler/filth)
	. = ..()

/obj/effect/decal/cleanable/process_weather(obj/abstract/weather_system/weather, decl/state/weather/weather_state)
	if(!weather_sensitive)
		return PROCESS_KILL
	if(weather_state.is_liquid)
		alpha -= 15
		if(alpha <= 0)
			clean(TRUE)

/obj/effect/decal/cleanable/clean(clean_forensics = TRUE)
	if(clean_forensics)
		qdel(src)
		return TRUE
	return ..()

/obj/effect/decal/cleanable/proc/set_cleanable_scent()
	if(cleanable_scent)
		set_extension(src, scent_type, cleanable_scent, scent_intensity, scent_descriptor, scent_range)

/obj/effect/decal/cleanable/fluid_act(var/datum/reagents/fluid)
	SHOULD_CALL_PARENT(FALSE)
	if(fluid?.total_volume && !QDELETED(src))
		if(reagents?.total_volume)
			reagents.trans_to(fluid, reagents.total_volume)
		qdel(src)
