/obj/item/gun/launcher/alien
	var/last_regen = 0
	var/ammo_gen_time = 100
	var/max_ammo = 3
	var/ammo = 3
	var/ammo_type
	var/ammo_name

/obj/item/gun/launcher/alien/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	last_regen = world.time

/obj/item/gun/launcher/alien/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/gun/launcher/alien/Process()
	if(ammo < max_ammo && world.time > last_regen + ammo_gen_time)
		ammo++
		last_regen = world.time
		update_icon()

/obj/item/gun/launcher/alien/examine(mob/user)
	. = ..()
	to_chat(user, "It has [ammo] [ammo_name]\s remaining.")

/obj/item/gun/launcher/alien/consume_next_projectile()
	if(ammo < 1) return null
	if(ammo == max_ammo) //stops people from buffering a reload (gaining effectively +1 to the clip)
		last_regen = world.time
	ammo--
	return new ammo_type

/obj/item/gun/launcher/alien/Initialize()
	. = ..()
	set_extension(src, /datum/extension/voxform)

//Vox pinning weapon.
/obj/item/gun/launcher/alien/spikethrower
	name = "spike thrower"
	desc = "A vicious alien projectile weapon. Parts of it quiver gelatinously, as though the thing is insectile and alive."
	w_class = ITEM_SIZE_LARGE
	ammo_name = "spike"
	ammo_type = /obj/item/spike
	release_force = 30
	icon = 'mods/species/vox/icons/gear/voxspike.dmi'
	icon_state = ICON_STATE_WORLD
	fire_sound_text = "a strange noise"
	fire_sound = 'sound/weapons/spike.ogg'

/obj/item/gun/launcher/alien/spikethrower/on_update_icon()
	icon_state = "[get_world_inventory_state()][Clamp(ammo,0,3)]"

/obj/item/arrow/quill
	name = "vox quill"
	desc = "A wickedly barbed quill from some bizarre animal."
	icon_state = "quill"
	item_state = "quill"
	throwforce = 5
