/mob/living/simple_animal/hostile/leech
	name = "megaleech"
	desc = "A green leech the size of a common snake."
	icon = 'icons/mob/simple_animal/megaleech.dmi'
	max_health = 15
	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/bite/weak
	pass_flags = PASS_FLAG_TABLE
	faction = "leeches"
	flash_protection = FLASH_PROTECTION_MAJOR
	bleed_colour = COLOR_VIOLET
	ai = /datum/mob_controller/aggressive/leech

	var/suck_potency = 8
	var/belly = 100

/datum/mob_controller/aggressive/leech
	break_stuff_probability = 5

/mob/living/simple_animal/hostile/can_pry_door()
	return FALSE

/mob/living/simple_animal/hostile/leech/exoplanet/Initialize()
	adapt_to_current_level()
	. = ..()

/mob/living/simple_animal/hostile/leech/handle_regular_status_updates()
	. = ..()
	if(.)
		if(istype(ai) && ai.get_target())
			belly -= 3
		else
			belly -= 1

/mob/living/simple_animal/hostile/leech/apply_attack_effects(mob/living/target)
	. = ..()
	if(ishuman(target) && belly <= 75)
		var/mob/living/human/H = target
		var/obj/item/clothing/suit/space/S = H.get_covering_equipped_item_by_zone(BP_CHEST)
		if(istype(S) && !length(S.breaches))
			return
		H.remove_blood(suck_potency, absolute = TRUE)
		if(current_health < get_max_health())
			heal_overall_damage(suck_potency / 1.5)
		belly += clamp(suck_potency, 0, 100)

/obj/structure/leech_spawner
	name = "reeds"
	desc = "Some reeds with a few funnel-like structures growing alongside."
	icon = 'icons/obj/structures/reeds.dmi'
	icon_state = "reeds"
	anchored = TRUE
	var/leech_type = /mob/living/simple_animal/hostile/leech
	var/datum/proximity_trigger/proxy_listener

/obj/structure/leech_spawner/exoplanet
	leech_type = /mob/living/simple_animal/hostile/leech/exoplanet

/obj/structure/leech_spawner/Initialize()
	..()
	. = INITIALIZE_HINT_LATELOAD

/obj/structure/leech_spawner/LateInitialize()
	..()
	proxy_listener = new /datum/proximity_trigger/square(src, PROC_REF(burst), PROC_REF(burst), 5)
	proxy_listener.register_turfs()

/obj/structure/leech_spawner/Destroy()
	QDEL_NULL(proxy_listener)
	. = ..()

/obj/structure/leech_spawner/proc/burst(var/mob/living/victim)
	if(!proxy_listener || !istype(victim) || !(victim in view(5, src)))
		return
	QDEL_NULL(proxy_listener) // delete prior to spawning the leeches to avoid infinite recursion
	for(var/i in 1 to 12)
		new leech_type(get_turf(src))
	visible_message(SPAN_MFAUNA("A swarm of leeches burst out from \the [src]!"))
	icon_state = "reeds_empty"
	desc = "Some alien reeds."
