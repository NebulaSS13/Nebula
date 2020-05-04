/obj/item/gun/projectile/revolver
	name = "revolver"
	desc = "The al-Maliki & Mosley Magnum Double Action is a choice revolver for when you absolutely, positively need to put a hole in the other guy."
	icon = 'icons/obj/guns/revolvers.dmi'
	on_mob_icon = 'icons/obj/guns/revolvers.dmi'
	icon_state = "world"
	safety_icon = "safety"
	caliber = CALIBER_PISTOL_MAGNUM
	origin_tech = "{'combat':2,'materials':2}"
	handle_casings = CYCLE_CASINGS
	max_shells = 6
	fire_delay = 12 //Revolvers are naturally slower-firing
	ammo_type = /obj/item/ammo_casing/pistol/magnum
	var/chamber_offset = 0 //how many empty chambers in the cylinder until you hit a round
	mag_insert_sound = 'sound/weapons/guns/interaction/rev_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/rev_magout.ogg'
	accuracy = 2
	accuracy_power = 8
	one_hand_penalty = 2
	bulk = 3

/obj/item/gun/projectile/revolver/AltClick()
	if(CanPhysicallyInteract(usr))
		spin_cylinder()

/obj/item/gun/projectile/revolver/verb/spin_cylinder()
	set name = "Spin cylinder"
	set desc = "Fun when you're bored out of your skull."
	set category = "Object"

	chamber_offset = 0
	visible_message("<span class='warning'>\The [usr] spins the cylinder of \the [src]!</span>", \
	"<span class='notice'>You hear something metallic spin and click.</span>")
	playsound(src.loc, 'sound/weapons/revolver_spin.ogg', 100, 1)
	loaded = shuffle(loaded)
	if(rand(1,max_shells) > loaded.len)
		chamber_offset = rand(0,max_shells - loaded.len)

/obj/item/gun/projectile/revolver/consume_next_projectile()
	if(chamber_offset)
		chamber_offset--
		return
	return ..()

/obj/item/gun/projectile/revolver/load_ammo(var/obj/item/A, mob/user)
	chamber_offset = 0
	return ..()

/obj/item/gun/projectile/revolver/capgun
	name = "cap gun"
	desc = "Looks almost like the real thing! Ages 8 and up."
	caliber = CALIBER_CAPS
	origin_tech = "{'combat':1,'materials':1}"
	ammo_type = /obj/item/ammo_casing/cap
	var/cap = TRUE

/obj/item/gun/projectile/revolver/capgun/on_update_icon()
	. = ..()
	if(cap)
		overlays += image(icon, "[icon_state]-toy")

/obj/item/gun/projectile/revolver/capgun/attackby(obj/item/wirecutters/W, mob/user)
	if(!istype(W) || !cap)
		return ..()
	to_chat(user, "<span class='notice'>You snip off the toy markings off the [src].</span>")
	name = "revolver"
	desc += " Someone snipped off the barrel's toy mark. How dastardly."
	cap = FALSE
	update_icon()
	return 1
