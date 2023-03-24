var/global/list/singularity_beacons = list()

//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

//  Beacon randomly spawns in space
//	When a non-traitor (no special role in /mind) uses it, he is given the choice to become a traitor
//	If he accepts there is a random chance he will be accepted, rejected, or rejected and killed
//	Bringing certain items can help improve the chance to become a traitor


/obj/machinery/syndicate_beacon
	name = "ominous beacon"
	desc = "This looks suspicious..."
	icon = 'icons/obj/items/syndibeacon.dmi'
	icon_state = "syndbeacon"

	anchored = 1
	density = 1

	var/temptext = ""
	var/selfdestructing = 0
	var/charges = 1

/obj/machinery/syndicate_beacon/interface_interact(var/mob/user)
	interact(user)
	return TRUE

/obj/machinery/syndicate_beacon/interact(var/mob/user)
	user.set_machine(src)
	var/dat = "<font color=#005500><i>Scanning [pick("retina pattern", "voice print", "fingerprints", "dna sequence")]...<br>Identity confirmed,<br></i></font>"
	if(istype(user, /mob/living/carbon/human) || istype(user, /mob/living/silicon/ai))
		if(is_special_character(user))
			dat += "<font color=#07700><i>Operative record found. Greetings, Agent [user.name].</i></font><br>"
		else if(charges < 1)
			dat += "<TT>Connection severed.</TT><BR>"
		else
			var/honorific = "Mr."
			if(user.gender == FEMALE)
				honorific = "Ms."
			dat += "<font color=red><i>Identity not found in operative database. What can the Syndicate do for you today, [honorific] [user.name]?</i></font><br>"
			if(!selfdestructing)
				dat += "<br><br><A href='?src=\ref[src];betraitor=1;traitormob=\ref[user]'>\"[pick("I want to switch teams.", "I want to work for you.", "Let me join you.", "I can be of use to you.", "You want me working for you, and here's why...", "Give me an objective.", "How's the 401k over at the Syndicate?")]\"</A><BR>"
	dat += temptext
	show_browser(user, dat, "window=syndbeacon")
	onclose(user, "syndbeacon")

/obj/machinery/syndicate_beacon/Topic(href, href_list)
	if(..())
		return
	if(href_list["betraitor"])
		if(charges < 1)
			src.updateUsrDialog()
			return
		var/mob/M = locate(href_list["traitormob"])
		if(M.mind.assigned_special_role || jobban_isbanned(M, /decl/special_role/traitor))
			temptext = "<i>We have no need for you at this time. Have a pleasant day.</i><br>"
			src.updateUsrDialog()
			return
		charges -= 1
		if(prob(50))
			temptext = "<font color=red><i><b>Double-crosser. You planned to betray us from the start. Allow us to repay the favor in kind.</b></i></font>"
			src.updateUsrDialog()
			addtimer(CALLBACK(src, .proc/selfdestruct), rand(5, 20) SECONDS)
			return
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/N = M
			to_chat(M, "<B>You have joined the ranks of the Syndicate and become a traitor to the station!</B>")
			var/decl/special_role/traitors = GET_DECL(/decl/special_role/traitor)
			traitors.add_antagonist(N.mind)
			traitors.equip(N)
			log_and_message_admins("has accepted a traitor objective from a syndicate beacon.", M)


	src.updateUsrDialog()
	return


/obj/machinery/syndicate_beacon/proc/selfdestruct()
	selfdestructing = 1
	INVOKE_ASYNC(GLOBAL_PROC, .proc/explosion, src.loc, 1, rand(1, 3), rand(3, 8), 10)

////////////////////////////////////////
//Singularity beacon
////////////////////////////////////////
/obj/machinery/singularity_beacon
	name = "ominous beacon"
	desc = "This looks suspicious..."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "beaconsynd"

	uncreated_component_parts = list(/obj/item/stock_parts/power/terminal)
	anchored = 0
	density = 1
	layer = BASE_ABOVE_OBJ_LAYER //so people can't hide it and it's REALLY OBVIOUS
	stat = 0
	use_power = POWER_USE_OFF

/obj/machinery/singularity_beacon/Initialize()
	. = ..()
	global.singularity_beacons += src

/obj/machinery/singularity_beacon/Destroy()
	if(use_power)
		Deactivate()
	global.singularity_beacons -= src
	return ..()

/obj/machinery/singularity_beacon/proc/Activate(mob/user = null)
	for(var/obj/effect/singularity/singulo in global.singularities)
		if(singulo.z == z)
			singulo.target = src
	icon_state = "[initial(icon_state)]1"
	update_use_power(POWER_USE_ACTIVE)
	if(user)
		to_chat(user, "<span class='notice'>You activate the beacon.</span>")

/obj/machinery/singularity_beacon/proc/Deactivate(mob/user = null)
	for(var/obj/effect/singularity/singulo in global.singularities)
		if(singulo.target == src)
			singulo.target = null
	icon_state = "[initial(icon_state)]0"
	update_use_power(POWER_USE_OFF)
	if(user)
		to_chat(user, "<span class='notice'>You deactivate the beacon.</span>")

/obj/machinery/singularity_beacon/physical_attack_hand(var/mob/user)
	. = TRUE
	if(anchored)
		if(use_power)
			Deactivate(user)
		else
			Activate(user)
	else
		to_chat(user, "<span class='danger'>You need to screw the beacon to the floor first!</span>")

/obj/machinery/singularity_beacon/attackby(obj/item/W, mob/user)
	if(IS_SCREWDRIVER(W))
		if(use_power)
			to_chat(user, "<span class='danger'>You need to deactivate the beacon first!</span>")
			return

		if(anchored)
			anchored = 0
			to_chat(user, "<span class='notice'>You unscrew the beacon from the floor.</span>")
			return
		else
			anchored = 1
			to_chat(user, "<span class='notice'>You screw the beacon to the floor.</span>")
			return
	..()
	return

// Ensure the terminal is always accessible to be plugged in.
/obj/machinery/singularity_beacon/components_are_accessible(var/path)
	if(ispath(path, /obj/item/stock_parts/power/terminal))
		return TRUE
	return ..()

/obj/machinery/singularity_beacon/power_change()
	. = ..()
	if(!. || !use_power)
		return
	if(stat & NOPOWER)
		Deactivate()

