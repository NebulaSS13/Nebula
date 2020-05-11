//For anything that can light stuff on fire
/obj/item/flame
	waterproof = FALSE
	var/lit = 0

/obj/item/flame/afterattack(var/obj/O, var/mob/user, proximity)
	..()
	if(proximity && lit && istype(O))
		O.HandleObjectHeating(src, user, 700)

/obj/item/flame/proc/extinguish(var/mob/user, var/no_message)
	lit = 0
	damtype = "brute"
	STOP_PROCESSING(SSobj, src)

/obj/item/flame/fluid_act(var/datum/reagents/fluids)
	..()
	if(!waterproof && lit)
		extinguish(no_message = TRUE)

/proc/isflamesource(var/atom/A)
	if(!istype(A))
		return FALSE
	if(isWelder(A))
		var/obj/item/weldingtool/WT = A
		return (WT.isOn())
	else if(istype(A, /obj/item/flame))
		var/obj/item/flame/F = A
		return (F.lit)
	else if(istype(A, /obj/item/clothing/mask/smokable) && !istype(A, /obj/item/clothing/mask/smokable/pipe))
		var/obj/item/clothing/mask/smokable/S = A
		return (S.lit)
	else if(istype(A, /obj/item/assembly/igniter))
		return TRUE
	return FALSE

///////////
//MATCHES//
///////////
/obj/item/flame/match
	name = "match"
	desc = "A simple match stick, used for lighting fine smokables."
	icon = 'icons/obj/items/storage/matches/match.dmi'
	on_mob_icon = 'icons/obj/items/storage/matches/match.dmi'
	icon_state = "world"
	var/burnt = 0
	var/smoketime = 5
	w_class = ITEM_SIZE_TINY
	origin_tech = "{'materials':1}"
	slot_flags = SLOT_EARS
	attack_verb = list("burnt", "singed")
	randpixel = 10

/obj/item/flame/match/Process()
	if(isliving(loc))
		var/mob/living/M = loc
		M.IgniteMob()
	var/turf/location = get_turf(src)
	smoketime--
	if(submerged() || smoketime < 1)
		extinguish()
		return
	if(location)
		location.hotspot_expose(700, 5)

/obj/item/flame/match/dropped(var/mob/user)
	//If dropped, put ourselves out
	//not before lighting up the turf we land on, though.
	if(lit)
		var/turf/location = src.loc
		if(istype(location))
			location.hotspot_expose(700, 5)
		extinguish()
	return ..()

/obj/item/flame/match/extinguish(var/mob/user, var/no_message)
	. = ..()
	name = "burnt match"
	desc = "A match. This one has seen better days."
	burnt = 1
	update_icon()

/obj/item/flame/match/on_update_icon()
	..()
	if(burnt)
		icon_state = "[get_world_inventory_state()]_burnt"
	else if(lit)
		icon_state = "[get_world_inventory_state()]_lit"