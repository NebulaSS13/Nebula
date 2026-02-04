/turf/wall/Serialize()
	. = ..()

	SERIALIZE_DECL_IF_MODIFIED(material, /turf/wall)
	SERIALIZE_DECL_IF_MODIFIED(girder_material, /turf/wall)
	SERIALIZE_DECL_IF_MODIFIED(shutter_material, /turf/wall)

	SERIALIZE_IF_MODIFIED(shutter_state, /turf/wall)
	SERIALIZE_IF_MODIFIED(stripe_color, /turf/wall)
	SERIALIZE_IF_MODIFIED(damage, /turf/wall)
	SERIALIZE_IF_MODIFIED(can_open, /turf/wall)

/turf/wall/Deserialize(list/instance_map)
	. = ..()
	DESERIALIZE_DECL_TO_TYPE(girder_material)
	DESERIALIZE_DECL_TO_TYPE(shutter_material)

/turf/wall/natural/Serialize()
	. = ..()
	SERIALIZE_IF_MODIFIED(ramp_slope_direction, /turf/wall/natural)
