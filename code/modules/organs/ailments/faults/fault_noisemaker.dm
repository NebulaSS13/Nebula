/datum/ailment/fault/noisemaker
	name = "noisemaker"

/datum/ailment/fault/noisemaker/on_ailment_event()
	organ.owner.audible_message(SPAN_DANGER("[organ.owner]'s [organ.name] emits a loud, piezoelectric screal."), hearing_distance = 7)
	playsound(organ.owner, 'sound/machines/screal.ogg', 100, 1, 4, ignore_walls = FALSE, zrange = 1)
