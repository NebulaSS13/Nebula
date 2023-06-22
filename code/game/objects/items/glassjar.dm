/obj/item/glass_jar
	name = "glass jar"
	desc = "A small empty jar."
	icon = 'icons/obj/items/jar.dmi'
	icon_state = "jar"
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/glass
	material_force_multiplier = 0.1
	item_flags = ITEM_FLAG_NO_BLUDGEON
	obj_flags = OBJ_FLAG_HOLLOW
	drop_sound = 'sound/foley/bottledrop1.ogg'
	pickup_sound = 'sound/foley/bottlepickup1.ogg'
	var/list/accept_mobs = list(
		/mob/living/simple_animal/lizard,
		/mob/living/simple_animal/mouse
	)
	var/contains = 0 // 0 = nothing, 1 = money, 2 = animal, 3 = spiderling

/obj/item/glass_jar/Initialize()
	. = ..()
	update_icon()

/obj/item/glass_jar/afterattack(var/atom/A, var/mob/user, var/proximity)
	if(!proximity || contains)
		return
	if(istype(A, /mob))
		var/accept = 0
		for(var/D in accept_mobs)
			if(istype(A, D))
				accept = 1
		if(!accept)
			to_chat(user, "[A] doesn't fit into \the [src].")
			return
		var/mob/L = A
		user.visible_message("<span class='notice'>[user] scoops [L] into \the [src].</span>", "<span class='notice'>You scoop [L] into \the [src].</span>")
		L.forceMove(src)
		contains = 2
		update_icon()
		return
	else if(istype(A, /obj/effect/spider/spiderling))
		var/obj/effect/spider/spiderling/S = A
		user.visible_message("<span class='notice'>[user] scoops [S] into \the [src].</span>", "<span class='notice'>You scoop [S] into \the [src].</span>")
		S.forceMove(src)
		STOP_PROCESSING(SSobj, S) // No growing inside jars
		contains = 3
		update_icon()
		return

/obj/item/glass_jar/attack_self(var/mob/user)
	switch(contains)
		if(1)
			for(var/obj/O in src)
				O.dropInto(user.loc)
			to_chat(user, "<span class='notice'>You take money out of \the [src].</span>")
			contains = 0
			update_icon()
			return
		if(2)
			for(var/mob/M in src)
				M.dropInto(user.loc)
				user.visible_message("<span class='notice'>[user] releases [M] from \the [src].</span>", "<span class='notice'>You release [M] from \the [src].</span>")
			contains = 0
			update_icon()
			return
		if(3)
			for(var/obj/effect/spider/spiderling/S in src)
				S.dropInto(user.loc)
				user.visible_message("<span class='notice'>[user] releases [S] from \the [src].</span>", "<span class='notice'>You release [S] from \the [src].</span>")
				START_PROCESSING(SSobj, S) // They can grow after being let out though
			contains = 0
			update_icon()
			return

/obj/item/glass_jar/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/cash))
		if(contains == 0)
			contains = 1
		if(contains != 1)
			return
		if(!user.try_unequip(W, src))
			return
		var/obj/item/cash/S = W
		user.visible_message("<span class='notice'>[user] puts \the [S] into \the [src].</span>")
		update_icon()

/obj/item/glass_jar/on_update_icon() // Also updates name and desc
	. = ..()
	underlays.Cut()
	switch(contains)
		if(0)
			SetName(initial(name))
			desc = initial(desc)
		if(1)
			SetName("tip jar")
			desc = "A small jar with money inside."
			for(var/obj/item/cash/S in src)
				var/image/cash = new
				cash.appearance = S
				cash.plane = FLOAT_PLANE
				cash.layer = FLOAT_LAYER
				cash.pixel_x = rand(-2, 3)
				cash.pixel_y = rand(-6, 6)
				var/matrix/M = cash.transform || matrix()
				M.Scale(0.6)
				cash.transform = M
				underlays += cash
		if(2)
			for(var/mob/M in src)
				var/image/victim = image(M.icon, M.icon_state)
				victim.pixel_y = 6
				underlays += victim
				SetName("glass jar with [M]")
				desc = "A small jar with [M] inside."
		if(3)
			for(var/obj/effect/spider/spiderling/S in src)
				var/image/victim = image(S.icon, S.icon_state)
				underlays += victim
				SetName("glass jar with [S]")
				desc = "A small jar with [S] inside."
	return
