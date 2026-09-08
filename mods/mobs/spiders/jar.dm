/obj/item/glass_jar/afterattack(var/atom/A, var/mob/user, var/proximity)
	if(proximity && !contains && istype(A, /obj/effect/spider/spiderling))
		var/obj/effect/spider/spiderling/S = A
		user.visible_message("<span class='notice'>[user] scoops [S] into \the [src].</span>", "<span class='notice'>You scoop [S] into \the [src].</span>")
		S.forceMove(src)
		STOP_PROCESSING(SSobj, S) // No growing inside jars
		contains = 3
		update_icon()
		return
	return ..()

/obj/item/glass_jar/on_update_icon() // Also updates name and desc
	. = ..()
	if(contains == 3)
		for(var/obj/effect/spider/spiderling/S in src)
			var/image/victim = image(S.icon, S.icon_state)
			underlays += victim
			SetName("glass jar with [S]")
			desc = "A small jar with [S] inside."

/obj/item/glass_jar/attack_self(var/mob/user)
	if(contains == 3)
		for(var/obj/effect/spider/spiderling/S in src)
			S.dropInto(user.loc)
			user.visible_message("<span class='notice'>[user] releases [S] from \the [src].</span>", "<span class='notice'>You release [S] from \the [src].</span>")
			START_PROCESSING(SSobj, S) // They can grow after being let out though
		contains = 0
		update_icon()
		return
	return ..()
