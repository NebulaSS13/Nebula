/decl/outfit/vox
	abstract_type = /decl/outfit/vox
	mask          = /obj/item/clothing/mask/gas/swat/vox
	back          = /obj/item/tank/nitrogen
	uniform       = /obj/item/clothing/suit/robe/vox
	shoes         = /obj/item/clothing/shoes/magboots/vox
	gloves        = /obj/item/clothing/gloves/vox
	var/list/glasses_types
	var/list/holster_types

/decl/outfit/vox/equip_outfit(mob/living/wearer, assignment, equip_adjustments, datum/job/job, datum/mil_rank/rank)
	uniform = pick(/obj/item/clothing/suit/robe/vox, /obj/item/clothing/pants/vox)
	if(length(glasses_types))
		glasses = pick(glasses_types)
	if(length(holster_types))
		holster = pick(holster_types)
	. = ..()
	wearer.set_internals(locate(/obj/item/tank) in wearer.contents)

/decl/outfit/vox/survivor
	name = "Job - Vox Survivor"

/decl/outfit/vox/raider
	name = "Job - Vox Raider"
	l_ear         = /obj/item/radio/headset/raider
	glasses       = /obj/item/clothing/glasses/thermal
	holster       = /obj/item/clothing/webbing/holster/armpit
	suit_store    = /obj/item/flashlight
	hands         = list(/obj/item/gun/launcher/alien/spikethrower)
	id_type       = /obj/item/card/id/syndicate
	holster_types = list(
		/obj/item/clothing/webbing/holster/armpit,
		/obj/item/clothing/webbing/holster/waist,
		/obj/item/clothing/webbing/holster/hip
	)
	glasses_types = list(
		/obj/item/clothing/glasses/thermal,
		/obj/item/clothing/glasses/thermal/plain/eyepatch,
		/obj/item/clothing/glasses/thermal/plain/monocle
	)
