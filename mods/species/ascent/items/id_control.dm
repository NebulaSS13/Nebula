// ID 'card'
/obj/item/card/id/ascent
	name = "alien chip"
	icon = 'mods/species/ascent/icons/ascent.dmi'
	icon_state = "access_card"
	desc = "A slender, complex chip of alien circuitry."
	access = list(access_ascent)

/obj/item/card/id/ascent/GetAccess()
	var/mob/living/human/H = loc
	if(istype(H) && !(H.species.name in ALL_ASCENT_SPECIES))
		. = list()
	else
		. = ..()

/obj/item/card/id/ascent/on_update_icon()
	SHOULD_CALL_PARENT(FALSE)
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
	organ_properties = ORGAN_PROP_PROSTHETIC
	var/obj/item/card/id/id_card = /obj/item/card/id/ascent

/obj/item/organ/internal/controller/do_install(mob/living/human/target, obj/item/organ/external/affected, in_place, update_icon, detached)
	. = ..()
	if(detached || !owner)
		return
	var/datum/extension/access_provider/owner_access = get_or_create_extension(owner, /datum/extension/access_provider)
	owner_access?.register_id(src)
	owner.set_id_info(id_card)
	owner.add_language(/decl/language/mantid/worldnet)

/obj/item/organ/internal/controller/do_uninstall(in_place, detach, ignore_children)
	if(owner)
		var/datum/extension/access_provider/owner_access = get_extension(owner, /datum/extension/access_provider)
		owner_access?.unregister_id(src)
	var/mob/living/H = owner
	. = ..()
	if(H && !(locate(type) in H.get_internal_organs()))
		H.remove_language(/decl/language/mantid/worldnet)

/obj/item/organ/internal/controller/Initialize()
	if(ispath(id_card))
		id_card = new id_card(src)
	. = ..()

/obj/item/organ/internal/controller/GetIdCards(list/exceptions)
	. = ..()
	//Not using is_broken() because it should be able to function when CUT_AWAY is set
	if(id_card && damage < min_broken_damage && !is_type_in_list(id_card, exceptions))
		LAZYDISTINCTADD(., id_card)

/obj/item/organ/internal/controller/GetAccess()
	if(damage < min_broken_damage)
		return id_card?.GetAccess()
