//  Beacon randomly spawns in space
//	When a non-traitor (no special role in /mind) uses it, he is given the choice to become a traitor
//	If he accepts there is a random chance he will be accepted, or rejected resulting in the beacon self-destructing.

/obj/machinery/syndicate_beacon
	name = "ominous beacon"
	desc = "This looks suspicious..."
	icon = 'icons/obj/items/syndibeacon.dmi'
	icon_state = "syndbeacon"

	anchored = TRUE
	density = TRUE

	var/temptext = ""
	var/selfdestructing = 0
	var/charges = 1

/obj/machinery/syndicate_beacon/interface_interact(var/mob/user)
	interact(user)
	return TRUE

/obj/machinery/syndicate_beacon/interact(var/mob/user)
	user.set_machine(src)
	var/dat = "<font color=#005500><i>Scanning [pick("retina pattern", "voice print", "fingerprints", "dna sequence")]...<br>Identity confirmed,<br></i></font>"
	if(ishuman(user) || isAI(user))
		var/decl/special_role/traitors = GET_DECL(/decl/special_role/traitor)
		if(traitors.is_antagonist(user))
			dat += "<font color=#007700><i>Operative record found. Greetings, Agent [user.name].</i></font><br>"
		else if(charges < 1)
			dat += "<TT>Connection severed.</TT><BR>"
		else
			var/decl/pronouns/pronouns = user.get_pronouns()
			dat += "<font color=red><i>Identity not found in operative database. What can the Syndicate do for you today, [pronouns.honorific] [user.name]?</i></font><br>"
			if(!selfdestructing)
				dat += "<br><br><A href='byond://?src=\ref[src];betraitor=1;traitormob=\ref[user]'>\"[pick("I want to switch teams.", "I want to work for you.", "Let me join you.", "I can be of use to you.", "You want me working for you, and here's why...", "Give me an objective.", "How's the 401k over at the Syndicate?")]\"</A><BR>"
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
			addtimer(CALLBACK(src, PROC_REF(selfdestruct)), rand(5, 20) SECONDS)
			return
		if(ishuman(M))
			var/mob/living/human/N = M
			to_chat(M, "<B>You have joined the ranks of the Syndicate and become a traitor to the station!</B>")
			var/decl/special_role/traitors = GET_DECL(/decl/special_role/traitor)
			traitors.add_antagonist(N.mind)
			log_and_message_admins("has accepted a traitor objective from a syndicate beacon.", M)


	src.updateUsrDialog()
	return


/obj/machinery/syndicate_beacon/proc/selfdestruct()
	selfdestructing = 1
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(explosion), src.loc, 1, rand(1, 3), rand(3, 8), 10)

// Add the syndicate beacon to artifact finds.
/datum/artifact_find/New()
	var/static/injected = FALSE
	if(!injected)
		potential_finds[/obj/machinery/syndicate_beacon] = 5
		injected = TRUE
	..()
