/obj/structure/displaycase
	name = "display case"
	icon = 'icons/obj/structures/displaycase.dmi'
	icon_state = "glassbox"
	desc = "A display case for prized possessions. It taunts you to kick it."
	density = 1
	anchored = 1
	unacidable = 1//Dissolving the case would also delete the gun.
	alpha = 150
	maxhealth = 100
	hitsound = 'sound/effects/Glasshit.ogg'
	var/destroyed = 0

/obj/structure/displaycase/Initialize()
	. = ..()
	var/turf/T = get_turf(src)
	for(var/atom/movable/AM in T)
		if(AM.simulated && !AM.anchored)
			AM.forceMove(src)
	update_icon()

/obj/structure/displaycase/examine(mob/user)
	. = ..()
	if(contents.len)
		to_chat(user, "Inside you see [english_list(contents)].")

/obj/structure/displaycase/explosion_act(severity)
	..()
	if(!QDELETED(src))
		if(severity == 1)
			new /obj/item/shard(loc)
			for(var/atom/movable/AM in src)
				AM.dropInto(loc)
			qdel(src)
		else if(prob(50))
			take_damage(20 - (severity * 5))

/obj/structure/displaycase/bullet_act(var/obj/item/projectile/Proj)
	..()
	take_damage(Proj.get_structure_damage())

/obj/structure/proc/subtract_matter(var/obj/subtracting)
	if(!length(matter))
		return
	if(!istype(subtracting) || !length(subtracting.matter))
		return
	for(var/mat in matter)
		if(!subtracting[mat])
			continue
		matter[mat] -= subtracting[mat]
		if(matter[mat] <= 0)
			matter -= mat
	UNSETEMPTY(matter)

/obj/structure/displaycase/dismantle()
	SHOULD_CALL_PARENT(FALSE)
	. = TRUE

/obj/structure/displaycase/physically_destroyed()
	if(destroyed)
		return
	. = ..()
	if(.)
		set_density(0)
		destroyed = TRUE
		subtract_matter(new /obj/item/shard(get_turf(src), material?.type))
		playsound(src, "shatter", 70, 1)
		update_icon()

/obj/structure/displaycase/on_update_icon()
	if(destroyed)
		icon_state = "glassboxb"
	else
		icon_state = "glassbox"
	underlays.Cut()
	for(var/atom/movable/AM in contents)
		underlays += AM.appearance

/obj/structure/displaycase/attackby(obj/item/W, mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	take_damage(W.force)
	..()

/obj/structure/displaycase/attack_hand(mob/user)
	add_fingerprint(user)
	if(!destroyed)
		to_chat(usr, text("<span class='warning'>You kick the display case.</span>"))
		visible_message("<span class='warning'>[usr] kicks the display case.</span>")
		take_damage(2)