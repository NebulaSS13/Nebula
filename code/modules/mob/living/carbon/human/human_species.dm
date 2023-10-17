/mob/living/carbon/human/dummy
	real_name = "test dummy"
	status_flags = GODMODE|CANPUSH
	virtual_mob = null

/mob/living/carbon/human/dummy/mannequin/Initialize()
	. = ..()
	STOP_PROCESSING(SSmobs, src)
	global.human_mob_list -= src

/mob/living/carbon/human/dummy/selfdress/Initialize()
	. = ..()
	for(var/obj/item/I in loc)
		equip_to_appropriate_slot(I)

/mob/living/carbon/human/corpse
	real_name = "corpse"

/mob/living/carbon/human/corpse/Initialize(mapload, new_species, obj/abstract/landmark/corpse/corpse)

	. = ..(mapload, new_species)

	var/decl/cultural_info/culture = get_cultural_value(TAG_CULTURE)
	if(culture)
		var/newname = culture.get_random_name(src, gender, species.name)
		if(newname && newname != name)
			real_name = newname
			SetName(newname)
			if(mind)
				mind.name = real_name

	adjustOxyLoss(maxHealth)//cease life functions
	setBrainLoss(maxHealth)
	var/obj/item/organ/internal/heart/corpse_heart = get_organ(BP_HEART, /obj/item/organ/internal/heart)
	if(corpse_heart)
		corpse_heart.pulse = PULSE_NONE//actually stops heart to make worried explorers not care too much
	if(corpse)
		corpse.randomize_appearance(src, new_species)
		corpse.equip_corpse_outfit(src)
	update_icon()

/mob/living/carbon/human/dummy/mannequin/add_to_living_mob_list()
	return FALSE

/mob/living/carbon/human/dummy/mannequin/add_to_dead_mob_list()
	return FALSE

/mob/living/carbon/human/dummy/mannequin/fully_replace_character_name(new_name, in_depth = TRUE)
	..("[new_name] (mannequin)", FALSE)

/mob/living/carbon/human/dummy/mannequin/InitializeHud()
	return	// Mannequins don't get HUDs

/mob/living/carbon/human/monkey
	gender = PLURAL

/mob/living/carbon/human/monkey/Initialize(mapload)
	if(gender == PLURAL)
		gender = pick(MALE, FEMALE)
	. = ..(mapload, SPECIES_MONKEY)
