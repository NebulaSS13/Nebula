/obj/item/soulstone
	name = "soul stone shard"
	icon = 'icons/obj/items/soulstone.dmi'
	icon_state = ICON_STATE_WORLD
	desc = "A strange, ridged chunk of some glassy red material. Achingly cold to the touch."
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_LOWER_BODY
	origin_tech = "{'wormholes':4,'materials':4}"

	var/full = SOULSTONE_EMPTY
	var/is_evil = 1
	var/mob/living/simple_animal/shade = null
	var/smashing = 0
	var/soulstatus = null

/obj/item/soulstone/Initialize(var/mapload)
	shade = new /mob/living/simple_animal/shade(src)
	. = ..(mapload)

/obj/item/soulstone/on_update_icon()
	cut_overlays()
	if(full == SOULSTONE_ESSENCE)
		add_overlay("[icon_state]-glow")
	else if(full == SOULSTONE_CRACKED)
		SetName("cracked soulstone")

/obj/item/soulstone/shatter()
	playsound(loc, "shatter", 70, 1)
	qdel(src)

/obj/item/soulstone/full
	full = SOULSTONE_ESSENCE

/obj/item/soulstone/Destroy()
	QDEL_NULL(shade)
	return ..()

/obj/item/soulstone/examine(mob/user)
	. = ..()
	if(full == SOULSTONE_EMPTY)
		to_chat(user, "The shard still flickers with a fraction of the full artifact's power, but it needs to be filled with the essence of someone's life before it can be used.")
	if(full == SOULSTONE_ESSENCE)
		to_chat(user,"The shard has gone transparent, a seeming window into a dimension of unspeakable horror.")
	if(full == SOULSTONE_CRACKED)
		to_chat(user, "This one is cracked and useless.")

/obj/item/soulstone/attackby(var/obj/item/I, var/mob/user)
	..()
	if(is_evil && istype(I, /obj/item/nullrod))
		to_chat(user, "<span class='notice'>You cleanse \the [src] of taint, purging its shackles to its creator..</span>")
		is_evil = 0
		return
	if(I.force >= 5)
		if(full != SOULSTONE_CRACKED)
			user.visible_message("<span class='warning'>\The [user] hits \the [src] with \the [I], and it breaks.[shade.client ? " You hear a terrible scream!" : ""]</span>", "<span class='warning'>You hit \the [src] with \the [I], and it cracks.[shade.client ? " You hear a terrible scream!" : ""]</span>", shade.client ? "You hear a scream." : null)
			playsound(loc, 'sound/effects/Glasshit.ogg', 75)
			set_full(SOULSTONE_CRACKED)
		else
			user.visible_message("<span class='danger'>\The [user] shatters \the [src] with \the [I]!</span>")
			shatter()

/obj/item/soulstone/attack(var/mob/living/simple_animal/M, var/mob/user)
	if(M == shade)
		to_chat(user, "<span class='notice'>You recapture \the [M].</span>")
		M.forceMove(src)
		return
	if(full == SOULSTONE_ESSENCE)
		to_chat(user, "<span class='notice'>\The [src] is already full.</span>")
		return
	if(M.stat != DEAD && !M.is_asystole())
		to_chat(user, "<span class='notice'>Kill or maim the victim first.</span>")
		return
	for(var/obj/item/W in M)
		M.drop_from_inventory(W)
	M.dust()
	set_full(SOULSTONE_ESSENCE)

/obj/item/soulstone/attack_self(var/mob/user)
	if(full != SOULSTONE_ESSENCE) // No essence - no shade
		to_chat(user, "<span class='notice'>This [src] has no life essence.</span>")
		return

	if(!shade.key) // No key = hasn't been used
		to_chat(user, "<span class='notice'>You cut your finger and let the blood drip on \the [src].</span>")
		user.remove_blood_simple(1)
		var/decl/ghosttrap/S = decls_repository.get_decl(/decl/ghosttrap/cult_shade)
		S.request_player(shade, "The soul stone shade summon ritual has been performed. ")
	else if(!shade.client) // Has a key but no client - shade logged out
		to_chat(user, "<span class='notice'>\The [shade] in \the [src] is dormant.</span>")
		return
	else if(shade.loc == src)
		var/choice = alert("Would you like to invoke the spirit within?",,"Yes","No")
		if(choice == "Yes")
			shade.dropInto(loc)
			to_chat(user, "<span class='notice'>You summon \the [shade].</span>")
		if(choice == "No")
			return

/obj/item/soulstone/proc/set_full(var/f)
	full = f
	update_icon()

/obj/structure/constructshell
	name = "empty shell"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "construct"
	desc = "A wicked machine used by those skilled in magical arts. It is inactive."

/obj/structure/constructshell/cult
	icon_state = "construct-cult"
	desc = "This eerie contraption looks like it would come alive if supplied with a missing ingredient."

/obj/structure/constructshell/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/soulstone))
		var/obj/item/soulstone/S = I
		if(!S.shade.client)
			to_chat(user, "<span class='notice'>\The [I] has essence, but no soul. Activate it in your hand to find a soul for it first.</span>")
			return
		if(S.shade.loc != S)
			to_chat(user, "<span class='notice'>Recapture the shade back into \the [I] first.</span>")
			return
		var/construct = alert(user, "Please choose which type of construct you wish to create.",,"Artificer", "Wraith", "Juggernaut")
		var/ctype
		switch(construct)
			if("Artificer")
				ctype = /mob/living/simple_animal/construct/builder
			if("Wraith")
				ctype = /mob/living/simple_animal/construct/wraith
			if("Juggernaut")
				ctype = /mob/living/simple_animal/construct/armoured
		var/mob/living/simple_animal/construct/C = new ctype(get_turf(src))
		C.key = S.shade.key
		//C.cancel_camera()
		if(S.is_evil)
			var/decl/special_role/cult = decls_repository.get_decl(/decl/special_role/cultist)
			cult.add_antagonist(C.mind)
		qdel(S)
		qdel(src)

/obj/structure/constructshell/get_artifact_scan_data()
	return "Tribal idol - subject resembles statues/emblems built by superstitious pre-warp civilisations to honour their gods. Material appears to be a rock/plastcrete composite."

#undef SOULSTONE_CRACKED
#undef SOULSTONE_EMPTY
#undef SOULSTONE_ESSENCE
