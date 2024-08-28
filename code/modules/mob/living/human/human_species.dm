/mob/living/human/dummy
	real_name = "test dummy"
	status_flags = GODMODE|CANPUSH
	virtual_mob = null

/mob/living/human/dummy/mannequin/Initialize(mapload, species_name, datum/mob_snapshot/supplied_appearance)
	. = ..()
	STOP_PROCESSING(SSmobs, src)
	global.human_mob_list -= src

/mob/living/human/dummy/selfdress/Initialize(mapload, species_name, datum/mob_snapshot/supplied_appearance)
	..()
	return INITIALIZE_HINT_LATELOAD

/mob/living/human/dummy/selfdress/LateInitialize()
	for(var/obj/item/I in loc)
		equip_to_appropriate_slot(I)

/mob/living/human/corpse
	real_name = "corpse"

/mob/living/human/corpse/get_death_message(gibbed)
	return SKIP_DEATH_MESSAGE

/mob/living/human/corpse/Initialize(mapload, species_name, datum/mob_snapshot/supplied_appearance, obj/abstract/landmark/corpse/corpse)
	. = ..(mapload, species_name, supplied_appearance) // do not pass the corpse landmark
	var/decl/background_detail/background = get_background_datum_by_flag(BACKGROUND_FLAG_NAMING)
	if(background)
		var/newname = background.get_random_name(src, gender, species.name)
		if(newname && newname != name)
			real_name = newname
			SetName(newname)
			if(mind)
				mind.name = real_name
	if(corpse)
		corpse.randomize_appearance(src, get_species_name())
		corpse.equip_corpse_outfit(src)
	return INITIALIZE_HINT_LATELOAD

/mob/living/human/corpse/get_death_message(gibbed)
	return SKIP_DEATH_MESSAGE

/mob/living/human/corpse/LateInitialize()
	..()
	var/current_max_health = get_max_health()
	take_damage(current_max_health, OXY) //cease life functions
	set_damage(BRAIN, current_max_health)
	death()
	var/obj/item/organ/internal/heart/corpse_heart = get_organ(BP_HEART, /obj/item/organ/internal/heart)
	if(corpse_heart)
		corpse_heart.pulse = PULSE_NONE//actually stops heart to make worried explorers not care too much

/mob/living/human/dummy/mannequin/add_to_living_mob_list()
	return FALSE

/mob/living/human/dummy/mannequin/add_to_dead_mob_list()
	return FALSE

/mob/living/human/dummy/mannequin/fully_replace_character_name(new_name, in_depth = TRUE)
	..("[new_name] (mannequin)", FALSE)

/mob/living/human/dummy/mannequin/InitializeHud()
	return	// Mannequins don't get HUDs

/mob/living/human/monkey
	gender = PLURAL

/mob/living/human/monkey/Initialize(mapload, species_name, datum/mob_snapshot/supplied_appearance)
	if(gender == PLURAL)
		gender = pick(MALE, FEMALE)
	species_name = SPECIES_MONKEY
	. = ..()
