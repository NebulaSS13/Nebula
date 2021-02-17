/mob/living/simple_animal/hostile/leech
	name = "megaleech"
	desc = "A green leech the size of a common snake."
	icon = 'icons/mob/simple_animal/megaleech.dmi'
	icon_state = "leech"
	icon_living = "leech"
	icon_dead = "leech_dead"
	health = 15
	maxHealth = 15
	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/bite/weak
	pass_flags = PASS_FLAG_TABLE
	faction = "leeches"
	can_pry = FALSE
	break_stuff_probability = 5
	flash_vulnerability = 0
	bleed_colour = COLOR_VIOLET

	var/suck_potency = 8
	var/belly = 100

/mob/living/simple_animal/hostile/leech/Life()
	. = ..()
	if(!.)
		return FALSE

	if(target_mob)
		belly -= 3
	else
		belly -= 1

/mob/living/simple_animal/hostile/leech/AttackingTarget()
	. = ..()
	if(ishuman(.) && belly <= 75)
		var/mob/living/carbon/human/H = .
		var/obj/item/clothing/suit/space/S = H.get_covering_equipped_item_by_zone(BP_CHEST)
		if(istype(S) && !length(S.breaches))
			return
		H.remove_blood_simple(suck_potency)
		if(health < maxHealth)
			health += suck_potency / 1.5
		belly += Clamp(suck_potency, 0, 100)

/obj/structure/leech_spawner
	name = "reeds"
	desc = "Some reeds with a few funnel-like structures growing alongside."
	icon = 'icons/mob/simple_animal/megaleech.dmi'
	icon_state = "reeds"
	anchored = TRUE
	var/datum/proximity_trigger/proxy_listener

/obj/structure/leech_spawner/Initialize()
	..()
	. = INITIALIZE_HINT_LATELOAD

/obj/structure/leech_spawner/LateInitialize()
	..()
	proxy_listener = new /datum/proximity_trigger/square(src, .proc/burst, .proc/burst, 5)
	proxy_listener.register_turfs()

/obj/structure/leech_spawner/Destroy()
	QDEL_NULL(proxy_listener)
	. = ..()

/obj/structure/leech_spawner/proc/burst(var/mob/living/carbon/victim)
	if(!proxy_listener || !istype(victim) || !(victim in view(5, src)))
		return
	for(var/i in 1 to 12)
		new /mob/living/simple_animal/hostile/leech(get_turf(src))
	visible_message(SPAN_MFAUNA("A swarm of leeches burst out from \the [src]!"))
	icon_state = "reeds_empty"
	desc = "Some alien reeds."
	QDEL_NULL(proxy_listener)
