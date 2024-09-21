/obj/structure/mineral_bath
	name = "mineral bath"
	desc = "A deep, narrow basin filled with a swirling, semi-opaque liquid."
	icon = 'icons/obj/structures/mineral_bath.dmi'
	icon_state = "bath"
	anchored = TRUE
	density = TRUE
	opacity = FALSE
	var/mob/living/occupant

/obj/structure/mineral_bath/Destroy()
	eject_occupant()
	. = ..()

/obj/structure/mineral_bath/return_air()
	var/datum/gas_mixture/venus = new(CELL_VOLUME, SYNTH_HEAT_LEVEL_1 - 10)
	venus.adjust_multi(/decl/material/gas/chlorine, MOLES_N2STANDARD, /decl/material/gas/hydrogen, MOLES_O2STANDARD)
	return venus

/obj/structure/mineral_bath/grab_attack(obj/item/grab/grab, mob/user)
	if(enter_bath(grab.affecting))
		qdel(grab)
		return TRUE
	return ..()

/obj/structure/mineral_bath/proc/enter_bath(var/mob/living/patient, var/mob/user)

	if(!istype(patient) || patient.anchored)
		return FALSE

	var/self_drop = (user == patient)

	if(!user.Adjacent(src) || !(self_drop || user.Adjacent(patient)))
		return FALSE

	if(occupant)
		to_chat(user, SPAN_WARNING("\The [src] is occupied."))
		return FALSE

	if(self_drop)
		user.visible_message(SPAN_NOTICE("\The [user] begins climbing into \the [src]."))
	else
		user.visible_message(SPAN_NOTICE("\The [user] begins pushing \the [patient] into \the [src]."))

	if(!do_after(user, 3 SECONDS, src))
		return FALSE

	if(!user.Adjacent(src) || !(self_drop || user.Adjacent(patient)))
		return FALSE

	if(occupant)
		to_chat(user, SPAN_WARNING("\The [src] is occupied."))
		return FALSE

	if(self_drop)
		user.visible_message(SPAN_NOTICE("\The [user] climbs into \the [src]."))
	else
		user.visible_message(SPAN_NOTICE("\The [user] pushes \the [patient] into \the [src]."))

	playsound(loc, 'sound/effects/slosh.ogg', 50, 1)
	patient.forceMove(src)
	occupant = patient
	START_PROCESSING(SSobj, src)
	return TRUE

/obj/structure/mineral_bath/attack_hand(var/mob/user)
	if(!user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()
	eject_occupant()
	return TRUE

/obj/structure/mineral_bath/proc/eject_occupant()
	if(occupant)
		occupant.dropInto(loc)
		playsound(loc, 'sound/effects/slosh.ogg', 50, 1)
		if(occupant.loc != src)
			if(occupant.client)
				occupant.client.eye = occupant.client.mob
				occupant.client.perspective = MOB_PERSPECTIVE
			occupant.update_icon()
			occupant = null
			STOP_PROCESSING(SSobj, src)

/obj/structure/mineral_bath/receive_mouse_drop(atom/dropping, mob/user, params)
	. = ..()
	if(!. && ismob(dropping))
		enter_bath(dropping, user)
		return TRUE

/obj/structure/mineral_bath/relaymove(var/mob/user)
	if(user == occupant)
		eject_occupant()

/obj/structure/mineral_bath/Process()

	if(!occupant)
		STOP_PROCESSING(SSobj, src)
		return

	if(occupant.loc != src)
		occupant = null
		STOP_PROCESSING(SSobj, src)
		return

	var/repaired_organ

	// Replace limbs for crystalline species.
	if(occupant.has_body_flag(BODY_FLAG_CRYSTAL_REFORM) && prob(10))
		var/decl/bodytype/root_bodytype = occupant.get_bodytype()
		for(var/limb_type in root_bodytype.has_limbs)
			var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(occupant, limb_type)
			if(E && !E.is_usable() && !(E.limb_flags & ORGAN_FLAG_HEALS_OVERKILL))
				occupant.remove_organ(E)
				qdel(E)
				E = null
			if(!E)
				var/list/organ_data = root_bodytype.has_limbs[limb_type]
				var/limb_path = organ_data["path"]
				E = new limb_path(occupant)
				organ_data["descriptor"] = E.name
				to_chat(occupant, SPAN_NOTICE("You feel your [E.name] reform in the crystal bath."))
				occupant.update_body()
				repaired_organ = TRUE
				break

		// Repair crystalline internal organs.
		if(prob(10))
			for(var/obj/item/organ/internal/I in occupant.get_internal_organs())
				if(BP_IS_CRYSTAL(I) && I.damage)
					I.heal_damage(rand(3,5))
					if(prob(25))
						to_chat(occupant, SPAN_NOTICE("The mineral-rich bath mends your [I.name]."))

		// Repair robotic external organs.
		if(!repaired_organ && prob(25))
			for(var/obj/item/organ/external/E in occupant.get_external_organs())
				if(BP_IS_PROSTHETIC(E))
					for(var/obj/implanted_object in E.implants)
						if(!istype(implanted_object,/obj/item/implant) && !istype(implanted_object,/obj/item/organ/internal/augment) && prob(25))	// We don't want to remove REAL implants. Just shrapnel etc.
							LAZYREMOVE(E.implants, implanted_object)
							to_chat(occupant, SPAN_NOTICE("The mineral-rich bath dissolves the [implanted_object.name]."))
							qdel(implanted_object)
					if(E.brute_dam || E.burn_dam)
						E.heal_damage(rand(3,5), rand(3,5), robo_repair = 1)
						if(prob(25))
							to_chat(occupant, SPAN_NOTICE("The mineral-rich bath mends your [E.name]."))
						if(!BP_IS_CRYSTAL(E) && !BP_IS_BRITTLE(E))
							E.status |= ORGAN_BRITTLE
							to_chat(occupant, SPAN_WARNING("It feels a bit brittle, though..."))
						break
