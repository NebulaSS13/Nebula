/obj/item/grenade/spawnergrenade
	desc = "It is set to detonate in 5 seconds. It will unleash unleash an unspecified anomaly into the vicinity."
	name = "delivery grenade"
	icon = 'icons/obj/items/grenades/delivery.dmi'
	origin_tech = "{'materials':3,'magnets':4}"
	var/banglet = 0
	var/spawner_type = null // must be an object path
	var/deliveryamt = 1 // amount of type to deliver

/obj/item/grenade/spawnergrenade/fake_carp/detonate()
	if(spawner_type && deliveryamt)
		var/turf/T = get_turf(src)
		playsound(T, 'sound/effects/phasein.ogg', 100, 1)
		for(var/mob/living/carbon/human/M in viewers(T, null))
			if(M.eyecheck() < FLASH_PROTECTION_MODERATE)
				M.flash_eyes()
			for(var/i = 1 to deliveryamt)
				var/atom/spawned = new spawner_type(T)
				if(prob(50))
					for(var/j = 1 to rand(1, 3))
						step(spawned, pick(GLOB.cardinal))
		qdel(src)

/obj/item/grenade/spawnergrenade/manhacks
	name = "manhack delivery grenade"
	spawner_type = /mob/living/simple_animal/hostile/viscerator
	deliveryamt = 5
	origin_tech = "{'materials':3,'magnets':4,'esoteric':4}"

/obj/item/grenade/spawnergrenade/spesscarp
	name = "carp delivery grenade"
	spawner_type = /mob/living/simple_animal/hostile/carp
	deliveryamt = 5
	origin_tech = "{'materials':3,'magnets':4,'esoteric':4}"
