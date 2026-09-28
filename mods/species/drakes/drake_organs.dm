/proc/drake_spend_spit(mob/living/user, amount)
	var/obj/item/organ/internal/drake_gizzard/gizzard = user.get_organ(BP_DRAKE_GIZZARD)
	if(istype(gizzard))
		return gizzard.spend_charge(amount)
	return FALSE

/proc/drake_has_spit(mob/living/user, amount)
	var/obj/item/organ/internal/drake_gizzard/gizzard = user.get_organ(BP_DRAKE_GIZZARD)
	if(istype(gizzard))
		return gizzard.has_charge(amount)
	return FALSE

/proc/drake_add_spit(mob/living/user, amount)
	var/obj/item/organ/internal/drake_gizzard/gizzard = user.get_organ(BP_DRAKE_GIZZARD)
	if(istype(gizzard))
		gizzard.add_charge(amount)
		return TRUE
	return FALSE

/obj/item/organ/internal/drake_gizzard
	name = "grafadreka gizzard"
	icon_state = "liver"
	prosthetic_icon = "liver-prosthetic"
	w_class = ITEM_SIZE_SMALL
	organ_tag = BP_DRAKE_GIZZARD
	parent_organ = BP_CHEST
	min_bruised_damage = 25
	min_broken_damage = 45
	max_damage = 70
	relative_size = 60
	min_regeneration_cutoff_threshold = 2
	max_regeneration_cutoff_threshold = 5
	has_stat_info = TRUE
	var/datum/reagents/sap_crop

/obj/item/organ/internal/drake_gizzard/Initialize()
	sap_crop = new(60, src)
	. = ..()

/obj/item/organ/internal/drake_gizzard/Destroy()
	QDEL_NULL(sap_crop)
	. = ..()

/obj/item/organ/internal/drake_gizzard/proc/add_charge(amount)
	if(REAGENTS_FREE_SPACE(sap_crop))
		sap_crop.add_reagent(/decl/material/liquid/drake_spit, amount)
		return TRUE
	return FALSE

/obj/item/organ/internal/drake_gizzard/proc/has_charge(amount)
	return REAGENT_TOTAL_VOLUME(sap_crop) >= amount

/obj/item/organ/internal/drake_gizzard/proc/spend_charge(amount)
	if(!sap_crop.has_reagent(/decl/material/liquid/drake_spit, amount))
		return FALSE
	sap_crop.remove_reagent(/decl/material/liquid/drake_spit, amount)
	return TRUE

/obj/item/organ/internal/drake_gizzard/get_stat_info()
	return list("Sap reserve", num2text(round((REAGENT_TOTAL_VOLUME(sap_crop) || 0), 0.1)))

/obj/item/organ/internal/drake_gizzard/Process()
	. = ..()
	if(owner && owner.stat != DEAD && !is_broken() && !has_charge(10))
		add_charge(0.5)

/obj/item/organ/internal/drake_gizzard/do_uninstall(in_place, detach, ignore_children, update_icon)
	. = ..()
	var/stored_sap = REAGENT_TOTAL_VOLUME(sap_crop)
	if(stored_sap)
		if(reagents)
			sap_crop.trans_to_holder(reagents, stored_sap)
		else if(isatom(loc))
			sap_crop.splash(loc, stored_sap)
		sap_crop.clear_reagents()

