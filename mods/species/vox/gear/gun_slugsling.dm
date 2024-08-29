/obj/item/slugegg
	name = "slugegg"
	desc = "A pulsing, disgusting door to new life."
	icon = 'mods/species/vox/icons/gear/slugegg.dmi'
	icon_state = "slugegg"
	material = /decl/material/solid/organic/skin/insect
	_base_attack_force = 1
	var/break_on_impact = 1 //There are two modes to the eggs.
							//One breaks the egg on hit,

/obj/item/slugegg/throw_impact(atom/hit_atom)
	if(break_on_impact)
		squish()
	else
		movable_flags |= MOVABLE_FLAG_PROXMOVE //Dont want it active during the throw... loooots of unneeded checking.
	return ..()

/obj/item/slugegg/attack_self(var/mob/user)
	squish()

/obj/item/slugegg/HasProximity(var/atom/movable/AM)
	. = ..()
	if(. && isliving(AM))
		var/mob/living/L = AM
		if(L.get_bodytype()?.bodytype_flag & BODY_FLAG_VOX)
			return FALSE
		if(L.faction == SPECIES_VOX)
			return FALSE
		squish()

/obj/item/slugegg/proc/squish()
	src.visible_message("<span class='warning'>\The [src] bursts open!</span>")
	new /mob/living/simple_animal/hostile/slug(get_turf(src))
	playsound(src.loc,'sound/effects/attackblob.ogg',100, 1)
	qdel(src)

//a slug sling basically launches a small egg that hatches (either on a person or on the floor), releasing a terrible blood thirsty monster.
//Balanced due to the non-spammy nature of the gun, as well as the frailty of the creatures.
/obj/item/gun/launcher/alien/slugsling
	name = "slug sling"
	desc = "A bulbous looking rifle. It feels like holding a plastic bag full of meat."
	w_class = ITEM_SIZE_LARGE
	icon = 'mods/species/vox/icons/gear/voxslug.dmi'
	icon_state = ICON_STATE_WORLD
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


/obj/item/gun/launcher/alien/slugsling/attack_self(var/mob/user)
	mode = mode == "Impact" ? "Sentry" : "Impact"
	to_chat(user,"<span class='notice'>You switch \the [src]'s mode to \"[mode]\"</span>")
