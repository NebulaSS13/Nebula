/datum/artifact_find/New()
	var/static/injected = FALSE
	if(!injected)
		potential_finds[/obj/structure/cult/pylon] = 50
		potential_finds[/obj/structure/constructshell] = 5
		injected = TRUE
	..()

/obj/structure/crematorium/on_cremate_mob(atom/cause, mob/living/victim)
	. = ..()
	if(. && round_is_spooky())
		if(prob(50))
			playsound(src, 'sound/effects/ghost.ogg', 10, 5)
		else
			playsound(src, 'sound/effects/ghost2.ogg', 10, 5)

/datum/trader/ship/clothingshop/hatglovesaccessories/New()
	..()
	possible_trading_items[/obj/item/clothing/head/culthood] = TRADER_BLACKLIST_ALL

/mob/living/silicon/ai
	shouldnt_see = list(/obj/effect/rune)

/obj/item/vampiric
	material = /decl/material/solid/stone/cult

/mob/safe_animal(var/MP)
	. = ..()
	if(ispath(MP, /mob/living/simple_animal/shade))
		return 1

/mob/living/simple_animal/hostile/revenant
	butchery_data = /decl/butchery_data/occult

/mob/living/simple_animal/hostile/revenant/cult
	faction = "cult"

/mob/living/simple_animal/hostile/revenant/cult/on_defilement()
	return

/obj/item/mop/populate_moppable_types()
	. = ..()
	moppable_types |= /obj/effect/rune

/obj/effect/gateway/active/can_transform(mob/victim)
	if(iscultist(victim))
		return FALSE
	return ..()