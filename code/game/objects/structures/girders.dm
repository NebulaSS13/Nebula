/obj/structure/girder
	name = "support"
	icon = 'icons/obj/structures/girder.dmi'
	icon_state = "girder"
	anchored = FALSE
	density =  TRUE
	layer =    BELOW_OBJ_LAYER
	material_alteration =    MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_COLOR
	tool_interaction_flags = (TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT)
	maxhealth = 100
	var/cover = 50
	var/prepped_for_fakewall

/obj/structure/girder/Initialize()
	set_extension(src, /datum/extension/penetration/simple, 100)
	. = ..()

/obj/structure/girder/can_unanchor(var/mob/user)
	. = ..()
	var/turf/T = loc
	if(!anchored && . && (!istype(T) || T.is_open()))
		to_chat(user, SPAN_WARNING("You can only secure \the [src] to solid ground."))
		return FALSE

/obj/structure/girder/handle_default_screwdriver_attackby(var/mob/user, var/obj/item/screwdriver)

	if(reinf_material)
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		visible_message(SPAN_NOTICE("\The [user] begins unscrewing \the [reinf_material.solid_name] struts from \the [src]."))
		if(do_after(user, 5 SECONDS, src) || QDELETED(src) || !reinf_material)
			visible_message(SPAN_NOTICE("\The [user] unscrews and removes \the [reinf_material.solid_name] struts from \the [src]."))
			reinf_material.place_dismantled_product(get_turf(src))
			reinf_material = null
		return TRUE

	playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
	prepped_for_fakewall = !prepped_for_fakewall
	visible_message(SPAN_NOTICE("\The [user] adjusts \the [src] with \the [screwdriver]."))
	if(prepped_for_fakewall)
		to_chat(user, SPAN_NOTICE("When finished, this wall will be able to be pushed aside, forming a hidden passage."))
	else
		to_chat(user, SPAN_NOTICE("This wall will no longer contain a hidden passage when finished."))
	return TRUE

/obj/structure/girder/on_update_icon()
	. = ..()
	if(!anchored)
		icon_state = "displaced"
	else if(reinf_material)
		icon_state = "reinforced"
	else
		icon_state = initial(icon_state)

/obj/structure/girder/displaced/Initialize()
	. = ..()
	anchored = prob(50)

/obj/structure/girder/bullet_act(var/obj/item/projectile/Proj)
	
	var/effective_cover = cover
	if(reinf_material)
		effective_cover *= 2
	if(!anchored) 
		effective_cover *= 0.5
	effective_cover = Clamp(FLOOR(effective_cover), 0, 100)
	if(Proj.original != src && !prob(effective_cover))
		return PROJECTILE_CONTINUE
	var/damage = Proj.get_structure_damage()
	if(!damage)
		return
	if(!istype(Proj, /obj/item/projectile/beam))
		damage *= 0.4
	if(reinf_material)
		damage = FLOOR(damage * 0.75)
	..()
	if(damage)
		take_damage(damage)

/obj/structure/girder/CanFluidPass(var/coming_from)
	return TRUE

/obj/structure/girder/can_unanchor(var/mob/user)
	if(anchored && reinf_material)
		to_chat(user, SPAN_WARNING("You must remove the support struts before you can dislodge \the [src]."))
		return FALSE
	. = ..()

/obj/structure/girder/can_dismantle(var/mob/user)
	if(reinf_material)
		to_chat(user, SPAN_WARNING("You must use a screwdriver to remove the [reinf_material.solid_name] reinforcement before you can dismantle \the [src]."))
		return FALSE
	. = ..()

/obj/structure/girder/attackby(var/obj/item/W, var/mob/user)
	// Other methods of quickly destroying a girder.
	if(W.is_special_cutting_tool(TRUE))
		if(istype(W, /obj/item/gun/energy/plasmacutter))
			var/obj/item/gun/energy/plasmacutter/cutter = W
			if(!cutter.slice(user))
				return
		playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
		visible_message(SPAN_NOTICE("\The [user] begins slicing apart \the [src] with \the [W]."))
		if(do_after(user,reinf_material ? 40: 20,src))
			visible_message(SPAN_NOTICE("\The [user] slices apart \the [src] with \the [W]."))
			dismantle()
		return TRUE
	if(istype(W, /obj/item/pickaxe/diamonddrill))
		playsound(src.loc, 'sound/weapons/Genhit.ogg', 100, 1)
		visible_message(SPAN_NOTICE("\The [user] begins drilling through \the [src] with \the [W]."))
		if(do_after(user,reinf_material ? 60 : 40,src))
			visible_message(SPAN_NOTICE("\The [user] drills through \the [src] with \the [W]."))
			dismantle()
		return TRUE
	// Reinforcing a girder, or turning it into a wall.
	if(istype(W, /obj/item/stack/material))
		if(anchored)
			return construct_wall(W, user)
		else
			if(reinf_material)
				to_chat(user, SPAN_WARNING("\The [src] is already reinforced with [reinf_material.solid_name]."))
			else
				return reinforce_with_material(W, user)
		return TRUE
	. = ..()

/obj/structure/girder/proc/construct_wall(obj/item/stack/material/S, mob/user)
	if(S.get_amount() < 2)
		to_chat(user, SPAN_WARNING("You will need at least two sheets of material clad a wall."))
		return 0

	if(!istype(S.material))
		return 0

	if(!anchored)
		to_chat(user, SPAN_WARNING("You must anchor \the [src] before finishing the wall."))
		return FALSE

	if(S.material.weight > max(material.wall_support_value, reinf_material?.wall_support_value))
		to_chat(user, SPAN_WARNING("You will need a support made of sturdier material to hold up [S.material.solid_name] cladding."))
		return FALSE

	add_hiddenprint(usr)
	if(S.material.integrity < 50)
		to_chat(user, SPAN_WARNING("This material is too soft for use in wall construction."))
		return 0

	to_chat(user, SPAN_NOTICE("You begin adding the [S.material.solid_name] cladding..."))

	if(!do_after(user,40,src) || !S.use(2))
		return 1 //once we've gotten this far don't call parent attackby()

	if(!prepped_for_fakewall)
		to_chat(user, SPAN_NOTICE("You added the [S.material.solid_name] cladding!"))
	else
		to_chat(user, SPAN_NOTICE("You create a false wall! Push on it to open or close the passage."))

	var/turf/Tsrc = get_turf(src)
	Tsrc.ChangeTurf(/turf/simulated/wall)
	var/turf/simulated/wall/T = get_turf(src)
	T.set_material(S.material, reinf_material, material)
	T.can_open = prepped_for_fakewall
	T.add_hiddenprint(usr)
	material = null
	reinf_material = null
	qdel(src)
	return 1

/obj/structure/girder/proc/reinforce_with_material(obj/item/stack/material/S, mob/user) //if the verb is removed this can be renamed.
	if(reinf_material)
		to_chat(user, SPAN_WARNING("\The [src] is already reinforced."))
		return TRUE
	if(S.get_amount() < 2)
		to_chat(user, SPAN_WARNING("You will need at least 2 sheets to reinforce \the [src]."))
		return TRUE
	var/decl/material/M = S.material
	if(!istype(M) || M.integrity < 50)
		to_chat(user, SPAN_WARNING("You cannot reinforce \the [src] with [M.solid_name]; it is too soft."))
		return TRUE
	visible_message(SPAN_NOTICE("\The [user] begins installing [M.solid_name] struts into \the [src]."))
	if (!do_after(user, 4 SECONDS, src) || !S.use(2))
		return TRUE
	visible_message(SPAN_NOTICE("\The [user] finishes reinforcing \the [src] with [M.solid_name]."))
	reinf_material = M
	update_icon()
	return 1

/obj/structure/girder/attack_hand(mob/user)
	if (MUTATION_HULK in user.mutations)
		visible_message(SPAN_DANGER("\The [user] smashes \the [src] apart!"))
		dismantle()
		return
	return ..()


/obj/structure/girder/explosion_act(severity)
	..()
	if(severity == 1 || (severity == 2 && prob(30)) || (severity == 3 && prob(5)))
		physically_destroyed()

/obj/structure/girder/cult
	icon= 'icons/obj/cult.dmi'
	icon_state= "cultgirder"
	maxhealth = 150
	cover = 70

/obj/structure/girder/cult/dismantle()
	material = null
	reinf_material = null
	parts_type = null
	. = ..()

/obj/structure/girder/wood
	material = /decl/material/solid/wood/mahogany

/obj/structure/grille/wood
	material = /decl/material/solid/wood/mahogany

/obj/structure/lattice/wood
	material = /decl/material/solid/wood/mahogany
