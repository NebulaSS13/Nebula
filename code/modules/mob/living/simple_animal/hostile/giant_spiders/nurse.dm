/mob/living/simple_animal/hostile/giant_spider/nurse
	desc = "A monstrously huge beige spider with shimmering eyes."
	icon = 'icons/mob/simple_animal/spider_beige.dmi'
	max_health = 80
	harm_intent_damage = 6 //soft
	poison_per_bite = 5
	base_movement_delay = 0
	poison_type = /decl/material/liquid/sedatives
	ai = /datum/mob_controller/aggressive/giant_spider/nurse
	var/fed = 0
	var/max_eggs = 8

/mob/living/simple_animal/hostile/giant_spider/nurse/get_door_pry_time()
	return 9 SECONDS

/mob/living/simple_animal/hostile/giant_spider/nurse/Destroy()
	. = ..()
	divorce()

/mob/living/simple_animal/hostile/giant_spider/nurse/apply_attack_effects(mob/living/target)
	. = ..()
	if(!ishuman(target) || max_eggs <= 0)
		return
	var/datum/mob_controller/aggressive/giant_spider/nurse/nurse_ai = ai
	if(istype(nurse_ai) && !prob(nurse_ai.infest_chance))
		return
	var/mob/living/human/H = target
	var/list/limbs = H.get_external_organs()
	var/obj/item/organ/external/O = LAZYLEN(limbs)? pick(limbs) : null
	if(O && !BP_IS_PROSTHETIC(O) && !BP_IS_CRYSTAL(O) && (LAZYLEN(O.implants) < 2))
		var/eggs = new /obj/effect/spider/eggcluster(O, src)
		LAZYADD(O.implants, eggs)
		max_eggs--
