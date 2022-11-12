/obj/item/organ/internal/proc/handle_shackled(var/given_lawset)
	return

/obj/item/organ/internal/posibrain/handle_shackled(var/given_lawset)
	..()
	update_icon()

/obj/item/organ/internal/posibrain/examine(mob/user)
	. = ..()
	if(owner?.mind?.shackle)
		. += SPAN_WARNING("It is clamped in a set of metal straps with a complex digital lock.")

/obj/item/organ/internal/posibrain/on_update_icon()
	. = ..()
	if(owner?.mind?.shackle)
		add_overlay("posibrain-shackles")
