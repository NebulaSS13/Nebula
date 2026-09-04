/obj/item/food/donkpocket
	name = "cold donk-pocket"
	desc = "The food of choice for the seasoned traitor."
	icon = 'icons/obj/food/donkpocket.dmi'
	filling_color = "#dedeab"
	center_of_mass = @'{"x":16,"y":10}'
	nutriment_desc = list("heartiness" = 1, "dough" = 2)
	nutriment_amt = 2
	var/warm = 0
	var/list/heated_reagents = list(/decl/material/liquid/regenerator = 5)

/obj/item/food/donkpocket/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 2)

/obj/item/food/donkpocket/grill(var/atom/heat_source)

	backyard_grilling_rawness--
	if(backyard_grilling_rawness <= 0)
		backyard_grilling_rawness = initial(backyard_grilling_rawness)

		// We're already warm, so we burn.
		if(warm)
			var/obj/item/food/badrecipe/whoops = new
			whoops.dropInto(loc)
			visible_message(SPAN_DANGER("\The [src] chars and blackens!"))
			qdel(src)
			return whoops

		// Otherwise we just warm up.
		heat()
		visible_message(SPAN_NOTICE("\The [src] steams gently!"))
		return src

/obj/item/food/donkpocket/proc/heat()
	if(warm)
		return
	warm = 1
	for(var/reagent in heated_reagents)
		add_to_reagents(reagent, heated_reagents[reagent])
	bitesize = 6
	SetName("warm donk-pocket")
	addtimer(CALLBACK(src, PROC_REF(cool)), 7 MINUTES)

/obj/item/food/donkpocket/proc/cool()
	if(!warm)
		return
	warm = 0
	for(var/reagent in heated_reagents)
		reagents.clear_reagent(reagent)
	SetName(initial(name))

/obj/item/food/donkpocket/sinpocket
	name = "\improper Sin-pocket"
	desc = "The food of choice for the veteran. Do <b>NOT</b> overconsume."
	filling_color = "#6d6d00"
	heated_reagents = list(
		/decl/material/liquid/regenerator = 5,
		/decl/material/liquid/amphetamines = 0.75,
		/decl/material/liquid/accumulated/stimulants = 0.25
	)
	var/has_been_heated = 0 // Unlike the warm var, this checks if the one-time self-heating operation has been used.

/obj/item/food/donkpocket/sinpocket/attack_self(mob/user)
	if(has_been_heated)
		to_chat(user, "<span class='notice'>The heating chemicals have already been spent.</span>")
		return
	has_been_heated = 1
	user.visible_message("<span class='notice'>[user] crushes \the [src] package.</span>", "You crush \the [src] package and feel a comfortable heat build up.")
	addtimer(CALLBACK(src, PROC_REF(heat), weakref(user)), 20 SECONDS)

/obj/item/food/donkpocket/sinpocket/heat(weakref/message_to)
	..()
	if(message_to)
		var/mob/user = message_to.resolve()
		if(user)
			to_chat(user, "You think \the [src] is ready to eat about now.")
