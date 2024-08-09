/mob/living/bot/floorbot
	name = "Floorbot"
	desc = "A little floor repairing robot, he looks so excited!"
	icon = 'icons/mob/bot/floorbot.dmi'
	icon_state = "floorbot0"
	req_access = list(list(access_construction, access_robotics))
	wait_if_pulled = 1
	ai = /datum/mob_controller/bot/floor

	var/amount = 10 // 1 for tile, 2 for lattice
	var/maxAmount = 60
	var/tilemake = 0 // When it reaches 100, bot makes a tile
	var/improvefloors = 0
	var/eattiles = 0
	var/maketiles = 0
	var/floor_build_type = /decl/flooring/tiling // Basic steel floor.
	var/boxtype = "blue"

/mob/living/bot/floorbot/premade
	name = "Rusty"
	boxtype = "yellow"
	on = 0

/mob/living/bot/floorbot/Initialize()
	. = ..()
	var/image/B = image(src, boxtype)
	src.underlays += B

/mob/living/bot/floorbot/handle_living_non_stasis_processes()
	. = ..()
	if(stat == DEAD)
		return
	tilemake++
	if(tilemake >= 100)
		tilemake = 0
		addTiles(1)
	if(prob(1))
		custom_emote(AUDIBLE_MESSAGE, "makes an excited booping beeping sound!")

/mob/living/bot/floorbot/on_update_icon()
	..()
	if(ai?.get_stance() == STANCE_BUSY)
		icon_state = "floorbot-c"
	else if(amount > 0)
		icon_state = "floorbot[on]"
	else
		icon_state = "floorbot[on]e"

/mob/living/bot/floorbot/GetInteractTitle()
	. = "<head><title>Repairbot v1.0 controls</title></head>"
	. += "<b>Automatic Floor Repairer v1.0</b>"

/mob/living/bot/floorbot/GetInteractStatus()
	. = ..()
	. += "<br>Tiles left: [amount]"

/mob/living/bot/floorbot/GetInteractPanel()
	. = "Improves floors: <a href='byond://?src=\ref[src];command=improve'>[improvefloors ? "Yes" : "No"]</a>"
	. += "<br>Finds tiles: <a href='byond://?src=\ref[src];command=tiles'>[eattiles ? "Yes" : "No"]</a>"
	. += "<br>Make single pieces of metal into tiles when empty: <a href='byond://?src=\ref[src];command=make'>[maketiles ? "Yes" : "No"]</a>"

/mob/living/bot/floorbot/GetInteractMaintenance()
	. = "Disassembly mode: "
	switch(emagged)
		if(0)
			. += "<a href='byond://?src=\ref[src];command=emag'>Off</a>"
		if(1)
			. += "<a href='byond://?src=\ref[src];command=emag'>On (Caution)</a>"
		if(2)
			. += "ERROROROROROR-----"

/mob/living/bot/floorbot/ProcessCommand(var/mob/user, var/command, var/href_list)
	..()
	if(CanAccessPanel(user))
		switch(command)
			if("improve")
				improvefloors = !improvefloors
			if("tiles")
				eattiles = !eattiles
			if("make")
				maketiles = !maketiles

	if(CanAccessMaintenance(user))
		switch(command)
			if("emag")
				if(emagged < 2)
					emagged = !emagged

/mob/living/bot/floorbot/emag_act(var/remaining_charges, var/mob/user)
	. = ..()
	if(!emagged)
		emagged = 1
		if(user)
			to_chat(user, "<span class='notice'>\The [src] buzzes and beeps.</span>")
		return 1

/mob/living/bot/floorbot/UnarmedAttack(var/atom/A, var/proximity)

	. = ..()
	if(.)
		return

	if(ai?.get_stance() == STANCE_BUSY)
		return TRUE

	if(get_turf(A) != loc)
		return FALSE

	if(emagged && istype(A, /turf/floor))
		var/turf/floor/F = A
		ai?.set_stance(STANCE_BUSY)
		update_icon()
		if(F.has_flooring())
			visible_message("<span class='warning'>[src] begins to tear up \the [F].</span>")
			if(do_after(src, 50, F))
				F.break_tile_to_plating()
				addTiles(1)
		else
			visible_message("<span class='danger'>[src] begins to tear through the floor!</span>")
			if(do_after(src, 150, F)) // Extra time because this can and will kill.
				F.physically_destroyed()
				addTiles(1)
		ai?.set_target(null)
		update_icon()
	else if(istype(A, /turf/floor))
		var/turf/floor/F = A
		if(F.is_floor_damaged())
			ai?.set_stance(STANCE_BUSY)
			update_icon()
			visible_message("<span class='notice'>[src] begins to remove the broken floor.</span>")
			anchored = TRUE
			if(do_after(src, 50, F))
				if(F.is_floor_damaged())
					F.set_flooring(null)
			anchored = FALSE
			ai?.set_target(null)
			ai?.set_stance(STANCE_IDLE)
			update_icon()
		else if(!F.has_flooring() && amount)
			ai?.set_stance(STANCE_BUSY)
			update_icon()
			visible_message("<span class='notice'>[src] begins to improve the floor.</span>")
			anchored = TRUE
			if(do_after(src, 50, F))
				if(!F.has_flooring())
					F.set_flooring(GET_DECL(floor_build_type))
					addTiles(-1)
			anchored = FALSE
			ai?.set_target(null)
			update_icon()
	else if(istype(A, /obj/item/stack/tile/floor) && amount < maxAmount)
		var/obj/item/stack/tile/floor/T = A
		visible_message("<span class='notice'>\The [src] begins to collect tiles.</span>")
		ai?.set_stance(STANCE_BUSY)
		update_icon()
		anchored = TRUE
		if(do_after(src, 20))
			if(T)
				var/eaten = min(maxAmount - amount, T.get_amount())
				T.use(eaten)
				addTiles(eaten)
		anchored = FALSE
		ai?.set_target(null)
		update_icon()
	else if(istype(A, /obj/item/stack/material) && amount + 4 <= maxAmount)
		var/obj/item/stack/material/M = A
		if(M.get_material_type() == /decl/material/solid/metal/steel)
			visible_message("<span class='notice'>\The [src] begins to make tiles.</span>")
			ai?.set_stance(STANCE_BUSY)
			anchored = TRUE
			update_icon()
			if(do_after(src, 50))
				if(M)
					M.use(1)
					addTiles(4)
			anchored = FALSE
	return TRUE

/mob/living/bot/floorbot/gib(do_gibs = TRUE)
	var/turf/my_turf = get_turf(src)
	. = ..()
	if(. && my_turf)
		var/list/things = list()
		for(var/atom/A in orange(5, src.loc))
			things += A
		var/list/shrapnel = list()
		for(var/I = 3, I<3 , I++) //Toolbox shatters.
			shrapnel += new /obj/item/shard/shrapnel(my_turf)
		for(var/Amt = amount, Amt>0, Amt--) //Why not just spit them out in a disorganized jumble?
			shrapnel += new /obj/item/stack/tile/floor(my_turf)
		if(prob(50))
			shrapnel += new /obj/item/robot_parts/l_arm(my_turf)
		shrapnel += new /obj/item/assembly/prox_sensor(my_turf)
		for(var/atom/movable/AM in shrapnel)
			AM.throw_at(pick(things),5)

/mob/living/bot/floorbot/proc/addTiles(var/am)
	amount += am
	if(amount < 0)
		amount = 0
	else if(amount > maxAmount)
		amount = maxAmount
	ai?.set_stance(STANCE_IDLE)
