/decl/special_role/raider/New()
	. = ..()
	LAZYSET(outfits_per_species, SPECIES_VOX, /decl/hierarchy/outfit/vox_raider)
	
/decl/hierarchy/outfit/vox_raider
	name = OUTFIT_JOB_NAME("Vox Raider")
	shoes =      /obj/item/clothing/shoes/magboots/vox
	gloves =     /obj/item/clothing/gloves/vox
	mask =       /obj/item/clothing/mask/gas/swat/vox
	back =       /obj/item/tank/nitrogen
	uniform =    /obj/item/clothing/under/vox/vox_robes
	glasses =    /obj/item/clothing/glasses/thermal
	holster =    /obj/item/clothing/accessory/storage/holster/armpit
	suit_store = /obj/item/flashlight
	hands =      list(/obj/item/gun/launcher/alien/spikethrower)

/decl/hierarchy/outfit/vox_raider/equip(mob/living/carbon/human/H, rank, assignment, equip_adjustments)
	uniform = pick(/obj/item/clothing/under/vox/vox_robes, /obj/item/clothing/under/vox/vox_casual)
	glasses = pick(/obj/item/clothing/glasses/thermal, /obj/item/clothing/glasses/thermal/plain/eyepatch, /obj/item/clothing/glasses/thermal/plain/monocle)
	holster = pick(/obj/item/clothing/accessory/storage/holster/armpit, /obj/item/clothing/accessory/storage/holster/waist, /obj/item/clothing/accessory/storage/holster/hip)
	. = ..()
	H.set_internals(locate(/obj/item/tank) in H.contents)

// The following mirror is ~special~.
/obj/item/storage/mirror/raider
	name = "cracked mirror"
	desc = "Something seems strange about this old, dirty mirror. Your reflection doesn't look like you remember it."
	icon_state = "mirror_broke"
	shattered = 1

/obj/item/storage/mirror/raider/use_mirror(mob/living/carbon/human/user)
	if(!istype(get_area(src),/area/map_template/syndicate_mothership))
		return ..()

	var/decl/special_role/raider/raiders = decls_repository.get_decl(/decl/special_role/raider)
	if(!istype(user) || !user.mind || !user.mind.assigned_special_role != raiders || user.species.name == SPECIES_VOX || !is_alien_whitelisted(user, SPECIES_VOX))
		return ..()

	var/choice = input("Do you wish to become a Vox of the Shoal? This is not reversible.") as null|anything in list("No","Yes")
	if(choice != "Yes")
		return ..()

	var/decl/hierarchy/outfit/outfit = decls_repository.get_decl(/decl/hierarchy/outfit/vox_raider)
	var/mob/living/carbon/human/vox/vox = new(get_turf(src), SPECIES_VOX)
	outfit.equip(vox)
	if(user.mind)
		user.mind.transfer_to(vox)
	qdel(user)
	addtimer(CALLBACK(src, .proc/do_post_voxifying, vox), 1)

/obj/item/storage/mirror/raider/proc/do_post_voxifying(var/mob/living/carbon/human/vox)
	var/newname = sanitizeSafe(input(vox,"Enter a name, or leave blank for the default name.", "Name change","") as text, MAX_NAME_LEN)
	if(!newname || newname == "")
		var/decl/cultural_info/voxculture = SSlore.get_culture(CULTURE_VOX_RAIDER)
		newname = voxculture.get_random_name()
	vox.real_name = newname
	vox.SetName(vox.real_name)
	var/decl/special_role/raider/raiders = decls_repository.get_decl(/decl/special_role/raider)
	raiders.update_access(vox)

/obj/item/magic_rock/Initialize(ml, material_key)
	LAZYSET(potentials, SPECIES_VOX, /spell/targeted/shapeshift/true_form)
	. = ..()
