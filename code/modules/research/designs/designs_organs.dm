/datum/design/item/mechfab/prosthetic_organ/Fabricate()
	var/obj/item/organ/internal/I = ..()
	if(istype(I))
		I.robotize()

/datum/design/item/mechfab/prosthetic_organ
	category = "Prosthetic Organs"
	materials = list(MAT_STEEL = 3000)

/datum/design/item/mechfab/prosthetic_organ/ModifyDesignName()
	name = "prosthetic organ ([name])"

/datum/design/item/mechfab/prosthetic_organ/stomach
	name = "stomach"
	desc = "A prosthetic stomach."
	req_tech = list(TECH_MATERIAL = 2)
	build_path = /obj/item/organ/internal/stomach

/datum/design/item/mechfab/prosthetic_organ/heart
	name = "heart"
	desc = "A prosthetic heart."
	req_tech = list(TECH_MATERIAL = 2)
	build_path = /obj/item/organ/internal/heart

/datum/design/item/mechfab/prosthetic_organ/liver
	name = "liver"
	desc = "A prosthetic liver."
	req_tech = list(TECH_MATERIAL = 2)
	build_path = /obj/item/organ/internal/liver

/datum/design/item/mechfab/prosthetic_organ/kidneys
	name = "kidneys"
	desc = "A prosthetic pair of kidneys."
	req_tech = list(TECH_MATERIAL = 2)
	build_path = /obj/item/organ/internal/kidneys

/datum/design/item/mechfab/prosthetic_organ/lungs
	name = "lungs"
	desc = "A prosthetic pair of lungs."
	req_tech = list(TECH_MATERIAL = 2)
	build_path = /obj/item/organ/internal/lungs

/datum/design/item/mechfab/prosthetic_organ/eyes
	name = "eyes"
	desc = "A prosthetic pair of eyes."
	req_tech = list(TECH_MATERIAL = 2)
	build_path = /obj/item/organ/internal/eyes
