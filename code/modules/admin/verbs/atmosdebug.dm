/client/proc/powerdebug()
	set category = "Mapping"
	set name = "Check Power"
	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return
	SSstatistics.add_field_details("admin_verb","CPOW") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	for (var/datum/powernet/PN in SSmachines.powernets)
		if (!LAZYLEN(PN.nodes))
			if(PN.cables && (PN.cables.len > 1))
				var/obj/structure/cable/C = PN.cables[1]
				var/area/A = get_area(C.loc)
				to_chat(usr, "Powernet with no nodes! (number [PN.number]) - example cable at [C.x], [C.y], [C.z] in area [A?.proper_name]")

		var/cable_count = LAZYLEN(PN.cables)
		if (cable_count > 1 && cable_count < 10)
			var/obj/structure/cable/C = PN.cables[1]
			var/area/A = get_area(C.loc)
			to_chat(usr, "Powernet with fewer than 10 cables! (number [PN.number]) - example cable at [C.x], [C.y], [C.z] in area [A?.proper_name]")
