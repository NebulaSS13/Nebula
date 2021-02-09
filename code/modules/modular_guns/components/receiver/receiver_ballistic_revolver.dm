/obj/item/firearm_component/receiver/ballistic/revolver
	handle_casings = CYCLE_CASINGS
	max_shells = 6
	loaded = /obj/item/ammo_casing/pistol/magnum
	mag_insert_sound = 'sound/weapons/guns/interaction/rev_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/rev_magout.ogg'
	var/chamber_offset = 0 //how many empty chambers in the cylinder until you hit a round

/obj/item/firearm_component/receiver/ballistic/revolver/load_ammo(mob/user, obj/item/loading)
	chamber_offset = 0
	. = ..()
	
/obj/item/firearm_component/receiver/ballistic/revolver/get_next_projectile(mob/user)
	if(chamber_offset)
		chamber_offset--
	. = ..()

/obj/item/firearm_component/receiver/ballistic/revolver/capgun
	loaded = /obj/item/ammo_casing/cap

/*
/obj/item/gun/projectile/revolver/verb/spin_cylinder()
	set name = "Spin cylinder"
	set desc = "Fun when you're bored out of your skull."
	set category = "Object"

	chamber_offset = 0
	visible_message("<span class='warning'>\The [usr] spins the cylinder of \the [holder || src]!</span>", \
	"<span class='notice'>You hear something metallic spin and click.</span>")
	playsound(get_turf(src), 'sound/weapons/revolver_spin.ogg', 100, 1)
	loaded = shuffle(loaded)
	if(rand(1,max_shells) > loaded.len)
		chamber_offset = rand(0,max_shells - loaded.len)


/obj/item/gun/projectile/revolver/AltClick()
	if(CanPhysicallyInteract(usr))
		spin_cylinder()


*/