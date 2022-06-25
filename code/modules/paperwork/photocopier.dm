/obj/machinery/photocopier
	name = "photocopier"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "photocopier"
	var/insert_anim = "photocopier_animation"
	anchored = 1
	density = 1
	idle_power_usage = 30
	active_power_usage = 200
	power_channel = EQUIP
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	obj_flags = OBJ_FLAG_ANCHORABLE
	var/obj/item/copyitem = null	//what's in the copier!
	var/copies = 1	//how many copies to print!
	var/toner = 30 //how much toner is left! woooooo~
	var/maxcopies = 10	//how many copies can be copied at once- idea shamelessly stolen from bs12's copier!

/obj/machinery/photocopier/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/photocopier/interact(mob/user)
	user.set_machine(src)

	var/dat = "Photocopier<BR><BR>"
	if(copyitem)
		dat += "<a href='byond://?src=\ref[src];remove=1'>Remove Item</a><BR>"
		if(toner)
			dat += "<a href='byond://?src=\ref[src];copy=1'>Copy</a><BR>"
			dat += "Printing: [copies] copies."
			dat += "<a href='byond://?src=\ref[src];min=1'>-</a> "
			dat += "<a href='byond://?src=\ref[src];add=1'>+</a><BR><BR>"
	else if(toner)
		dat += "Please insert something to copy.<BR><BR>"
	if(istype(user,/mob/living/silicon))
		dat += "<a href='byond://?src=\ref[src];aipic=1'>Print photo from database</a><BR><BR>"
	dat += "Current toner level: [toner]"
	if(!toner)
		dat +="<BR>Please insert a new toner cartridge!"
	show_browser(user, dat, "window=copier")
	onclose(user, "copier")
	return

/obj/machinery/photocopier/OnTopic(user, href_list, state)
	if(href_list["copy"])
		for(var/i = 0, i < copies, i++)
			if(toner <= 0)
				break
			if (istype(copyitem, /obj/item/paper))
				copy(copyitem, 1)
				sleep(15)
			else if (istype(copyitem, /obj/item/photo))
				photocopy(copyitem)
				sleep(15)
			else if (istype(copyitem, /obj/item/paper_bundle))
				var/obj/item/paper_bundle/B = bundlecopy(copyitem)
				sleep(15*B.pages.len)
			else
				to_chat(user, "<span class='warning'>\The [copyitem] can't be copied by \the [src].</span>")
				break

			use_power_oneoff(active_power_usage)
		return TOPIC_REFRESH

	if(href_list["remove"])
		OnRemove(user)
		return TOPIC_REFRESH

	if(href_list["min"])
		if(copies > 1)
			copies--
		return TOPIC_REFRESH

	else if(href_list["add"])
		if(copies < maxcopies)
			copies++
		return TOPIC_REFRESH

	if(href_list["aipic"])
		if(!istype(user,/mob/living/silicon)) return

		if(toner >= 5)
			var/mob/living/silicon/tempAI = user
			var/obj/item/camera/siliconcam/camera = tempAI.silicon_camera

			if(!camera)
				return
			var/obj/item/photo/selection = camera.selectpicture()
			if (!selection)
				return

			var/obj/item/photo/p = photocopy(selection)
			if (p.desc == "")
				p.desc += "Copied by [tempAI.name]"
			else
				p.desc += " - Copied by [tempAI.name]"
			toner -= 5
			sleep(15)
		return TOPIC_REFRESH

/obj/machinery/photocopier/proc/OnRemove(mob/user)
	if(copyitem)
		user.put_in_hands(copyitem)
		to_chat(user, "<span class='notice'>You take \the [copyitem] out of \the [src].</span>")
		copyitem = null

/obj/machinery/photocopier/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/paper) || istype(O, /obj/item/photo) || istype(O, /obj/item/paper_bundle))
		if(!copyitem)
			if(!user.unEquip(O, src))
				return
			copyitem = O
			to_chat(user, "<span class='notice'>You insert \the [O] into \the [src].</span>")
			flick(insert_anim, src)
			updateUsrDialog()
		else
			to_chat(user, "<span class='notice'>There is already something in \the [src].</span>")
	else if(istype(O, /obj/item/toner))
		if(toner <= 10) //allow replacing when low toner is affecting the print darkness
			if(!user.unEquip(O, src))
				return
			to_chat(user, "<span class='notice'>You insert the toner cartridge into \the [src].</span>")
			var/obj/item/toner/T = O
			toner += T.toner_amount
			qdel(O)
			updateUsrDialog()
		else
			to_chat(user, "<span class='notice'>This cartridge is not yet ready for replacement! Use up the rest of the toner.</span>")
	else ..()

/obj/machinery/photocopier/explosion_act(severity)
	..()
	if(!QDELETED(src) && (severity == 2 || prob(50)) && toner)
		new /obj/effect/decal/cleanable/blood/oil(get_turf(src))
		toner = 0

/obj/machinery/photocopier/proc/copy(var/obj/item/paper/original, var/need_toner=1)
	var/obj/item/paper/copy = original.Clone()
	copy.set_color(COLOR_WHITE)

	//Apply a greyscale filter on all stamps overlays
	for(var/image/I in copy.applied_stamps)
		I.filters += filter(type = "color", color = list(1,0,0, 0,0,0, 0,0,1), space = FILTER_COLOR_HSV)
	var/copied = original.info
	copied = replacetext(copied, "<font face=\"[copy.deffont]\" color=", "<font face=\"[copy.deffont]\" nocolor=")	//state of the art techniques in action
	copied = replacetext(copied, "<font face=\"[copy.crayonfont]\" color=", "<font face=\"[copy.crayonfont]\" nocolor=")	//This basically just breaks the existing color tag, which we need to do because the innermost tag takes priority.

	//Comments preserved for posterity:
	//lots of toner, make it dark
	//no toner? shitty copies for you!
	if(toner > 10)
		copy.set_content("<font color = [(toner > 10)? "#101010" : "#808080"]>[copied]</font>")
	
	if(need_toner)
		toner--
	if(toner == 0)
		visible_message(SPAN_WARNING("A red light on \the [src] flashes, indicating that it is out of toner."))
	return copy

/obj/machinery/photocopier/proc/photocopy(var/obj/item/photo/photocopy, var/need_toner=1)
	var/obj/item/photo/p = photocopy.copy()
	p.dropInto(loc)

	if(toner > 10)	//plenty of toner, go straight greyscale
		p.img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))//I'm not sure how expensive this is, but given the many limitations of photocopying, it shouldn't be an issue.
		p.update_icon()
	else			//not much toner left, lighten the photo
		p.img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
		p.update_icon()
	if(need_toner)
		toner -= 5	//photos use a lot of ink!
	if(toner < 0)
		toner = 0
		visible_message("<span class='notice'>A red light on \the [src] flashes, indicating that it is out of toner.</span>")

	return p

//If need_toner is 0, the copies will still be lightened when low on toner, however it will not be prevented from printing. TODO: Implement print queues for fax machines and get rid of need_toner
/obj/machinery/photocopier/proc/bundlecopy(var/obj/item/paper_bundle/bundle, var/need_toner=1)
	var/obj/item/paper_bundle/p = new /obj/item/paper_bundle (src)
	for(var/obj/item/W in bundle.pages)
		if(toner <= 0 && need_toner)
			toner = 0
			visible_message("<span class='notice'>A red light on \the [src] flashes, indicating that it is out of toner.</span>")
			break

		if(istype(W, /obj/item/paper))
			W = copy(W)
		else if(istype(W, /obj/item/photo))
			W = photocopy(W)
		W.forceMove(p)
		p.pages += W

	p.dropInto(loc)
	p.update_icon()
	p.icon_state = "paper_words"
	p.SetName(bundle.name)
	return p

/obj/item/toner
	name = "toner cartridge"
	icon = 'icons/obj/items/tonercartridge.dmi'
	icon_state = "tonercartridge"
	material = /decl/material/solid/plastic
	var/toner_amount = 30
