/obj/item/grenade/decompiler
	desc = "It is set to detonate in 5 seconds. It will create an unstable singularity that will break nearby objects down into purified matter cubes."
	name = "decompiler grenade"
	icon = 'icons/obj/items/grenades/delivery.dmi'
	origin_tech = "{'materials':3,'magnets':2,'exoticmatter':3}"
	matter = list(
		/decl/material/solid/exotic_matter = MATTER_AMOUNT_TRACE
	)

/obj/item/grenade/decompiler/detonate()
	var/spawn_loc = get_turf(src)
	qdel(src)
	new /obj/effect/decompiler(spawn_loc)

/obj/effect/decompiler
	name = "unstable singularity"
	desc = "Wow, this really sucks."
	icon = 'icons/effects/96x96.dmi'
	icon_state = "singularity_s3"
	pixel_w = -32
	pixel_z = -32
	alpha = 0

	var/pull_range = 7
	var/eat_range = 1
	var/lifetime = 10 SECONDS
	var/expiry_time
	var/list/decompiled_matter

/obj/effect/decompiler/Initialize()
	. = ..()
	expiry_time = world.time + lifetime
	START_PROCESSING(SSobj, src)
	decompiled_matter = list()
	fade_in()

/obj/effect/decompiler/proc/fade_in()
	visible_message(SPAN_DANGER("\A [src] forms, reaching out hungrily!"))
	playsound(loc, 'sound/magic/ethereal_enter.ogg', 75, FALSE)
	set_light(4.5, 0.8, LIGHT_COLOR_PURPLE)
	var/matrix/M = matrix()
	M.Scale(0.01)
	transform = M
	animate(src, transform = null, alpha = 255, easing = SINE_EASING, time = 5)

/obj/effect/decompiler/proc/fade_out()
	set waitfor = FALSE
	playsound(loc, 'sound/magic/ethereal_exit.ogg', 75, FALSE)
	var/matrix/M = matrix()
	M.Scale(0.01)
	animate(src, alpha = 0, transform = M, time = 5)
	sleep(5)
	var/dump_cubes = get_turf(src)
	if(dump_cubes)
		visible_message(SPAN_DANGER("\The [src] collapses!"))
		for(var/mat in decompiled_matter)
			var/sheet_amount = FLOOR(decompiled_matter[mat]/SHEET_MATERIAL_AMOUNT)
			if(sheet_amount > 0)
				while(sheet_amount > 100)
					var/obj/item/stack/material/cubes/cubes = new (dump_cubes, 100, mat)
					cubes.pixel_w = rand(-8, 8)
					cubes.pixel_z = rand(-8, 8)
					sheet_amount -= 100
				var/obj/item/stack/material/cubes/cubes = new(dump_cubes, sheet_amount, mat)
				cubes.pixel_w = rand(-8, 8)
				cubes.pixel_z = rand(-8, 8)
	qdel(src)

/obj/effect/decompiler/Process()

	FOR_DVIEW(var/atom/movable/thing, pull_range, loc, INVISIBILITY_LEVEL_TWO)
		if(thing.simulated && !thing.anchored)
			step_towards(thing, src)
	END_FOR_DVIEW

	if(world.time > expiry_time)
		fade_out()
		return PROCESS_KILL

	playsound(loc, 'sound/magic/lightningshock.ogg', 30, FALSE)

	var/list/eaten
	for(var/eat_turf in RANGE_TURFS(loc, eat_range))

		var/turf/T = eat_turf
		var/list/eating = T.contents?.Copy()

		while(length(eating))
			var/atom/movable/thing = pick_n_take(eating)
			if(QDELETED(thing) || !istype(thing) || !thing.simulated || thing.anchored || prob(15))
				continue

			if(prob(30))

				if(ismob(thing) && prob(50))
					var/mob/M = thing
					var/options = M.get_equipped_items(TRUE)
					if(length(options))
						thing = pick(options)

				if(ishuman(thing))
					var/mob/living/carbon/human/H = thing
					for(var/obj/item/organ/external/limb in H.organs)
						if(BP_IS_PROSTHETIC(limb) && !limb.is_stump() && !length(limb.children))
							limb.dismember()
							limb.forceMove(src)
							thing = limb
							break

			if(isitem(thing))
				var/obj/item/eating_obj = thing
				for(var/mat in eating_obj.matter)
					decompiled_matter[mat] += eating_obj.matter[mat]
				LAZYADD(eaten, eating_obj)

	if(length(eaten))
		playsound(loc, 'sound/magic/magic_missile.ogg', Clamp(length(eaten) * 10, 10, 50), FALSE)
		QDEL_NULL_LIST(eaten)

/obj/effect/decompiler/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()
