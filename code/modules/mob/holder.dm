var/global/list/holder_mob_icon_cache = list()

//Helper object for picking creatures up.
/obj/item/holder
	name = "holder"
	desc = "You shouldn't ever see this."
	icon = 'icons/obj/objects.dmi'
	slot_flags = SLOT_HEAD | SLOT_HOLSTER
	origin_tech = null
	pixel_y = 8
	origin_tech = "{'biotech':1}"
	var/last_holder

/obj/item/holder/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/holder/proc/destroy_all()
	for(var/atom/movable/AM in src)
		qdel(AM)
	qdel(src)

/obj/item/holder/physically_destroyed()
	SHOULD_CALL_PARENT(FALSE)
	destroy_all()

/obj/item/holder/Destroy()
	for(var/atom/movable/AM in src)
		unregister_all_movement(last_holder, AM)
		AM.forceMove(get_turf(src))
	last_holder = null
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/holder/Process()
	update_state()

/obj/item/holder/dropped()
	..()
	update_state(1)

/obj/item/holder/throw_impact(atom/hit_atom, datum/thrownthing/TT)
	..()
	update_state(1)

/obj/item/holder/proc/update_state(var/delay)
	set waitfor = 0

	for(var/mob/M in contents)
		unregister_all_movement(last_holder, M)

	if(delay)
		sleep(delay)

	if(QDELETED(src) || throwing)
		return

	if(istype(loc,/turf) || !contents.len)
		for(var/mob/M in contents)
			var/atom/movable/mob_container = M
			mob_container.dropInto(loc)
			M.reset_view()
		qdel(src)
	else if(last_holder != loc)
		for(var/mob/M in contents)
			register_all_movement(loc, M)

	last_holder = loc

/obj/item/holder/onDropInto(var/atom/movable/AM)
	if(ismob(loc))   // Bypass our holding mob and drop directly to its loc
		return loc.loc
	return ..()

/obj/item/holder/GetIdCard()
	for(var/mob/M in contents)
		var/obj/item/I = M.GetIdCard()
		if(I)
			return I
	return null

/obj/item/holder/GetAccess()
	var/obj/item/I = GetIdCard()
	return I ? I.GetAccess() : ..()

/obj/item/holder/attack_self()
	for(var/mob/M in contents)
		M.show_inv(usr)

/obj/item/holder/attack(mob/target, mob/user)
	// Devour on click on self with holder
	if(target == user && istype(user,/mob/living/carbon))
		var/mob/living/carbon/M = user

		for(var/mob/victim in src.contents)
			M.devour(victim)

		update_state()

	..()

var/global/list/holder_mob_icons = list(
	"repairbot" =         'icons/clothing/holders/holder_repairbot.dmi',
	"constructiondrone" = 'icons/clothing/holders/holder_constructiondrone.dmi',
	"mouse_brown" =       'icons/clothing/holders/holder_mouse_brown.dmi',
	"mouse_gray" =        'icons/clothing/holders/holder_mouse_gray.dmi',
	"mouse_white" =       'icons/clothing/holders/holder_mouse_white.dmi',
	"pai-repairbot" =     'icons/clothing/holders/holder_pai_repairbot.dmi',
	"pai-monkey" =        'icons/clothing/holders/holder_pai_monkey.dmi',
	"pai-rabbit" =        'icons/clothing/holders/holder_pai_rabbit.dmi',
	"pai-mouse" =         'icons/clothing/holders/holder_pai_mouse.dmi',
	"pai-crow" =          'icons/clothing/holders/holder_pai_crow.dmi',
	"monkey" =            'icons/clothing/holders/holder_monkey.dmi',
	"kitten" =            'icons/clothing/holders/holder_kitten.dmi',
	"cat" =               'icons/clothing/holders/holder_cat.dmi',
	"cat2" =              'icons/clothing/holders/holder_cat2.dmi',
	"cat3" =              'icons/clothing/holders/holder_cat3.dmi',
	"corgi" =             'icons/clothing/holders/holder_corgi.dmi',
	"possum" =            'icons/clothing/holders/holder_possum.dmi',
	"poppy" =             'icons/clothing/holders/holder_poppy.dmi'
)

/obj/item/holder/proc/sync(var/mob/living/M)

	set_dir(SOUTH)
	overlays.Cut()

	var/check_state
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		check_state = lowertext(H.species.name)
	else
		var/datum/extension/base_icon_state/bis = get_extension(M, /datum/extension/base_icon_state)
		check_state = bis?.base_icon_state || initial(M.icon_state) 

	if(check_state && global.holder_mob_icons[check_state])
		icon = global.holder_mob_icons[check_state]
		icon_state = ICON_STATE_WORLD
		item_state = null
		use_single_icon = TRUE
	else
		icon = M.icon
		icon_state = M.icon_state
		item_state = M.item_state
		overlays |= M.overlays
		use_single_icon = FALSE

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		color = H.skin_colour
	else
		color = M.color
	SetName(M.name)
	desc = M.desc

	var/mob/living/carbon/human/H = loc
	if(istype(H))
		last_holder = H
		register_all_movement(H, M)

	update_held_icon()

//Mob specific holders.
/obj/item/holder/drone
	origin_tech = "{'magnets':3,'engineering':5}"

/obj/item/holder/mouse
	w_class = ITEM_SIZE_TINY

//need own subtype to work with recipes
/obj/item/holder/corgi
	origin_tech = "{'biotech':4}"

/obj/item/holder/attackby(obj/item/W, mob/user)
	for(var/mob/M in src.contents)
		M.attackby(W,user)

//Mob procs and vars for scooping up
/mob/living/var/holder_type

/mob/living/proc/get_scooped(var/mob/living/carbon/human/grabber, var/self_grab)
	if(!holder_type || buckled || pinned.len)
		return

	if(self_grab)
		if(src.incapacitated()) return
	else
		if(grabber.incapacitated()) return

	var/obj/item/holder/H = new holder_type(get_turf(src))

	if(self_grab)
		if(!grabber.equip_to_slot_if_possible(H, slot_back_str, del_on_fail=0, disable_warning=1))
			to_chat(src, "<span class='warning'>You can't climb onto [grabber]!</span>")
			return

		to_chat(grabber, "<span class='notice'>\The [src] clambers onto you!</span>")
		to_chat(src, "<span class='notice'>You climb up onto \the [grabber]!</span>")
	else
		if(!grabber.put_in_hands(H))
			to_chat(grabber, "<span class='warning'>Your hands are full!</span>")
			return

		to_chat(grabber, "<span class='notice'>You scoop up \the [src]!</span>")
		to_chat(src, "<span class='notice'>\The [grabber] scoops you up!</span>")

	src.forceMove(H)

	grabber.status_flags |= PASSEMOTES
	H.sync(src)
	return H

/mob/living/attack_hand(mob/user)

	var/datum/extension/hattable/hattable = get_extension(src, /datum/extension/hattable)
	if(hattable && hattable.hat)
		hattable.hat.forceMove(get_turf(src))
		user.put_in_hands(hattable.hat)
		user.visible_message(SPAN_DANGER("\The [user] removes \the [src]'s [hattable.hat]!"))
		hattable.hat = null
		update_icons()
		return TRUE

	if(ishuman(user))
		var/mob/living/carbon/H = user
		if(H.a_intent == I_GRAB && scoop_check(user))
			get_scooped(user, FALSE)
			return TRUE

	. = ..()

/mob/living/proc/scoop_check(var/mob/living/scooper)
	. = TRUE

/mob/living/carbon/human/scoop_check(var/mob/living/scooper)
	. = ..() && scooper.mob_size > src.mob_size
