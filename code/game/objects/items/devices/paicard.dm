/obj/item/paicard
	name = "personal AI device"
	icon = 'icons/obj/items/device/pai.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_LOWER_BODY
	origin_tech = "{'programming':2}"
	material = /decl/material/solid/glass
	matter = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT)

	var/current_emotion = 1
	var/obj/item/radio/radio
	var/looking_for_personality = 0
	var/mob/living/silicon/pai/pai

/obj/item/paicard/relaymove(var/mob/user, var/direction)
	if(user.stat || user.stunned)
		return
	var/obj/item/rig/rig = src.get_rig()
	if(istype(rig))
		rig.forced_move(direction, user)

/obj/item/paicard/Initialize()
	. = ..()
	overlays += "pai-off"

/obj/item/paicard/Destroy()
	//Will stop people throwing friend pAIs into the singularity so they can respawn
	if(!isnull(pai))
		pai.death(0)
	QDEL_NULL(radio)
	return ..()

/obj/item/paicard/attack_self(mob/user)
	if (!in_range(src, user))
		return
	user.set_machine(src)
	var/dat = {"
		<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
		<html>
			<head>
				<style>
					body {
					    margin-top:5px;
					    font-family:Verdana;
					    color:white;
					    font-size:13px;
					    background-image:url('uiBackground.png');
					    background-repeat:repeat;
					    background-color:#272727;
						background-position:center top;
					}
					table {
					    font-size:13px;
					    margin-left:-2px;
					}
					table.request {
					    border-collapse:collapse;
					}
					table.desc {
					    border-collapse:collapse;
					    font-size:13px;
					    border: 1px solid #161616;
					    width:100%;
					}
					table.download {
					    border-collapse:collapse;
					    font-size:13px;
					    border: 1px solid #161616;
					    width:100%;
					}
					tr.d0 td, tr.d0 th {
					    background-color: #506070;
					    color: white;
					}
					tr.d1 td, tr.d1 th {
					    background-color: #708090;
					    color: white;
					}
					tr.d2 td {
					    background-color: #00ff00;
					    color: white;
					    text-align:center;
					}
					td.button {
					    border: 1px solid #161616;
					    background-color: #40628a;
					}
					td.button {
					    border: 1px solid #161616;
					    background-color: #40628a;
					    text-align: center;
					}
					td.button_red {
					    border: 1px solid #161616;
					    background-color: #b04040;
					    text-align: center;
					}
					td.download {
					    border: 1px solid #161616;
					    background-color: #40628a;
					    text-align: center;
					}
					th {
					    text-align:left;
					    width:125px;
					}
					td.request {
					    width:140px;
					    vertical-align:top;
					}
					td.radio {
					    width:90px;
					    vertical-align:top;
					}
					td.request {
					    vertical-align:top;
					}
					a {
					    color:#4477e0;
					}
					a.button {
					    color:white;
					    text-decoration: none;
					}
					h2 {
					    font-size:15px;
					}
				</style>
			</head>
			<body>
	"}

	if(pai)
		dat += {"
			<b><font size='3px'>Personal AI Device</font></b><br><br>
			<table class="request">
				<tr>
					<td class="request">Installed Personality:</td>
					<td>[pai.name]</td>
				</tr>
				<tr>
					<td class="request">Prime directive:</td>
					<td>[pai.pai_law0]</td>
				</tr>
				<tr>
					<td class="request">Additional directives:</td>
					<td>[pai.pai_laws]</td>
				</tr>
			</table>
			<br>
		"}
		dat += {"
			<table>
				<td class="button">
					<a href='byond://?src=\ref[src];setlaws=1' class='button'>Configure Directives</a>
				</td>
			</table>
		"}
		if(pai && (!pai.master_dna || !pai.master))
			dat += {"
				<table>
					<td class="button">
						<a href='byond://?src=\ref[src];setdna=1' class='button'>Imprint Master DNA</a>
					</td>
				</table>
			"}
		dat += "<br>"
		if(radio)
			dat += "<b>Radio Uplink</b>"
			dat += {"
				<table class="request">
					<tr>
						<td class="radio">Transmit:</td>
						<td><a href='byond://?src=\ref[src];wires=4'>[radio.broadcasting ? "<font color=#55ff55>En" : "<font color=#ff5555>Dis" ]abled</font></a>

						</td>
					</tr>
					<tr>
						<td class="radio">Receive:</td>
						<td><a href='byond://?src=\ref[src];wires=2'>[radio.listening ? "<font color=#55ff55>En" : "<font color=#ff5555>Dis" ]abled</font></a>

						</td>
					</tr>
				</table>
				<br>
			"}
		else //</font></font>
			dat += "<b>Radio Uplink</b><br>"
			dat += "<font color=red><i>Radio firmware not loaded. Please install a pAI personality to load firmware.</i></font><br>"
		dat += {"
			<table>
				<td class="button_red"><a href='byond://?src=\ref[src];wipe=1' class='button'>Wipe current pAI personality</a>

				</td>
			</table>
		"}
	else
		if(looking_for_personality)
			dat += {"
				<b><font size='3px'>pAI Request Module</font></b><br><br>
				<p>Requesting AI personalities from central database... If there are no entries, or if a suitable entry is not listed, check again later as more personalities may be added.</p>
				<img src='loading.gif' /> Searching for personalities<br><br>

				<table>
					<tr>
						<td class="button">
							<a href='byond://?src=\ref[src];request=1' class="button">Refresh available personalities</a>
						</td>
					</tr>
				</table><br>
			"}
		else
			dat += {"
				<b><font size='3px'>pAI Request Module</font></b><br><br>
			    <p>No personality is installed.</p>
				<table>
					<tr>
						<td class="button"><a href='byond://?src=\ref[src];request=1' class="button">Request personality</a>
						</td>
					</tr>
				</table>
				<br>
				<p>Each time this button is pressed, a request will be sent out to any available personalities. Check back often give plenty of time for personalities to respond. This process could take anywhere from 15 seconds to several minutes, depending on the available personalities' timeliness.</p>
			"}
	show_browser(user, dat, "window=paicard")
	onclose(user, "paicard")
	return

/obj/item/paicard/CanUseTopic(mob/user, datum/topic_state/state, href_list)
	. = ..()
	// possible NRE in Topic
	if(href_list && (href_list["setdna"] || href_list["setlaws"] || href_list["wires"]) && !istype(pai))
		return FALSE

/obj/item/paicard/Topic(href, href_list)
	if ((. = ..()))
		return

	if(href_list["setdna"])
		if(pai.master_dna)
			return
		var/mob/M = usr
		if(!istype(M, /mob/living/carbon))
			to_chat(usr, "<span class='notice'>You don't have any DNA, or your DNA is incompatible with this device.</span>")
		else
			var/datum/dna/dna = usr.dna
			pai.master = M.real_name
			pai.master_dna = dna.unique_enzymes
			to_chat(pai, "<span class='warning'>You have been bound to a new master.</span>")
	if(href_list["request"])
		src.looking_for_personality = 1
		paiController.findPAI(src, usr)
	if(href_list["wipe"])
		var/confirm = input("Are you CERTAIN you wish to delete the current personality? This action cannot be undone.", "Personality Wipe") in list("Yes", "No")
		if(confirm == "Yes")
			for(var/mob/M in src)
				to_chat(M, "<font color = #ff0000><h2>You feel yourself slipping away from reality.</h2></font>")
				to_chat(M, "<font color = #ff4d4d><h3>Byte by byte you lose your sense of self.</h3></font>")
				to_chat(M, "<font color = #ff8787><h4>Your mental faculties leave you.</h4></font>")
				to_chat(M, "<font color = #ffc4c4><h5>oblivion... </h5></font>")
				M.death(0)
			removePersonality()
	if(href_list["wires"])
		var/t1 = text2num(href_list["wires"])
		switch(t1)
			if(4)
				radio.ToggleBroadcast()
			if(2)
				radio.ToggleReception()
	if(href_list["setlaws"])
		var/newlaws = sanitize(input("Enter any additional directives you would like your pAI personality to follow. Note that these directives will not override the personality's allegiance to its imprinted master. Conflicting directives will be ignored.", "pAI Directive Configuration", pai.pai_laws) as message)
		if(newlaws)
			pai.pai_laws = newlaws
			to_chat(pai, "Your supplemental directives have been updated. Your new directives are:")
			to_chat(pai, "Prime Directive: <br>[pai.pai_law0]")
			to_chat(pai, "Supplemental Directives: <br>[pai.pai_laws]")
	attack_self(usr)

// 		WIRE_SIGNAL = 1
//		WIRE_RECEIVE = 2
//		WIRE_TRANSMIT = 4

/obj/item/paicard/proc/setPersonality(mob/living/silicon/pai/personality)
	src.pai = personality
	src.overlays += "pai-happy"

/obj/item/paicard/proc/removePersonality()
	src.pai = null
	src.overlays.Cut()
	src.overlays += "pai-off"

/obj/item/paicard/proc/setEmotion(var/emotion)
	if(pai)
		current_emotion = emotion

/obj/item/paicard/on_update_icon()
	cut_overlays()
	if(pai)
		switch(current_emotion)
			if(1)  add_overlay("pai-happy")
			if(2)  add_overlay("pai-cat")
			if(3)  add_overlay("pai-extremely-happy")
			if(4)  add_overlay("pai-face")
			if(5)  add_overlay("pai-laugh")
			if(6)  add_overlay("pai-off")
			if(7)  add_overlay("pai-sad")
			if(8)  add_overlay("pai-angry")
			if(9)  add_overlay("pai-what")
			if(10) add_overlay("pai-neutral")
			if(11) add_overlay("pai-silly")
			if(12) add_overlay("pai-nose")
			if(13) add_overlay("pai-smirk")
			if(14) add_overlay("pai-exclamation")
			if(15) add_overlay("pai-question")

/obj/item/paicard/proc/alertUpdate()
	var/turf/T = get_turf_or_move(src.loc)
	for (var/mob/M in viewers(T))
		M.show_message("<span class='notice'>\The [src] flashes a message across its screen, \"Additional personalities available for download.\"</span>", 3, "<span class='notice'>\The [src] bleeps electronically.</span>", 2)

/obj/item/paicard/emp_act(severity)
	for(var/mob/M in src)
		M.emp_act(severity)

/obj/item/paicard/explosion_act(severity)
	..()
	if(!QDELETED(src))
		if(pai)
			pai.explosion_act(severity)
		else
			qdel(src)

/obj/item/paicard/see_emote(mob/living/M, text)
	if(pai && pai.client && pai.stat == CONSCIOUS)
		var/rendered = "<span class='message'>[text]</span>"
		pai.show_message(rendered, 2)
	..()

/obj/item/paicard/show_message(msg, type, alt, alt_type)
	if(pai && pai.client)
		var/rendered = "<span class='message'>[msg]</span>"
		pai.show_message(rendered, type)
	..()
