/decl/hierarchy/supply_pack/medical
	name = "Medical"
	containertype = /obj/structure/closet/crate/medical

/decl/hierarchy/supply_pack/medical/medical
	name = "Refills - Medical supplies"
	contains = list(/obj/item/storage/firstaid/regular,
					/obj/item/storage/firstaid/trauma,
					/obj/item/storage/firstaid/fire,
					/obj/item/storage/firstaid/toxin,
					/obj/item/storage/firstaid/o2,
					/obj/item/storage/firstaid/adv,
					/obj/item/storage/firstaid/stab,
					/obj/item/chems/glass/bottle/antitoxin,
					/obj/item/chems/glass/bottle/stabilizer,
					/obj/item/chems/glass/bottle/sedatives,
					/obj/item/storage/box/syringes,
					/obj/item/storage/box/autoinjectors)
	containername = "medical crate"

/decl/hierarchy/supply_pack/medical/atk
	name = "Triage - Advanced trauma supplies"
	contains = list(/obj/item/stack/medical/advanced/bruise_pack = 6)
	containername = "advanced trauma crate"

/decl/hierarchy/supply_pack/medical/abk
	name = "Triage - Advanced burn supplies"
	contains = list(/obj/item/stack/medical/advanced/ointment = 6)
	containername = "advanced burn crate"

/decl/hierarchy/supply_pack/medical/trauma
	name = "EMERGENCY - Trauma pouches"
	contains = list(/obj/item/storage/firstaid/trauma = 3)
	containername = "trauma pouch crate"

/decl/hierarchy/supply_pack/medical/burn
	name = "EMERGENCY - Burn pouches"
	contains = list(/obj/item/storage/firstaid/fire = 3)
	containername = "burn pouch crate"

/decl/hierarchy/supply_pack/medical/toxin
	name = "EMERGENCY - Toxin pouches"
	contains = list(/obj/item/storage/firstaid/toxin = 3)
	containername = "toxin pouch crate"

/decl/hierarchy/supply_pack/medical/oxyloss
	name = "EMERGENCY - Low oxygen pouches"
	contains = list(/obj/item/storage/firstaid/o2 = 3)
	containername = "low oxygen pouch crate"

/decl/hierarchy/supply_pack/medical/stab
	name = "Triage - Stability kit"
	contains = list(/obj/item/storage/firstaid/stab = 3)
	containername = "stability kit crate"

/decl/hierarchy/supply_pack/medical/bloodpack
	name = "Refills - Blood Bags (Empty)"
	contains = list(/obj/item/storage/box/bloodpacks = 3)
	containername = "blood pack crate"

/decl/hierarchy/supply_pack/medical/blood
	name = "Refills - Synthetic Blood"
	contains = list(/obj/item/chems/ivbag/nanoblood = 4)
	containername = "synthetic blood crate"

/decl/hierarchy/supply_pack/medical/bodybag
	name = "Equipment - Body bags"
	contains = list(/obj/item/storage/box/bodybags = 3)
	containername = "body bag crate"

/decl/hierarchy/supply_pack/medical/stretcher
	name = "Equipment - Roller bed crate"
	contains = list(/obj/item/roller = 3)
	containername = "\improper Roller bed crate"

/decl/hierarchy/supply_pack/medical/wheelchair
	name = "Equipment - Wheelchair crate"
	contains = list(/obj/structure/bed/chair/wheelchair)
	containertype = /obj/structure/closet/crate/large
	containername = "\improper Wheelchair crate"

/decl/hierarchy/supply_pack/medical/rescuebag
	name = "Equipment - Rescue bags"
	contains = list(/obj/item/bodybag/rescue = 3)
	containername = "\improper Rescue bag crate"

/decl/hierarchy/supply_pack/medical/medicalextragear
	name = "Gear - Medical surplus equipment"
	contains = list(/obj/item/storage/belt/medical = 3,
					/obj/item/clothing/glasses/hud/health = 3)
	containertype = /obj/structure/closet/crate/secure
	containername = "medical surplus equipment crate"
	access = access_medical

/decl/hierarchy/supply_pack/medical/cmogear
	name = "Gear - Chief medical officer equipment"
	contains = list(/obj/item/storage/belt/medical,
					/obj/item/radio/headset/heads/cmo,
					/obj/item/clothing/under/chief_medical_officer,
					/obj/item/chems/hypospray/vial,
					/obj/item/clothing/accessory/stethoscope,
					/obj/item/clothing/glasses/hud/health,
					/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
					/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
					/obj/item/clothing/mask/surgical,
					/obj/item/clothing/shoes/color/white,
					/obj/item/clothing/gloves/latex,
					/obj/item/scanner/health,
					/obj/item/scanner/breath,
					/obj/item/flashlight/pen,
					/obj/item/chems/syringe)
	containertype = /obj/structure/closet/crate/secure
	containername = "chief medical officer equipment crate"
	access = access_cmo

/decl/hierarchy/supply_pack/medical/doctorgear
	name = "Gear - Medical Doctor equipment"
	contains = list(/obj/item/storage/belt/medical,
					/obj/item/radio/headset/headset_med,
					/obj/item/clothing/under/medical,
					/obj/item/clothing/accessory/stethoscope,
					/obj/item/clothing/glasses/hud/health,
					/obj/item/clothing/suit/storage/toggle/labcoat,
					/obj/item/clothing/mask/surgical,
					/obj/item/storage/firstaid/adv,
					/obj/item/clothing/shoes/color/white,
					/obj/item/clothing/gloves/latex,
					/obj/item/scanner/health,
					/obj/item/scanner/breath,
					/obj/item/flashlight/pen,
					/obj/item/chems/syringe)
	containertype = /obj/structure/closet/crate/secure
	containername = "medical Doctor equipment crate"
	access = access_medical_equip

/decl/hierarchy/supply_pack/medical/chemistgear
	name = "Gear - Pharmacist equipment"
	contains = list(/obj/item/storage/box/beakers,
					/obj/item/radio/headset/headset_med,
					/obj/item/storage/box/autoinjectors,
					/obj/item/clothing/under/chemist,
					/obj/item/clothing/glasses/science,
					/obj/item/clothing/suit/storage/toggle/labcoat/chemist,
					/obj/item/clothing/mask/surgical,
					/obj/item/clothing/shoes/color/white,
					/obj/item/clothing/gloves/latex,
					/obj/item/chems/dropper,
					/obj/item/scanner/health,
					/obj/item/scanner/breath,
					/obj/item/storage/box/pillbottles,
					/obj/item/chems/syringe)
	containertype = /obj/structure/closet/crate/secure
	containername = "pharmacist equipment crate"
	access = access_chemistry

/decl/hierarchy/supply_pack/medical/paramedicgear
	name = "Gear - Paramedic equipment"
	contains = list(/obj/item/storage/belt/medical/emt,
					/obj/item/radio/headset/headset_med,
					/obj/item/clothing/under/medical/scrubs/black,
					/obj/item/clothing/accessory/armband/medgreen,
					/obj/item/clothing/glasses/hud/health,
					/obj/item/clothing/suit/storage/toggle/labcoat,
					/obj/item/clothing/under/medical,
					/obj/item/clothing/suit/storage/toggle/fr_jacket,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/under/medical/paramedic,
					/obj/item/clothing/accessory/stethoscope,
					/obj/item/storage/firstaid/adv,
					/obj/item/clothing/shoes/jackboots,
					/obj/item/clothing/gloves/latex,
					/obj/item/scanner/health,
					/obj/item/scanner/breath,
					/obj/item/flashlight/pen,
					/obj/item/chems/syringe,
					/obj/item/clothing/accessory/storage/vest)
	containertype = /obj/structure/closet/crate/secure
	containername = "paramedic equipment crate"
	access = access_medical_equip

/decl/hierarchy/supply_pack/medical/psychiatristgear
	name = "Gear - Psychiatrist equipment"
	contains = list(/obj/item/clothing/under/psych,
					/obj/item/radio/headset/headset_med,
					/obj/item/clothing/under/psych/turtleneck,
					/obj/item/clothing/shoes/dress,
					/obj/item/clothing/suit/storage/toggle/labcoat,
					/obj/item/clothing/shoes/color/white,
					/obj/item/clipboard,
					/obj/item/folder/cyan,
					/obj/item/pen)
	containertype = /obj/structure/closet/crate/secure
	containername = "psychiatrist equipment crate"
	access = access_psychiatrist

/decl/hierarchy/supply_pack/medical/medicalscrubs
	name = "Gear - Medical scrubs"
	contains = list(/obj/item/clothing/shoes/color/white = 4,
					/obj/item/clothing/under/medical/scrubs/blue,
					/obj/item/clothing/under/medical/scrubs/green,
					/obj/item/clothing/under/medical/scrubs/purple,
					/obj/item/clothing/under/medical/scrubs/black,
					/obj/item/clothing/head/surgery/black,
					/obj/item/clothing/head/surgery/purple,
					/obj/item/clothing/head/surgery/blue,
					/obj/item/clothing/head/surgery/green,
					/obj/item/storage/box/masks,
					/obj/item/storage/box/gloves)
	containertype = /obj/structure/closet/crate/secure
	containername = "medical scrubs crate"
	access = access_medical_equip

/decl/hierarchy/supply_pack/medical/autopsy
	name = "Gear - Autopsy equipment"
	contains = list(/obj/item/folder/cyan,
					/obj/item/camera,
					/obj/item/camera_film = 2,
					/obj/item/scanner/autopsy,
					/obj/item/scalpel,
					/obj/item/storage/box/masks,
					/obj/item/storage/box/gloves,
					/obj/item/pen)
	containertype = /obj/structure/closet/crate/secure
	containername = "autopsy equipment crate"
	access = access_morgue

/decl/hierarchy/supply_pack/medical/medicaluniforms
	name = "Gear - Medical uniforms"
	contains = list(/obj/item/clothing/shoes/color/white = 3,
					/obj/item/clothing/under/chief_medical_officer,
					/obj/item/clothing/under/geneticist,
					/obj/item/clothing/under/virologist,
					/obj/item/clothing/under/nursesuit,
					/obj/item/clothing/under/nurse,
					/obj/item/clothing/under/orderly,
					/obj/item/clothing/under/medical = 3,
					/obj/item/clothing/under/medical/paramedic = 3,
					/obj/item/clothing/suit/storage/toggle/labcoat = 3,
					/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
					/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
					/obj/item/clothing/suit/storage/toggle/labcoat/genetics,
					/obj/item/clothing/suit/storage/toggle/labcoat/virologist,
					/obj/item/clothing/suit/storage/toggle/labcoat/chemist,
					/obj/item/storage/box/masks,
					/obj/item/storage/box/gloves)
	containertype = /obj/structure/closet/crate/secure
	containername = "medical uniform crate"
	access = access_medical_equip

/decl/hierarchy/supply_pack/medical/medicalbiosuits
	name = "Gear - Medical biohazard gear"
	contains = list(/obj/item/clothing/head/bio_hood = 3,
					/obj/item/clothing/suit/bio_suit = 3,
					/obj/item/clothing/head/bio_hood/virology = 2,
					/obj/item/clothing/suit/bio_suit/cmo = 2,
					/obj/item/clothing/mask/gas = 5,
					/obj/item/tank/oxygen = 5,
					/obj/item/storage/box/masks,
					/obj/item/storage/box/gloves)
	containertype = /obj/structure/closet/crate/secure
	containername = "medical biohazard equipment crate"
	access = access_medical_equip

/decl/hierarchy/supply_pack/medical/portablefreezers
	name = "Equipment - Portable freezers"
	contains = list(/obj/item/storage/box/freezer = 7)
	containertype = /obj/structure/closet/crate/secure
	containername = "portable freezers crate"
	access = access_medical_equip

/decl/hierarchy/supply_pack/medical/surgery
	name = "Gear - Surgery tools"
	contains = list(/obj/item/cautery,
					/obj/item/surgicaldrill,
					/obj/item/clothing/mask/breath/medical,
					/obj/item/sutures,
					/obj/item/hemostat,
					/obj/item/scalpel,
					/obj/item/bonegel,
					/obj/item/retractor,
					/obj/item/bonesetter,
					/obj/item/circular_saw)
	containertype = /obj/structure/closet/crate/secure
	containername = "surgery crate"
	access = access_medical

/decl/hierarchy/supply_pack/medical/sterile
	name = "Gear - Sterile clothes"
	contains = list(/obj/item/clothing/under/medical/scrubs/green = 2,
					/obj/item/clothing/head/surgery/green = 2,
					/obj/item/storage/box/masks,
					/obj/item/storage/box/gloves,
					/obj/item/storage/belt/medical = 3)
	containertype = /obj/structure/closet/crate
	containername = "sterile clothes crate"

/decl/hierarchy/supply_pack/medical/scanner_module
	name = "Electronics - Medical scanner modules"
	contains = list(/obj/item/stock_parts/computer/scanner/medical = 4)
	containername = "medical scanner module crate"
	containertype = /obj/structure/closet/crate/secure
	access = access_medical_equip

/decl/hierarchy/supply_pack/medical/defib
	name = "Electronics - Defibrilator crate"
	contains = list(/obj/item/defibrillator)
	containername = "\improper Defibrilator crate"
	containertype = /obj/structure/closet/crate/secure
	access = access_medical_equip

/decl/hierarchy/supply_pack/medical/beltdefib
	name = "Electronics - Compact Defibrilator crate"
	contains = list(/obj/item/defibrillator/compact)
	containername = "\improper Compact Defibrilator crate"
	containertype = /obj/structure/closet/crate/secure
	access = access_medical_equip

/decl/hierarchy/supply_pack/medical/autocomp
	name = "Electronics - Auto-Compressor crate"
	contains = list(/obj/item/auto_cpr)
	containername = "\improper Auto-Compressor crate"
	containertype = /obj/structure/closet/crate/secure
	access = access_medical_equip