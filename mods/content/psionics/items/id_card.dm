/obj/item/card/id/foundation_civilian
	name = "operant registration card"
	desc = "A registration card in a faux-leather case. It marks the named individual as a registered, law-abiding psionic."
	icon = 'icons/obj/id/id_warrantcard_civ.dmi'
	detail_color = null

/obj/item/card/id/foundation_civilian/on_update_icon()
	SHOULD_CALL_PARENT(FALSE)
	return

/obj/item/card/id/foundation
	name = "\improper Foundation warrant card"
	desc = "A warrant card in a handsome leather case."
	assignment = "Field Agent"
	icon = 'icons/obj/id/id_warrantcard.dmi'
	detail_color = null

/obj/item/card/id/foundation/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 && isliving(user))
		var/datum/ability_handler/psionics/psi = user.get_ability_handler(/datum/ability_handler/psionics)
		if(psi)
			to_chat(user, SPAN_WARNING("There is a psionic compulsion surrounding \the [src], forcing anyone who reads it to perceive it as a legitimate document of authority. The actual text just reads 'I can do what I want.'"))
		else
			to_chat(user, SPAN_NOTICE("This is the real deal, stamped by [global.using_map.boss_name]. It gives the holder the full authority to pursue their goals. You believe it implicitly."))

/obj/item/card/id/foundation/attack_self(var/mob/user)
	. = ..()
	if(isliving(user))
		var/datum/ability_handler/psionics/psi = user.get_ability_handler(/datum/ability_handler/psionics)
		if(psi)
			for(var/mob/M in viewers(world.view, get_turf(user))-user)
				if(isliving(M))
					var/datum/ability_handler/psionics/other_psi = M.get_ability_handler(/datum/ability_handler/psionics)
					if(!other_psi)
						to_chat(M, SPAN_NOTICE("This is the real deal, stamped by [global.using_map.boss_name]. It gives the holder the full authority to pursue their goals. You believe \the [user] implicitly."))
						continue
				to_chat(M, SPAN_WARNING("There is a psionic compulsion surrounding \the [src] in a flicker of indescribable light."))

/obj/item/card/id/foundation/on_update_icon()
	SHOULD_CALL_PARENT(FALSE)
	return

/obj/item/card/id/foundation/Initialize()
	. = ..()
	access |= get_all_station_access()
