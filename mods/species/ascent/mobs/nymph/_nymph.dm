#define ANYMPH_SCREEN_LOC_HELD   "EAST-8:16,SOUTH:5"
#define ANYMPH_SCREEN_LOC_HAT    "EAST-7:16,SOUTH:5"
#define ANYMPH_SCREEN_LOC_MOLT   "EAST-6:16,SOUTH:5"
#define ANYMPH_SCREEN_LOC_INTENT "EAST-2,SOUTH:5"
#define ANYMPH_SCREEN_LOC_HEALTH ui_alien_health

#define ANYMPH_MAX_CRYSTALS      20000
#define ANYMPH_CRYSTAL_MOLT      2000  // How much it takes to molt.
#define ANYMPH_NUTRITION_MOLT    125   // How much nutrition it takes to molt.
#define ANYMPH_TIME_MOLT         300   // How long to wait between molts.

/mob/living/carbon/alien/ascent_nymph
	name = SPECIES_MANTID_NYMPH
	desc = "It's a little alien skittery critter. Hiss."
	icon = 'mods/species/ascent/icons/species/nymph.dmi'
	icon_state = "larva"
	item_state = "larva"
	death_msg = "expires with a pitiful hiss..."
	health = 60
	maxHealth = 60
	available_maneuvers = list(/decl/maneuver/leap)

	only_species_language = 1
	voice_name = SPECIES_MANTID_NYMPH
	speak_emote = list("hisses", "chitters")
	universal_understand = FALSE
	universal_speak = FALSE

	can_pull_size = ITEM_SIZE_SMALL
	can_pull_mobs = MOB_PULL_SMALLER

	holder_type = /obj/item/holder/ascent_nymph
	possession_candidate = 1
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_REACT
	hud_type = /datum/hud/ascent_nymph

	var/obj/item/holding_item
	var/crystal_reserve = 1000
	var/last_molt = 0
	var/molt

/mob/living/carbon/alien/ascent_nymph/get_jump_distance()
	return 3

/mob/living/carbon/alien/ascent_nymph/Login()
	. = ..()
	if(client)
		if(holding_item)
			holding_item.screen_loc = ANYMPH_SCREEN_LOC_HELD
			client.screen |= holding_item

/mob/living/carbon/alien/ascent_nymph/Initialize(var/mapload)
	update_icon()
	. = ..(mapload)
	set_extension(src, /datum/extension/base_icon_state, icon_state)

/mob/living/carbon/alien/ascent_nymph/examine(mob/user)
	. = ..()
	if(holding_item)
		to_chat(user, SPAN_NOTICE("It is holding \icon[holding_item] \a [holding_item]."))

/mob/living/carbon/alien/ascent_nymph/has_dexterity()
	return FALSE

/mob/living/carbon/alien/ascent_nymph/death(gibbed)
	if(holding_item)
		unEquip(holding_item)

	return ..(gibbed,death_msg)

/mob/living/carbon/alien/ascent_nymph/on_update_icon()
	..()
	if(stat == DEAD)
		icon_state = "[initial(icon_state)]_dead"
	else if(incapacitated(INCAPACITATION_KNOCKOUT))
		icon_state = "[initial(icon_state)]_dead" // Maybe add sleep later?
	else
		icon_state = "[initial(icon_state)]"
