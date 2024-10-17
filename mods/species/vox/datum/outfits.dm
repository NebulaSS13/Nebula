/decl/outfit/vox_raider
	name = "Job - Vox Raider"
	l_ear =      /obj/item/radio/headset/raider
	shoes =      /obj/item/clothing/shoes/magboots/vox
	gloves =     /obj/item/clothing/gloves/vox
	mask =       /obj/item/clothing/mask/gas/swat/vox
	back =       /obj/item/tank/nitrogen
	uniform =    /obj/item/clothing/suit/robe/vox
	glasses =    /obj/item/clothing/glasses/thermal
	holster =    /obj/item/clothing/webbing/holster/armpit
	suit_store = /obj/item/flashlight
	hands =      list(/obj/item/gun/launcher/alien/spikethrower)
	id_type =    /obj/item/card/id/syndicate

/decl/outfit/vox_raider/equip_outfit(mob/living/human/H, assignment, equip_adjustments, datum/job/job, datum/mil_rank/rank)
	uniform = pick(/obj/item/clothing/suit/robe/vox, /obj/item/clothing/pants/vox)
	glasses = pick(/obj/item/clothing/glasses/thermal, /obj/item/clothing/glasses/thermal/plain/eyepatch, /obj/item/clothing/glasses/thermal/plain/monocle)
	holster = pick(/obj/item/clothing/webbing/holster/armpit, /obj/item/clothing/webbing/holster/waist, /obj/item/clothing/webbing/holster/hip)
	. = ..()
	H.set_internals(locate(/obj/item/tank) in H.contents)