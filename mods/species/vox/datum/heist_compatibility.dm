#ifdef GAMEMODE_PACK_HEIST
/decl/special_role/raider/Initialize()
	. = ..()
	LAZYSET(outfits_per_species, SPECIES_VOX, /decl/outfit/vox_raider)

// The following mirror is ~special~.
/obj/structure/mirror/raider
	name = "cracked mirror"
	desc = "Something seems strange about this old, dirty mirror. Your reflection doesn't look like you remember it."
	icon_state = "mirror_broke"
	shattered = TRUE

/obj/structure/mirror/raider/attack_hand(mob/user)
	if(!istype(get_area(src), /area/map_template/syndicate_mothership))
		return ..()

	var/decl/species/my_species = user?.get_species()
	var/decl/special_role/raider/raiders = GET_DECL(/decl/special_role/raider)
	if(!istype(user) || !user.mind || !user.mind.assigned_special_role != raiders || !my_species || my_species.name == SPECIES_VOX || !is_alien_whitelisted(user, SPECIES_VOX))
		return ..()

	var/choice = input("Do you wish to become a vox of the Shoal? This is not reversible.") as null|anything in list("No","Yes")
	if(choice != "Yes")
		return ..()

	var/decl/outfit/outfit = GET_DECL(/decl/outfit/vox_raider)
	var/mob/living/human/vox/vox = new(get_turf(src), SPECIES_VOX)
	outfit.equip_outfit(vox)
	if(user.mind)
		user.mind.transfer_to(vox)
	qdel(user)
	addtimer(CALLBACK(src, PROC_REF(do_post_voxifying), vox), 1)

/obj/structure/mirror/raider/proc/do_post_voxifying(var/mob/living/human/vox)
	var/newname = sanitize_safe(input(vox,"Enter a name, or leave blank for the default name.", "Name change","") as text, MAX_NAME_LEN)
	if(!newname || newname == "")
		var/decl/background_detail/background = GET_DECL(/decl/background_detail/heritage/vox/raider)
		newname = background.get_random_name()
	vox.real_name = newname
	vox.SetName(vox.real_name)
	var/decl/special_role/raider/raiders = GET_DECL(/decl/special_role/raider)
	raiders.update_access(vox)
#endif