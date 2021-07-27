#define DIONA_SCREEN_LOC_HELD   "EAST-8:16,SOUTH:5"
#define DIONA_SCREEN_LOC_HAT    "EAST-7:16,SOUTH:5"
#define DIONA_SCREEN_LOC_INTENT "EAST-2,SOUTH:5"
#define DIONA_SCREEN_LOC_HEALTH ui_alien_health

/datum/extension/hattable/diona_nymph/wear_hat(mob/wearer, obj/item/clothing/head/new_hat)
	var/mob/living/carbon/alien/diona/doona = wearer
	if(istype(doona) && (!doona.holding_item || doona.holding_item != new_hat))
		. = ..()
	if(.)
		hat?.screen_loc = DIONA_SCREEN_LOC_HAT

/mob/living/carbon/alien/diona
	name = "diona nymph"
	desc = "It's a little skittery critter. Chirp."
	icon = 'mods/mobs/dionaea/icons/gestalt.dmi'
	icon_state = "nymph"
	item_state = "nymph"
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

	var/obj/item/holding_item
	var/mob/living/carbon/alien/diona/next_nymph
	var/mob/living/carbon/alien/diona/previous_nymph
	var/tmp/image/flower
	var/tmp/image/eyes
	var/tmp/last_glow

/mob/living/carbon/alien/diona/get_jump_distance()
	return 3

/mob/living/carbon/alien/diona/Login()
	. = ..()
	if(client)
		if(holding_item)
			holding_item.screen_loc = DIONA_SCREEN_LOC_HELD
			client.screen |= holding_item
		var/datum/extension/hattable/hattable = get_extension(src, /datum/extension/hattable)
		if(hattable?.hat)
			hattable.hat.screen_loc = DIONA_SCREEN_LOC_HAT
			client.screen |= hattable.hat

/mob/living/carbon/alien/diona/sterile
	name = "sterile nymph"

/mob/living/carbon/alien/diona/sterile/Initialize(var/mapload)
	. = ..(mapload, 0)

/mob/living/carbon/alien/diona/Initialize(var/mapload, var/flower_chance = 15)

	set_extension(src, /datum/extension/base_icon_state, icon_state)
	add_language(/decl/language/diona)
	add_language(/decl/language/human/common, 0)

	set_extension(src, /datum/extension/hattable/diona_nymph, list(0, -8))

	eyes = emissive_overlay(icon = icon, icon_state = "eyes_[icon_state]")

	if(prob(flower_chance))
		flower = image(icon = icon, icon_state = "flower_back")
		var/image/I = image(icon = icon, icon_state = "flower_fore")
		I.color = get_random_colour(1)
		flower.overlays += I

	update_icon()

	. = ..(mapload)

/mob/living/carbon/alien/diona/examine(mob/user)
	. = ..()
	if(holding_item)
		to_chat(user, SPAN_NOTICE("It is holding [html_icon(holding_item)] \a [holding_item]."))
	var/datum/extension/hattable/hattable = get_extension(src, /datum/extension/hattable)
	if(hattable?.hat)
		to_chat(user, SPAN_NOTICE("It is wearing [html_icon(hattable.hat)] \a [hattable.hat]."))

/mob/living/carbon/alien/diona/has_dexterity()
	return FALSE