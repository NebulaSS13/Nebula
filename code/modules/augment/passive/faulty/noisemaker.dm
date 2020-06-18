/obj/item/organ/internal/augment/faulty/noisemaker
	name = "noisemaker"
	desc = "An augment that was badly installed. Sometimes it emits a loud noise."

/obj/item/organ/internal/augment/faulty/noisemaker/on_malfunction()
	owner.audible_message(SPAN_DANGER("[owner]'s body emits a loud, piezoelectric beep."), hearing_distance = 7)