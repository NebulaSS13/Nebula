/obj/structure
	icon = 'icons/obj/structures/barricade.dmi'
	w_class = ITEM_SIZE_STRUCTURE
	layer = STRUCTURE_LAYER

	var/last_damage_message
	var/health = 0
	var/maxhealth = 50
	var/hitsound = 'sound/weapons/smash.ogg'
	var/breakable
	var/parts_type
	var/parts_amount
	var/footstep_type
	var/mob_offset

/obj/structure/create_matter()
	..()
	if(material || reinf_material)
		LAZYINITLIST(matter)
		var/matter_mult = get_matter_amount_modifier()
		if(material)
			matter[material.type] = max(matter[material.type], round(MATTER_AMOUNT_PRIMARY * matter_mult))
		if(reinf_material)
			matter[reinf_material.type] = max(matter[reinf_material.type], round(MATTER_AMOUNT_REINFORCEMENT * matter_mult))
		UNSETEMPTY(matter)

/obj/structure/Initialize(var/ml, var/_mat, var/_reinf_mat)
	if(ispath(_mat, /decl/material))
		material = _mat
	if(ispath(material, /decl/material))
		material = GET_DECL(material)
	if(ispath(_reinf_mat, /decl/material))
		reinf_material = _reinf_mat
	if(ispath(reinf_material, /decl/material))
		reinf_material = GET_DECL(reinf_material)
	. = ..()
	update_materials()
	if(!CanFluidPass())
		fluid_update()

/obj/structure/proc/show_examined_damage(mob/user, var/perc)
	if(maxhealth == -1)
		return
	if(perc >= 1)
		to_chat(user, SPAN_NOTICE("It looks fully intact."))
	else if(perc > 0.75)
		to_chat(user, SPAN_NOTICE("It has a few cracks."))
	else if(perc > 0.5)
		to_chat(user, SPAN_WARNING("It looks slightly damaged."))
	else if(perc > 0.25)
		to_chat(user, SPAN_WARNING("It looks moderately damaged."))
	else
		to_chat(user, SPAN_DANGER("It looks heavily damaged."))

/obj/structure/examine(mob/user, var/distance)
	. = ..()
	if(distance <= 3)

		show_examined_damage(user, (health/maxhealth))

		if(tool_interaction_flags & TOOL_INTERACTION_ANCHOR)
			if(anchored)
				to_chat(user, SPAN_SUBTLE("Can be unanchored with a wrench, and moved around."))
			else
				to_chat(user, SPAN_SUBTLE("Can be anchored in place with a wrench."))

		if(tool_interaction_flags & TOOL_INTERACTION_DECONSTRUCT)
			var/removed_with = "a crowbar"
			if(material && material.removed_by_welder)
				removed_with = "a welding torch"
			if(tool_interaction_flags & TOOL_INTERACTION_ANCHOR)
				if(anchored)
					to_chat(user, SPAN_SUBTLE("Can be deconstructed with [removed_with]."))
				else
					to_chat(user, SPAN_SUBTLE("Can be deconstructed with [removed_with], if anchored down with a wrench first."))
			else
				to_chat(user, SPAN_SUBTLE("Can be deconstructed with [removed_with]."))

		if(tool_interaction_flags & TOOL_INTERACTION_WIRING)
			if(tool_interaction_flags & TOOL_INTERACTION_ANCHOR)
				if(wired)
					if(anchored)
						to_chat(user, SPAN_SUBTLE("Can have its wiring removed with wirecutters"))
					else
						to_chat(user, SPAN_SUBTLE("Can have its wiring removed with wirecutters, if anchored down with a wrench first."))
				else
					if(anchored)
						to_chat(user, SPAN_SUBTLE("Can have wiring installed with a cable coil."))
					else
						to_chat(user, SPAN_SUBTLE("Can have wiring installed with a cable coil, if anchored down with a wrench first."))
			else
				if(wired)
					to_chat(user, SPAN_SUBTLE("Can have its wiring removed with wirecutters"))
				else
					to_chat(user, SPAN_SUBTLE("Can have wiring installed with a cable coil."))

/obj/structure/proc/mob_breakout(var/mob/living/escapee)
	set waitfor = FALSE
	return FALSE

/obj/structure/proc/is_pressurized_fluid_source()
	return FALSE

/obj/structure/proc/take_damage(var/damage)
	if(health == -1) // This object does not take damage.
		return

	if(material && material.is_brittle())
		if(reinf_material)
			if(reinf_material.is_brittle())
				damage *= STRUCTURE_BRITTLE_MATERIAL_DAMAGE_MULTIPLIER
		else
			damage *= STRUCTURE_BRITTLE_MATERIAL_DAMAGE_MULTIPLIER

	playsound(loc, hitsound, 75, 1)
	health = Clamp(health - damage, 0, maxhealth)
	
	show_damage_message(health/maxhealth)

	if(health == 0)
		physically_destroyed()

/obj/structure/proc/show_damage_message(var/perc)
	if(perc > 0.75)
		return
	if(perc <= 0.25 && last_damage_message < 0.25)
		visible_message(SPAN_DANGER("\The [src] looks like it's about to break!"))
		last_damage_message = 0.25
	else if(perc <= 0.5 && last_damage_message < 0.5)
		visible_message(SPAN_WARNING("\The [src] looks seriously damaged!"))
		last_damage_message = 0.5
	else if(perc <= 0.75 && last_damage_message < 0.75)
		visible_message(SPAN_WARNING("\The [src] is showing some damage!"))
		last_damage_message = 0.75

/obj/structure/physically_destroyed(var/skip_qdel)
	. = ..(TRUE)
	dismantle()

/obj/structure/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	. = ..()
	var/dmg = 100
	if(istype(material))
		dmg = round(dmg * material.combustion_effect(get_turf(src),temperature, 0.3))
	if(dmg)
		take_damage(dmg)

/obj/structure/Destroy()
	var/turf/T = get_turf(src)
	if(T)
		T.fluid_update()
	. = ..()
	if(T)
		for(var/atom/movable/AM in T)
			AM.reset_offsets()
			AM.reset_plane_and_layer()

/obj/structure/Crossed(O)
	. = ..()
	if(ismob(O))
		var/mob/M = O
		M.reset_offsets()
		M.reset_plane_and_layer()

/obj/structure/Uncrossed(O)
	. = ..()
	if(ismob(O))
		var/mob/M = O
		M.reset_offsets()
		M.reset_plane_and_layer()

/obj/structure/Move()
	var/turf/T = get_turf(src)
	. = ..()
	if(. && !CanFluidPass())
		fluid_update()
		if(T)
			for(var/atom/movable/AM in T)
				AM.reset_offsets()	
				AM.reset_plane_and_layer()

/obj/structure/attack_hand(mob/user)
	..()
	if(breakable)
		if(MUTATION_HULK in user.mutations)
			user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
			attack_generic(user,1,"smashes")
		else if(istype(user,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(user))
				attack_generic(user,1,"slices")
	return ..()

/obj/structure/grab_attack(var/obj/item/grab/G)
	if (!G.force_danger())
		to_chat(G.assailant, SPAN_WARNING("You need a better grip to do that!"))
		return TRUE
	var/mob/living/affecting_mob = G.get_affecting_mob()
	if(G.assailant.a_intent == I_HURT)

		if(!istype(affecting_mob))
			to_chat(G.assailant, SPAN_WARNING("You need to be grabbing a living creature to do that!"))
			return TRUE

		// Slam their face against the table.
		var/blocked = affecting_mob.get_blocked_ratio(BP_HEAD, BRUTE, damage = 8)
		if (prob(30 * (1 - blocked)))
			SET_STATUS_MAX(affecting_mob, STAT_WEAK, 5)

		affecting_mob.apply_damage(8, BRUTE, BP_HEAD)
		visible_message(SPAN_DANGER("[G.assailant] slams [affecting_mob]'s face against \the [src]!"))
		if (material)
			playsound(loc, material.tableslam_noise, 50, 1)
		else
			playsound(loc, 'sound/weapons/tablehit1.ogg', 50, 1)
		var/list/L = take_damage(rand(1,5))
		for(var/obj/item/shard/S in L)
			if(S.sharp && prob(50))
				affecting_mob.visible_message(SPAN_DANGER("\The [S] slices into [affecting_mob]'s face!"), SPAN_DANGER("\The [S] slices into your face!"))
				affecting_mob.standard_weapon_hit_effects(S, G.assailant, S.force*2, BP_HEAD)
		qdel(G)
	else if(atom_flags & ATOM_FLAG_CLIMBABLE)
		var/obj/occupied = turf_is_crowded()
		if (occupied)
			to_chat(G.assailant, SPAN_WARNING("There's \a [occupied] in the way."))
			return TRUE
		G.affecting.forceMove(src.loc)
		if(affecting_mob)
			SET_STATUS_MAX(affecting_mob, STAT_WEAK, rand(2,5))
		visible_message(SPAN_DANGER("[G.assailant] puts [G.affecting] on \the [src]."))
		qdel(G)
		return TRUE

/obj/structure/explosion_act(severity)
	..()
	if(!QDELETED(src))
		if(severity == 1)
			physically_destroyed()
		else if(severity == 2)
			take_damage(rand(20, 30))
		else
			take_damage(rand(5, 15))

/obj/structure/proc/can_repair(var/mob/user)
	if(health >= maxhealth)
		to_chat(user, SPAN_NOTICE("\The [src] does not need repairs."))
		return FALSE
	return TRUE

/obj/structure/bullet_act(var/obj/item/projectile/Proj)
	if(take_damage(Proj.get_structure_damage()))
		return PROJECTILE_CONTINUE

/*
Automatic alignment of items to an invisible grid, defined by CELLS and CELLSIZE, defined in code/__defines/misc.dm.
Since the grid will be shifted to own a cell that is perfectly centered on the turf, we end up with two 'cell halves'
on edges of each row/column.
Each item defines a center_of_mass, which is the pixel of a sprite where its projected center of mass toward a turf
surface can be assumed. For a piece of paper, this will be in its center. For a bottle, it will be (near) the bottom
of the sprite.
auto_align() will then place the sprite so the defined center_of_mass is at the bottom left corner of the grid cell
closest to where the cursor has clicked on.
Note: This proc can be overwritten to allow for different types of auto-alignment.
*/
/obj/structure/proc/auto_align(obj/item/W, click_params)
	if (!W.center_of_mass) // Clothing, material stacks, generally items with large sprites where exact placement would be unhandy.
		W.pixel_x = rand(-W.randpixel, W.randpixel)
		W.pixel_y = rand(-W.randpixel, W.randpixel)
		W.pixel_z = 0
		return
	if (!click_params)
		return
	var/list/click_data = params2list(click_params)
	if (!click_data["icon-x"] || !click_data["icon-y"])
		return
	// Calculation to apply new pixelshift.
	var/mouse_x = text2num(click_data["icon-x"])-1 // Ranging from 0 to 31
	var/mouse_y = text2num(click_data["icon-y"])-1
	var/cell_x = Clamp(round(mouse_x/CELLSIZE), 0, CELLS-1) // Ranging from 0 to CELLS-1
	var/cell_y = Clamp(round(mouse_y/CELLSIZE), 0, CELLS-1)
	var/list/center = cached_json_decode(W.center_of_mass)
	W.pixel_x = (CELLSIZE * (cell_x + 0.5)) - center["x"]
	W.pixel_y = (CELLSIZE * (cell_y + 0.5)) - center["y"]
	W.pixel_z = 0
