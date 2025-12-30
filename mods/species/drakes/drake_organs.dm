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

/obj/item/organ/internal/drake_gizzard/Process()
	. = ..()
	if(owner && owner.stat != DEAD && !is_broken() && sap_crop && REAGENT_TOTAL_VOLUME(sap_crop) < 10)
		sap_crop.add_reagent(/decl/material/liquid/sifsap, 0.5)

/obj/item/organ/internal/drake_gizzard/do_uninstall(in_place, detach, ignore_children, update_icon)
	. = ..()
	var/sap_vol = REAGENT_TOTAL_VOLUME(sap_crop)
	if(sap_vol)
		if(reagents)
			sap_crop.trans_to_holder(reagents, sap_vol)
		else if(isatom(loc))
			sap_crop.splash(loc, sap_vol)
		sap_crop.clear_reagents()

/obj/item/organ/internal/drake_gizzard/Destroy()
	QDEL_NULL(sap_crop)
	. = ..()

/obj/item/organ/internal/drake_gizzard/get_stat_info()
	return list("Sap reserve", num2text(round((REAGENT_TOTAL_VOLUME(sap_crop) || 0), 0.1)))
