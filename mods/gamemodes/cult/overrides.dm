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

/datum/trader/ship/clothingshop/hatglovesaccessories/New()
	possible_trading_items[/obj/item/clothing/head/culthood] = TRADER_BLACKLIST_ALL

/mob/living/silicon/ai
	shouldnt_see = list(/obj/effect/rune)

// Vent crawling whitelisted items, whoo
/mob/living/Initialize()
	. = ..()
	can_enter_vent_with += list(
		/obj/item/clothing/head/culthood,
		/obj/item/clothing/suit/cultrobes,
		/obj/item/book/tome,
		/obj/item/sword/cultblade
	)

/obj/item/vampiric
	material = /decl/material/solid/stone/cult

/mob/safe_animal(var/MP)
	. = ..()
	if(ispath(MP, /mob/living/simple_animal/shade))
		return 1

/mob/living/simple_animal/hostile/faithless
	butchery_data = /decl/butchery_data/occult

/mob/living/simple_animal/hostile/faithless/cult
	faction = "cult"

/mob/living/simple_animal/hostile/faithless/cult/on_defilement()
	return

/obj/item/mop/Initialize()
	. = ..()
	moppable_types += /obj/effect/rune

/obj/effect/gateway/active/can_transform(mob/victim)
	if(iscultist(victim))
		return FALSE
	return ..()