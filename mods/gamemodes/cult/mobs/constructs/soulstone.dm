#define SOULSTONE_CRACKED -1
#define SOULSTONE_EMPTY 0
#define SOULSTONE_ESSENCE 1

/obj/item/soulstone
	name = "soul stone shard"
	icon = 'icons/obj/items/soulstone.dmi'
	icon_state = ICON_STATE_WORLD
	desc = "A strange, ridged chunk of some glassy red material. Achingly cold to the touch."
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_LOWER_BODY
	origin_tech = @'{"wormholes":4,"materials":4}'
	material = /decl/material/solid/gemstone/crystal
	var/full = SOULSTONE_EMPTY
	var/is_evil = 1
	var/mob/living/simple_animal/shade = null

/obj/item/soulstone/Initialize(var/mapload)
	shade = new /mob/living/simple_animal/shade(src)
	. = ..(mapload)

/obj/item/soulstone/on_update_icon()
	. = ..()
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
		to_chat(user, SPAN_NOTICE("You cleanse \the [src] of taint, purging its shackles to its creator."))
		is_evil = 0
		return
	if(I.get_attack_force(user) >= 5)
		if(full != SOULSTONE_CRACKED)
			user.visible_message(
				SPAN_WARNING("\The [user] hits \the [src] with \the [I], and it breaks.[shade.client ? " You hear a terrible scream!" : ""]"),
				SPAN_WARNING("You hit \the [src] with \the [I], and it cracks.[shade.client ? " You hear a terrible scream!" : ""]"),
				shade.client ? SPAN_NOTICE("You hear a scream.") : null)
			playsound(loc, 'sound/effects/Glasshit.ogg', 75)
			set_full(SOULSTONE_CRACKED)
		else
			user.visible_message(SPAN_DANGER("\The [user] shatters \the [src] with \the [I]!"))
			shatter()

/obj/item/soulstone/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(target == shade)
		to_chat(user, SPAN_NOTICE("You recapture \the [target]."))
		target.forceMove(src)
		return TRUE
	if(full == SOULSTONE_ESSENCE)
		to_chat(user, SPAN_NOTICE("\The [src] is already full."))
		return TRUE
	if(target.stat != DEAD && !target.is_asystole())
		to_chat(user, SPAN_NOTICE("Kill or maim the victim first."))
		return TRUE
	for(var/obj/item/thing in target)
		target.drop_from_inventory(thing)
	target.dust()
	set_full(SOULSTONE_ESSENCE)
	return TRUE

/obj/item/soulstone/attack_self(var/mob/user)
	if(full != SOULSTONE_ESSENCE) // No essence - no shade
		to_chat(user, SPAN_NOTICE("This [src] has no life essence."))
		return

	if(!shade.key) // No key = hasn't been used
		to_chat(user, SPAN_NOTICE("You cut your finger and let the blood drip on \the [src]."))
		user.remove_blood(1, absolute = TRUE)
		var/decl/ghosttrap/S = GET_DECL(/decl/ghosttrap/cult_shade)
		S.request_player(shade, "The soul stone shade summon ritual has been performed. ")
	else if(!shade.client) // Has a key but no client - shade logged out
		to_chat(user, SPAN_NOTICE("\The [shade] in \the [src] is dormant."))
		return
	else if(shade.loc == src)
		var/choice = alert("Would you like to invoke the spirit within?",,"Yes","No")
		if(choice == "Yes")
			shade.dropInto(loc)
			to_chat(user, SPAN_NOTICE("You summon \the [shade]."))
		if(choice == "No")
			return

/obj/item/soulstone/proc/set_full(var/f)
	full = f
	update_icon()

/obj/structure/constructshell
	name = "empty shell"
	icon = 'icons/obj/structures/construct.dmi'
	icon_state = "construct"
	desc = "A wicked machine used by those skilled in magical arts. It is inactive."

/obj/structure/constructshell/cult
	icon_state = "construct-cult"
	desc = "This eerie contraption looks like it would come alive if supplied with a missing ingredient."

/obj/structure/constructshell/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/soulstone))
		var/obj/item/soulstone/S = I
		if(!S.shade.client)
			to_chat(user, SPAN_NOTICE("\The [I] has essence, but no soul. Activate it in your hand to find a soul for it first."))
			return
		if(S.shade.loc != S)
			to_chat(user, SPAN_NOTICE("Recapture the shade back into \the [I] first."))
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
			var/decl/special_role/cult = GET_DECL(/decl/special_role/cultist)
			cult.add_antagonist(C.mind)
		qdel(S)
		qdel(src)

/obj/structure/constructshell/get_artifact_scan_data()
	return "Tribal idol - subject resembles statues/emblems built by superstitious pre-warp civilisations to honour their gods. Material appears to be a rock/plastcrete composite."

#undef SOULSTONE_CRACKED
#undef SOULSTONE_EMPTY
#undef SOULSTONE_ESSENCE
