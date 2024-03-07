//Seeing stuff
/datum/hallucination/mirage
	duration = 30 SECONDS
	max_power = 30
	var/number = 1
	var/list/things = list() //list of images to display
	var/static/list/trash_states = icon_states('icons/obj/trash.dmi')

/datum/hallucination/mirage/proc/generate_mirage()
	return image('icons/obj/trash.dmi', pick(trash_states), layer = BELOW_TABLE_LAYER)

/datum/hallucination/mirage/start()
	. = ..()
	var/list/possible_points = list()
	for(var/turf/F in view(holder, world.view+1))
		if(F.simulated && F.is_floor())
			possible_points += F
	if(possible_points.len)
		for(var/i = 1 to number)
			var/image/thing = generate_mirage()
			things += thing
			thing.loc = pick(possible_points)
	if(holder?.client && length(things))
		holder.client.images += things

/datum/hallucination/mirage/end()
	if(holder?.client)
		holder.client.images -= things
	return ..()

//Blood and aftermath of firefight
/datum/hallucination/mirage/carnage
	min_power = 50
	number = 10
	var/static/list/carnage_states = list(
		"mfloor1",
		"mfloor2",
		"mfloor3",
		"mfloor4",
		"mfloor5",
		"mfloor6",
		"mfloor7"
	)

/datum/hallucination/mirage/carnage/generate_mirage()
	var/image/I
	if(prob(50))
		I = image('icons/effects/blood.dmi', pick(carnage_states), layer = BELOW_TABLE_LAYER)
		I.color = COLOR_BLOOD_HUMAN
	else
		I = image('icons/obj/ammo.dmi', "s-casing-spent", layer = BELOW_TABLE_LAYER)
		I.layer = BELOW_TABLE_LAYER
		I.dir = pick(global.alldirs)
		I.pixel_x = rand(-10,10)
		I.pixel_y = rand(-10,10)
	return I

//LOADSEMONEY
/datum/hallucination/mirage/money
	min_power = 20
	max_power = 45
	number = 2
	var/static/obj/item/cash/cash

/datum/hallucination/mirage/money/New()
	if(!cash)
		cash = new /obj/item/cash/c500
		cash.update_icon()
		cash.compile_overlays()
	..()

/datum/hallucination/mirage/money/generate_mirage()
	var/image/I = new
	I.appearance = cash
	I.layer = BELOW_TABLE_LAYER
	qdel(cash)
	return I
