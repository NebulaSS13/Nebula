/obj/structure/rubble
	name = "pile of rubble"
	desc = "One man's garbage is another man's treasure."
	icon = 'icons/obj/structures/rubble.dmi'
	icon_state = "base"
	opacity = TRUE
	density = TRUE
	anchored = TRUE
	max_health = 50

	var/list/loot = list(
		/obj/item/cell,
		/obj/item/stack/material/ingot/mapped/iron,
		/obj/item/stack/material/rods
	)
	var/lootleft = 1
	var/emptyprob = 95
	var/is_rummaging = 0

/obj/structure/rubble/Initialize()
	. = ..()
	if(prob(emptyprob))
		lootleft = 0
	update_icon()

/obj/structure/rubble/on_update_icon()
	..()
	for(var/i = 1 to 7)
		var/image/overlay_image = image(icon,"rubble[rand(1,76)]")
		if(prob(10))
			var/atom/A = pick(loot)
			if(initial(A.icon) && initial(A.icon_state))
				overlay_image.icon = initial(A.icon)
				overlay_image.icon_state = initial(A.icon_state)
				overlay_image.color = initial(A.color)
			if(!lootleft)
				overlay_image.color = "#54362e"
		overlay_image.pixel_x = rand(-16,16)
		overlay_image.pixel_y = rand(-16,16)
		var/matrix/M = matrix()
		M.Turn(rand(0,360))
		overlay_image.transform = M
		add_overlay(overlay_image)

	if(lootleft)
		add_overlay("twinkle[rand(1,3)]")

/obj/structure/rubble/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()
	if(!is_rummaging)
		if(!lootleft)
			to_chat(user, SPAN_NOTICE("There's nothing left in this one but unusable garbage..."))
			return TRUE
		visible_message(SPAN_NOTICE("\The [user] starts rummaging through \the [src]."))
		is_rummaging = TRUE
		if(do_after(user, 30))
			var/obj/item/booty = pickweight(loot)
			booty = new booty(loc)
			lootleft--
			update_icon()
			to_chat(user, SPAN_NOTICE("You find something and pull it carefully out of \the [src]."))
		is_rummaging = FALSE
	else
		to_chat(user, SPAN_WARNING("Someone is already rummaging here!"))
	return TRUE

/obj/structure/rubble/attackby(var/obj/item/used_item, var/mob/user)
	if(used_item.do_tool_interaction(TOOL_PICK, user, used_item, 3 SECONDS, set_cooldown = TRUE))
		if(lootleft && prob(1))
			var/obj/item/booty = pickweight(loot)
			booty = new booty(loc)
		qdel(src)
		return TRUE
	. = ..()

/obj/structure/rubble/dismantle_structure(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	qdel(src)
	. = TRUE

/obj/structure/rubble/physically_destroyed(var/skip_qdel)
	SHOULD_CALL_PARENT(FALSE)
	visible_message(SPAN_NOTICE("\The [src] is cleared away."))
	qdel(src)
	. = TRUE

/obj/structure/rubble/house
	loot = list(
		/obj/random/archaeological_find/house,
		/obj/random/archaeological_find/construction = 2
	)

/obj/structure/rubble/lab
	emptyprob = 30
	loot = list(
		/obj/random/archaeological_find/lab,
		/obj/random/archaeological_find/construction = 6
	)

/obj/structure/rubble/war
	emptyprob = 95 //can't have piles upon piles of guns
	loot = list(
		/obj/random/archaeological_find/blade,
		/obj/random/archaeological_find/gun
	)