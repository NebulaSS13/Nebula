/obj/item/organ/internal/augment/faulty/noisemaker
	name = "noisemaker"
	desc = "An augment that was badly installed. Sometimes it emits a loud noise."

/obj/item/organ/internal/augment/faulty/noisemaker/on_malfunction()
	owner.audible_message(SPAN_DANGER("[owner]'s body emits a loud, piezoelectric screal."), hearing_distance = 7)
	playsound(owner, 'sound/machines/screal.ogg', 100, 1, 4, ignore_walls = FALSE, zrange = 1)