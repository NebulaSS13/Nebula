// Base type, do not use.
/obj/structure/lift
	name = "turbolift control component"
	icon = 'icons/obj/turbolift.dmi'
	anchored = 1
	density = 0
	layer = ABOVE_OBJ_LAYER
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	directional_offset = "{'NORTH':{'y':-32}, 'SOUTH':{'y':32}, 'EAST':{'x':-32}, 'WEST':{'x':32}}"
	var/datum/turbolift/lift

/obj/structure/lift/proc/pressed(var/mob/user)
	if(!istype(user, /mob/living/silicon))
		if(user.a_intent == I_HURT)
			user.visible_message("<span class='danger'>\The [user] hammers on the lift button!</span>")
		else
			user.visible_message("<span class='notice'>\The [user] presses the lift button.</span>")
		playsound(src, 'sound/machines/button3.ogg', 100, 1)


/obj/structure/lift/Initialize(mapload, var/datum/turbolift/_lift)
	. = ..(mapload)
	lift = _lift

/obj/structure/lift/attack_ai(var/mob/user)
	return attack_hand(user)

/obj/structure/lift/attack_hand(var/mob/user)
	SHOULD_CALL_PARENT(FALSE)
	return interact(user)

/obj/structure/lift/interact(var/mob/user)
	if(!lift.is_functional())
		return FALSE
	if(!user.check_dexterity(DEXTERITY_SIMPLE_MACHINES))
		return FALSE
	return TRUE
// End base.

// Button. No HTML interface, just calls the associated lift to its floor.
/obj/structure/lift/button
	name = "elevator button"
	desc = "A call button for an elevator. Be sure to hit it three hundred times."
	icon_state = "button"
	var/light_up = FALSE
	var/datum/turbolift_floor/floor

/obj/structure/lift/button/Destroy()
	if(floor && floor.ext_panel == src)
		floor.ext_panel = null
	floor = null
	return ..()

/obj/structure/lift/button/proc/reset()
	light_up = FALSE
	update_icon()

/obj/structure/lift/button/interact(var/mob/user)
	if(!..())
		return
	light_up()
	pressed(user)
	if(floor == lift.current_floor)
		lift.open_doors()
		spawn(3)
			reset()
		return
	lift.queue_move_to(floor)

/obj/structure/lift/button/proc/light_up()
	light_up = TRUE
	update_icon()

/obj/structure/lift/button/standalone
	icon_state = "plinth"

/obj/structure/lift/button/on_update_icon()
	..()
	if(light_up)
		icon_state = "[initial(icon_state)]_lit"
	else
		icon_state = initial(icon_state)

// End button.

// Panel. Lists floors (HTML), moves with the elevator, schedules a move to a given floor.
/obj/structure/lift/panel
	name = "elevator control panel"
	icon_state = "panel"

/obj/structure/lift/panel/standalone
	icon_state = "standing_panel"
	obj_flags = 0
	directional_offset = null

/obj/structure/lift/panel/attack_ghost(var/mob/user)
	return interact(user)

/obj/structure/lift/panel/interact(var/mob/user)
	if(!..())
		return

	var/dat = list()
	dat += "<html><body><hr><b>Lift panel</b><hr>"

	//the floors list stores levels in order of increasing Z
	//therefore, to display upper levels at the top of the menu and
	//lower levels at the bottom, we need to go through the list in reverse
	for(var/i in lift.floors.len to 1 step -1)
		var/datum/turbolift_floor/floor = lift.floors[i]
		var/label = floor.label? floor.label : "Level #[i]"
		dat += "<font color = '[(floor in lift.queued_floors) ? COLOR_YELLOW : COLOR_WHITE]'>"
		dat += "<a href='?src=\ref[src];move_to_floor=["\ref[floor]"]'>[label]</a>: [floor.name]</font><br>"

	dat += "<hr>"
	if(LAZYLEN(lift.doors))
		if(lift.doors_are_open())
			dat += "<a href='?src=\ref[src];close_doors=1'>Close Doors</a><br>"
		else
			dat += "<a href='?src=\ref[src];open_doors=1'>Open Doors</a><br>"
	dat += "<a href='?src=\ref[src];emergency_stop=1'>Emergency Stop</a>"
	dat += "<hr></body></html>"

	var/datum/browser/written_digital/popup = new(user, "turbolift_panel", "Lift Panel", 230, 260)
	popup.set_content(jointext(dat, null))
	popup.open()
	return

/obj/structure/lift/panel/OnTopic(user, href_list)
	if(href_list["move_to_floor"])
		lift.queue_move_to(locate(href_list["move_to_floor"]))
		. = TOPIC_REFRESH
	if(href_list["open_doors"])
		lift.open_doors()
		. = TOPIC_REFRESH
	if(href_list["close_doors"])
		lift.close_doors()
		. = TOPIC_REFRESH
	if(href_list["emergency_stop"])
		lift.emergency_stop()
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		pressed(user)

// End panel.