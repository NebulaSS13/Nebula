
/obj/machinery/honey_extractor
	name = "honey extractor"
	desc = "A machine used to extract honey and wax from a beehive frame."
	icon = 'icons/obj/virology.dmi'
	icon_state = "centrifuge"
	anchored = TRUE
	density = TRUE
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

	var/processing = 0
	var/honey = 0

/obj/machinery/honey_extractor/components_are_accessible(path)
	return !processing && ..()

/obj/machinery/honey_extractor/cannot_transition_to(state_path, mob/user)
	if(processing)
		return SPAN_NOTICE("You must wait for \the [src] to finish first!")
	return ..()

/obj/machinery/honey_extractor/attackby(var/obj/item/I, var/mob/user)
	if(processing)
		to_chat(user, "<span class='notice'>\The [src] is currently spinning, wait until it's finished.</span>")
		return
	if((. = component_attackby(I, user)))
		return
	if(istype(I, /obj/item/honey_frame))
		var/obj/item/honey_frame/H = I
		if(!H.honey)
			to_chat(user, "<span class='notice'>\The [H] is empty, put it into a beehive.</span>")
			return
		user.visible_message("<span class='notice'>\The [user] loads \the [H] into \the [src] and turns it on.</span>", "<span class='notice'>You load \the [H] into \the [src] and turn it on.</span>")
		processing = H.honey
		icon_state = "centrifuge_moving"
		qdel(H)
		spawn(50)
			new /obj/item/honey_frame(loc)
			new /obj/item/stack/material/bar/wax(loc, 1)
			honey += processing
			processing = 0
			icon_state = "centrifuge"
	else if(istype(I, /obj/item/chems/glass))
		if(!honey)
			to_chat(user, "<span class='notice'>There is no honey in \the [src].</span>")
			return
		var/obj/item/chems/glass/G = I
		var/transferred = min(G.reagents.maximum_volume - G.reagents.total_volume, honey)
		G.add_to_reagents(/decl/material/liquid/nutriment/honey, transferred)
		honey -= transferred
		user.visible_message("<span class='notice'>\The [user] collects honey from \the [src] into \the [G].</span>", "<span class='notice'>You collect [transferred] units of honey from \the [src] into \the [G].</span>")
		return 1
