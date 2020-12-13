/datum/ailment/fault/noisemaker/on_malfunction()
	organ.owner.audible_message(SPAN_DANGER("[organ.owner]'s body emits a loud, piezoelectric screal."), hearing_distance = 7)
	playsound(organ.owner, 'sound/machines/screal.ogg', 100, 1, 4, ignore_walls = FALSE, zrange = 1)
