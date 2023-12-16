#define DIONA_SCREEN_LOC_HELD   "RIGHT-8:16,BOTTOM:5"
#define DIONA_SCREEN_LOC_HAT    "RIGHT-7:16,BOTTOM:5"
#define DIONA_SCREEN_LOC_INTENT "RIGHT-2,BOTTOM:5"
#define DIONA_SCREEN_LOC_HEALTH ui_alien_health

/mob/living/carbon/alien/diona
	name = "diona nymph"
	desc = "It's a little skittery critter. Chirp."
	icon = 'mods/mobs/dionaea/icons/nymph.dmi'
	icon_state = ICON_STATE_WORLD
	death_msg = "expires with a pitiful chirrup..."
	health = 60
	maxHealth = 60
	available_maneuvers = list(/decl/maneuver/leap)
	status_flags = NO_ANTAG

	language = /decl/language/diona
	species_language = /decl/language/diona
	only_species_language = 1
	voice_name = "diona nymph"
	speak_emote = list("chirrups")
	universal_understand = FALSE
	universal_speak = FALSE

	can_pull_size = ITEM_SIZE_SMALL
	can_pull_mobs = MOB_PULL_SMALLER

	holder_type = /obj/item/holder/diona
	possession_candidate = 1
	atom_flags = ATOM_FLAG_NO_CHEM_CHANGE
	hud_type = /datum/hud/diona_nymph

	ai = /datum/ai/nymph

	z_flags = ZMM_MANGLE_PLANES

	var/tmp/flower_color
	var/tmp/last_glow

/mob/living/carbon/alien/diona/get_jump_distance()
	return 3

/mob/living/carbon/alien/diona/sterile
	name = "sterile nymph"

/mob/living/carbon/alien/diona/sterile/Initialize(var/mapload)
	. = ..(mapload, 0)

/mob/living/carbon/alien/diona/Initialize(var/mapload, var/flower_chance = 15)

	set_extension(src, /datum/extension/base_icon_state, icon_state)
	add_language(/decl/language/diona)
	add_language(/decl/language/human/common, 0)
	add_inventory_slot(new /datum/inventory_slot/head/simple)
	add_held_item_slot(new /datum/inventory_slot/gripper/mouth/nymph)
	if(prob(flower_chance))
		flower_color = get_random_colour(1)
	update_icon()

	. = ..(mapload)

/mob/living/carbon/alien/diona/get_dexterity(var/silent)
	return (DEXTERITY_EQUIP_ITEM|DEXTERITY_HOLD_ITEM)

/mob/living/carbon/alien/diona/get_bodytype()
	return GET_DECL(/decl/bodytype/diona)

/decl/bodytype/diona
	name = "nymph"
	bodytype_flag = 0
	bodytype_category = "diona nymph body"

/decl/bodytype/diona/Initialize()
	equip_adjust = list(
		slot_head_str = list(
			"[NORTH]" = list(0, -8),
			"[SOUTH]" = list(0, -8),
			"[EAST]" =  list(0, -8),
			"[WEST]" =  list(0, -8)
		)
	)
	. = ..()
