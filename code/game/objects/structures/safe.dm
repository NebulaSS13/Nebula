/*
CONTAINS:
SAFES
FLOOR SAFES
*/

//SAFES
/obj/structure/safe
	name = "safe"
	desc = "A huge chunk of metal with a dial embedded in it. Fine print on the dial reads \"Scarborough Arms - 2 tumbler safe, guaranteed thermite resistant, explosion resistant, and assistant resistant.\"."
	icon = 'icons/obj/structures/safe.dmi'
	icon_state = "safe"
	anchored = TRUE
	density = TRUE
	var/open = 0		//is the safe open?
	var/tumbler_1_pos	//the tumbler position- from 0 to 72
	var/tumbler_1_open	//the tumbler position to open at- 0 to 72
	var/tumbler_2_pos
	var/tumbler_2_open
	var/dial = 0		//where is the dial pointing?
	var/space = 0		//the combined w_class of everything in the safe
	var/maxspace = 24	//the maximum combined w_class of stuff in the safe

// TODO: make this use a storage datum?
/obj/structure/safe/Initialize()
	for(var/obj/item/thing in loc)
		if(space >= maxspace)
			break
		if(thing.w_class + space <= maxspace) //todo replace with internal storage or something
			space += thing.w_class
			thing.forceMove(src)
	. = ..()
	tumbler_1_pos = rand(0, 72)
	tumbler_1_open = rand(0, 72)

	tumbler_2_pos = rand(0, 72)
	tumbler_2_open = rand(0, 72)

/obj/structure/safe/proc/check_unlocked(mob/user, canhear)
	if(user && canhear)
		if(tumbler_1_pos == tumbler_1_open)
			to_chat(user, "<span class='notice'>You hear a [pick("tonk", "krunk", "plunk")] from [src].</span>")
		if(tumbler_2_pos == tumbler_2_open)
			to_chat(user, "<span class='notice'>You hear a [pick("tink", "krink", "plink")] from [src].</span>")
	if(tumbler_1_pos == tumbler_1_open && tumbler_2_pos == tumbler_2_open)
		if(user) visible_message("<b>[pick("Spring", "Sprang", "Sproing", "Clunk", "Krunk")]!</b>")
		return 1
	return 0


/obj/structure/safe/proc/decrement(num)
	num -= 1
	if(num < 0)
		num = 71
	return num


/obj/structure/safe/proc/increment(num)
	num += 1
	if(num > 71)
		num = 0
	return num


/obj/structure/safe/on_update_icon()
	..()
	if(open)
		icon_state = "[initial(icon_state)]-open"
	else
		icon_state = initial(icon_state)

/obj/structure/safe/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_COMPLEX_TOOLS, TRUE))
		return ..()

	user.set_machine(src)
	var/dat = "<center>"
	dat += "<a href='byond://?src=\ref[src];open=1'>[open ? "Close" : "Open"] [src]</a> | <a href='byond://?src=\ref[src];decrement=1'>-</a> [dial * 5] <a href='byond://?src=\ref[src];increment=1'>+</a>"
	if(open)
		dat += "<table>"
		for(var/i = contents.len, i>=1, i--)
			var/obj/item/P = contents[i]
			dat += "<tr><td><a href='byond://?src=\ref[src];retrieve=\ref[P]'>[P.name]</a></td></tr>"
		dat += "</table></center>"
	show_browser(user, "<html><head><title>[name]</title></head><body>[dat]</body></html>", "window=safe;size=350x300")
	return TRUE

/obj/structure/safe/DefaultTopicState()
	return global.physical_no_access_topic_state

/obj/structure/safe/OnTopic(mob/user, href_list, state)
	if(href_list["open"])
		if(check_unlocked())
			to_chat(user, "<span class='notice'>You [open ? "close" : "open"] [src].</span>")
			open = !open
			return TOPIC_REFRESH
		else
			to_chat(user, "<span class='notice'>You can't [open ? "close" : "open"] [src], the lock is engaged!</span>")
			return TOPIC_HANDLED

	var/canhear = locate(/obj/item/clothing/neck/stethoscope) in user.get_held_items()
	if(href_list["decrement"])
		dial = decrement(dial)
		if(dial == tumbler_1_pos + 1 || dial == tumbler_1_pos - 71)
			tumbler_1_pos = decrement(tumbler_1_pos)
			if(canhear)
				to_chat(user, "<span class='notice'>You hear a [pick("clack", "scrape", "clank")] from [src].</span>")
			if(tumbler_1_pos == tumbler_2_pos + 37 || tumbler_1_pos == tumbler_2_pos - 35)
				tumbler_2_pos = decrement(tumbler_2_pos)
				if(canhear)
					to_chat(user, "<span class='notice'>You hear a [pick("click", "chink", "clink")] from [src].</span>")
			check_unlocked(user, canhear)
		return TOPIC_REFRESH

	if(href_list["increment"])
		dial = increment(dial)
		if(dial == tumbler_1_pos - 1 || dial == tumbler_1_pos + 71)
			tumbler_1_pos = increment(tumbler_1_pos)
			if(canhear)
				to_chat(user, "<span class='notice'>You hear a [pick("clack", "scrape", "clank")] from [src].</span>")
			if(tumbler_1_pos == tumbler_2_pos - 37 || tumbler_1_pos == tumbler_2_pos + 35)
				tumbler_2_pos = increment(tumbler_2_pos)
				if(canhear)
					to_chat(user, "<span class='notice'>You hear a [pick("click", "chink", "clink")] from [src].</span>")
			check_unlocked(user, canhear)
		return TOPIC_REFRESH

	if(href_list["retrieve"])
		if(!open)
			return TOPIC_CLOSE // Close the menu
		var/obj/item/P = locate(href_list["retrieve"]) in src
		if(P && CanPhysicallyInteract(user))
			user.put_in_hands(P)
		return TOPIC_REFRESH


/obj/structure/safe/attackby(obj/item/used_item, mob/user)
	if(open)
		if(used_item.w_class + space <= maxspace)
			if(!user.try_unequip(used_item, src))
				return TRUE
			space += used_item.w_class
			to_chat(user, "<span class='notice'>You put [used_item] in [src].</span>")
			updateUsrDialog()
			return TRUE
		else
			to_chat(user, "<span class='notice'>[used_item] won't fit in [src].</span>")
			return TRUE
	else
		if(istype(used_item, /obj/item/clothing/neck/stethoscope))
			to_chat(user, "Hold [used_item] in one of your hands while you manipulate the dial.")
			return TRUE
		return FALSE


/obj/structure/safe/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	return

//FLOOR SAFES
/obj/structure/safe/floor
	name = "floor safe"
	icon_state = "floorsafe"
	density = FALSE
	level = LEVEL_BELOW_PLATING
	layer = BELOW_OBJ_LAYER

/obj/structure/safe/floor/Initialize()
	. = ..()
	var/turf/T = loc
	if(istype(T) && !T.is_plating())
		hide(1)
	update_icon()

/obj/structure/safe/floor/hide(var/intact)
	set_invisibility(intact ? 101 : 0)

/obj/structure/safe/floor/hides_under_flooring()
	return 1
