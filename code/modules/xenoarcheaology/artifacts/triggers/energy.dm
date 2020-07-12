/datum/artifact_trigger/energy
	name = "applied high energy"
	var/global/list/energetic_things = list(
		/obj/item/sword/cultblade,
		/obj/item/card/emag,
		/obj/item/multitool
	)

/datum/artifact_trigger/energy/on_hit(obj/O, mob/user)
	. = ..()
	if(istype(O, /obj/item/projectile))
		var/obj/item/projectile/P = O
		. = (P.damage_type == BURN) || (P.damage_type == ELECTROCUTE)
	if(istype(O,/obj/item/baton))
		var/obj/item/baton/B = O 
		. = B.status
	else if (istype(O,/obj/item/energy_blade))
		var/obj/item/energy_blade/E = O
		. = E.active
	else if (is_type_in_list(O, energetic_things))
		. = TRUE
