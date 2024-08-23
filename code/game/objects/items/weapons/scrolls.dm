/obj/item/paper/scroll/teleportation
	name = "scroll of teleportation"
	desc = "A scroll for moving around."
	origin_tech = @'{"wormholes":4}'
	info = {"
		<B>Teleportation Scroll:</B><BR>
		<HR>
		<B>Comes with four charges! Use them wisely.</B><BR>
		Kind regards,<br>Wizards Federation<br><br>P.S. Don't forget to bring your gear, you'll need it to cast most spells.
	"}
	var/uses = 4

/obj/item/paper/scroll/teleportation/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		var/decl/special_role/wizard/wizards = GET_DECL(/decl/special_role/wizard)
		if(wizards.is_antagonist(user.mind))
			to_chat(user, SPAN_NOTICE("\The [src] has [uses] charge\s remaining."))

/obj/item/paper/scroll/teleportation/attack_self(mob/user)
	var/decl/special_role/wizard/wizards = GET_DECL(/decl/special_role/wizard)
	if((user.mind && !wizards.is_antagonist(user.mind)))
		to_chat(user, SPAN_WARNING("You stare at \the [src], but cannot make sense of the markings!"))
		return TRUE
	if(alert(user, "Do you wish to teleport using \the [src]? It has [uses] charge\s remaining.", "Scroll of Teleportation", "No", "Yes") == "Yes")
		teleportscroll(user)
	return TRUE

/obj/item/paper/scroll/teleportation/proc/teleportscroll(var/mob/user)
	if(uses <= 0)
		return

	var/area/thearea = input(user, "Select an area to jump to.", "Scroll of Teleportation") as null|anything in wizteleportlocs
	if(!thearea || QDELETED(src) || QDELETED(user) || user.get_active_held_item() != src || CanUseTopic(user) != STATUS_INTERACTIVE)
		return

	thearea = thearea ? wizteleportlocs[thearea] : thearea
	if(!thearea)
		return

	var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread()
	smoke.set_up(5, 0, user.loc)
	smoke.attach(user)
	smoke.start()
	var/turf/end = user.try_teleport(thearea)
	if(!end)
		to_chat(user, SPAN_WARNING("The spell matrix was unable to locate a suitable teleport destination for an unknown reason. Sorry!"))
		return
	smoke.start()
	src.uses -= 1
