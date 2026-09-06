// Allows you to monitor messages that passes the server.

/obj/machinery/computer/message_monitor
	name = "messaging monitor console"
	desc = "Used to access and maintain data on messaging servers. Allows you to view request console messages and telecommunication logs."
	icon_screen = "comm_logs"
	light_color = "#00b000"

	var/hack_icon = "error"
	var/const/noserver = "<span class='alert'>ALERT: No server detected.</span>"
	var/const/incorrectkey = "<span class='warning'>ALERT: Incorrect decryption key!</span>"
	var/const/defaultmsg = "<span class='notice'>Welcome. Please select an option.</span>"
	var/const/rebootmsg = "<span class='warning'>%$&(£: Critical %$$@ Error // !RestArting! <lOadiNg backUp iNput ouTput> - ?pLeaSe wAit!</span>"

	var/const/SCREEN_MAIN_MENU    = 0
	var/const/SCREEN_MESSAGE_LOGS = 1
	var/const/SCREEN_HACKING      = 2
	var/screen = SCREEN_MAIN_MENU
	var/hacking = FALSE // Is it being hacked into by a silicon?
	var/message = "<span class='notice'>System bootup complete. Please select an option.</span>"	// The message that shows on the main menu.
	var/auth = FALSE // Are they authenticated?
	var/obj/machinery/network/message_server/tracking_linked_server

/obj/machinery/computer/message_monitor/Initialize()
	set_extension(src, /datum/extension/network_device/lazy)
	. = ..()

/obj/machinery/computer/message_monitor/Destroy()
	tracking_linked_server = null
	. = ..()

/obj/machinery/computer/message_monitor/proc/get_message_server()
	if(!tracking_linked_server || (tracking_linked_server.stat & (NOPOWER|BROKEN)))
		tracking_linked_server = null
		var/datum/extension/network_device/network_device = get_extension(src, /datum/extension/network_device)
		var/datum/computer_network/network = network_device?.get_network()
		for(var/datum/extension/network_device/message_server in network?.devices)
			var/obj/machinery/network/message_server/MS = message_server.holder
			if(istype(MS) && !(MS.stat & (BROKEN|NOPOWER)))
				tracking_linked_server = MS
				break
	. = tracking_linked_server

/obj/machinery/computer/message_monitor/attackby(obj/item/used_item, mob/user)
	if(stat & (NOPOWER|BROKEN))
		return ..()
	if(!istype(user))
		return TRUE
	if(IS_SCREWDRIVER(used_item) && emagged)
		//Stops people from just unscrewing the monitor and putting it back to get the console working again.
		to_chat(user, "<span class='warning'>It is too hot to mess with!</span>")
		return TRUE
	return ..()

/obj/machinery/computer/message_monitor/emag_act(var/remaining_charges, var/mob/user)

	// Will create sparks and print out the console's password. You will then have to wait a while for the console to be back online.
	// It'll take more time if there's more characters in the password.
	if(!emagged && operable())
		var/obj/machinery/network/message_server/linked_server = get_message_server()
		if(linked_server)
			emagged = TRUE
			screen = SCREEN_HACKING
			spark_at(src, amount = 5)
			var/obj/item/paper/monitorkey/MK = new(loc)
			// Will help make emagging the console not so easy to get away with.
			MK.info += "<br><br><font color='red'>£%@%(*$%&(£&?*(%&£/{}</font>"
			addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/machinery/computer/message_monitor, UnemagConsole)), 100*length(linked_server.decryptkey))
			message = rebootmsg
			update_icon()
			return 1
		else
			to_chat(user, "<span class='notice'>A no server error appears on the screen.</span>")

/obj/machinery/computer/message_monitor/on_update_icon()
	if(emagged || hacking)
		icon_screen = hack_icon
	else
		icon_screen = initial(icon_screen)
	..()

/obj/machinery/computer/message_monitor/interface_interact(user)
	interact(user)
	return TRUE

/obj/machinery/computer/message_monitor/interact(var/mob/living/user)
	//If the computer is being hacked or is emagged, display the reboot message.
	if(hacking || emagged)
		message = rebootmsg

	var/obj/machinery/network/message_server/linked_server = get_message_server()
	// This must run early so that changing the message actually works.
	if(hacking || emagged)
		screen = SCREEN_HACKING
	else if(!auth || !linked_server || (linked_server.stat & (NOPOWER|BROKEN)))
		message = auth ? noserver : message
		screen = SCREEN_MAIN_MENU
	var/list/dat = list()
	dat += "<head><title>Message Monitor Console</title></head><body>"
	dat += "<center><h2>Message Monitor Console</h2></center><hr>"
	dat += "<center><h4><font color='blue'[message]</h5></center>"

	if(auth)
		dat += "<h4><dd><A href='byond://?src=\ref[src];auth=1'>&#09;<font color='green'>\[Authenticated\]</font></a>&#09;/"
		dat += " Server Power: <A href='byond://?src=\ref[src];active=1'>[linked_server?.active ? "<font color='green'>\[On\]</font>":"<font color='red'>\[Off\]</font>"]</a></h4>"
	else
		dat += "<h4><dd><A href='byond://?src=\ref[src];auth=1'>&#09;<font color='red'>\[Unauthenticated\]</font></a>&#09;/"
		dat += " Server Power: <u>[linked_server?.active ? "<font color='green'>\[On\]</font>":"<font color='red'>\[Off\]</font>"]</u></h4>"

	switch(screen)
		//Main menu
		if(SCREEN_MAIN_MENU)
			//&#09; = TAB
			var/i = 0
			dat += "<dd><A href='byond://?src=\ref[src];find=1'>&#09;[++i]. Link To A Server</a></dd>"
			if(auth)
				if(!linked_server || (linked_server.stat & (NOPOWER|BROKEN)))
					dat += "<dd><A>&#09;ERROR: Server not found!</A><br></dd>"
				else
					dat += "<dd><A href='byond://?src=\ref[src];viewr=1'>&#09;[++i]. View Request Console Logs </a></br></dd>"
					dat += "<dd><A href='byond://?src=\ref[src];clearr=1'>&#09;[++i]. Clear Request Console Logs</a><br></dd>"
					dat += "<dd><A href='byond://?src=\ref[src];pass=1'>&#09;[++i]. Set Custom Key</a><br></dd>"
			else
				dat += "<br><hr><dd><span class='notice'>Please authenticate with the server in order to show additional options.</span>"
			if((isAI(user) || isrobot(user)) && player_is_antag(user.mind))
				//Malf/Traitor AIs can bruteforce into the system to gain the Key.
				dat += "<dd><A href='byond://?src=\ref[src];hack=1'><i><font color='Red'>*&@#. Bruteforce Key</font></i></font></a></dd>"
		//Request Console Logs
		if(SCREEN_MESSAGE_LOGS)
			var/index = 0
			/* 	data_rc_msg
				X												 - 5%
				var/rec_dpt = "Unspecified" //name of the person - 15%
				var/send_dpt = "Unspecified" //name of the sender- 15%
				var/message = "Blank" //transferred message		 - 300px
				var/stamp = "Unstamped"							 - 15%
				var/id_auth = "Unauthenticated"					 - 15%
				var/priority = "Normal"							 - 10%
			*/
			dat += "<center><A href='byond://?src=\ref[src];back=1'>Back</a> - <A href='byond://?src=\ref[src];refresh=1'>Refresh</center><hr>"
			dat += {"<table border='1' width='100%'><tr><th width = '5%'>X</th><th width='15%'>Sending Dep.</th><th width='15%'>Receiving Dep.</th>
			<th width='300px' word-wrap: break-word>Message</th><th width='15%'>Stamp</th><th width='15%'>ID Auth.</th><th width='15%'>Priority.</th></tr>"}
			for(var/datum/data_rc_msg/rc in linked_server.rc_msgs)
				if(++index > 3000)
					break
				// Del - Sender   - Recepient - Message
				// X   - Al Green - Your Mom  - WHAT UP!?
				dat += {"<tr><td width = '5%'><center><A href='byond://?src=\ref[src];deleter=\ref[rc]' style='color: rgb(255,0,0)'>X</a></center></td><td width='15%'>[rc.send_dpt]</td>
				<td width='15%'>[rc.rec_dpt]</td><td width='300px'>[rc.message]</td><td width='15%'>[rc.stamp]</td><td width='15%'>[rc.id_auth]</td><td width='15%'>[rc.priority]</td></tr>"}
			dat += "</table>"
		//Hacking screen.
		if(SCREEN_HACKING)
			if(issilicon(user))
				dat += "Brute-forcing for server key.<br> It will take 20 seconds for every character that the password has."
				dat += "In the meantime, this console can reveal your true intentions if you let someone access it. Make sure no humans enter the room during that time."
			else
				//It's the same message as the one above but in binary. Because robots understand binary and humans don't... well I thought it was clever.
				dat += {"01000010011100100111010101110100011001010010110<br>
				10110011001101111011100100110001101101001011011100110011<br>
				10010000001100110011011110111001000100000011100110110010<br>
				10111001001110110011001010111001000100000011010110110010<br>
				10111100100101110001000000100100101110100001000000111011<br>
				10110100101101100011011000010000001110100011000010110101<br>
				10110010100100000001100100011000000100000011100110110010<br>
				10110001101101111011011100110010001110011001000000110011<br>
				00110111101110010001000000110010101110110011001010111001<br>
				00111100100100000011000110110100001100001011100100110000<br>
				10110001101110100011001010111001000100000011101000110100<br>
				00110000101110100001000000111010001101000011001010010000<br>
				00111000001100001011100110111001101110111011011110111001<br>
				00110010000100000011010000110000101110011001011100010000<br>
				00100100101101110001000000111010001101000011001010010000<br>
				00110110101100101011000010110111001110100011010010110110<br>
				10110010100101100001000000111010001101000011010010111001<br>
				10010000001100011011011110110111001110011011011110110110<br>
				00110010100100000011000110110000101101110001000000111001<br>
				00110010101110110011001010110000101101100001000000111100<br>
				10110111101110101011100100010000001110100011100100111010<br>
				10110010100100000011010010110111001110100011001010110111<br>
				00111010001101001011011110110111001110011001000000110100<br>
				10110011000100000011110010110111101110101001000000110110<br>
				00110010101110100001000000111001101101111011011010110010<br>
				10110111101101110011001010010000001100001011000110110001<br>
				10110010101110011011100110010000001101001011101000010111<br>
				00010000001001101011000010110101101100101001000000111001<br>
				10111010101110010011001010010000001101110011011110010000<br>
				00110100001110101011011010110000101101110011100110010000<br>
				00110010101101110011101000110010101110010001000000111010<br>
				00110100001100101001000000111001001101111011011110110110<br>
				10010000001100100011101010111001001101001011011100110011<br>
				10010000001110100011010000110000101110100001000000111010<br>
				001101001011011010110010100101110"}
	dat += "</body>"
	var/datum/browser/written_digital/popup = new(user, "message", "Message Monitoring Console", 700, 700)
	popup.set_content(JOINTEXT(dat))
	popup.open()
	return

/obj/machinery/computer/message_monitor/proc/BruteForce(mob/user)
	var/obj/machinery/network/message_server/linked_server = get_message_server()
	if(!linked_server)
		to_chat(user, "<span class='warning'>Could not complete brute-force: Linked Server Disconnected!</span>")
	else
		var/currentKey = linked_server.decryptkey
		to_chat(user, "<span class='warning'>Brute-force completed! The key is '[currentKey]'.</span>")
	hacking = FALSE
	update_icon()
	screen = SCREEN_MAIN_MENU // Return the screen back to normal
	message = defaultmsg // reset it for the next interaction

/obj/machinery/computer/message_monitor/proc/UnemagConsole()
	emagged = FALSE
	update_icon()

/obj/machinery/computer/message_monitor/OnTopic(mob/user, href_list)
	if((. = ..()))
		return

	//Authenticate
	var/obj/machinery/network/message_server/linked_server = get_message_server()
	if (href_list["auth"])
		if(auth)
			auth = FALSE
			screen = SCREEN_MAIN_MENU
			message = defaultmsg // reset it for the next interaction
			. = TOPIC_REFRESH
		else
			var/dkey = trim(input(user, "Please enter the decryption key.") as text|null)
			. = TOPIC_HANDLED
			if(dkey)
				. = TOPIC_REFRESH
				if(linked_server?.decryptkey == dkey)
					auth = TRUE
				else
					message = incorrectkey

	//Turn the server on/off.
	if (href_list["active"] && auth && linked_server)
		linked_server.active = !linked_server.active
		. = TOPIC_REFRESH

	//Find a server
	if (href_list["find"])
		var/list/local_message_servers = list()
		var/list/local_zs = SSmapping.get_connected_levels(z)
		for(var/obj/machinery/network/message_server/MS in SSmachines.machinery)
			if((MS.z in local_zs) && !(MS.stat & (BROKEN|NOPOWER)))
				local_message_servers += MS
		if(length(local_message_servers) > 1)
			tracking_linked_server = input(user, "Please select a server.", "Select a server.", null) as null|anything in local_message_servers
			message = "<span class='alert'>NOTICE: Server selected.</span>"
		else if(length(local_message_servers) > 0)
			tracking_linked_server = local_message_servers[1]
			message =  "<span class='notice'>NOTICE: Only Single Server Detected - Server selected.</span>"
		else
			message = noserver
		linked_server = get_message_server()
		. = TOPIC_REFRESH

	//Clears the request console logs - KEY REQUIRED
	if (href_list["clearr"])
		if(!linked_server || (linked_server.stat & (NOPOWER|BROKEN)))
			message = noserver
			. = TOPIC_REFRESH
		else if(auth)
			linked_server.rc_msgs = list()
			message = "<span class='notice'>NOTICE: Logs cleared.</span>"
			. = TOPIC_REFRESH
	//Change the password - KEY REQUIRED
	if (href_list["pass"])
		if(!linked_server || (linked_server.stat & (NOPOWER|BROKEN)))
			message = noserver
			. = TOPIC_REFRESH
		else if(auth)
			var/dkey = trim(input(user, "Please enter the decryption key.") as text|null)
			. = TOPIC_HANDLED
			if(dkey)
				. = TOPIC_REFRESH
				if(linked_server.decryptkey == dkey)
					var/newkey = trim(input(user,"Please enter the new key (3 - 16 characters max):"))
					if(length(newkey) <= 3)
						message = "<span class='notice'>NOTICE: Decryption key too short!</span>"
					else if(length(newkey) > 16)
						message = "<span class='notice'>NOTICE: Decryption key too long!</span>"
					else if(newkey && newkey != "")
						linked_server.decryptkey = newkey
					message = "<span class='notice'>NOTICE: Decryption key set.</span>"
				else
					message = incorrectkey

	//Hack the Console to get the password
	if (href_list["hack"])
		if(issilicon(user) && player_is_antag(user.mind))
			hacking = TRUE
			screen = SCREEN_HACKING
			. = TOPIC_REFRESH
			//Time it takes to bruteforce is dependant on the password length.
			addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/machinery/computer/message_monitor, BruteForceConsole), user, linked_server), 10 SECONDS * length(linked_server.decryptkey))

	//Delete the request console log.
	if (href_list["deleter"])
		. = TOPIC_REFRESH
		//Make sure they're still on the view logs screen.
		if(screen == SCREEN_MESSAGE_LOGS)
			if(!linked_server || (linked_server.stat & (NOPOWER|BROKEN)))
				message = noserver
			else //if(istype(href_list["delete"], /datum/data_pda_msg))
				linked_server.rc_msgs -= locate(href_list["deleter"])
				message = "<span class='notice'>NOTICE: Log Deleted!</span>"

	//Request Console Logs - KEY REQUIRED
	if(href_list["viewr"])
		if(linked_server == null || (linked_server.stat & (NOPOWER|BROKEN)))
			message = noserver
			. = TOPIC_REFRESH
		else if(auth)
			screen = SCREEN_MESSAGE_LOGS
			. = TOPIC_REFRESH

	if (href_list["back"])
		screen = SCREEN_MAIN_MENU
		message = defaultmsg // reset it for the next interaction
		. = TOPIC_REFRESH
	// don't call interact() here, let the prior Topic() call do that via our TOPIC_REFRESH return value

/obj/machinery/computer/message_monitor/proc/BruteForceConsole(var/mob/user, var/decrypting)
	var/obj/machinery/network/message_server/linked_server = get_message_server()
	if(linked_server && linked_server == decrypting && user)
		BruteForce(user)

/obj/item/paper/monitorkey
	name = "monitor decryption key"
	info = "The paper is smudged and unreadable."

/obj/item/paper/monitorkey/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/paper/monitorkey/LateInitialize()
	. = ..()
	var/turf/T = get_turf(src)
	if(!T)
		return
	var/list/our_z = SSmapping.get_connected_levels(T.z)
	for(var/obj/machinery/network/message_server/server in SSmachines.machinery)
		if((server.z in our_z) && !(server.stat & (BROKEN|NOPOWER)) && !isnull(server.decryptkey))
			info = "<center><h2>Daily Key Reset</h2></center><br>The new message monitor key is '[server.decryptkey]'.<br>This key is only intended for personnel granted access to the messaging server. Keep it safe.<br>If necessary, change the password to a more secure one."
			info_links = info
			update_icon()
			break
