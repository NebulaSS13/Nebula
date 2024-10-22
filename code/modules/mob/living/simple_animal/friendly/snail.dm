// TODO: /obj/effect/decal/cleanable/snail_trail
/datum/mob_controller/snail
	expected_type = /mob/living/simple_animal/snail
	emote_see    = list("retracts and extends its eyes")
	speak_chance = 0
	turns_per_wander = 20

/mob/living/simple_animal/snail
	name = "snail"
	desc = "A famous shelled mollusc known for carrying their home with them."
	icon = 'icons/mob/simple_animal/snail.dmi'
	mob_size = MOB_SIZE_TINY
	base_movement_delay = 5 SECONDS
	max_health = 1
	butchery_data = null
	ai = /datum/mob_controller/snail

/mob/living/simple_animal/snail/proc/smear(turf/smear_turf)
	if(istype(smear_turf) && !(locate(/obj/effect/decal/cleanable/mucus) in smear_turf))
		new /obj/effect/decal/cleanable/mucus(smear_turf)

/mob/living/simple_animal/snail/Move()
	var/last_loc = loc
	. = ..()
	if(. && last_loc)
		smear(last_loc)

/mob/living/simple_animal/snail/death(gibbed)
	. = ..()
	if(loc)
		smear(loc)
		new /obj/item/food/butchery/meat/fish/mollusc(get_turf(loc))
	qdel(src)
