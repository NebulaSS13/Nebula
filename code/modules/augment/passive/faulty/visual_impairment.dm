/obj/item/organ/internal/augment/faulty/visual_impair
	name = "visual impairment"
	desc = "An augment that was badly installed, which has removed the ability to perceive color."
	allowed_organs = list(BP_AUGMENT_HEAD)

/obj/item/organ/internal/augment/faulty/visual_impair/onInstall()
	owner.add_client_color(/datum/client_color/monochrome)

/obj/item/organ/internal/augment/faulty/visual_impair/onRemove()
	owner.remove_client_color(/datum/client_color/monochrome)