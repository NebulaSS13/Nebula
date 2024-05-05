/obj/structure/flaps
	name = "flaps"
	desc = "A set of thin, dangling flaps. Completely impassable - or are they?"
	icon = 'icons/obj/structures/plastic_flaps.dmi'
	icon_state = "plasticflaps"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER
	explosion_resistance = 5
	material = /decl/material/solid/organic/plastic
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC

	obj_flags = OBJ_FLAG_ANCHORABLE

	var/list/mobs_can_pass = list(
		/mob/living/bot,
		/mob/living/simple_animal/mouse,
		/mob/living/silicon/robot/drone
		)
	var/airtight = FALSE

/obj/structure/flaps/CanPass(atom/A, turf/T)
	if(istype(A) && A.checkpass(PASS_FLAG_GLASS))
		return prob(60)

	var/obj/structure/bed/B = A
	if (istype(A, /obj/structure/bed) && B.buckled_mob)//if it's a bed/chair and someone is buckled, it will not pass
		return 0

	if(istype(A, /obj/vehicle))	//no vehicles
		return 0

	var/mob/living/M = A
	if(istype(M))
		if(M.current_posture.prone)
			return ..()
		for(var/mob_type in mobs_can_pass)
			if(istype(A, mob_type))
				return ..()
		return issmall(M)

	return ..()

/obj/structure/flaps/attackby(obj/item/W, mob/user)
	if(IS_CROWBAR(W) && !anchored)
		user.visible_message("<span class='notice'>\The [user] begins deconstructing \the [src].</span>", "<span class='notice'>You start deconstructing \the [src].</span>")
		if(user.do_skilled(3 SECONDS, SKILL_CONSTRUCTION, src))
			user.visible_message("<span class='warning'>\The [user] deconstructs \the [src].</span>", "<span class='warning'>You deconstruct \the [src].</span>")
			qdel(src)
	if(IS_SCREWDRIVER(W) && anchored)
		airtight = !airtight
		airtight ? become_airtight() : clear_airtight()
		user.visible_message("<span class='warning'>\The [user] adjusts \the [src], [airtight ? "preventing" : "allowing"] air flow.</span>")
	else ..()

/obj/structure/flaps/explosion_act(severity)
	..()
	if(!QDELETED(src) && (severity == 1 || (severity == 2 && prob(50)) || (severity == 3 && prob(5))))
		physically_destroyed()

/obj/structure/flaps/Initialize()
	. = ..()
	if(airtight)
		become_airtight()

/obj/structure/flaps/Destroy() //lazy hack to set the turf to allow air to pass if it's a simulated floor
	if(airtight)
		clear_airtight()
	. = ..()

/obj/structure/flaps/proc/become_airtight()
	atmos_canpass = CANPASS_NEVER
	update_nearby_tiles()

/obj/structure/flaps/proc/clear_airtight()
	atmos_canpass = CANPASS_ALWAYS
	update_nearby_tiles()

/obj/structure/flaps/airtight // airtight defaults to on
	airtight = TRUE