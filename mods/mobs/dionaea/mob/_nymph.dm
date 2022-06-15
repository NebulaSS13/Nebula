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
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_REACT
	hud_type = /datum/hud/diona_nymph

	ai = /datum/ai/nymph

	z_flags = ZMM_MANGLE_PLANES

	var/tmp/flower_color
	var/tmp/last_glow

/mob/living/carbon/alien/diona/has_dexterity(dex_level)
	return dex_level <= DEXTERITY_GRIP

/mob/living/carbon/alien/diona/get_jump_distance()
	return 3

/mob/living/carbon/alien/diona/Initialize(var/mapload, var/flower_chance = 15)

	set_extension(src, /datum/extension/base_icon_state, icon_state)
	add_language(/decl/language/diona)
	add_language(/decl/language/human/common, 0)

	if(prob(flower_chance))
		flower_color = get_random_colour(1)
	update_icon()

	. = ..(mapload)

/mob/living/carbon/alien/diona/show_examined_worn_held_items(mob/user, distance, infix, suffix, hideflags, decl/pronouns/pronouns)
	. = ..()
	var/datum/extension/hattable/hattable = get_extension(src, /datum/extension/hattable)
	if(hattable?.hat)
		to_chat(user, SPAN_NOTICE("It is wearing [html_icon(hattable.hat)] \a [hattable.hat]."))

/mob/living/carbon/alien/diona/has_dexterity()
	return FALSE


/mob/living/carbon/alien/diona/sterile
	name = "sterile nymph"

/mob/living/carbon/alien/diona/sterile/Initialize(var/mapload)
	. = ..(mapload, 0)

