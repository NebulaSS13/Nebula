/mob/living/carbon/alien/ascent_nymph/drop_from_inventory(var/obj/item/I)
	. = ..()
	if(I == holding_item)
		holding_item = null

/mob/living/carbon/alien/ascent_nymph/put_in_hands(var/obj/item/W) // No hands. Use mouth.
	if(can_collect(W))
		collect(W)
	else
		W.forceMove(get_turf(src))
	return 1


/mob/living/carbon/alien/ascent_nymph/hotkey_drop()
	if(holding_item)
		drop_item()
	else
		to_chat(usr, SPAN_WARNING("You have nothing to drop."))

/mob/living/carbon/alien/ascent_nymph/proc/can_collect(var/obj/item/collecting)
	return (!holding_item && \
		istype(collecting) && \
		collecting.loc != src && \
		!collecting.anchored && \
		collecting.simulated && \
		collecting.w_class <= can_pull_size \
	)

/mob/living/carbon/alien/ascent_nymph/proc/contains_crystals(var/obj/item/W)
	for(var/mat in W.matter)
		if(mat == /decl/material/solid/mineral/sand)
			. += W.matter[mat]
		else if(mat == /decl/material/solid/gemstone/crystal)
			. += W.matter[mat]
		else if(mat == /decl/material/solid/mineral/quartz)
			. += W.matter[mat]
		else if(mat == /decl/material/solid/glass)
			. += W.matter[mat]

/mob/living/carbon/alien/ascent_nymph/proc/collect(var/obj/item/collecting)
	collecting.forceMove(src)
	holding_item = collecting
	visible_message(SPAN_NOTICE("\The [src] engulfs \the [holding_item]."))

	// This means nymph can hoover up beakers as a kind of impromptu chem disposal
	// technique, so long as they're okay with the reagents reacting inside them.
	if(holding_item.reagents && holding_item.reagents.total_volume)
		holding_item.reagents.trans_to_mob(src, holding_item.reagents.total_volume, CHEM_INGEST)

	// It also means they can do the old school cartoon schtick of eating an entire sandwich
	// and spitting up an empty plate. Ptooie.
	if(istype(holding_item, /obj/item/chems/food))
		var/obj/item/chems/food/food = holding_item
		holding_item = null
		if(food.trash) holding_item = new food.trash(src)
		qdel(food)

	var/crystals = contains_crystals(collecting)
	if(crystals)
		if(crystal_reserve < ANYMPH_MAX_CRYSTALS)
			crystal_reserve = min(ANYMPH_MAX_CRYSTALS, crystal_reserve + crystals)
			qdel(collecting)
		else
			to_chat(src, SPAN_WARNING("You've already filled yourself with as much crystalline matter as you can!"))
			return

	if(!QDELETED(holding_item))
		holding_item.equipped(src)
		holding_item.screen_loc = ANYMPH_SCREEN_LOC_HELD

/mob/living/carbon/alien/ascent_nymph/verb/drop_item_verb()
	set name = "Drop Held Item"
	set desc = "Drop the item you are currently holding inside."
	set category = "IC"
	set src = usr
	drop_item()

/mob/living/carbon/alien/ascent_nymph/drop_item()
	var/item = holding_item
	if(item && unEquip(item))
		visible_message(SPAN_NOTICE("\The [src] regurgitates \the [item]."))
		return TRUE
	. = ..()
