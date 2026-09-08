// Constantly emits radiation from the tile it's placed on.
/obj/abstract/map_effect/radiation_emitter
	name = "radiation emitter"
	icon_state = "radiation_emitter"
	var/radiation_power = 30 // Bigger numbers means more radiation.

/obj/abstract/map_effect/radiation_emitter/Initialize()
	START_PROCESSING(SSobj, src)
	return ..()

/obj/abstract/map_effect/radiation_emitter/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/abstract/map_effect/radiation_emitter/Process()
	SSradiation.radiate(src, radiation_power)

/obj/abstract/map_effect/radiation_emitter/strong
	radiation_power = 100
