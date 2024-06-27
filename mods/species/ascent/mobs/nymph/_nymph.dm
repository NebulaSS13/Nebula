#define ANYMPH_SCREEN_LOC_HELD   "RIGHT-8:16,BOTTOM:5"
#define ANYMPH_SCREEN_LOC_HAT    "RIGHT-7:16,BOTTOM:5"
#define ANYMPH_SCREEN_LOC_MOLT   "RIGHT-6:16,BOTTOM:5"
#define ANYMPH_SCREEN_LOC_INTENT "RIGHT-2,BOTTOM:5"
#define ANYMPH_SCREEN_LOC_HEALTH ui_alien_health

#define ANYMPH_MAX_CRYSTALS      20000
#define ANYMPH_CRYSTAL_MOLT      2000  // How much it takes to molt.
#define ANYMPH_NUTRITION_MOLT    125   // How much nutrition it takes to molt.
#define ANYMPH_TIME_MOLT         300   // How long to wait between molts.

/mob/living/simple_animal/alien/kharmaan
	name = "mantid nymph"
	desc = "It's a little alien skittery critter. Hiss."
	icon = 'mods/species/ascent/icons/species/nymph.dmi'
	icon_state = ICON_STATE_WORLD
	death_message = "expires with a pitiful hiss..."
	max_health = 60
	available_maneuvers = list(/decl/maneuver/leap)

	only_species_language = 1
	speak_emote = list("hisses", "chitters")
	universal_understand = FALSE
	universal_speak = FALSE

	can_pull_size = ITEM_SIZE_SMALL
	can_pull_mobs = MOB_PULL_SMALLER

	holder_type = /obj/item/holder/ascent_nymph
	possession_candidate = 1
	atom_flags = ATOM_FLAG_NO_CHEM_CHANGE
	hud_used = /datum/hud/ascent_nymph

	var/crystal_reserve = 1000
	var/last_molt = 0
	var/molt

/mob/living/simple_animal/alien/kharmaan/setup_languages()
	add_language(/decl/language/mantid)
	add_language(/decl/language/mantid/nonvocal)

/mob/living/simple_animal/alien/kharmaan/get_jump_distance()
	return 3

/mob/living/simple_animal/alien/kharmaan/Initialize(var/mapload)
	update_icon()
	. = ..(mapload)
	add_inventory_slot(new /datum/inventory_slot/head/simple)
	add_held_item_slot(new /datum/inventory_slot/gripper/mouth/nymph/ascent)
	set_extension(src, /datum/extension/base_icon_state, icon_state)

/mob/living/simple_animal/alien/kharmaan/get_dexterity(var/silent)
	return (DEXTERITY_EQUIP_ITEM)
