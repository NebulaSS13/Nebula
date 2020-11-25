/datum/forensics/gunshot_residue
	name = "gunshot residue"

/datum/forensics/gunshot_residue/add_from_atom(var/obj/item/ammo_casing/C)
	add_data(C.caliber)

/datum/forensics/gunshot_residue/get_formatted_data()
	. = list("<h4>[capitalize(name)] report</h4>")
	for(var/D in data)
		. += "<li>Residue matching a caliber [D] bullet"
	return jointext(., "<br>")

/datum/forensics/gunshot_residue/spot_message(mob/detective, atom/location)
	to_chat(detective, SPAN_NOTICE("You notice a faint acrid smell coming from \the [location]."))