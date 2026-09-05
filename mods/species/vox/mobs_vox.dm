/mob/living/simple_animal/hostile/slug/check_friendly_species(var/mob/living/human/H)
	return (istype(H) && H.get_bodytype_category() == BODYTYPE_VOX) || ..()

/mob/living/human/vox
	faction = "vox"
	var/spawn_outfit = /decl/outfit/vox

/mob/living/human/vox/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	SET_HAIR_STYLE(src, /decl/sprite_accessory/hair/vox/short, TRUE)
	SET_HAIR_COLOR(src, COLOR_BEASTY_BROWN, TRUE)
	species_uid = /decl/species/vox::uid
	. = ..()
	set_eye_colour(COLOR_CYAN)
	if(spawn_outfit)
		dressup_human(src, GET_DECL(spawn_outfit))

/datum/mob_controller/aggressive/vox_raider
	socially_distancing = TRUE

/mob/living/human/vox/survivor
	spawn_outfit = /decl/outfit/vox/survivor

/mob/living/human/vox/raider
	spawn_outfit = /decl/outfit/vox/raider
	ai = /datum/mob_controller/aggressive/vox_raider
