/obj/item/cynosure_prop
	abstract_type = /obj/item/cynosure_prop
	icon = 'maps/cynosure/icons/props.dmi'
	var/emits_radiation

/obj/item/cynosure_prop/Initialize()
	if(emits_radiation)
		START_PROCESSING(SSobj, src)
	return ..()

/obj/item/cynosure_prop/Process()
	..()
	SSradiation.radiate(src, emits_radiation)

/obj/item/cynosure_prop/Destroy()
	if(emits_radiation)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/cynosure_prop/pascalb
	name = "misshapen manhole cover"
	desc = "The top of this twisted chunk of metal is faintly stamped with a five pointed star. 'Property of US Army, Pascal B - 1957'."
	icon_state = "pascalb"
	emits_radiation = 5

/obj/item/cynosure_prop/brokenoldreactor
	icon_state = "poireactor_broken"
	name = "ruptured fission reactor rack"
	desc = "This broken hunk of machinery looks extremely dangerous."
	emits_radiation = 25
