/proc/drake_spend_sap(mob/living/user, amount)
	var/obj/item/organ/internal/drake_gizzard/gizzard = user.get_organ(BP_DRAKE_GIZZARD)
	if(istype(gizzard))
		return gizzard.spend_charge(amount)
	return FALSE

/proc/drake_has_sap(mob/living/user, amount)
	var/obj/item/organ/internal/drake_gizzard/gizzard = user.get_organ(BP_DRAKE_GIZZARD)
	if(istype(gizzard))
		return gizzard.has_charge(amount)
	return FALSE

/proc/drake_add_sap(mob/living/user, amount)
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
	var/stored_sap = 0

/obj/item/organ/internal/drake_gizzard/proc/has_charge(amount)
	return stored_sap >= amount

/obj/item/organ/internal/drake_gizzard/proc/spend_charge(amount)
	stored_sap -= amount
	if(stored_sap < 0)
		stored_sap = 0
		return FALSE
	return TRUE

/obj/item/organ/internal/drake_gizzard/proc/add_charge(amount)
	stored_sap += amount
	return TRUE

/obj/item/organ/internal/drake_gizzard/get_stat_info()
	return list("Sap reserve", num2text(round((stored_sap || 0), 0.1)))

/obj/item/organ/internal/drake_gizzard/Process()
	. = ..()
	if(owner && owner.stat != DEAD && !is_broken() && !has_charge(10))
		add_charge(0.5)
