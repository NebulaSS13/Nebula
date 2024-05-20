/*
	Badges are worn on the belt or neck, and can be used to show the user's credentials.
	The user' details can be imprinted on holobadges with the relevant ID card,
	or they can be emagged to accept any ID for use in disguises.
*/

/obj/item/clothing/badge
	name = "badge"
	desc = "A leather-backed badge, with gold trimmings."
	icon = 'icons/clothing/accessories/badges/detectivebadge.dmi'
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_LOWER_BODY
	accessory_slot = ACCESSORY_SLOT_INSIGNIA
	fallback_slot = slot_w_uniform_str
	var/badge_string = "Detective"
	var/stored_name


/obj/item/clothing/badge/get_initial_accessory_hide_on_states()
	var/static/list/initial_accessory_hide_on_states = list(
		/decl/clothing_state_modifier/rolled_down
	)
	return initial_accessory_hide_on_states

/obj/item/clothing/badge/get_lore_info()
	. = ..()
	if(SScodex.get_codex_entry(badge_string))
		. += "<br>Denotes affiliation to <l>[badge_string]</l>."
	else
		. += "<br>Denotes affiliation to [badge_string]."

/obj/item/clothing/badge/proc/set_name(var/new_name)
	stored_name = new_name

/obj/item/clothing/badge/proc/set_desc(var/mob/living/human/H)

/obj/item/clothing/badge/get_examine_line()
	. = ..()
	. += "  <a href='byond://?src=\ref[src];look_at_me=1'>\[View\]</a>"

/obj/item/clothing/badge/examine(user)
	. = ..()
	if(stored_name)
		to_chat(user,"It reads: [stored_name], [badge_string].")

/obj/item/clothing/badge/attack_self(mob/user)

	if(!stored_name)
		to_chat(user, "You inspect your [src.name]. Everything seems to be in order and you give it a quick cleaning with your hand.")
		set_name(user.real_name)
		set_desc(user)
		return

	if(isliving(user))
		if(stored_name)
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [stored_name], [badge_string].</span>","<span class='notice'>You display your [src.name].\nIt reads: [stored_name], [badge_string].</span>")
		else
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [badge_string].</span>","<span class='notice'>You display your [src.name]. It reads: [badge_string].</span>")

/obj/item/clothing/badge/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(isliving(user) && user.a_intent == I_HURT)
		user.visible_message(
			SPAN_DANGER("\The [user] invades \the [target]'s personal space, thrusting \the [src] into their face insistently."),
			SPAN_DANGER("You invade \the [target]'s personal space, thrusting \the [src] into their face insistently.")
		)
		if(stored_name)
			to_chat(target, SPAN_NOTICE("It reads: [stored_name], [badge_string]."))
		return TRUE
	return ..()
