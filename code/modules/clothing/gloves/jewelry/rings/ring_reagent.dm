/////////////////////////////////////////
//Reagent Rings
/obj/item/clothing/gloves/ring/reagent
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	origin_tech = @'{"materials":2,"esoteric":4}'
	chem_volume = 15

/obj/item/clothing/gloves/ring/reagent/equipped(var/mob/living/human/H)
	..()
	if(istype(H) && H.get_equipped_item(slot_gloves_str) == src)
		to_chat(H, SPAN_DANGER("You feel a prick as you slip on the ring."))

		if(reagents.total_volume)
			if(H.reagents)
				var/contained_reagents = reagents.get_reagents()
				var/trans = reagents.trans_to_mob(H, reagents.total_volume, CHEM_INJECT)
				admin_inject_log(usr, H, src, contained_reagents, trans)
	return

//Sleepy Ring
/obj/item/clothing/gloves/ring/reagent/sleepy
	origin_tech = @'{"materials":2,"esoteric":5}'

/obj/item/clothing/gloves/ring/reagent/sleepy/populate_reagents()
	add_to_reagents(/decl/material/liquid/paralytics, 10)
	add_to_reagents(/decl/material/liquid/sedatives,   5)
