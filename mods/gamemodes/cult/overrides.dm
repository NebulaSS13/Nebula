/datum/artifact_find/New()
	var/static/injected = FALSE
	if(!injected)
		potential_finds[/obj/structure/cult/pylon] = 50
		injected = TRUE
	..()

/obj/structure/crematorium/on_cremate_mob(atom/cause, mob/living/victim)
	. = ..()
	if(. && round_is_spooky())
		if(prob(50))
			playsound(src, 'sound/effects/ghost.ogg', 10, 5)
		else
			playsound(src, 'sound/effects/ghost2.ogg', 10, 5)

/datum/trader/ship/unique/wizard/New()
	possible_wanted_items |= list(
		/mob/living/simple_animal/construct       = TRADER_SUBTYPES_ONLY,
		/obj/item/sword/cultblade                 = TRADER_THIS_TYPE,
		/obj/item/clothing/head/culthood          = TRADER_ALL,
		/obj/item/clothing/suit/space/cult        = TRADER_ALL,
		/obj/item/clothing/suit/cultrobes         = TRADER_ALL,
		/obj/item/clothing/head/helmet/space/cult = TRADER_ALL,
		/obj/structure/cult                       = TRADER_SUBTYPES_ONLY,
		/obj/structure/constructshell             = TRADER_ALL
	)
	..()