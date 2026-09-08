/obj/item/gun/launcher/vox
	var/last_regen = 0
	var/ammo_gen_time = 100
	var/max_ammo = 3
	var/ammo = 3
	var/ammo_type
	var/ammo_name

/obj/item/gun/launcher/vox/get_examine_hints(mob/user, distance, infix, suffix)
	. = ..()
	LAZYADD(., SPAN_SUBTLE("Feeding meat to \the [src] will increase its firing force by 25% for fifteen minutes."))

/obj/item/gun/launcher/vox/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	last_regen = world.time

/obj/item/gun/launcher/vox/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/gun/launcher/vox/Process()
	if(ammo < max_ammo && world.time > last_regen + ammo_gen_time)
		ammo++
		last_regen = world.time
		update_icon()

/obj/item/gun/launcher/vox/update_release_force(obj/item/projectile)
	. = ..()
	release_force = initial(release_force)
	var/datum/extension/voxform/voxform = get_extension(src, /datum/extension/voxform)
	if(voxform && world.time <= voxform.fed_until)
		release_force = round(release_force * 1.25)

/obj/item/gun/launcher/vox/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	. += "It has [ammo] [ammo_name]\s remaining."

/obj/item/gun/launcher/vox/consume_next_projectile()
	if(ammo < 1) return null
	if(ammo == max_ammo) //stops people from buffering a reload (gaining effectively +1 to the clip)
		last_regen = world.time
	ammo--
	return new ammo_type

/obj/item/gun/launcher/vox/Initialize()
	. = ..()
	set_extension(src, /datum/extension/voxform)

//Vox pinning weapon.
/obj/item/gun/launcher/vox/spikethrower
	name = "spike thrower"
	desc = "A vicious, insect-like alien projectile weapon originally used for securing hull segments in vacuum. Parts of it quiver gelatinously, as though the thing is alive."
	w_class = ITEM_SIZE_LARGE
	ammo_name = "spike"
	ammo_type = /obj/item/stack/material/bow_ammo/spike
	release_force = 30
	icon = 'mods/species/vox/icons/gear/voxspike.dmi'
	icon_state = ICON_STATE_WORLD
	fire_sound_text = "a strange noise"
	fire_sound = 'sound/weapons/spike.ogg'

/obj/item/gun/launcher/vox/spikethrower/on_update_icon()
	. = ..()
	icon_state = "[get_world_inventory_state()][clamp(ammo,0,3)]"

/obj/item/gun/launcher/vox/spikethrower/small
	name = "spike pistol"
	desc = "A cut-down version of the infamous insectile spike thrower, adapted from a tool used for bolting hull sections together. Parts of it quiver gelatinously, as though the thing is alive."
	icon = 'mods/species/vox/icons/gear/voxspike_small.dmi'
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BACK | SLOT_LOWER_BODY
	release_force = 24
	ammo_gen_time = 180
	max_ammo = 3
	ammo = 3

/obj/item/stack/material/bow_ammo/quill
	name = "vox quill"
	desc = "A wickedly barbed quill from some bizarre animal."
	icon = 'mods/species/vox/icons/gear/arrow_quill.dmi'
	material = /decl/material/solid/organic/leather/chitin
	material_alteration = MAT_FLAG_ALTERATION_NONE

/obj/item/stack/material/bow_ammo/quill/make_superheated()
	return
