/mob/living/carbon/alien/diona/drop_from_inventory(var/obj/item/I)
	. = ..()
	if(I == holding_item)
		holding_item = null

/mob/living/carbon/alien/diona/put_in_hands(var/obj/item/W) // No hands. Use mouth.
	if(can_collect(W))
		collect(W)
		return TRUE
	W.forceMove(get_turf(src))
	return TRUE

/mob/living/carbon/alien/diona/proc/can_collect(var/obj/item/collecting)
	var/datum/extension/hattable/hattable = get_extension(src, /datum/extension/hattable)
	return (!holding_item && \
		istype(collecting) && \
		collecting != hattable?.hat && \
		collecting.loc != src && \
		!collecting.anchored && \
		collecting.simulated && \
		collecting.w_class <= can_pull_size \
	)

/mob/living/carbon/alien/diona/proc/collect(var/obj/item/collecting)
	collecting.forceMove(src)
	holding_item = collecting
	visible_message(SPAN_NOTICE("\The [src] engulfs \the [holding_item]."))

	// This means dionaea can hoover up beakers as a kind of impromptu chem disposal
	// technique, so long as they're okay with the reagents reacting inside them.
	if(holding_item.reagents && holding_item.reagents.total_volume)
		holding_item.reagents.trans_to_mob(src, holding_item.reagents.total_volume, CHEM_INGEST)

	// It also means they can do the old school cartoon schtick of eating an entire sandwich
	// and spitting up an empty plate. Ptooie.
	if(istype(holding_item, /obj/item/chems/food))
		var/obj/item/chems/food/food = holding_item
		holding_item = null
		if(food.trash)
			holding_item = new food.trash(src)
		qdel(food)

	if(!QDELETED(holding_item))
		holding_item.equipped(src)
		holding_item.screen_loc = DIONA_SCREEN_LOC_HELD

/mob/living/carbon/alien/diona/verb/drop_item_verb()
	set name = "Drop Held Item"
	set desc = "Drop the item you are currently holding inside."
	set category = "IC"
	set src = usr
	drop_item()

/mob/living/carbon/alien/diona/drop_item()
	var/item = holding_item
	if(item && unEquip(item))
		visible_message(SPAN_NOTICE("\The [src] regurgitates \the [item]."))
		return TRUE
	. = ..()
