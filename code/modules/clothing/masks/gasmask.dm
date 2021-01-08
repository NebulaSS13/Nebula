/obj/item/clothing/mask/gas
	name = "gas mask"
	desc = "A face-covering mask that can be connected to an air supply. Filters harmful gases from the air."
	icon = 'icons/clothing/mask/gas_mask_full.dmi'
	icon_state = ICON_STATE_WORLD
	item_flags = ITEM_FLAG_BLOCK_GAS_SMOKE_EFFECT | ITEM_FLAG_AIRTIGHT
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	body_parts_covered = SLOT_FACE|SLOT_EYES
	w_class = ITEM_SIZE_NORMAL
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	siemens_coefficient = 0.9
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		bio = ARMOR_BIO_STRONG
		)
	filtered_gases = list(
		/decl/material/gas/nitrous_oxide,
		/decl/material/gas/chlorine,
		/decl/material/gas/ammonia,
		/decl/material/gas/carbon_monoxide,
		/decl/material/gas/methyl_bromide,
		/decl/material/gas/methane
	)
	var/clogged
	var/filter_water
	var/gas_filter_strength = 1			//For gas mask filters


/obj/item/clothing/mask/gas/examine(mob/user)
	. = ..()
	if(clogged)
		to_chat(user, "<span class='warning'>The intakes are clogged with [clogged]!</span>")

/obj/item/clothing/mask/gas/filters_water()
	return (filter_water && !clogged)

/obj/item/clothing/mask/gas/attack_self(var/mob/user)
	if(clogged)
		user.visible_message("<span class='notice'>\The [user] begins unclogging the intakes of \the [src].</span>")
		if(do_after(user, 100, progress = 1) && clogged)
			user.visible_message("<span class='notice'>\The [user] has unclogged \the [src].</span>")
			clogged = FALSE
		return
	. = ..()

/obj/item/clothing/mask/gas/filter_air(datum/gas_mixture/air)
	var/datum/gas_mixture/filtered = new

	for(var/g in filtered_gases)
		if(air.gas[g])
			filtered.gas[g] = air.gas[g] * gas_filter_strength
			air.gas[g] -= filtered.gas[g]

	air.update_values()
	filtered.update_values()

	return filtered

/obj/item/clothing/mask/gas/half
	name = "face mask"
	desc = "A compact, durable gas mask that can be connected to an air supply."
	icon = 'icons/clothing/mask/gas_mask_half.dmi'
	siemens_coefficient = 0.7
	body_parts_covered = SLOT_FACE
	w_class = ITEM_SIZE_SMALL
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bio = ARMOR_BIO_RESISTANT
		)

//In scaling order of utility and seriousness

/obj/item/clothing/mask/gas/radical
	name = "gas mask"
	desc = "A face-covering mask that can be connected to an air supply. Filters harmful gases from the air. This one has additional filters to remove radioactive particles."
	icon = 'icons/clothing/mask/gas_mask.dmi'
	body_parts_covered = SLOT_FACE|SLOT_EYES
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		bio = ARMOR_BIO_STRONG,
		rad = ARMOR_RAD_SMALL
		)

/obj/item/clothing/mask/gas/budget
	name = "gas mask"
	desc = "A face-covering mask that can be connected to an air supply. Filters harmful gases from the air. This one looks pretty dodgy. Are you sure it works?"
	icon = 'icons/clothing/mask/gas_mask_alt.dmi'
	body_parts_covered = SLOT_FACE|SLOT_EYES
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		bio = ARMOR_BIO_SMALL
		)

/obj/item/clothing/mask/gas/swat
	name = "\improper SWAT mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon = 'icons/clothing/mask/gas_mask_swat.dmi'
	siemens_coefficient = 0.7
	body_parts_covered = SLOT_FACE|SLOT_EYES
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bio = ARMOR_BIO_STRONG
		)

/obj/item/clothing/mask/gas/syndicate
	name = "tactical mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon = 'icons/clothing/mask/gas_mask_swat.dmi'
	siemens_coefficient = 0.7
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MINOR,
		bio = ARMOR_BIO_STRONG
		)

/obj/item/clothing/mask/gas/death_commando
	name = "\improper Death Commando Mask"
	desc = "A grim tactical mask worn by the fictional Death Commandos, elites of the also fictional Space Syndicate. Saturdays at 10!"
	icon = 'icons/clothing/mask/gas_mask_death.dmi'
	siemens_coefficient = 0.2

/obj/item/clothing/mask/gas/cyborg
	name = "cyborg visor"
	desc = "Beep boop!"
	icon = 'icons/clothing/mask/gas_mask_death.dmi'

//Plague Dr suit can be found in clothing/suits/bio.dm
/obj/item/clothing/mask/gas/plaguedoctor
	name = "plague doctor mask"
	desc = "A modernised version of the classic design, this mask will not only filter out toxins, but it can also be connected to an air supply."
	icon = 'icons/clothing/mask/gas_mask_plague.dmi'
	armor = list(
		bio = ARMOR_BIO_SHIELDED
		)
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES

/obj/item/clothing/mask/gas/clown_hat
	name = "clown wig and mask"
	desc = "A true prankster's facial attire. A clown is incomplete without their wig and mask."
	icon = 'icons/clothing/mask/gas_mask_clown.dmi'

/obj/item/clothing/mask/gas/sexyclown
	name = "sexy-clown wig and mask"
	desc = "A feminine clown mask for the dabbling crossdressers or female entertainers."
	icon = 'icons/clothing/mask/gas_mask_sexyclown.dmi'

/obj/item/clothing/mask/gas/mime
	name = "mime mask"
	desc = "The traditional mime's mask. It has an eerie facial posture."
	icon = 'icons/clothing/mask/gas_mask_mime.dmi'

/obj/item/clothing/mask/gas/monkeymask
	name = "monkey mask"
	desc = "A mask used when acting as a monkey."
	icon = 'icons/clothing/mask/gas_mask_monkey.dmi'
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES

/obj/item/clothing/mask/gas/sexymime
	name = "sexy mime mask"
	desc = "A traditional female mime's mask."
	icon = 'icons/clothing/mask/gas_mask_sexymime.dmi'

/obj/item/clothing/mask/gas/owl_mask
	name = "owl mask"
	desc = "Twoooo!"
	icon = 'icons/clothing/mask/gas_mask_owl.dmi'
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES

/obj/item/clothing/mask/gas/aquabreather
	name = "aquabreather"
	desc = "A compact CO2 scrubber and breathing apparatus that draws oxygen from water."
	icon = 'icons/clothing/mask/gas_mask_half.dmi'
	filter_water = TRUE
	body_parts_covered = SLOT_FACE
	w_class = ITEM_SIZE_SMALL
