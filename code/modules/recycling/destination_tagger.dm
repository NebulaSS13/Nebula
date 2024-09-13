#define MAX_DEST_TAGGER_PREVIOUS_TAGS 25 //Give them 25 memory slot until they begin overwriting the first in the list

/obj/item/destTagger
	name       = "destination tagger"
	desc       = "Used to set the destination of properly wrapped packages."
	icon       = 'icons/obj/items/device/destination_tagger.dmi'
	icon_state = ICON_STATE_WORLD
	w_class    = ITEM_SIZE_SMALL
	slot_flags = SLOT_LOWER_BODY
	material   = /decl/material/solid/organic/plastic
	matter     = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT
	)
	///Text of the destination tag we're going to be applying next.
	var/current_tag
	///List of the last tags that were actually applied on something. Like a sort of handy quick dial feature.
	var/list/last_used_tags

/obj/item/destTagger/proc/clear_previous_tags()
	LAZYCLEARLIST(last_used_tags)

///Add a previous destionation tag to the list and perform rotation of the tag history if neccessary.
/obj/item/destTagger/proc/add_previous_tag(var/text)
	if(LAZYLEN(last_used_tags) >= MAX_DEST_TAGGER_PREVIOUS_TAGS)
		last_used_tags.Cut(1, 2)
	LAZYADD(last_used_tags, text)

/obj/item/destTagger/interact(mob/user)

	var/dat = "<tt><center><h1><b>TagMaster 2.3</b></h1></center><br>"
	dat += "<div class='item'>"
	dat += "<div class='itemLabel'>Current Selection:</div> <div class='itemContents'><a href='byond://?src=\ref[src];input_tag=1'>[current_tag ? current_tag : "None"]</a></div>"
	dat += "</div>"

	dat += "<h4>Tag History:</h4>"
	dat += "<a href='byond://?src=\ref[src];clear_previous_tags=1'>Clear History</a>"
	dat += "<table style='width:100%; padding:4px;'><tr>"
	var/cnt = 1
	for(var/prevdest in last_used_tags)
		if(cnt % 4 == 0)
			dat += "</tr><tr>"
		dat += "<td><a href='byond://?src=\ref[src];set_tag=[prevdest]'>[prevdest]</a></td>"
		++cnt
	dat += "</tr></table></tt>"

	show_browser(user, dat, "window=destTagScreen;size=450x375")

/obj/item/destTagger/attack_self(mob/user)
	interact(user)

/obj/item/destTagger/OnTopic(user, href_list, state)
	if(href_list["set_tag"])
		current_tag = sanitize_safe(href_list["set_tag"], encode = FALSE)
		to_chat(user, SPAN_NOTICE("You set \the [src] to <b>[current_tag]</b>."))
		playsound(src.loc, 'sound/machines/pda_click.ogg', 30, TRUE)
		. = TOPIC_REFRESH

	if(href_list["input_tag"])
		var/dest = input(user, "Please enter custom location.", "Location", current_tag)
		if(CanUseTopic(user, state))
			if(dest)
				current_tag = sanitize_safe(dest, encode = FALSE)
				add_previous_tag(current_tag)
				to_chat(user, SPAN_NOTICE("You designate a custom location on \the [src], set to <b>[current_tag]</b>."))
				playsound(src.loc, 'sound/machines/pda_click.ogg', 30, TRUE)
			else
				current_tag = null
				to_chat(user, SPAN_NOTICE("You clear \the [src]'s custom location."))
				playsound(src.loc, 'sound/machines/quiet_beep.ogg', 30, TRUE)
			. = TOPIC_REFRESH
		else
			. = TOPIC_HANDLED
	else if(href_list["clear_previous_tags"])
		clear_previous_tags()
		to_chat(user, SPAN_NOTICE("You clear \the [src]'s tag history."))
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		interact(user)

#undef MAX_DEST_TAGGER_PREVIOUS_TAGS