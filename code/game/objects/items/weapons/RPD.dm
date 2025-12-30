var/global/list/rpd_pipe_selection = list()
var/global/list/rpd_pipe_selection_skilled = list()

/proc/init_rpd_lists()
	global.rpd_pipe_selection = list(
	"Regular Pipes" = list(
		new /datum/fabricator_recipe/pipe(),
		new /datum/fabricator_recipe/pipe/bent(),
		new /datum/fabricator_recipe/pipe/manifold(),
		new /datum/fabricator_recipe/pipe/manifold4w(),
		new /datum/fabricator_recipe/pipe/cap()),
	"Supply Pipes" = list(
		new /datum/fabricator_recipe/pipe/supply(),
		new /datum/fabricator_recipe/pipe/supply/bent(),
		new /datum/fabricator_recipe/pipe/supply/manifold(),
		new /datum/fabricator_recipe/pipe/supply/manifold4w(),
		new /datum/fabricator_recipe/pipe/supply/cap()),
	"Scrubber Pipes" = list(
		new /datum/fabricator_recipe/pipe/scrubber(),
		new /datum/fabricator_recipe/pipe/scrubber/bent(),
		new /datum/fabricator_recipe/pipe/scrubber/manifold(),
		new /datum/fabricator_recipe/pipe/scrubber/manifold4w(),
		new /datum/fabricator_recipe/pipe/scrubber/cap())
	)

	global.rpd_pipe_selection_skilled = list(
	"Regular Pipes" = list(
		new /datum/fabricator_recipe/pipe(),
		new /datum/fabricator_recipe/pipe/bent(),
		new /datum/fabricator_recipe/pipe/manifold(),
		new /datum/fabricator_recipe/pipe/manifold4w(),
		new /datum/fabricator_recipe/pipe/cap(),
		new /datum/fabricator_recipe/pipe/up(),
		new /datum/fabricator_recipe/pipe/down()
		),
	"Supply Pipes" = list(
		new /datum/fabricator_recipe/pipe/supply(),
		new /datum/fabricator_recipe/pipe/supply/bent(),
		new /datum/fabricator_recipe/pipe/supply/manifold(),
		new /datum/fabricator_recipe/pipe/supply/manifold4w(),
		new /datum/fabricator_recipe/pipe/supply/cap(),
		new /datum/fabricator_recipe/pipe/supply/up(),
		new /datum/fabricator_recipe/pipe/supply/down()
		),
	"Scrubber Pipes" = list(
		new /datum/fabricator_recipe/pipe/scrubber(),
		new /datum/fabricator_recipe/pipe/scrubber/bent(),
		new /datum/fabricator_recipe/pipe/scrubber/manifold(),
		new /datum/fabricator_recipe/pipe/scrubber/manifold4w(),
		new /datum/fabricator_recipe/pipe/scrubber/cap(),
		new /datum/fabricator_recipe/pipe/scrubber/up(),
		new /datum/fabricator_recipe/pipe/scrubber/down()
		),
	"Fuel Pipes" = list(
		new /datum/fabricator_recipe/pipe/fuel(),
		new /datum/fabricator_recipe/pipe/fuel/bent(),
		new /datum/fabricator_recipe/pipe/fuel/manifold(),
		new /datum/fabricator_recipe/pipe/fuel/manifold4w(),
		new /datum/fabricator_recipe/pipe/fuel/cap(),
		new /datum/fabricator_recipe/pipe/fuel/up(),
		new /datum/fabricator_recipe/pipe/fuel/down()
		)
	)

/obj/item/rpd
	name = "rapid piping device"
	desc = "Portable, complex and deceptively heavy, it's the cousin of the RCD, use to dispense piping on the move."
	icon = 'icons/obj/items/device/rpd.dmi'
	icon_state = "rpd"
	throw_speed = 1
	throw_range = 3
	w_class = ITEM_SIZE_NORMAL
	origin_tech = @'{"engineering":5,"materials":4}'
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE
	)
	_base_attack_force = 12

	var/datum/fabricator_recipe/pipe/P
	var/pipe_color = "white"
	var/datum/browser/written_digital/popup

/obj/item/rpd/Initialize()
	. = ..()
	if(!length(global.rpd_pipe_selection))
		init_rpd_lists()
	spark_at(src, amount = 5, holder = src)
	var/list/L = global.rpd_pipe_selection[global.rpd_pipe_selection[1]]
	P = L[1]

/obj/item/rpd/proc/get_console_data(var/list/pipe_categories, var/color_options = FALSE)
	. = list()
	. += "<table>"
	if(color_options)
		. += "<tr><td>Color</td><td><a href='byond://?src=\ref[src];color=\ref[src]'><font color = '[pipe_color]'>[pipe_color]</font></a></td></tr>"
	for(var/category in pipe_categories)
		. += "<tr><td><font color = '#517087'><strong>[category]</strong></font></td></tr>"
		for(var/datum/fabricator_recipe/pipe/pipe in pipe_categories[category])
			. += "<tr><td>[pipe.name]</td><td>[P.type == pipe.type ? "<span class='linkOn'>Select</span>" : "<a href='byond://?src=\ref[src];select=\ref[pipe]'>Select</a>"]</td></tr>"
	.+= "</table>"
	. = JOINTEXT(.)

/obj/item/rpd/interact(mob/user)
	popup = new (user, "Pipe List", "[src] menu")
	popup.set_content(get_console_data(user.skill_check(SKILL_ATMOS,SKILL_EXPERT) ? global.rpd_pipe_selection_skilled : global.rpd_pipe_selection, TRUE))
	popup.open()

/obj/item/rpd/OnTopic(var/user, var/list/href_list)
	if(href_list["select"])
		P = locate(href_list["select"])
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		interact(user)
		if(prob(10))
			spark_at(src, amount = 5, holder = src)
		return TOPIC_HANDLED
	if(href_list["color"])
		var/choice = input(user, "What color do you want pipes to have?") as null|anything in pipe_colors
		if(!choice || !CanPhysicallyInteract(user))
			return TOPIC_HANDLED
		pipe_color = choice
		interact(user)
		return TOPIC_HANDLED

/obj/item/rpd/dropped(mob/user)
	..()
	if(popup)
		popup.close()

/obj/item/rpd/afterattack(atom/A, mob/user, proximity)
	if(!proximity) return
	if(istype(A, /obj/item/pipe))
		recycle(A,user)
	else
		if(user.skill_fail_prob(SKILL_ATMOS, 80, SKILL_ADEPT))
			var/C = pick(global.rpd_pipe_selection)
			P = pick(global.rpd_pipe_selection[C])
			user.visible_message(SPAN_WARNING("[user] cluelessly fumbles with \the [src]."))
		var/turf/T = get_turf(A)
		if(!T.Adjacent(src.loc)) return		//checks so it can't pipe through window and such

		playsound(get_turf(user), 'sound/machines/click.ogg', 50, 1)
		if(T.is_wall())	//pipe through walls!
			if(!do_after(user, 30, T))
				return
			playsound(get_turf(user), 'sound/items/Deconstruct.ogg', 50, 1)

		P.build(T, new/datum/fabricator_build_order(P, 1, list("selected_color" = pipe_colors[pipe_color])))
		if(prob(20))
			spark_at(src, amount = 5, holder = src)

/obj/item/rpd/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1)
		if(user.skill_check(SKILL_ATMOS,SKILL_BASIC))
			. += "[SPAN_NOTICE("Current selection reads:")] [P]"
		else
			to_chat(user, SPAN_WARNING("The readout is flashing some atmospheric jargon, you can't understand."))

/obj/item/rpd/attack_self(mob/user)
	interact(user)
	add_fingerprint(user)

/obj/item/rpd/attackby(var/obj/item/used_item, var/mob/user)
	if(istype(used_item, /obj/item/pipe))
		if(!user.try_unequip(used_item))
			return TRUE
		recycle(used_item,user)
		return TRUE
	return ..()

/obj/item/rpd/proc/recycle(var/obj/item/used_item,var/mob/user)
	if(!user.skill_check(SKILL_ATMOS,SKILL_BASIC))
		user.visible_message("<b>\The [user]</b> struggles with \the [src] as they futilely jam \the [used_item] against it.")
		return
	playsound(src.loc, 'sound/effects/pop.ogg', 50, 1)
	qdel(used_item)