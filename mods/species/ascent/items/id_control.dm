// ID 'card'
/obj/item/card/id/ascent
	name = "alien chip"
	icon = 'mods/species/ascent/icons/ascent.dmi'
	icon_state = "access_card"
	desc = "A slender, complex chip of alien circuitry."
	access = list(access_ascent)

/obj/item/card/id/ascent/GetAccess()
	var/mob/living/carbon/human/H = loc
	if(istype(H) && !(H.species.name in ALL_ASCENT_SPECIES))
		. = list()
	else
		. = ..()

/obj/item/card/id/ascent/on_update_icon()
	return

/obj/item/card/id/ascent/prevent_tracking()
	return TRUE

/obj/item/card/id/ascent/attack_self(mob/user)
	return

/obj/item/card/id/ascent/show()
	return

// ID implant/organ/interface device.
/obj/item/organ/internal/controller
	name = "system controller"
	desc = "A fist-sized lump of complex circuitry."
	icon = 'mods/species/ascent/icons/ascent.dmi'
	icon_state = "plant"
	parent_organ = BP_CHEST
	organ_tag = BP_SYSTEM_CONTROLLER
	surface_accessible = TRUE
	status = ORGAN_PROSTHETIC
	var/obj/item/card/id/id_card = /obj/item/card/id/ascent

/obj/item/organ/internal/controller/do_install(mob/living/carbon/human/target, obj/item/organ/external/affected, in_place, update_icon, detached)
	. = ..()
	if(!detached && owner)
		owner.set_id_info(id_card)
		owner.add_language(/decl/language/mantid/worldnet)

/obj/item/organ/internal/controller/do_uninstall(in_place, detach, ignore_children)
	var/mob/living/carbon/H = owner
	. = ..()
	if(istype(H) && H != owner && !(locate(type) in H.get_internal_organs()))
		H.remove_language(/decl/language/mantid/worldnet)

/obj/item/organ/internal/controller/Initialize()
	if(ispath(id_card))
		id_card = new id_card(src)
	. = ..()

/obj/item/organ/internal/controller/GetIdCard()
	//Not using is_broken() because it should be able to function when CUT_AWAY is set
	if(damage < min_broken_damage)
		return id_card

/obj/item/organ/internal/controller/GetAccess()
	if(id_card && damage < min_broken_damage)
		return id_card.GetAccess()
