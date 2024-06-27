/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the IC data card reader
 */
/obj/item/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card.dmi'
	w_class = ITEM_SIZE_TINY
	material = /decl/material/solid/organic/plastic
	slot_flags = SLOT_EARS
	drop_sound = 'sound/foley/paperpickup1.ogg'
	pickup_sound = 'sound/foley/paperpickup2.ogg'

/obj/item/card/union
	name = "union card"
	desc = "A card showing membership in the local worker's union."
	icon_state = "union"
	slot_flags = SLOT_ID
	var/signed_by

/obj/item/card/union/examine(mob/user)
	. = ..()
	if(signed_by)
		to_chat(user, "It has been signed by [signed_by].")
	else
		to_chat(user, "It has a blank space for a signature.")

/obj/item/card/union/attackby(var/obj/item/thing, var/mob/user)
	if(IS_PEN(thing))
		if(signed_by)
			to_chat(user, SPAN_WARNING("\The [src] has already been signed."))
		else
			var/signature = sanitize_safe(input("What do you want to sign the card as?", "Union Card") as text, MAX_NAME_LEN)
			if(signature && !signed_by && !user.incapacitated() && Adjacent(user))
				signed_by = signature
				user.visible_message(SPAN_NOTICE("\The [user] signs \the [src] with a flourish."))
		return
	..()

/obj/item/card/data
	name = "data card"
	desc = "A plastic magstripe card for simple and speedy data storage and transfer. This one has a stripe running down the middle."
	icon_state = "data_1"
	var/detail_color = COLOR_ASSEMBLY_ORANGE
	var/function = "storage"
	var/data = "null"

/obj/item/card/data/Initialize()
	. = ..()
	update_icon()

/obj/item/card/data/on_update_icon()
	. = ..()
	add_overlay(overlay_image(icon, "[icon_state]-color", detail_color))

/obj/item/card/data/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/integrated_electronics/detailer))
		var/obj/item/integrated_electronics/detailer/D = I
		detail_color = D.detail_color
		update_icon()
	return ..()

/obj/item/card/data/full_color
	desc = "A plastic magstripe card for simple and speedy data storage and transfer. This one has the entire card colored."
	icon_state = "data_2"

/obj/item/card/data/disk
	desc = "A plastic magstripe card for simple and speedy data storage and transfer. This one inexplicibly looks like a floppy disk."
	icon_state = "data_3"

/obj/item/card/data/get_assembly_detail_color()
	return detail_color

/*
 * ID CARDS
 */

/obj/item/card/emag_broken
	desc = "It's a card with a magnetic strip attached to some circuitry. It looks too busted to be used for anything but salvage."
	name = "broken cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = @'{"magnets":2,"esoteric":2}'

/obj/item/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = @'{"magnets":2,"esoteric":2}'
	var/uses = 10

	var/static/list/card_choices = list(
							/obj/item/card/emag,
							/obj/item/card/union,
							/obj/item/card/data,
							/obj/item/card/data/full_color,
							/obj/item/card/data/disk,
							/obj/item/card/id,
						) //Should be enough of a selection for most purposes

var/global/const/NO_EMAG_ACT = -50
/obj/item/card/emag/resolve_attackby(atom/A, mob/user)
	var/used_uses = A.emag_act(uses, user, src)
	if(used_uses == NO_EMAG_ACT)
		return ..(A, user)

	uses -= used_uses
	A.add_fingerprint(user)
	if(used_uses)
		log_and_message_admins("emagged \an [A].")

	if(uses<1)
		user.visible_message("<span class='warning'>\The [src] fizzles and sparks - it seems it's been used once too often, and is now spent.</span>")
		var/obj/item/card/emag_broken/junk = new(user.loc)
		junk.add_fingerprint(user)
		qdel(src)

	return 1

/obj/item/card/emag/Initialize()
	. = ..()
	if(length(card_choices) && !card_choices[card_choices[1]])
		card_choices = generate_chameleon_choices(card_choices)

/obj/item/card/emag/verb/change(picked in card_choices)
	set name = "Change Cryptographic Sequencer Appearance"
	set category = "Chameleon Items"
	set src in usr

	if (!(usr.incapacitated()))
		if(!ispath(card_choices[picked]))
			return

		disguise(card_choices[picked], usr)

/obj/item/card/emag/examine(mob/user)
	. = ..()
	if(user.skill_check(SKILL_DEVICES,SKILL_ADEPT))
		to_chat(user, SPAN_WARNING("This ID card has some form of non-standard modifications."))

/obj/item/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access."
	icon = 'icons/obj/id/id.dmi'
	slot_flags = SLOT_ID
	var/list/access = list()
	var/registered_name = "Unknown" // The name registered_name on the card
	var/associated_account_number = 0

	// Associated network account. For normal IDs this is simply informational, but for network enabled IDs this is used for group-based access.
	var/list/associated_network_account = list("login" = "", "password" = "")

	var/age = "\[UNSET\]"
	var/blood_type = "\[UNSET\]"
	var/dna_hash = "\[UNSET\]"
	var/fingerprint_hash = "\[UNSET\]"
	var/card_gender = "\[UNSET\]"
	var/icon/front
	var/icon/side

	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system
	var/assignment //can be alt title or the actual job
	var/position   // actual job

	var/datum/mil_branch/military_branch = null //Vars for tracking branches and ranks on multi-crewtype maps
	var/datum/mil_rank/military_rank = null

	var/formal_name_prefix
	var/formal_name_suffix

	var/detail_color
	var/extra_details

/obj/item/card/id/Initialize()
	. = ..()
	update_icon()

/obj/item/card/id/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && detail_color)
		overlay.overlays += overlay_image(overlay.icon, "[overlay.icon_state]-colors", detail_color, RESET_COLOR)
	. = ..()

/obj/item/card/id/on_update_icon()
	. = ..()
	if(detail_color)
		add_overlay(overlay_image(icon, "[icon_state]-colors", detail_color, RESET_COLOR))
	for(var/detail in extra_details)
		add_overlay(overlay_image(icon, "[icon_state]-[detail]", flags = RESET_COLOR))

/obj/item/card/id/Topic(href, href_list, datum/topic_state/state)
	var/mob/user = usr
	if(href_list["look_at_id"] && istype(user))
		var/turf/T = get_turf(src)
		if(T.CanUseTopic(user, global.view_topic_state) != STATUS_CLOSE)
			user.examinate(src)
			return TOPIC_HANDLED
	. = ..()

/obj/item/card/id/examine(mob/user, distance)
	. = ..()
	to_chat(user, "It says '[get_display_name()]'.")
	if(distance <= 1)
		show(user)

/obj/item/card/id/proc/prevent_tracking()
	return 0

/obj/item/card/id/proc/show(mob/user)
	if(front && side)
		send_rsc(user, front, "front.png")
		send_rsc(user, side, "side.png")
	var/datum/browser/written_physical/popup = new(user, "idcard", name, 600, 250)
	popup.set_content(dat())
	popup.open()
	return

/obj/item/card/id/proc/get_display_name()
	. = registered_name
	if(military_rank && military_rank.name_short)
		. ="[military_rank.name_short] [.][formal_name_suffix]"
	else if(formal_name_prefix || formal_name_suffix)
		. = "[formal_name_prefix][.][formal_name_suffix]"
	if(assignment)
		. += ", [assignment]"

/obj/item/card/id/proc/set_id_photo(var/mob/M)
	front = getFlatIcon(M, SOUTH, always_use_defdir = 1)
	side = getFlatIcon(M, WEST, always_use_defdir = 1)

/mob/proc/set_id_info(var/obj/item/card/id/id_card)
	id_card.age = 0

	id_card.formal_name_prefix = initial(id_card.formal_name_prefix)
	id_card.formal_name_suffix = initial(id_card.formal_name_suffix)
	if(client && client.prefs)
		for(var/culturetag in client.prefs.cultural_info)
			var/decl/cultural_info/culture = GET_DECL(client.prefs.cultural_info[culturetag])
			if(culture)
				id_card.formal_name_prefix = "[culture.get_formal_name_prefix()][id_card.formal_name_prefix]"
				id_card.formal_name_suffix = "[id_card.formal_name_suffix][culture.get_formal_name_suffix()]"

	id_card.registered_name = real_name

	var/decl/pronouns/G = get_pronouns()
	if(G)
		id_card.card_gender = capitalize(G.bureaucratic_term )
	else
		id_card.card_gender = "Unset"
	id_card.set_id_photo(src)

	id_card.blood_type       = get_blood_type()                       || "Unset"
	id_card.dna_hash         = get_unique_enzymes()                   || "Unset"
	id_card.fingerprint_hash = get_full_print(ignore_blockers = TRUE) || "Unset"

/mob/living/human/set_id_info(var/obj/item/card/id/id_card)
	..()
	id_card.age = get_age()
	if(global.using_map.flags & MAP_HAS_BRANCH)
		id_card.military_branch = char_branch
	if(global.using_map.flags & MAP_HAS_RANK)
		id_card.military_rank = char_rank

/obj/item/card/id/proc/dat()
	var/list/dat = list("<table><tr><td>")
	dat += text("Name: []</A><BR>", "[formal_name_prefix][registered_name][formal_name_suffix]")
	dat += text("Gender: []</A><BR>\n", card_gender)
	dat += text("Age: []</A><BR>\n", age)

	if(global.using_map.flags & MAP_HAS_BRANCH)
		dat += text("Branch: []</A><BR>\n", military_branch ? military_branch.name : "\[UNSET\]")
	if(global.using_map.flags & MAP_HAS_RANK)
		dat += text("Rank: []</A><BR>\n", military_rank ? military_rank.name : "\[UNSET\]")

	dat += text("Assignment: []</A><BR>\n", assignment)
	dat += text("Fingerprint: []</A><BR>\n", fingerprint_hash)
	dat += text("Blood Type: []<BR>\n", blood_type)
	dat += text("DNA Hash: []<BR><BR>\n", dna_hash)
	if(front && side)
		dat +="<td align = center valign = top>Photo:<br><img src=front.png width=80 border=4><img src=side.png width=80 border=4></td>"
	dat += "</tr></table>"
	return jointext(dat,null)

/obj/item/card/id/attack_self(mob/user)
	user.visible_message("\The [user] shows you: [html_icon(src)] [src.name]. The assignment on the card: '[src.assignment]'.",\
		"You flash your ID card: [html_icon(src)] [src.name]. The assignment on the card: '[src.assignment]'.")

	src.add_fingerprint(user)
	return

/obj/item/card/id/GetAccess()
	return access.Copy()


/obj/item/card/id/GetIdCards(list/exceptions)
	. = ..()
	if(!is_type_in_list(src, exceptions))
		LAZYDISTINCTADD(., src)

/obj/item/card/id/verb/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	to_chat(usr, "[html_icon(src)] [name]: The current assignment on the card is [assignment].")
	to_chat(usr, "The blood type on the card is [blood_type].")
	to_chat(usr, "The DNA hash on the card is [dna_hash].")
	to_chat(usr, "The fingerprint hash on the card is [fingerprint_hash].")
	return

/decl/vv_set_handler/id_card_military_branch
	handled_type = /obj/item/card/id
	handled_vars = list("military_branch")

/decl/vv_set_handler/id_card_military_branch/handle_set_var(var/obj/item/card/id/id, variable, var_value, client)
	if(!var_value)
		id.military_branch = null
		id.military_rank = null
		return

	if(istype(var_value, /datum/mil_branch))
		if(var_value != id.military_branch)
			id.military_branch = var_value
			id.military_rank = null
		return

	if(ispath(var_value, /datum/mil_branch) || istext(var_value))
		var/datum/mil_branch/new_branch = mil_branches.get_branch(var_value)
		if(new_branch)
			if(new_branch != id.military_branch)
				id.military_branch = new_branch
				id.military_rank = null
			return

	to_chat(client, SPAN_WARNING("Input, must be an existing branch - [var_value] is invalid"))

/decl/vv_set_handler/id_card_military_rank
	handled_type = /obj/item/card/id
	handled_vars = list("military_rank")

/decl/vv_set_handler/id_card_military_rank/handle_set_var(var/obj/item/card/id/id, variable, var_value, client)
	if(!var_value)
		id.military_rank = null
		return

	if(!id.military_branch)
		to_chat(client, SPAN_WARNING("military_branch not set - No valid ranks available"))
		return

	if(ispath(var_value, /datum/mil_rank))
		var/datum/mil_rank/rank = var_value
		var_value = initial(rank.name)

	if(istype(var_value, /datum/mil_rank))
		var/datum/mil_rank/rank = var_value
		var_value = rank.name

	if(istext(var_value))
		var/new_rank = mil_branches.get_rank(id.military_branch.name, var_value)
		if(new_rank)
			id.military_rank = new_rank
			return

	to_chat(client, SPAN_WARNING("Input must be an existing rank belonging to military_branch - [var_value] is invalid"))

/obj/item/card/id/syndicate_command
	name = "syndicate ID card"
	desc = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	assignment = "Syndicate Overlord"
	access = list(access_hacked, access_external_airlocks)
	color = COLOR_RED_GRAY
	detail_color = COLOR_GRAY40

/obj/item/card/id/captains_spare
	name = "captain's spare ID"
	desc = "The spare ID of the High Lord himself."
	icon_state = ICON_STATE_WORLD
	item_state = "gold_id"
	registered_name = "Captain"
	assignment = "Captain"
	detail_color = COLOR_AMBER

/obj/item/card/id/captains_spare/Initialize()
	. = ..()
	access = get_all_station_access()

/obj/item/card/id/captains_spare/preserve_in_cryopod(var/obj/machinery/cryopod/pod)
	return TRUE

/obj/item/card/id/synthetic
	name = "\improper Synthetic ID"
	desc = "Access module for lawed synthetics."
	icon_state = "robot_base"
	assignment = "Synthetic"
	detail_color = COLOR_AMBER

/obj/item/card/id/synthetic/Initialize()
	. = ..()
	access = get_all_station_access() + access_synth

/obj/item/card/id/centcom
	name = "\improper CentCom. ID"
	desc = "An ID straight from Cent. Com."
	registered_name = "Central Command"
	assignment = "General"
	color = COLOR_GRAY40
	detail_color = COLOR_COMMAND_BLUE
	extra_details = list("goldstripe")

/obj/item/card/id/centcom/station/Initialize()
	. = ..()
	access |= get_all_station_access()

/obj/item/card/id/centcom/ERT
	name = "\improper Emergency Response Team ID"
	assignment = "Emergency Response Team"

/obj/item/card/id/centcom/ERT/Initialize()
	. = ..()
	access |= get_all_station_access()

/obj/item/card/id/all_access
	name = "\improper Administrator's spare ID"
	desc = "The spare ID of the Lord of Lords himself."
	registered_name = "Administrator"
	assignment = "Administrator"
	detail_color = COLOR_MAROON
	extra_details = list("goldstripe")

/obj/item/card/id/all_access/Initialize()
	. = ..()
	access = get_access_ids()

/obj/item/card/id/civilian
	name = "identification card"
	desc = "A card issued to civilian staff."
	detail_color = COLOR_CIVIE_GREEN

/obj/item/card/id/civilian/head //This is not the HoP. There's no position that uses this right now.
	name = "identification card"
	desc = "A card which represents common sense and responsibility."
	extra_details = list("goldstripe")

/obj/item/card/id/merchant
	name = "identification card"
	desc = "A card issued to Merchants, indicating their right to sell and buy goods."
	access = list(access_merchant)
	color = COLOR_OFF_WHITE
	detail_color = COLOR_BEIGE

/obj/item/card/id/silver
	name = "identification card"
	desc = "A silver card which shows honour and dedication."
	item_state = "silver_id"

/obj/item/card/id/gold
	name = "identification card"
	desc = "A golden card which shows power and might."
	color = "#d4c780"
	extra_details = list("goldstripe")