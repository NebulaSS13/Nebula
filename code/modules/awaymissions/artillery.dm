
/obj/machinery/artillerycontrol
	var/reload = 180
	name = "superluminal artillery control"
	icon_state = "control_boxp1"
	icon = 'icons/obj/machines/particle_accelerator2.dmi'
	density = TRUE
	anchored = TRUE

/obj/machinery/artillerycontrol/Process()
	if(src.reload<180)
		src.reload++

/obj/structure/artilleryplaceholder
	name = "artillery"
	icon = 'icons/obj/machines/artillery.dmi'
	anchored = TRUE
	density = TRUE
	desc = "The ship's old superluminal artillery cannon. Looks inoperative."

/obj/structure/artilleryplaceholder/decorative
	density = FALSE

/obj/machinery/artillerycontrol/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/artillerycontrol/interact(mob/user)
	user.set_machine(src)
	var/dat = "<B>Superluminal Artillery Control:</B><BR>"
	dat += "Locked on<BR>"
	dat += "<B>Charge progress: [reload]/180:</B><BR>"
	dat += "<A href='byond://?src=\ref[src];fire=1'>Open Fire</A><BR>"
	dat += "Deployment of weapon authorized by <br>[global.using_map.company_name] Naval Command<br><br>Remember, friendly fire is grounds for termination of your contract and life.<HR>"
	show_browser(user, dat, "window=scroll")
	onclose(user, "scroll")

/obj/machinery/artillerycontrol/Topic(href, href_list, state = global.physical_topic_state)
	if(..())
		return 1

	if ((usr.contents.Find(src) || (in_range(src, usr) && isturf(src.loc))) || (issilicon(usr)))
		var/area/thearea = input("Area to jump bombard", "Open Fire") as null|anything in teleportlocs
		thearea = thearea ? teleportlocs[thearea] : thearea
		if (!thearea || CanUseTopic(usr, global.physical_topic_state) != STATUS_INTERACTIVE)
			return
		if (src.reload < 180)
			return
		if ((usr.contents.Find(src) || (in_range(src, usr) && isturf(src.loc))) || (issilicon(usr)))
			command_announcement.Announce("Wormhole artillery fire detected. Brace for impact.")
			log_and_message_admins("has launched an artillery strike.", 1)
			var/list/L = list()
			for(var/turf/T in get_area_turfs(thearea))
				L+=T
			var/loc = pick(L)
			explosion(loc,2,5,11)
			reload = 0
