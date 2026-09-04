/obj/item/mine/incendiary
	name = "incendiary mine"
	desc = "A small explosive mine with a fire symbol on the side."
	payload = /datum/mine_payload/incendiary

/obj/item/mine/incendiary/mapped
	armed = TRUE

/datum/mine_payload/incendiary/trigger_payload(var/obj/item/mine/owner, var/atom/trigger)
	..()
	for(var/turf/floor/target in range(1, owner))
		if(!target.blocks_air)
			target.assume_gas(/decl/material/gas/hydrogen, 10)
			target.assume_gas(/decl/material/gas/oxygen, 5)
			target.hotspot_expose(1000, CELL_VOLUME)
	owner.visible_message("\The [owner] spews a cloud of flaming gas!")
