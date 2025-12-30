/obj/machinery/beehive
	name = "apiary"
	icon = 'mods/content/beekeeping/icons/beekeeping.dmi'
	icon_state = "beehive-0"
	desc = "A wooden box designed specifically to house our buzzling buddies. Far more efficient than traditional hives. Just insert a frame and a queen, close it up, and you're good to go!"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER

	var/closed = 0
	var/bee_count = 0 // Percent
	var/smoked = 0 // Timer
	var/honeycombs = 0 // Percent
	var/frames = 0
	var/maxFrames = 5

/obj/machinery/beehive/Initialize()
	. = ..()
	update_icon()

/obj/machinery/beehive/on_update_icon()
	overlays.Cut()
	icon_state = "beehive-[closed]"
	if(closed)
		overlays += "lid"
	if(frames)
		overlays += "empty[frames]"
	if(honeycombs >= 100)
		overlays += "full[round(honeycombs / 100)]"
	if(!smoked)
		switch(bee_count)
			if(1 to 20)
				overlays += "bees1"
			if(21 to 40)
				overlays += "bees2"
			if(41 to 60)
				overlays += "bees3"
			if(61 to 80)
				overlays += "bees4"
			if(81 to 100)
				overlays += "bees5"

/obj/machinery/beehive/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(!closed)
		. += "The lid is open."

/obj/machinery/beehive/attackby(var/obj/item/used_item, var/mob/user)
	if(IS_CROWBAR(used_item))
		closed = !closed
		user.visible_message("<span class='notice'>\The [user] [closed ? "closes" : "opens"] \the [src].</span>", "<span class='notice'>You [closed ? "close" : "open"] \the [src].</span>")
		update_icon()
		return TRUE
	else if(IS_WRENCH(used_item))
		anchored = !anchored
		user.visible_message("<span class='notice'>\The [user] [anchored ? "wrenches" : "unwrenches"] \the [src].</span>", "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>")
		return TRUE
	else if(istype(used_item, /obj/item/bee_smoker))
		if(closed)
			to_chat(user, "<span class='notice'>You need to open \the [src] with a crowbar before smoking the bees.</span>")
			return TRUE
		user.visible_message("<span class='notice'>\The [user] smokes the bees in \the [src].</span>", "<span class='notice'>You smoke the bees in \the [src].</span>")
		smoked = 30
		update_icon()
		return TRUE
	else if(istype(used_item, /obj/item/hive_frame/crafted))
		if(closed)
			to_chat(user, "<span class='notice'>You need to open \the [src] with a crowbar before inserting \the [used_item].</span>")
			return TRUE
		if(frames >= maxFrames)
			to_chat(user, "<span class='notice'>There is no place for an another frame.</span>")
			return TRUE
		var/obj/item/hive_frame/crafted/H = used_item
		if(REAGENT_TOTAL_VOLUME(H.reagents))
			to_chat(user, "<span class='notice'>\The [used_item] is full with beeswax and honey, empty it in the extractor first.</span>")
			return TRUE
		++frames
		user.visible_message("<span class='notice'>\The [user] loads \the [used_item] into \the [src].</span>", "<span class='notice'>You load \the [used_item] into \the [src].</span>")
		update_icon()
		qdel(used_item)
		return TRUE
	else if(istype(used_item, /obj/item/bee_pack))
		var/obj/item/bee_pack/B = used_item
		if(B.full && bee_count)
			to_chat(user, "<span class='notice'>\The [src] already has bees inside.</span>")
			return TRUE
		if(!B.full && bee_count < 90)
			to_chat(user, "<span class='notice'>\The [src] is not ready to split.</span>")
			return TRUE
		if(!B.full && !smoked)
			to_chat(user, "<span class='notice'>Smoke \the [src] first!</span>")
			return TRUE
		if(closed)
			to_chat(user, "<span class='notice'>You need to open \the [src] with a crowbar before moving the bees.</span>")
			return TRUE
		if(B.full)
			user.visible_message("<span class='notice'>\The [user] puts the queen and the bees from \the [used_item] into \the [src].</span>", "<span class='notice'>You put the queen and the bees from \the [used_item] into \the [src].</span>")
			bee_count = 20
			B.empty()
		else
			user.visible_message("<span class='notice'>\The [user] puts bees and larvae from \the [src] into \the [used_item].</span>", "<span class='notice'>You put bees and larvae from \the [src] into \the [used_item].</span>")
			bee_count /= 2
			B.fill()
		update_icon()
		return TRUE
	else if(istype(used_item, /obj/item/scanner/plant))
		to_chat(user, "<span class='notice'>Scan result of \the [src]...</span>")
		to_chat(user, "Beehive is [bee_count ? "[round(bee_count)]% full" : "empty"].[bee_count > 90 ? " Colony is ready to split." : ""]")
		if(frames)
			to_chat(user, "[frames] frames installed, [round(honeycombs / 100)] filled.")
			if(honeycombs < frames * 100)
				to_chat(user, "Next frame is [round(honeycombs % 100)]% full.")
		else
			to_chat(user, "No frames installed.")
		if(smoked)
			to_chat(user, "The hive is smoked.")
		return TRUE
	else if(IS_SCREWDRIVER(used_item))
		if(bee_count)
			to_chat(user, "<span class='notice'>You can't dismantle \the [src] with these bees inside.</span>")
			return TRUE
		to_chat(user, "<span class='notice'>You start dismantling \the [src]...</span>")
		playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 30, src))
			user.visible_message("<span class='notice'>\The [user] dismantles \the [src].</span>", "<span class='notice'>You dismantle \the [src].</span>")
			new /obj/item/beehive_assembly(loc)
			qdel(src)
		return TRUE
	return FALSE // this should probably not be a machine, so don't do any component interactions

/obj/machinery/beehive/physical_attack_hand(var/mob/user)
	if(closed)
		return FALSE
	. = TRUE
	if(honeycombs < 100)
		to_chat(user, "<span class='notice'>There are no filled honeycombs.</span>")
		return
	if(!smoked && bee_count)
		to_chat(user, "<span class='notice'>The bees won't let you take the honeycombs out like this, smoke them first.</span>")
		return
	user.visible_message("<span class='notice'>\The [user] starts taking the honeycombs out of \the [src].</span>", "<span class='notice'>You start taking the honeycombs out of \the [src]...</span>")
	while(honeycombs >= 100 && do_after(user, 30, src))
		new /obj/item/hive_frame/crafted/filled(loc)
		honeycombs -= 100
		--frames
	update_icon()
	if(honeycombs < 100)
		to_chat(user, "<span class='notice'>You take all filled honeycombs out.</span>")

/obj/machinery/beehive/Process()
	if(closed && !smoked && bee_count)
		pollinate_flowers()
		update_icon()
	smoked = max(0, smoked - 1)
	if(!smoked && bee_count)
		bee_count = min(bee_count * 1.005, 100)
		update_icon()

/obj/machinery/beehive/proc/pollinate_flowers()
	var/coef = bee_count / 100
	var/trays = 0
	for(var/obj/machinery/portable_atmospherics/hydroponics/H in view(7, src))
		if(H.seed && !H.dead)
			H.plant_health += 0.05 * coef
			if(H.pollen >= 1)
				H.pollen--
				trays++
	honeycombs = min(honeycombs + 0.1 * coef * min(trays, 5), frames * 100)
