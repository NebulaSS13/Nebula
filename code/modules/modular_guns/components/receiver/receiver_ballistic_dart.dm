/obj/item/firearm_component/receiver/ballistic/dart
	load_method = MAGAZINE
	ammo_magazine = /obj/item/ammo_magazine/chemdart
	allowed_magazines = /obj/item/ammo_magazine/chemdart
	handle_casings = CLEAR_CASINGS

	var/list/beakers = list() // All containers inside the gun.
	var/list/mixing = list()  // Containers being used for mixing.
	var/max_beakers = 3
	var/dart_reagent_amount = 15
	var/container_type = /obj/item/chems/glass/beaker
	var/list/starting_chems

/obj/item/firearm_component/receiver/ballistic/dart/Initialize()
	if(starting_chems)
		for(var/chem in starting_chems)
			var/obj/B = new container_type(src)
			B.reagents.add_reagent(chem, 60)
			beakers += B
	. = ..()

/obj/item/firearm_component/receiver/ballistic/dart/get_ammo_indicator(var/base_state)
	return mutable_appearance(icon, "[base_state]-[Clamp(length(ammo_magazine?.stored_ammo), 0, 5)]")

/obj/item/firearm_component/receiver/ballistic/dart/get_next_projectile(mob/user)
	var/obj/item/projectile/bullet/chemdart/dart = ..()
	if(istype(dart) && length(mixing))
		var/mix_amount = round(dart.reagent_amount/length(mixing))
		for(var/obj/item/chems/glass/beaker/B in mixing)
			B.reagents.trans_to_obj(dart, Clamp(mix_amount, 0, B.reagents.total_volume))
	return dart

/obj/item/firearm_component/receiver/ballistic/dart/show_examine_info(var/mob/user)
	. = ..()
	if(length(beakers))
		to_chat(user, SPAN_NOTICE("\The [loc] contains:"))
		for(var/obj/item/chems/glass/beaker/B in beakers)
			for(var/rtype in B.reagents?.reagent_volumes)
				var/decl/material/R = decls_repository.get_decl(rtype)
				to_chat(user, SPAN_NOTICE("[REAGENT_VOLUME(B.reagents, rtype)] units of [R.name]"))

/obj/item/firearm_component/receiver/ballistic/dart/holder_attackby(obj/item/W, mob/user)
	if(istype(W, container_type))
		if(length(beakers) >= max_beakers)
			to_chat(user, SPAN_WARNING("\The [loc] already has [max_beakers] beakers in it - another one isn't going to fit!"))
		else if(user.unEquip(W, src))
			beakers |= W
			user.visible_message(SPAN_NOTICE("\The [user] inserts \a [W] into \the [loc]."))
		return TRUE
	. = ..()
	
/obj/item/firearm_component/receiver/ballistic/dart/holder_attack_hand(mob/user)
	interact(user)
	return TRUE
	
/obj/item/firearm_component/receiver/ballistic/dart/interact(var/mob/user)
	user.set_machine(src)
	var/list/dat = list("<b>[src] mixing control:</b><br><br>")
	if(!length(beakers))
		dat += "There are no beakers inserted!<br><br>"
	else
		var/i = 0
		for(var/obj/item/chems/glass/beaker/B in beakers)
			i++
			dat += "Beaker #[i] contains: "
			if(B.reagents && LAZYLEN(B.reagents.reagent_volumes))
				for(var/rtype in B.reagents.reagent_volumes)
					var/decl/material/R = decls_repository.get_decl(rtype)
					dat += "<br>    [REAGENT_VOLUME(B.reagents, rtype)] units of [R.name], "
				if(B in mixing)
					dat += "<A href='?src=\ref[src];stop_mix=[i]'><font color='green'>Mixing</font></A> "
				else
					dat += "<A href='?src=\ref[src];mix=[i]'><font color='red'>Not mixing</font></A> "
			else
				dat += "nothing."
			dat += " \[<A href='?src=\ref[src];eject=[i]'>Eject</A>\]<br>"

	if(ammo_magazine)
		if(length(ammo_magazine.stored_ammo))
			dat += "The dart cartridge has [length(ammo_magazine.stored_ammo)] shot\s remaining."
		else
			dat += "<font color='red'>The dart cartridge is empty!</font>"
		dat += " \[<A href='?src=\ref[src];eject_cart=1'>Eject</A>\]<br>"
	dat += "<br>\[<A href='?src=\ref[src];refresh=1'>Refresh</A>\]"

	var/datum/browser/popup = new(user, "dartgun", "[src] mixing control")
	popup.set_content(jointext(dat,null))
	popup.open()

/obj/item/firearm_component/receiver/ballistic/dart/proc/remove_beaker(var/obj/item/chems/glass/B, mob/user)
	mixing -= B
	beakers -= B
	user.put_in_hands(B)
	user.visible_message(SPAN_NOTICE("\The [user] removes \a [B] from \the [loc]."))

/obj/item/firearm_component/receiver/ballistic/dart/OnTopic(user, href_list)
	. = ..()
	if(.)
		return
	if(href_list["stop_mix"])
		var/index = text2num(href_list["stop_mix"])
		mixing -= beakers[index]
		. = TOPIC_REFRESH
	else if (href_list["mix"])
		var/index = text2num(href_list["mix"])
		mixing |= beakers[index]
		. = TOPIC_REFRESH
	else if (href_list["eject"])
		var/index = text2num(href_list["eject"])
		if(beakers[index])
			remove_beaker(beakers[index], usr)
		. = TOPIC_REFRESH
	else if (href_list["eject_cart"])
		unload_ammo(usr)
		. = TOPIC_REFRESH
	interact(usr)
