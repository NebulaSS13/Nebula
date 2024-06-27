/datum/extension/scent/custom/pheromone/check_smeller(var/mob/living/smeller)
	. = (..() && istype(smeller) && smeller.can_read_pheromones())

/obj/effect/decal/cleanable/pheromone
	name = "pheromone trace"
	invisibility = INVISIBILITY_MAXIMUM
	alpha = 0
	scent_type = /datum/extension/scent/custom/pheromone
	var/image/marker

/obj/effect/decal/cleanable/pheromone/proc/fade()
	alpha = max(alpha-5, 0)
	if(alpha <= 0)
		qdel(src)
	else
		addtimer(CALLBACK(src, /obj/effect/decal/cleanable/pheromone/proc/fade), 300 SECONDS)
		update_scent_marker()

/obj/effect/decal/cleanable/pheromone/Initialize(ml, _age)
	. = ..()
	addtimer(CALLBACK(src, /obj/effect/decal/cleanable/pheromone/proc/fade), 300 SECONDS)
	marker = image(loc = src, icon = 'icons/effects/blood.dmi', icon_state = pick(list("mfloor1", "mfloor2", "mfloor3", "mfloor4", "mfloor5", "mfloor6", "mfloor7")))
	marker.alpha = 90
	marker.plane = ABOVE_LIGHTING_PLANE
	marker.layer = ABOVE_LIGHTING_LAYER

/obj/effect/decal/cleanable/pheromone/Destroy()
	. = ..()
	global.pheromone_markers -= marker
	for(var/client/C)
		C.images -= marker

/obj/effect/decal/cleanable/pheromone/proc/update_scent_marker()
	if(!marker)
		return
	for(var/client/C)
		var/mob/living/human/H = C.mob
		if(istype(H) && H.can_read_pheromones())
			C.images -= marker
	var/datum/extension/scent/custom/pheromone/smell = get_extension(src, /datum/extension/scent)
	if(!istype(smell))
		return
	marker.alpha = alpha
	if(color)
		marker.color = color
		marker.filters = filter(type="drop_shadow", color = color + "F0", size = 2, offset = 1, x = 0, y = 0)
	global.pheromone_markers |= marker
	for(var/client/C)
		var/mob/living/human/H = C.mob
		if(istype(H) && H.can_read_pheromones())
			C.images |= marker

/obj/effect/decal/cleanable/pheromone/set_cleanable_scent()
	. = ..()
	update_scent_marker()
	var/datum/extension/scent/custom/pheromone/smell = get_extension(src, /datum/extension/scent)
	if(istype(smell))
		for(var/mob/living/smeller in all_hearers(smell.holder, smell.range))
			var/turf/T = get_turf(smeller.loc)
			if(!T || !T.return_air())
				continue
			if(!smell.check_smeller(smeller))
				continue
			if(smell.scent in smeller.smell_cooldown)
				to_chat(smeller, SPAN_NOTICE("The scent of [smell.scent] intensifies."))
