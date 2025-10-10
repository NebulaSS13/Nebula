//BS12 Explosive
/obj/item/implant/explosive
	name = "explosive implant"
	desc = "A military grade micro bio-explosive. Highly dangerous."
	icon_state = "implant_evil"
	origin_tech = @'{"materials":1,"biotech":2,"esoteric":3}'
	hidden = TRUE
	var/elevel
	var/phrase
	var/code = 13
	var/frequency = 1443
	var/datum/radio_frequency/radio_connection
	var/warning_message = "Tampering detected. Tampering detected."

/obj/item/implant/explosive/get_data()
	. = {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> Robust Corp RX-78 Intimidation Class Implant<BR>
	<b>Life:</b> Activates upon codephrase.<BR>
	<b>Important Notes:</b> Explodes<BR>
	<HR>
	<b>Implant Details:</b><BR>
	<b>Function:</b> Contains a compact, electrically detonated explosive that detonates upon receiving a specially encoded signal or upon host death.<BR>
	<b>Special Features:</b> Explodes<BR>
	<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}
	if(!malfunction)
		. += {"
		<HR><B>Explosion yield mode:</B><BR>
		<A href='byond://?src=\ref[src];mode=1'>[elevel || "NONE SET"]</A><BR>
		<B>Activation phrase:</B><BR>
		<A href='byond://?src=\ref[src];phrase=1'>[phrase || "NONE SET"]</A><BR>
		<B>Frequency:</B><BR>
		<A href='byond://?src=\ref[src];freq=-10'>-</A>
		<A href='byond://?src=\ref[src];freq=-2'>-</A>
		[format_frequency(frequency)]
		<A href='byond://?src=\ref[src];freq=2'>+</A>
		<A href='byond://?src=\ref[src];freq=10'>+</A><BR>
		<B>Code:</B><BR>
		<A href='byond://?src=\ref[src];code=-5'>-</A>
		<A href='byond://?src=\ref[src];code=-1'>-</A>
		<A href='byond://?src=\ref[src];code=set'>[code]</A>
		<A href='byond://?src=\ref[src];code=1'>+</A>
		<A href='byond://?src=\ref[src];code=5'>+</A><BR>
		<B>Tampering warning message:</B><BR>
		This will be broadcasted on radio if implant is exposed during surgery.<BR>
		<A href='byond://?src=\ref[src];msg=1'>[warning_message || "NONE SET"]</A>
		"}

/obj/item/implant/explosive/Initialize()
	. = ..()
	global.listening_objects += src
	set_frequency(frequency)

/obj/item/implant/explosive/Topic(href, href_list)
/obj/item/implant/explosive/OnTopic(mob/user, href_list, datum/topic_state/state)
	if (href_list["freq"])
		var/new_frequency = frequency + text2num(href_list["freq"])
		new_frequency = sanitize_frequency(new_frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
		set_frequency(new_frequency)
		return TOPIC_REFRESH
	if (href_list["code"])
		var/adj = text2num(href_list["code"])
		if(!adj)
			code = input("Set radio activation code","Radio activation") as num
		else
			code += adj
		code = clamp(code,1,100)
		return TOPIC_REFRESH
	if (href_list["mode"])
		var/mod = input("Set explosion mode", "Explosion mode") as null|anything in list("Localized Limb", "Destroy Body", "Full Explosion")
		if(mod)
			elevel = mod
		return TOPIC_REFRESH
	if (href_list["msg"])
		var/msg = input("Set tampering message, or leave blank for no broadcasting.", "Anti-tampering", warning_message) as text|null
		if(msg)
			warning_message = msg
		return TOPIC_REFRESH
	if (href_list["phrase"])
		var/talk = input("Set activation phrase", "Audio activation", phrase) as text|null
		if(talk)
			phrase = sanitize_phrase(talk)
		return TOPIC_REFRESH

/obj/item/implant/explosive/receive_signal(datum/signal/signal)
	if(signal && signal.encryption == code)
		activate()

/obj/item/implant/explosive/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT)

/obj/item/implant/explosive/hear_talk(mob/M, msg)
	hear(msg)

/obj/item/implant/explosive/hear(var/msg)
	if(!phrase)
		return
	if(findtext(sanitize_phrase(msg),phrase))
		activate()
		qdel(src)

/obj/item/implant/explosive/exposed()
	if(warning_message)
		do_telecomms_announcement(src, warning_message, "Anti-Tampering System")

/obj/item/implant/explosive/proc/sanitize_phrase(phrase)
	var/list/replacechars = list("'" = "","\"" = "",">" = "","<" = "","(" = "",")" = "")
	return replace_characters(phrase, replacechars)

/obj/item/implant/explosive/activate()
	if (malfunction)
		return

	var/turf/our_turf = get_turf(src)
	if(our_turf)
		our_turf.hotspot_expose(3500, CELL_VOLUME/20) // expose roughly 1/20th of a cell to 3500K heat

	playsound(our_turf, 'sound/items/countdown.ogg', 75, 1, -3)
	if(ismob(imp_in))
		imp_in.audible_message(SPAN_WARNING("Something beeps inside [imp_in][part ? "'s [part.name]" : ""]!"))
		log_and_message_admins("Explosive implant triggered in [imp_in] ([imp_in.key]). (<A HREF='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[imp_in.x];Y=[imp_in.y];Z=[imp_in.z]'>JMP</a>) ")
	else
		audible_message(SPAN_WARNING("[src] beeps omniously!"))
		log_and_message_admins("Explosive implant triggered in [our_turf.loc]. (<A HREF='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[our_turf.x];Y=[our_turf.y];Z=[our_turf.z]'>JMP</a>) ")

	if(!elevel)
		elevel = "Full Explosion"
	switch(elevel)
		if ("Localized Limb")
			switch(part?.organ_tag)
				if(BP_CHEST, BP_GROIN)
					part.take_damage(60, inflicter = "Explosion")
				if(null)
					pass()
				else
					part.dismember(0,DISMEMBER_METHOD_BLUNT)
			explosion(our_turf, -1, -1, 2, 3)
		if ("Destroy Body")
			explosion(our_turf, -1, 0, 1, 6)
			if(ismob(imp_in))
				imp_in.gib()
		if ("Full Explosion")
			explosion(our_turf, 0, 1, 3, 6)
			if(ismob(imp_in))
				imp_in.gib()
	qdel(src)

/obj/item/implant/explosive/implanted(mob/target)
	if(!elevel)
		elevel = alert("What sort of explosion would you prefer?", "Implant Intent", "Localized Limb", "Destroy Body", "Full Explosion")
	if(!phrase)
		phrase = sanitize_phrase(input("Choose activation phrase:") as text)
	if(!phrase)
		return

	var/memo = "Explosive implant in [target] can be activated by saying something containing the phrase ''[phrase]'', <B>say [phrase]</B> to attempt to activate. It can also be triggered with a radio signal on frequency <b>[format_frequency(src.frequency)]</b> with code <b>[code]</b>."
	usr.StoreMemory(memo, /decl/memory_options/system)
	to_chat(usr, memo)
	return TRUE

/obj/item/implant/explosive/Destroy()
	removed()
	radio_controller.remove_object(src, frequency)
	radio_connection = null
	return ..()

/obj/item/implanter/explosive
	name = "implanter (E)"
	imp = /obj/item/implant/explosive

/obj/item/implantcase/explosive
	name = "glass case - 'explosive'"
	imp = /obj/item/implant/explosive