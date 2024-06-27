//Adminpaper - it's like paper, but more adminny!
/obj/item/paper/admin
	name = "administrative paper"
	desc = "If you see this, something has gone horribly wrong."
	var/datum/admins/admindatum = null

	var/interactions = null
	var/isCrayon = 0
	var/origin = null
	var/mob/sender = null
	var/weakref/destination_ref

	var/header = null
	var/headerOn = TRUE

	var/footer = null
	var/footerOn = FALSE

	var/logo_list = list()
	var/logo = ""
	var/signature //Signature entered by the admin

/obj/item/paper/admin/Initialize(mapload, material_key, _text, _title, list/md)
	. = ..()
	generateInteractions()

/obj/item/paper/admin/proc/generateInteractions()
	//clear first
	interactions = null

	//Snapshot is crazy and likes putting each topic hyperlink on a seperate line from any other tags so it's nice and clean.
	interactions += "<HR><center><font size= \"1\">The fax will transmit everything above this line</font><br>"
	interactions += "<A href='byond://?src=\ref[src];confirm=1'>Send fax</A> "
	interactions += "<A href='byond://?src=\ref[src];penmode=1'>Pen mode: [isCrayon ? "Crayon" : "Pen"]</A> "
	interactions += "<A href='byond://?src=\ref[src];cancel=1'>Cancel fax</A> "
	interactions += "<BR>"
	interactions += "<A href='byond://?src=\ref[src];changelogo=1'>Change logo</A> "
	interactions += "<A href='byond://?src=\ref[src];toggleheader=1'>Toggle Header</A> "
	interactions += "<A href='byond://?src=\ref[src];togglefooter=1'>Toggle Footer</A> "
	interactions += "<A href='byond://?src=\ref[src];clear=1'>Clear page</A> "
	interactions += "</center>"

/obj/item/paper/admin/proc/generateHeader()
	var/originhash = md5("[origin]")
	var/challengehash = copytext(md5("[game_id]"),1,10) // changed to a hash of the game ID so it's more consistant but changes every round.
	var/text = null
	//TODO change logo based on who you're contacting.
	text = "<center><img src = [logo]></br>"
	text += "<b>[origin] Quantum Uplink Signed Message</b><br>"
	text += "<font size = \"1\">Encryption key: [originhash]<br>"
	text += "Challenge: [challengehash]<br></font></center><hr>"

	header = text

/obj/item/paper/admin/proc/generateFooter()
	var/text = null

	text = "<hr><font size= \"1\">"
	text += "This transmission is intended only for the addressee and may contain confidential information. Any unauthorized disclosure is strictly prohibited. <br><br>"
	text += "If this transmission is recieved in error, please notify both the sender and the office of [global.using_map.boss_name] Internal Affairs immediately so that corrective action may be taken."
	text += "Failure to comply is a breach of regulation and may be prosecuted to the fullest extent of the law, where applicable."
	text += "</font>"

	footer = text

/obj/item/paper/admin/proc/adminbrowse()
	updateinfolinks()
	generateHeader()
	generateFooter()
	updateDisplay()

/obj/item/paper/admin/proc/updateDisplay()
	show_browser(usr, "<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY>[headerOn ? header : ""][info_links][stamp_text][footerOn ? footer : ""][interactions]</BODY></HTML>", "window=[name];can_close=0")

/obj/item/paper/admin/Topic(href, href_list)
	if(href_list["write"])
		var/id = href_list["write"]
		if(free_space <= 0)
			to_chat(usr, "<span class='info'>There isn't enough space left on \the [src] to write anything.</span>")
			return

		var/t =  sanitize(input("Enter what you want to write:", "Write", null, null) as message, free_space, extra = 0)

		if(!t)
			return

		var last_fields_value = fields

		//t = html_encode(t)
		t = replacetext(t, "\n", "<BR>")
		t = parsepencode(t,,, isCrayon) // Encode everything from pencode to html


		if(fields > 50)//large amount of fields creates a heavy load on the server, see updateinfolinks() and addtofield()
			to_chat(usr, "<span class='warning'>Too many fields. Sorry, you can't do this.</span>")
			fields = last_fields_value
			return

		if(id!="end")
			addtofield(text2num(id), t) // He wants to edit a field, let him.
		else
			info += t // Oh, he wants to edit to the end of the file, let him.
			updateinfolinks()

		update_space(t)

		updateDisplay()

		update_icon()
		return

	if(href_list["confirm"])
		var/obj/machinery/faxmachine/F = destination_ref.resolve()
		if(!istype(F))
			to_chat(usr, "The destination machine doesn't exist anymore.")
			return
		switch(alert("Are you sure you want to send the fax as is?",, "Yes", "No"))
			if("Yes")
				if(headerOn)
					info = header + info
				if(footerOn)
					info += footer
				updateinfolinks()
				close_browser(usr, "window=[name]")
				admindatum.faxCallback(src, F)
		return

	if(href_list["penmode"])
		isCrayon = !isCrayon
		generateInteractions()
		updateDisplay()
		return

	if(href_list["cancel"])
		close_browser(usr, "window=[name]")
		qdel(src)
		return

	if(href_list["clear"])
		clearpaper()
		updateDisplay()
		return

	if(href_list["toggleheader"])
		headerOn = !headerOn
		updateDisplay()
		return

	if(href_list["togglefooter"])
		footerOn = !footerOn
		updateDisplay()
		return

	if(href_list["changelogo"])
		logo = input(usr, "What logo?", "Choose a logo", "") as null|anything in (logo_list)
		generateHeader()
		updateDisplay()
		return

/obj/item/paper/admin/get_signature(obj/item/pen/P, mob/user)
	return signature

/obj/item/paper/admin/proc/set_signature(var/sig)
	signature = sig