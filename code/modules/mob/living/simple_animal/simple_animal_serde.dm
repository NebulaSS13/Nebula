// Very basic serde for simple animals for things like the Shaded Hills submap.
/mob/living/simple_animal/ShouldSerialize(_age)
	return simulated

/mob/living/simple_animal/GetPossiblySerializableInstances()
	return list(src)

/mob/living/simple_animal/Serialize()
	. = ..()

	SERIALIZE_IF_MODIFIED(name, /mob/living/simple_animal)
	SERIALIZE_IF_MODIFIED(desc, /mob/living/simple_animal)
	SERIALIZE_IF_MODIFIED(icon_state, /mob/living/simple_animal)

	SERIALIZE_IF_MODIFIED(purge, /mob/living/simple_animal)
	SERIALIZE_IF_MODIFIED(eye_color, /mob/living/simple_animal)
	SERIALIZE_IF_MODIFIED(brute_damage, /mob/living/simple_animal)
	SERIALIZE_IF_MODIFIED(burn_damage, /mob/living/simple_animal)
	SERIALIZE_IF_MODIFIED(gene_damage, /mob/living/simple_animal)

	var/list/defaults = get_default_animal_colours()
	var/changed_from_defaults = length(defaults) != length(draw_visible_overlays)
	if(!changed_from_defaults && islist(draw_visible_overlays))
		for(var/animal_color in defaults)
			if(!(animal_color in draw_visible_overlays) || defaults[animal_color] != draw_visible_overlays[animal_color])
				changed_from_defaults = TRUE
				break
		if(!changed_from_defaults)
			for(var/animal_color in draw_visible_overlays)
				if(!(animal_color in defaults) || defaults[animal_color] != draw_visible_overlays[animal_color])
					changed_from_defaults = TRUE
					break
	if(changed_from_defaults)
		SERIALIZE_VALUE(draw_visible_overlays, /mob/living/simple_animal, json_encode(draw_visible_overlays))
