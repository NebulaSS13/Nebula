/obj/item/gun/projectile/dartgun
	name = "dart gun"
	desc = "The Artemis is a gas-powered dart gun capable of delivering chemical cocktails swiftly across short distances."
	on_mob_icon = 'icons/obj/guns/dartgun.dmi'
	icon = 'icons/obj/guns/dartgun.dmi'
	icon_state = "world"

	caliber = CALIBER_DART
	fire_sound = 'sound/weapons/empty.ogg'
	fire_sound_text = "a metallic click"
	screen_shake = 0
	silenced = 1
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/chemdart
	allowed_magazines = /obj/item/ammo_magazine/chemdart
	auto_eject = 0
	handle_casings = CLEAR_CASINGS //delete casings instead of dropping them

	var/list/beakers = list() //All containers inside the gun.
	var/list/mixing = list() //Containers being used for mixing.
	var/max_beakers = 3
	var/dart_reagent_amount = 15
	var/container_type = /obj/item/chems/glass/beaker
	var/list/starting_chems = null

/obj/item/gun/projectile/dartgun/Initialize()
	if(starting_chems)
		for(var/chem in starting_chems)
			var/obj/B = new container_type(src)
			B.reagents.add_reagent(chem, 60)
			beakers += B
	. = ..()
	update_icon()

/obj/item/gun/projectile/dartgun/on_update_icon()
	if(!ammo_magazine)
		icon_state = "[get_world_inventory_state()]-empty"
		return 1

	icon_state = "[get_world_inventory_state()]-[Clamp(length(ammo_magazine.stored_ammo.len), 0, 5)]"
	return 1

/obj/item/gun/projectile/dartgun/experimental_mob_overlay(mob/user_mob, slot)
	var/image/I = ..()
	if(slot == slot_r_hand_str || slot == slot_l_hand_str)
		if(!ammo_magazine)
			I.icon_state += "-empty"
		else
			I.icon_state += "-[Clamp(length(ammo_magazine.stored_ammo.len), 0, 5)]"
	return I
/obj/item/gun/projectile/dartgun/consume_next_projectile()
	. = ..()
	var/obj/item/projectile/bullet/chemdart/dart = .
	if(istype(dart))
		fill_dart(dart)

/obj/item/gun/projectile/dartgun/examine(mob/user)
	. = ..()
	if (beakers.len)
		to_chat(user, "<span class='notice'>\The [src] contains:</span>")
		for(var/obj/item/chems/glass/beaker/B in beakers)
			if(B.reagents && LAZYLEN(B.reagents?.reagent_volumes))
				for(var/rtype in B.reagents.reagent_volumes)
					var/decl/reagent/R = decls_repository.get_decl(rtype)
					to_chat(user, "<span class='notice'>[REAGENT_VOLUME(B.reagents, rtype)] units of [R.name]</span>")

/obj/item/gun/projectile/dartgun/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/chems/glass))
		add_beaker(I, user)
		return 1
	..()

/obj/item/gun/projectile/dartgun/proc/add_beaker(var/obj/item/chems/glass/B, mob/user)
	if(!istype(B, container_type))
		to_chat(user, "<span class='warning'>[B] doesn't seem to fit into [src].</span>")
		return
	if(beakers.len >= max_beakers)
		to_chat(user, "<span class='warning'>[src] already has [max_beakers] beakers in it - another one isn't going to fit!</span>")
		return
	if(!user.unEquip(B, src))
		return
	beakers |= B
	user.visible_message("\The [user] inserts \a [B] into [src].", "<span class='notice'>You slot [B] into [src].</span>")

/obj/item/gun/projectile/dartgun/proc/remove_beaker(var/obj/item/chems/glass/B, mob/user)
	mixing -= B
	beakers -= B
	user.put_in_hands(B)
	user.visible_message("\The [user] removes \a [B] from [src].", "<span class='notice'>You remove [B] from [src].</span>")

//fills the given dart with reagents
/obj/item/gun/projectile/dartgun/proc/fill_dart(var/obj/item/projectile/bullet/chemdart/dart)
	if(mixing.len)
		var/mix_amount = dart.reagent_amount/mixing.len
		for(var/obj/item/chems/glass/beaker/B in mixing)
			B.reagents.trans_to_obj(dart, mix_amount)

/obj/item/gun/projectile/dartgun/attack_self(mob/user)
	Interact(user)

/obj/item/gun/projectile/dartgun/proc/Interact(mob/user)
	user.set_machine(src)
	var/list/dat = list("<b>[src] mixing control:</b><br><br>")

	if (!beakers.len)
		dat += "There are no beakers inserted!<br><br>"
	else
		for(var/i in 1 to beakers.len)
			var/obj/item/chems/glass/beaker/B = beakers[i]
			if(!istype(B)) continue

			dat += "Beaker [i] contains: "
			if(B.reagents && LAZYLEN(B.reagents.reagent_volumes))
				for(var/rtype in B.reagents.reagent_volumes)
					var/decl/reagent/R = decls_repository.get_decl(rtype)
					dat += "<br>    [REAGENT_VOLUME(B.reagents, rtype)] units of [R.name], "
				if(B in mixing)
					dat += "<A href='?src=\ref[src];stop_mix=[i]'><font color='green'>Mixing</font></A> "
				else
					dat += "<A href='?src=\ref[src];mix=[i]'><font color='red'>Not mixing</font></A> "
			else
				dat += "nothing."
			dat += " \[<A href='?src=\ref[src];eject=[i]'>Eject</A>\]<br>"

	if(ammo_magazine)
		if(ammo_magazine.stored_ammo && ammo_magazine.stored_ammo.len)
			dat += "The dart cartridge has [ammo_magazine.stored_ammo.len] shots remaining."
		else
			dat += "<font color='red'>The dart cartridge is empty!</font>"
		dat += " \[<A href='?src=\ref[src];eject_cart=1'>Eject</A>\]<br>"

	dat += "<br>\[<A href='?src=\ref[src];refresh=1'>Refresh</A>\]"

	var/datum/browser/popup = new(user, "dartgun", "[src] mixing control")
	popup.set_content(jointext(dat,null))
	popup.open()

/obj/item/gun/projectile/dartgun/OnTopic(user, href_list)
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

	Interact(usr)

/obj/item/gun/projectile/dartgun/medical
	starting_chems = list(/decl/reagent/burn_meds,/decl/reagent/brute_meds,/decl/reagent/antitoxins)

/obj/item/gun/projectile/dartgun/raider
	starting_chems = list(/decl/reagent/psychoactives,/decl/reagent/sedatives,/decl/reagent/narcotics)
