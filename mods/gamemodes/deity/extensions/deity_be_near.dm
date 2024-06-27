/datum/extension/deity_be_near
	base_type = /datum/extension/deity_be_near
	expected_type = /obj/item
	var/keep_away_instead = FALSE
	var/mob/living/deity/connected_deity
	var/threshold_base = 6
	var/expected_helmet
	flags = EXTENSION_FLAG_IMMEDIATE

/datum/extension/deity_be_near/New(var/datum/holder, var/mob/living/deity/connect)
	..()
	events_repository.register(/decl/observ/moved, holder,src, PROC_REF(check_movement))
	connected_deity = connect
	events_repository.register(/decl/observ/destroyed, holder, src, PROC_REF(dead_deity))
	var/obj/O = holder
	O.desc += "<br><span class='cult'>This item deals damage to its wielder the [keep_away_instead ? "closer" : "farther"] it is from a deity structure</span>"


/datum/extension/deity_be_near/Destroy()
	events_repository.unregister(/decl/observ/moved, holder,src)
	events_repository.unregister(/decl/observ/destroyed, holder, src)
	events_repository.unregister(/decl/observ/item_equipped, holder, src)
	. = ..()

/datum/extension/deity_be_near/proc/check_movement()
	var/obj/item/I = holder
	if(!isliving(I.loc))
		return
	var/min_dist = INFINITY
	for(var/s in connected_deity.structures)
		var/dist = get_dist(holder,s)
		if(dist < min_dist)
			min_dist = dist
	if(keep_away_instead && min_dist < threshold_base)
		deal_damage(I.loc, round(threshold_base/min_dist))
	else if(min_dist > threshold_base)
		deal_damage(I.loc, round(min_dist/threshold_base))


/datum/extension/deity_be_near/proc/deal_damage(var/mob/living/victim, var/mult)
	return

/datum/extension/deity_be_near/proc/dead_deity()
	var/obj/item/I = holder
	I.visible_message(SPAN_WARNING("\The [holder]'s power fades!"))
	qdel(src)

/datum/extension/deity_be_near/proc/wearing_full()
	var/obj/item/I = holder

	if(!ishuman(I.loc))
		return FALSE
	var/mob/living/human/H = I.loc
	if(H.get_equipped_slot_for_item(I) != slot_wear_suit_str)
		return FALSE
	if(expected_helmet && !istype(H.get_equipped_item(slot_head_str), expected_helmet))
		return FALSE
	return TRUE

/datum/extension/deity_be_near/champion/deal_damage(var/mob/living/victim,var/mult)
	victim.take_damage(3 * mult, OXY)

/datum/extension/deity_be_near/oracle/deal_damage(var/mob/living/victim, var/mult)
	victim.take_damage(mult, BURN)

/datum/extension/deity_be_near/traitor/deal_damage(var/mob/living/victim, var/mult)
	victim.take_damage(5 * mult, PAIN)