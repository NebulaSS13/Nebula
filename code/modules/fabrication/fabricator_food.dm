/obj/machinery/fabricator/replicator
	name = "food replicator"
	desc = "A versatile machine that dispenses nourishing but bland food. Responds to voice commands like 'menu' and 'status'."
	fabricator_class = FABRICATOR_CLASS_FOOD
	icon = 'icons/obj/machines/fabricators/replicator.dmi'
	icon_state = "replicator"
	base_icon_state = "replicator"
	base_storage_capacity_mult = 5

/obj/machinery/fabricator/replicator/hear_talk(var/mob/M, var/text, var/verb, var/decl/language/speaking)
	if(speaking && !speaking.machine_understands)
		return ..()
	var/true_text = lowertext(html_decode(text))
	if(findtext(true_text, "status"))
		addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/machinery/fabricator/replicator, state_status)), 2 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	else if(findtext(true_text, "menu"))
		addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/machinery/fabricator/replicator, state_menu)), 2 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	else
		for(var/datum/fabricator_recipe/recipe in design_cache)
			if(recipe.hidden && !(fab_status_flags & FAB_HACKED))
				continue
			if(findtext(true_text, lowertext(recipe.name)))
				addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/machinery/fabricator, try_queue_build), recipe, 1), 2 SECONDS)
				break
	..()

/obj/machinery/fabricator/bioprinter/can_ingest(var/obj/item/thing)
	return istype(thing, /obj/item/food) || ..()

/obj/machinery/fabricator/replicator/proc/state_status()
	for(var/thing in storage_capacity)
		audible_message("<b>\The [src]</b> announces, \"[capitalize(thing)] storage at [(stored_material[thing]/storage_capacity[thing])*100]%!\"")

/obj/machinery/fabricator/replicator/proc/state_menu()
	var/list/menu = list()
	for(var/datum/fabricator_recipe/recipe in design_cache)
		if(recipe.hidden && !(fab_status_flags & FAB_HACKED))
			continue
		menu += recipe.name
	if(length(menu))
		audible_message("<b>\The [src]</b> states, \"Greetings! I serve the following dishes: [english_list(menu)]\"")
	else
		audible_message("<b>\The [src]</b> states, \"Apologies! I cannot serve any dishes at the moment.\"")