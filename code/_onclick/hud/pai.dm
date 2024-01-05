/datum/hud/pai/FinalizeInstantiation()
	for(var/hud_type in subtypesof(/obj/screen/pai))
		var/obj/screen/pai/hud_elem = hud_type
		if(TYPE_IS_ABSTRACT(hud_elem))
			continue
		adding += new hud_elem(null, mymob)

	..()
	hide_inventory()
