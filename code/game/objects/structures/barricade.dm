//Barricades!
/obj/structure/barricade
	name = "barricade"
	icon = 'icons/obj/structures/barricade.dmi'
	icon_state = "barricade"
	anchored = 1.0
	density = 1
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	layer = ABOVE_WINDOW_LAYER
	material_alteration = MAT_FLAG_ALTERATION_ALL
	maxhealth = 100

	var/spike_damage //how badly it smarts when you run into this like a rube
	var/list/poke_description = list("gored", "spiked", "speared", "stuck", "stabbed")

/obj/structure/barricade/spike
	icon_state = "cheval"

/obj/structure/barricade/spike/Initialize()
	if(!reinf_material)
		reinf_material = /decl/material/solid/wood
	. = ..()

/obj/structure/barricade/Initialize()
	if(!material)
		material = /decl/material/solid/wood
	. = ..()
	if(!istype(material))
		return INITIALIZE_HINT_QDEL

/obj/structure/barricade/update_materials(var/keep_health)
	. = ..()
	spike_damage = reinf_material?.hardness * 0.85

/obj/structure/barricade/update_material_name()
	..(reinf_material ? "cheval-de-frise" : "barricade")

/obj/structure/barricade/update_material_desc()
	if(reinf_material)
		desc = "A rather simple [material.solid_name] barrier. It menaces with spikes of [reinf_material.solid_name]."
	else
		desc = "A heavy, solid barrier made of [material.solid_name]."

/obj/structure/barricade/on_update_icon()
	..()
	if(reinf_material)
		icon_state = "cheval"
		overlays = overlay_image(icon, "cheval_spikes", color = reinf_material.color, flags = RESET_COLOR)
	else
		icon_state = "barricade"
	
/obj/structure/barricade/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/material/rods) && !reinf_material)
		var/obj/item/stack/material/rods/R = W
		if(R.get_amount() < 5)
			to_chat(user, SPAN_WARNING("You need more rods to build a cheval de frise."))
		else
			visible_message(SPAN_NOTICE("\The [user] begins to work on \the [src]."))
			if(do_after(user, 4 SECONDS, src) && !reinf_material && R.use(5))
				visible_message(SPAN_NOTICE("\The [user] fastens \the [R] to \the [src]."))
				reinf_material = R.material
				update_materials(TRUE)
	. = ..()

/obj/structure/barricade/dismantle()
	visible_message(SPAN_DANGER("The barricade is smashed apart!"))
	. = ..()

/obj/structure/barricade/explosion_act(severity)
	..()
	if(QDELETED(src))
		if(severity == 1)
			parts_type = null
			physically_destroyed()
		else if(severity == 2)
			take_damage(25)

/obj/structure/barricade/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)//So bullets will fly over and stuff.
	if(air_group || (height==0))
		return 1
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1
	else
		return 0

/obj/structure/barricade/Bumped(mob/living/victim)
	. = ..()
	if(!reinf_material || !isliving(victim))
		return
	if(world.time - victim.last_bumped <= 15) //spam guard
		return FALSE

	victim.last_bumped = world.time
	var/spike_damage_holder = spike_damage
	var/target_zone = pick(BP_CHEST, BP_GROIN, BP_L_LEG, BP_R_LEG)
	if(MOVING_DELIBERATELY(victim)) //walking into this is less hurty than running
		spike_damage_holder = (spike_damage / 4)
	if(isanimal(victim)) //simple animals have simple health, reduce our spike_damage
		spike_damage_holder = (spike_damage / 4)
	victim.apply_damage(spike_damage_holder, BRUTE, target_zone, damage_flags = DAM_SHARP, used_weapon = src)
	visible_message(SPAN_DANGER("\The [victim] is [pick(poke_description)] by \the [src]!"))