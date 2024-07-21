/decl/sprite_accessory_category/facial_hair
	name                  = "Facial Hair"
	base_accessory_type   = /decl/sprite_accessory/facial_hair
	default_accessory     = /decl/sprite_accessory/facial_hair/shaved
	always_apply_defaults = TRUE
	uid                   = "acc_cat_facial_hair"

/decl/sprite_accessory/facial_hair
	abstract_type         = /decl/sprite_accessory/facial_hair
	icon                  = 'icons/mob/human_races/species/human/facial.dmi'
	hidden_by_gear_slot   = slot_head_str
	hidden_by_gear_flag   = BLOCK_HEAD_HAIR
	body_parts            = list(BP_HEAD)
	sprite_overlay_layer  = FLOAT_LAYER
	is_heritable          = TRUE
	accessory_category    = SAC_FACIAL_HAIR
	accessory_flags       = HAIR_LOSS_VULNERABLE
	grooming_flags        = GROOMABLE_BRUSH | GROOMABLE_COMB

/decl/sprite_accessory/facial_hair/get_grooming_descriptor(grooming_result, obj/item/organ/external/organ, obj/item/grooming/tool)
	return grooming_result == GROOMING_RESULT_PARTIAL ? "chin and cheeks" : "facial hair"

/decl/sprite_accessory/facial_hair/can_be_groomed_with(obj/item/organ/external/organ, obj/item/grooming/tool)
	. = ..()
	if(. == GROOMING_RESULT_SUCCESS && (accessory_flags & HAIR_VERY_SHORT))
		return GROOMING_RESULT_PARTIAL

/decl/sprite_accessory/facial_hair/get_hidden_substitute()
	return GET_DECL(/decl/sprite_accessory/facial_hair/shaved)

/decl/sprite_accessory/facial_hair/refresh_mob(var/mob/living/subject)
	if(istype(subject))
		subject.update_hair()

/decl/sprite_accessory/facial_hair/shaved
	name                        = "Shaved"
	icon_state                  = "bald"
	uid                         = "acc_fhair_shaved"
	bodytypes_allowed           = null
	bodytypes_denied            = null
	species_allowed             = null
	subspecies_allowed          = null
	bodytype_categories_allowed = null
	bodytype_categories_denied  = null
	body_flags_allowed          = null
	body_flags_denied           = null
	draw_accessory              = FALSE
	grooming_flags              = null

/decl/sprite_accessory/facial_hair/watson
	name = "Watson Mustache"
	icon_state = "facial_watson"
	uid = "acc_fhair_watson"

/decl/sprite_accessory/facial_hair/hogan
	name = "Hulk Hogan Mustache"
	icon_state = "facial_hogan" //-Neek
	uid = "acc_fhair_hogan"

/decl/sprite_accessory/facial_hair/vandyke
	name = "Van Dyke Mustache"
	icon_state = "facial_vandyke"
	uid = "acc_fhair_vandyke"

/decl/sprite_accessory/facial_hair/chaplin
	name = "Square Mustache"
	icon_state = "facial_chaplin"
	uid = "acc_fhair_chaplin"

/decl/sprite_accessory/facial_hair/selleck
	name = "Selleck Mustache"
	icon_state = "facial_selleck"
	uid = "acc_fhair_selleck"

/decl/sprite_accessory/facial_hair/neckbeard
	name = "Neckbeard"
	icon_state = "facial_neckbeard"
	uid = "acc_fhair_neckbeard"

/decl/sprite_accessory/facial_hair/fullbeard
	name = "Full Beard"
	icon_state = "facial_fullbeard"
	uid = "acc_fhair_fullbeard"

/decl/sprite_accessory/facial_hair/longbeard
	name = "Long Beard"
	icon_state = "facial_longbeard"
	uid = "acc_fhair_longbeard"

/decl/sprite_accessory/facial_hair/vlongbeard
	name = "Very Long Beard"
	icon_state = "facial_wise"
	uid = "acc_fhair_vlongbeard"

/decl/sprite_accessory/facial_hair/elvis
	name = "Elvis Sideburns"
	icon_state = "facial_elvis"
	uid = "acc_fhair_elvis"

/decl/sprite_accessory/facial_hair/abe
	name = "Abraham Lincoln Beard"
	icon_state = "facial_abe"
	uid = "acc_fhair_abe"

/decl/sprite_accessory/facial_hair/chinstrap
	name = "Chinstrap"
	icon_state = "facial_chin"
	uid = "acc_fhair_chinstrap"

/decl/sprite_accessory/facial_hair/hip
	name = "Hipster Beard"
	icon_state = "facial_hip"
	uid = "acc_fhair_hipster"

/decl/sprite_accessory/facial_hair/gt
	name = "Goatee"
	icon_state = "facial_gt"
	uid = "acc_fhair_goatee"

/decl/sprite_accessory/facial_hair/jensen
	name = "Adam Jensen Beard"
	icon_state = "facial_jensen"
	uid = "acc_fhair_jensen"

/decl/sprite_accessory/facial_hair/volaju
	name = "Volaju"
	icon_state = "facial_volaju"
	uid = "acc_fhair_volaju"

/decl/sprite_accessory/facial_hair/dwarf
	name = "Dwarf Beard"
	icon_state = "facial_dwarf"
	uid = "acc_fhair_dwarf"

/decl/sprite_accessory/facial_hair/threeOclock
	name = "3 O'clock Shadow"
	icon_state = "facial_3oclock"
	uid = "acc_fhair_3oclock"

/decl/sprite_accessory/facial_hair/threeOclockstache
	name = "3 O'clock Shadow and Moustache"
	icon_state = "facial_3oclockmoustache"
	uid = "acc_fhair_3oclockmoustache"

/decl/sprite_accessory/facial_hair/fiveOclock
	name = "5 O'clock Shadow"
	icon_state = "facial_5oclock"
	uid = "acc_fhair_5oclock"

/decl/sprite_accessory/facial_hair/fiveOclockstache
	name = "5 O'clock Shadow and Moustache"
	icon_state = "facial_5oclockmoustache"
	uid = "acc_fhair_5oclockmoustache"

/decl/sprite_accessory/facial_hair/sevenOclock
	name = "7 O'clock Shadow"
	icon_state = "facial_7oclock"
	uid = "acc_fhair_7oclock"

/decl/sprite_accessory/facial_hair/sevenOclockstache
	name = "7 O'clock Shadow and Moustache"
	icon_state = "facial_7oclockmoustache"
	uid = "acc_fhair_7oclockmoustache"

/decl/sprite_accessory/facial_hair/mutton
	name = "Mutton Chops"
	icon_state = "facial_mutton"
	uid = "acc_fhair_mutton"

/decl/sprite_accessory/facial_hair/muttonstache
	name = "Mutton Chops and Moustache"
	icon_state = "facial_muttonmus"
	uid = "acc_fhair_muttonmus"

/decl/sprite_accessory/facial_hair/walrus
	name = "Walrus Moustache"
	icon_state = "facial_walrus"
	uid = "acc_fhair_walrus"

/decl/sprite_accessory/facial_hair/croppedbeard
	name = "Full Cropped Beard"
	icon_state = "facial_croppedfullbeard"
	uid = "acc_fhair_cropped"

/decl/sprite_accessory/facial_hair/chinless
	name = "Chinless Beard"
	icon_state = "facial_chinlessbeard"
	uid = "acc_fhair_chinless"

/decl/sprite_accessory/facial_hair/braided
	name = "Braided Beard"
	icon_state = "facial_biker"
	uid = "acc_fhair_braided"

/decl/sprite_accessory/facial_hair/seadog
	name = "Sea Dog"
	icon_state = "facial_seadog"
	uid = "acc_fhair_seadog"

/decl/sprite_accessory/facial_hair/lumberjack
	name = "Lumberjack"
	icon_state = "facial_lumberjack"
	uid = "acc_fhair_lumberjack"
