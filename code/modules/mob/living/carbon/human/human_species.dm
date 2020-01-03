/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH
	virtual_mob = null

/mob/living/carbon/human/dummy/mannequin/Initialize()
	. = ..()
	STOP_PROCESSING(SSmobs, src)
	GLOB.human_mob_list -= src
	delete_inventory()

/mob/living/carbon/human/dummy/selfdress/Initialize()
	. = ..()
	for(var/obj/item/I in loc)
		equip_to_appropriate_slot(I)

/mob/living/carbon/human/corpse/Initialize(mapload, new_species, obj/effect/landmark/corpse/corpse)
	. = ..(mapload, new_species)

	adjustOxyLoss(maxHealth)//cease life functions
	setBrainLoss(maxHealth)
	var/obj/item/organ/internal/heart/corpse_heart = internal_organs_by_name[BP_HEART]
	if(corpse_heart)
		corpse_heart.pulse = PULSE_NONE//actually stops heart to make worried explorers not care too much
	if(corpse)
		corpse.randomize_appearance(src, new_species)
		corpse.equip_outfit(src)
	update_icon()

/mob/living/carbon/human/dummy/mannequin/add_to_living_mob_list()
	return FALSE

/mob/living/carbon/human/dummy/mannequin/add_to_dead_mob_list()
	return FALSE

/mob/living/carbon/human/dummy/mannequin/fully_replace_character_name(new_name)
	..("[new_name] (mannequin)", FALSE)

/mob/living/carbon/human/dummy/mannequin/InitializeHud()
	return	// Mannequins don't get HUDs

/mob/living/carbon/human/monkey/Initialize(mapload)
	gender = pick(MALE, FEMALE)
	. = ..(ampload, SPECIES_MONKEY)