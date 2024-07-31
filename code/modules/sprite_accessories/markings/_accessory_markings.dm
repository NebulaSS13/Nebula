/decl/sprite_accessory_category/markings
	name                  = "Markings"
	single_selection      = FALSE
	base_accessory_type   = /decl/sprite_accessory/marking
	uid                   = "acc_cat_markings"
	always_apply_defaults = TRUE
	clear_in_pref_apply   = TRUE

/decl/sprite_accessory/marking
	icon                  = 'icons/mob/human_races/species/default_markings.dmi'
	abstract_type         = /decl/sprite_accessory/marking
	mask_to_bodypart      = TRUE
	accessory_category    = SAC_MARKINGS

/decl/sprite_accessory/marking/refresh_mob(var/mob/living/subject)
	if(istype(subject))
		subject.update_body()
