/obj/item/slugegg
	name = "slugegg"
	desc = "A pulsing, disgusting door to new life."
	force = 1
	throwforce = 6
	icon = 'icons/obj/items/slug_egg.dmi'
	icon_state = "slugegg"
	var/break_on_impact = 1 //There are two modes to the eggs.
							//One breaks the egg on hit,

/obj/item/slugegg/throw_impact(atom/hit_atom)
	if(break_on_impact)
		squish()
	else
		movable_flags |= MOVABLE_FLAG_PROXMOVE //Dont want it active during the throw... loooots of unneeded checking.
	return ..()

/obj/item/slugegg/attack_self(var/mob/living/user)
	squish()

/obj/item/slugegg/HasProximity(var/atom/movable/AM)
	if(isliving(AM))
		squish()

/obj/item/slugegg/proc/squish()
	src.visible_message("<span class='warning'>\The [src] bursts open!</span>")
	new /mob/living/simple_animal/hostile/voxslug(get_turf(src))
	playsound(src.loc,'sound/effects/attackblob.ogg',100, 1)
	qdel(src)

//a slug sling basically launches a small egg that hatches (either on a person or on the floor), releasing a terrible blood thirsty monster.
//Balanced due to the non-spammy nature of the gun, as well as the frailty of the creatures.
/obj/item/gun/launcher/alien/slugsling
	name = "slug sling"
	desc = "A bulbous looking rifle. It feels like holding a plastic bag full of meat."
	w_class = ITEM_SIZE_LARGE
	on_mob_icon = 'icons/obj/guns/launcher/voxslug.dmi'
	icon = 'icons/obj/guns/launcher/voxslug.dmi'
	icon_state = "world"
	fire_sound_text = "a strange noise"
	fire_sound = 'sound/weapons/towelwhip.ogg'
	release_force = 6
	ammo_name = "slug"
	ammo_type = /obj/item/slugegg
	max_ammo = 2
	ammo = 2
	ammo_gen_time = 600
	var/mode = "Impact"

/obj/item/gun/launcher/alien/slugsling/consume_next_projectile()
	var/obj/item/slugegg/S = ..()
	if(S)
		S.break_on_impact = (mode == "Impact")
	return S


/obj/item/gun/launcher/alien/slugsling/attack_self(var/mob/living/user)
	mode = mode == "Impact" ? "Sentry" : "Impact"
	to_chat(user,"<span class='notice'>You switch \the [src]'s mode to \"[mode]\"</span>")
