/obj/item/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	fire_sound = 'sound/weapons/gunshot/gunshot.ogg'

	damage_type     = BRUTE
	damage_flags    = DAM_BULLET | DAM_SHARP
	embed           = TRUE
	sharp           = TRUE
	space_knockback = TRUE

	var/mob_passthrough_check = FALSE
	var/caliber

	miss_sounds = list('sound/weapons/guns/miss1.ogg','sound/weapons/guns/miss2.ogg','sound/weapons/guns/miss3.ogg','sound/weapons/guns/miss4.ogg')
	ricochet_sounds = list('sound/weapons/guns/ricochet1.ogg', 'sound/weapons/guns/ricochet2.ogg','sound/weapons/guns/ricochet3.ogg', 'sound/weapons/guns/ricochet4.ogg')
	impact_sounds = list(BULLET_IMPACT_MEAT = SOUNDS_BULLET_MEAT, BULLET_IMPACT_METAL = SOUNDS_BULLET_METAL)
	muzzle_type = /obj/effect/projectile/muzzle/bullet

/obj/item/projectile/bullet/get_autopsy_descriptors()
	. = ..()
	if(caliber)
		. += "matching caliber [caliber]"

/obj/item/projectile/bullet/on_hit(var/atom/target, var/blocked = 0)
	if(..(target, blocked))
		var/mob/living/L = target
		shake_camera(L, 3, 2)

/obj/item/projectile/bullet/attack_mob(var/mob/target_mob, var/distance, var/miss_modifier)
	if(penetrating > 0 && damage > 20 && prob(damage))
		mob_passthrough_check = TRUE
	else
		mob_passthrough_check = FALSE
	. = ..()
	if(. == 1 && iscarbon(target_mob))
		damage *= 0.7 //squishy mobs absorb KE

/obj/item/projectile/bullet/can_embed()
	//prevent embedding if the projectile is passing through the mob
	if(mob_passthrough_check)
		return 0
	return ..()

/obj/item/projectile/bullet/check_penetrate(var/atom/A)
	if(QDELETED(A) || !A.density) return 1 //if whatever it was got destroyed when we hit it, then I guess we can just keep going

	if(ismob(A))
		if(!mob_passthrough_check)
			return 0
		return 1

	var/chance = damage
	if(has_extension(A, /datum/extension/penetration))
		var/datum/extension/penetration/P = get_extension(A, /datum/extension/penetration)
		chance = P.PenetrationProbability(chance, damage, damage_type)

	if(prob(chance))
		if(A.opacity)
			//display a message so that people on the other side aren't so confused
			A.visible_message("<span class='warning'>\The [src] pierces through \the [A]!</span>")
		return 1

	return 0

//Pistol

/obj/item/projectile/bullet/pistol
	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	damage = 50
	armor_penetration = 10
	penetration_modifier = 1

//Holdout/SMG

/obj/item/projectile/bullet/pistol/small
	fire_sound = 'sound/weapons/gunshot/gunshot_4mm.ogg' //well its not 4mm the sound was just unused
	armor_penetration = 20
	penetration_modifier = 1.3
	distance_falloff = 3

//Magnum

/obj/item/projectile/bullet/pistol/magnum
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	damage = 60
	armor_penetration = 30
	penetration_modifier = 1.5

//Practice

/obj/item/projectile/bullet/pistol/practice
	damage_flags = DAM_BULLET
	damage = 5
	embed = FALSE
	penetration_modifier = 0

//Rubber

/obj/item/projectile/bullet/pistol/rubber
	name = "rubber bullet"
	damage_flags = 0
	armor_penetration = 0
	damage = 5
	agony = 30
	embed = FALSE
	penetration_modifier = 0

/obj/item/projectile/bullet/pistol/rubber/small
	agony = 20

/obj/item/projectile/bullet/pistol/rubber/magnum
	damage = 10
	agony = 40

//Shotgun

/obj/item/projectile/bullet/shotgun
	name = "slug"
	fire_sound = 'sound/weapons/gunshot/shotgun.ogg'
	damage = 70
	armor_penetration = 40
	penetration_modifier = 2
	distance_falloff = 3

/obj/item/projectile/bullet/shotgun/beanbag
	name = "beanbag"
	damage_flags = 0
	armor_penetration = 0
	damage = 25
	agony = 50
	embed = FALSE
	penetration_modifier = 0

/obj/item/projectile/bullet/shotgun/practice
	damage_flags = DAM_BULLET
	damage = 5
	embed = FALSE
	penetration_modifier = 0

//Rifle

/obj/item/projectile/bullet/rifle
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'
	damage = 60
	armor_penetration = 30
	penetrating = 1
	penetration_modifier = 2
	distance_falloff = 1

/obj/item/projectile/bullet/rifle/rubber
	name = "rubber bullet"
	damage_flags = 0
	armor_penetration = 0
	damage = 15
	agony = 50
	embed = FALSE
	penetration_modifier = 0

/obj/item/projectile/bullet/rifle/practice
	damage_flags = DAM_BULLET
	damage = 5
	embed = FALSE
	penetration_modifier = 0
	penetrating = 0

//AM rifle

/obj/item/projectile/bullet/rifle/shell
	fire_sound = 'sound/weapons/gunshot/sniper.ogg'
	damage = 140
	armor_penetration = 140
	stun = 20
	weaken = 20
	agony = 20
	penetrating = 4
	penetration_modifier = 4 //its a bad idea to shoot a living human being with a fucking anti-tank cannon
	distance_falloff = 0.5

/obj/item/projectile/bullet/rifle/shell/on_impact(var/atom/A)
	. = ..()
	explosion(A,0,0,2,5)

//TODOOOOOOOOOOOOO THIS SHIT RAILGUUUN

/obj/item/projectile/bullet/magnetic
	name = "rod"
	icon_state = "rod"
	fire_sound = 'sound/weapons/railgun.ogg'
	damage = 60
	armor_penetration = 90
	penetrating = 5
	penetration_modifier = 4
	distance_falloff = 0.5

/obj/item/projectile/bullet/magnetic/slug
	name = "slug"
	icon_state = "gauss_silenced"
	damage = 80
	stun = 10
	penetration_modifier = 5

/obj/item/projectile/bullet/magnetic/flechette
	name = "flechette"
	icon_state = "flechette"
	fire_sound = 'sound/weapons/rapidslice.ogg'
	damage = 40
	armor_penetration = 100

//Special

/obj/item/projectile/bullet/pistol/cap
	name = "cap"
	fire_sound = null
	invisibility = 101
	damage_type = PAIN
	damage_flags = 0
	damage = 0
	nodamage = TRUE
	embed = FALSE

/obj/item/projectile/bullet/pistol/cap/Process()
	qdel(src)
	return PROCESS_KILL

//Chemdart

/obj/item/projectile/bullet/chemdart
	name = "dart"
	icon_state = "dart"
	damage = 5
	embed = TRUE //the dart is shot fast enough to pierce space suits, so I guess splintering inside the target can be a thing. Should be rare due to low damage.
	var/reagent_amount = 15
	life_span = 15 //shorter range
	unacidable = 1
	muzzle_type = null

/obj/item/projectile/bullet/chemdart/initialize_reagents(populate)
	create_reagents(reagent_amount)
	. = ..()

/obj/item/projectile/bullet/chemdart/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	if(blocked < 100 && isliving(target))
		var/mob/living/L = target
		if(L.can_inject(null, def_zone) == CAN_INJECT)
			reagents.trans_to_mob(L, reagent_amount, CHEM_INJECT)