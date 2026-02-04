/obj/effect/decal/cleanable
	density = FALSE
	anchored = TRUE
	abstract_type = /obj/effect/decal/cleanable

	var/burnable = TRUE
	var/sweepable = FALSE
	var/weather_sensitive = TRUE
	var/use_legacy_persistence = FALSE
	var/generic_filth = FALSE
	var/list/random_icon_states
	var/image/hud_overlay/hud_overlay
	var/cleanable_scent
	var/scent_type = /datum/extension/scent/custom
	var/scent_intensity = /decl/scent_intensity/normal
	var/scent_descriptor = "smell"
	var/scent_range = 2
	var/have_randomized_icon_state = FALSE

/obj/effect/decal/cleanable/ShouldSerialize(_age)
	return ..() && use_legacy_persistence

/obj/effect/decal/cleanable/GetSerializedType()
	return generic_filth ? /obj/effect/decal/cleanable/filth : ..()

/obj/effect/decal/cleanable/Serialize()
	. = ..()
	SERIALIZE_IF_MODIFIED(icon_state, /atom)

/obj/effect/decal/cleanable/Deserialize(list/instance_map)
	. = ..()
	have_randomized_icon_state = TRUE

/obj/effect/decal/cleanable/Initialize(var/ml, var/_age)
	if(!have_randomized_icon_state && length(random_icon_states))
		icon_state = pick(random_icon_states)
		have_randomized_icon_state = TRUE
	if(!ml)
		if(!isnull(_age))
			age = _age
		if(use_legacy_persistence)
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
	if(use_legacy_persistence)
		SSpersistence.forget_value(src, /decl/persistence_handler/filth)
	. = ..()

/obj/effect/decal/cleanable/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	. = ..()
	if(burnable && !QDELETED(src))
		qdel(src)

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
	if(REAGENT_TOTAL_LIQUID_VOLUME(fluid) && !QDELETED(src))
		if(REAGENT_TOTAL_VOLUME(reagents))
			reagents.trans_to(fluid, REAGENT_TOTAL_VOLUME(reagents))
		qdel(src)
