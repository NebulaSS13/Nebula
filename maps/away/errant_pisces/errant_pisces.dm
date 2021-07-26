#include "../../../mods/content/corporate/_corporate.dme"
#include "errant_pisces_areas.dm"

/obj/effect/overmap/visitable/ship/errant_pisces
	name = "CV Ahab's Harpoon"
	desc = "Sensors detect civilian vessel with unusual signs of life aboard."
	color = "#bd6100"
	max_speed = 1/(3 SECONDS)
	instant_contact = TRUE
	burn_delay = 15 SECONDS
	fore_dir = SOUTH

/datum/map_template/ruin/away_site/errant_pisces
	name = "Errant Pisces"
	id = "awaysite_errant_pisces"
	description = "Carp trawler"
	suffixes = list("errant_pisces/errant_pisces.dmm")
	cost = 1
	area_usage_test_exempted_root_areas = list(/area/errant_pisces)

/mob/living/simple_animal/hostile/carp/shark // generally stronger version of a carp that doesn't die from a mean look. Fance new sprites included, credits to F-Tang Steve
	name = "cosmoshark"
	desc = "Enormous creature that resembles a shark with magenta glowing lines along its body and set of long deep-purple teeth."
	icon = 'maps/away/errant_pisces/icons/cosmoshark.dmi'
	icon_state = "shark"
	icon_living = "shark"
	icon_dead = "shark_dead"
	icon_gib = "shark_dead"
	turns_per_move = 5
	meat_type = /obj/item/chems/food/sharkmeat
	speed = 2
	maxHealth = 100
	health = 100
	natural_weapon = /obj/item/natural_weapon/bite/strong
	break_stuff_probability = 35
	faction = "shark"

/mob/living/simple_animal/hostile/carp/shark/carp_randomify()
	return

/mob/living/simple_animal/hostile/carp/shark/on_update_icon()
	SHOULD_CALL_PARENT(FALSE)
	return

/mob/living/simple_animal/hostile/carp/shark/death()
	..()
	var/datum/gas_mixture/environment = loc.return_air()
	if (environment)
		var/datum/gas_mixture/sharkmaw_chlorine = new
		sharkmaw_chlorine.adjust_gas(/decl/material/gas/chlorine, 10)
		environment.merge(sharkmaw_chlorine)
		visible_message(SPAN_WARNING("\The [src]'s body releases some gas from the gills with a quiet fizz!"))

/mob/living/simple_animal/hostile/carp/shark/AttackingTarget()
	set waitfor = 0//to deal with sleep() possibly stalling other procs
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(25))//if one is unlucky enough, they get tackled few tiles away
			L.visible_message("<span class='danger'>\The [src] tackles [L]!</span>")
			var/tackle_length = rand(3,5)
			for (var/i = 1 to tackle_length)
				var/turf/T = get_step(L.loc, dir)//on a first step of tackling standing mob would block movement so let's check if there's something behind it. Works for consequent moves too
				if (T.density || LinkBlocked(L.loc, T) || TurfBlockedNonWindow(T) || DirBlocked(T, global.flip_dir[dir]))
					break
				sleep(2)
				forceMove(T)//maybe there's better manner then just forceMove() them
				L.forceMove(T)
			visible_message("<span class='danger'>\The [src] releases [L].</span>")

/obj/item/chems/food/sharkmeat
	name = "cosmoshark fillet"
	desc = "A fillet of cosmoshark meat."
	icon_state = "fishfillet"
	filling_color = "#cecece"
	center_of_mass = @"{'x':17,'y':13}"

/obj/item/chems/food/sharkmeat/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 5)
	reagents.add_reagent(/decl/material/liquid/psychoactives, 1)
	reagents.add_reagent(/decl/material/gas/chlorine, 1)
	src.bitesize = 8


/obj/structure/net//if you want to have fun, make them to be draggable as a whole unless at least one piece is attached to a non-space turf or anchored object
	name = "industrial net"
	desc = "A sturdy industrial net of synthetic belts reinforced with plasteel threads."
	icon = 'maps/away/errant_pisces/icons/net.dmi'
	icon_state = "net_f"
	anchored = 1
	layer = CATWALK_LAYER//probably? Should cover cables, pipes and the rest of objects that are secured on the floor
	maxhealth = 100

/obj/structure/net/Initialize(var/mapload)
	. = ..()
	update_connections()
	if (!mapload)//if it's not mapped object but rather created during round, we should update visuals of adjacent net objects
		var/turf/T = get_turf(src)
		for (var/turf/AT in T.CardinalTurfs(FALSE))
			for (var/obj/structure/net/N in AT)
				if (type != N.type)//net-walls cause update for net-walls and floors for floors but not for each other
					continue
				N.update_connections()

/obj/structure/net/show_examined_damage(mob/user, var/perc)
	if(maxhealth == -1)
		return
	if(perc >= 1)
		to_chat(user, SPAN_NOTICE("It looks fully intact."))
	else if (perc < 0.2)
		to_chat(perc, SPAN_DANGER("\The [src] is barely hanging on by the last few threads."))
	else if (perc < 0.5)
		to_chat(user, SPAN_WARNING("Large swathes of \the [src] have been cut."))
	else if (perc < 0.9)
		to_chat(user, SPAN_NOTICE("A few strands of \the [src] have been severed."))

/obj/structure/net/attackby(obj/item/W, mob/user)
	if(W.sharp || W.edge)
		var/obj/item/SH = W
		if (!(SH.sharp) || (SH.sharp && SH.force < 10))//is not sharp enough or at all
			to_chat(user,"<span class='warning'>You can't cut throught \the [src] with \the [W], it's too dull.</span>")
			return
		visible_message("<span class='warning'>[user] starts to cut through \the [src] with \the [W]!</span>")
		while(health > 0 && !QDELETED(src) && !QDELETED(user))
			if (!do_after(user, 20, src))
				visible_message("<span class='warning'>[user] stops cutting through \the [src] with \the [W]!</span>")
				return
			take_damage(20 * (1 + (SH.force-10)/10)) //the sharper the faster, every point of force above 10 adds 10 % to damage
		new /obj/item/stack/net(src.loc)
		qdel(src)
		return TRUE
	. = ..()

/obj/structure/net/physically_destroyed(var/skip_qdel)
	SHOULD_CALL_PARENT(FALSE)
	visible_message("<span class='warning'>\The [src] is torn apart!</span>")
	qdel(src)
	. = TRUE

/obj/structure/net/bullet_act(obj/item/projectile/P)
	. = PROJECTILE_CONTINUE //few cloth ribbons won't stop bullet or energy ray
	if(P.damage_type != BURN)//beams, lasers, fire. Bullets won't make a lot of damage to the few hanging belts.
		return
	visible_message("<span class='warning'>\The [P] hits \the [src] and tears it!</span>")
	take_damage(P.damage)

/obj/structure/net/update_connections()//maybe this should also be called when any of the walls nearby is removed but no idea how I can make it happen
	overlays.Cut()
	var/turf/T = get_turf(src)
	for (var/turf/AT in T.CardinalTurfs(FALSE))
		if((locate(/obj/structure/net) in AT) || (locate(/obj/structure/lattice) in AT))//connects to another net objects or walls/floors or lattices
			var/image/I = image(icon,"[icon_state]_ol_[get_dir(src,AT)]")
			overlays += I

/obj/structure/net/net_wall
	icon_state = "net_w"
	density = 1
	layer = ABOVE_HUMAN_LAYER

/obj/structure/net/net_wall/Initialize(var/mapload)
	. = ..()
	if (mapload)//if it's pre-mapped, it should put floor-net below itself
		var/turf/T = get_turf(src)
		for (var/obj/structure/net/N in T)
			if (N.type != /obj/structure/net/net_wall)//if there's net that is not a net-wall, we don't need to spawn it
				return
		new /obj/structure/net(T)


/obj/structure/net/net_wall/update_connections()//this is different for net-walls because they only connect to walls and net-walls
	overlays.Cut()
	var/turf/T = get_turf(src)
	for (var/turf/AT in T.CardinalTurfs(FALSE))
		if ((locate(/obj/structure/net/net_wall) in AT) || istype(AT, /turf/simulated/wall)  || istype(AT, /turf/unsimulated/wall))//connects to another net-wall objects or walls
			var/image/I = image(icon,"[icon_state]_ol_[get_dir(src,AT)]")
			overlays += I

/obj/item/stack/net
	name = "industrial net roll"
	desc = "Sturdy industrial net reinforced with plasteel threads."
	icon = 'maps/away/errant_pisces/icons/net_roll.dmi'
	icon_state = "net_roll"
	w_class = ITEM_SIZE_LARGE
	force = 3.0
	throwforce = 5.0
	throw_speed = 5
	throw_range = 10
	matter = list("cloth" = 1875, "plasteel" = 350)
	max_amount = 30
	center_of_mass = null
	attack_verb = list("hit", "bludgeoned", "whacked")
	lock_picking_level = 3

/obj/item/stack/net/Initialize()
	. = ..()
	update_icon()

/obj/item/stack/net/thirty
	amount = 30

/obj/item/stack/net/on_update_icon()
	if(amount == 1)
		icon_state = "net"
	else
		icon_state = "net_roll"

/obj/item/stack/net/proc/attach_wall_check()//checks if wall can be attached to something vertical such as walls or another net-wall
	if (!has_gravity())
		return 1
	var/turf/T = get_turf(src)
	for (var/turf/AT in T.CardinalTurfs(FALSE))
		if ((locate(/obj/structure/net/net_wall) in AT) || istype(AT, /turf/simulated/wall)  || istype(AT, /turf/unsimulated/wall))//connects to another net-wall objects or walls
			return 1
	return 0

/obj/item/stack/net/attack_self(mob/user)//press while holding to lay one. If there's net already, place wall
	var/turf/T = get_turf(user)
	if (locate(/obj/structure/net/net_wall) in T)
		to_chat(user, "<span class='warning'>Net wall is already placed here!</span>")
		return
	if (locate(/obj/structure/net) in T)//if there's already layed "floor" net
		if (!attach_wall_check())
			to_chat(user, "<span class='warning'>You try to place net wall but it falls on the floor. Try to attach it to something vertical and stable.</span>")
			return
		new /obj/structure/net/net_wall(T)
		//update_adjacent_nets(1)//since net-wall was added we also update adjacent wall-nets
	else
		new /obj/structure/net(T)
		//update_adjacent_nets(0)
	amount -= 1
	update_icon()
	if (amount < 1)
		qdel(src)

/obj/item/clothing/under/carp //as far as I know sprites are taken from /tg/
	name = "space carp suit"
	desc = "A suit in a shape of a space carp. Usually worn by corporate interns who are sent to entertain children during HQ excursions."
	icon = 'maps/away/errant_pisces/icons/carpsuit.dmi'

/obj/effect/landmark/corpse/carp_fisher
	name = "carp fisher"
	corpse_outfits = list(/decl/hierarchy/outfit/corpse/carp_fisher)

/decl/hierarchy/outfit/corpse/carp_fisher
	name = "Dead carp fisher"
	uniform = /obj/item/clothing/under/color/green
	suit = /obj/item/clothing/suit/apron/overalls
	belt = /obj/item/knife/combat
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/hardhat/dblue
