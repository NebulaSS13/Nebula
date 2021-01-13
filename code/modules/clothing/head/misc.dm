/obj/item/clothing/head/centhat
	name = "\improper CentComm. hat"
	desc = "It's good to be emperor."
	icon = 'icons/clothing/head/centcom.dmi'
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/hairflower
	name = "hair flower pin"
	icon = 'icons/clothing/head/hairflower/red.dmi'
	desc = "Smells nice."
	slot_flags = SLOT_HEAD | SLOT_EARS
	body_parts_covered = 0

/obj/item/clothing/head/hairflower/blue
	icon = 'icons/clothing/head/hairflower/pink.dmi'
/obj/item/clothing/head/hairflower/pink
	icon = 'icons/clothing/head/hairflower/pink.dmi'
/obj/item/clothing/head/hairflower/yellow
	icon = 'icons/clothing/head/hairflower/yellow.dmi'
/obj/item/clothing/head/hairflower/bow
	name = "hair bow"
	desc = "A ribbon tied into a bow with a clip on the back to attach to hair."
	icon = 'icons/clothing/head/bow.dmi'

/obj/item/clothing/head/powdered_wig
	name = "powdered wig"
	desc = "A powdered wig."
	icon = 'icons/clothing/head/powderd_wig.dmi'
/obj/item/clothing/head/that
	name = "top-hat"
	desc = "It's an amish looking hat."
	icon = 'icons/clothing/head/tophat.dmi'
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/redcoat
	name = "redcoat's hat"
	icon = 'icons/clothing/head/redcoat.dmi'
	desc = "<i>'I guess it's a redhead.'</i>"
	body_parts_covered = 0

/obj/item/clothing/head/plaguedoctorhat
	name = "plague doctor's hat"
	desc = "These were once used by Plague doctors. They're pretty much useless."
	icon = 'icons/clothing/head/plague.dmi'
	permeability_coefficient = 0.01
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/hasturhood
	name = "hastur's hood"
	desc = "It's unspeakably stylish."
	icon = 'icons/clothing/head/hastur.dmi'
	flags_inv = BLOCKHAIR
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES

/obj/item/clothing/head/nursehat
	name = "nurse's hat"
	desc = "It allows quick identification of trained medical personnel."
	icon = 'icons/clothing/head/nurse.dmi'
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/cardborg
	name = "cardborg helmet"
	desc = "A helmet made out of a box."
	icon = 'icons/clothing/head/cardborg.dmi'
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES

/obj/item/clothing/head/cardborg/Initialize()
	. = ..()
	set_extension(src, /datum/extension/appearance/cardborg)

/obj/item/clothing/head/rabbitears
	name = "rabbit ears"
	desc = "Wearing these makes you looks useless, and only good for your sex appeal."
	icon = 'icons/clothing/head/bunny.dmi'
	body_parts_covered = 0

/obj/item/clothing/head/flatcap
	name = "flat cap"
	desc = "A working man's cap."
	icon = 'icons/clothing/head/flatcap.dmi'
	siemens_coefficient = 0.9

/obj/item/clothing/head/pirate
	name = "pirate hat"
	desc = "Yarr."
	icon = 'icons/clothing/head/pirate.dmi'
	body_parts_covered = 0

/obj/item/clothing/head/hgpiratecap
	name = "pirate hat"
	desc = "Yarr."
	icon = 'icons/clothing/head/pirate_cap.dmi'
	body_parts_covered = 0

/obj/item/clothing/head/bandana
	name = "pirate bandana"
	desc = "Yarr."
	icon = 'icons/clothing/head/bandana/pirate.dmi'
	body_parts_covered = 0

/obj/item/clothing/head/bandana/green
	name = "green bandana"
	desc = "It's a green bandana with some fine nanotech lining."
	icon = 'icons/clothing/head/bandana/green.dmi'
/obj/item/clothing/head/bandana/orange //themij: Taryn Kifer
	name = "orange bandana"
	desc = "An orange piece of cloth, worn on the head."
	icon = 'icons/clothing/head/bandana/orange.dmi'
/obj/item/clothing/head/bowler
	name = "bowler-hat"
	desc = "Gentleman, elite aboard!"
	body_parts_covered = 0
	icon = 'icons/clothing/head/bowler.dmi'

//stylish bs12 hats

/obj/item/clothing/head/beaverhat
	name = "beaver hat"
	desc = "Soft felt makes this hat both comfortable and elegant."
	icon = 'icons/clothing/head/beaver.dmi'

/obj/item/clothing/head/boaterhat
	name = "boater hat"
	desc = "The ultimate in summer fashion."
	icon = 'icons/clothing/head/boater.dmi'

/obj/item/clothing/head/fedora
	name = "fedora"
	desc = "A sharp, stylish hat."
	icon = 'icons/clothing/head/fedora.dmi'

/obj/item/clothing/head/feathertrilby
	name = "feather trilby"
	desc = "A sharp, stylish hat with a feather."
	icon = 'icons/clothing/head/trilby.dmi'

/obj/item/clothing/head/fez
	name = "fez"
	desc = "You should wear a fez. Fezzes are cool."
	icon = 'icons/clothing/head/fez.dmi'

//end bs12 hats

/obj/item/clothing/head/witchwig
	name = "witch costume wig"
	desc = "Eeeee~heheheheheheh!"
	icon = 'icons/clothing/head/wizard/marisa.dmi'
	flags_inv = BLOCKHAIR
	siemens_coefficient = 2.0

/obj/item/clothing/head/chicken
	name = "chicken suit head"
	desc = "Bkaw!"
	icon = 'icons/clothing/head/chicken.dmi'
	flags_inv = BLOCKHAIR
	siemens_coefficient = 0.7
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES

/obj/item/clothing/head/bearpelt
	name = "bear pelt hat"
	desc = "Fuzzy."
	icon = 'icons/clothing/head/bearpelt.dmi'
	flags_inv = BLOCKHAIR
	siemens_coefficient = 0.7

/obj/item/clothing/head/xenos
	name = "xenos helmet"
	desc = "A helmet made out of chitinous alien hide."
	icon = 'icons/clothing/head/xeno.dmi'
	w_class = ITEM_SIZE_NORMAL
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	siemens_coefficient = 2.0
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES

/obj/item/clothing/head/philosopher_wig
	name = "natural philosopher's wig"
	desc = "A stylish monstrosity unearthed from Earth's Renaissance period. With this most distinguish'd wig, you'll be ready for your next soiree!"
	icon = 'icons/clothing/head/huge_wig.dmi'
	flags_inv = BLOCKHAIR
	body_parts_covered = 0

/obj/item/clothing/head/hijab
	name = "hijab"
	desc = "A veil which is wrapped to cover the head and chest."
	icon = 'icons/clothing/head/hijab.dmi'
	body_parts_covered = 0
	flags_inv = BLOCKHAIR

/obj/item/clothing/head/kippa
	name = "kippa"
	desc = "A small, brimless cap."
	icon = 'icons/clothing/head/kippa.dmi'
	body_parts_covered = 0

/obj/item/clothing/head/turban
	name = "turban"
	desc = "A sturdy cloth, worn around the head."
	icon = 'icons/clothing/head/turban.dmi'
	body_parts_covered = 0
	flags_inv = BLOCKHEADHAIR //Shows beards!

/obj/item/clothing/head/cowboy_hat
	name = "cowboy hat"
	desc = "A wide-brimmed hat, in the prevalent style of America's frontier period. By law, you are required to wear this hat while watching True Grit."
	icon = 'icons/clothing/head/cowboy.dmi'
	body_parts_covered = 0

/obj/item/clothing/head/taqiyah
	name = "taqiyah"
	desc = "A short, rounded skullcap usually worn for religious purposes."
	icon = 'icons/clothing/head/taqiyah.dmi'
	body_parts_covered = 0

/obj/item/clothing/head/rastacap
	name = "rastacap"
	desc = "A round, crocheted cap, often worn to tuck hair away or for religious purposes."
	icon = 'icons/clothing/head/rasta.dmi'
	body_parts_covered = 0
	flags_inv = BLOCKHEADHAIR

/obj/item/clothing/head/tank
	name = "padded cap"
	desc = "A padded skullcup for those prone to bumping their heads against hard surfaces."
	icon = 'icons/clothing/head/tank.dmi'
	flags_inv = BLOCKHEADHAIR
	color = "#5f5f5f"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bomb = ARMOR_BOMB_PADDED
		)

/obj/item/clothing/head/tank/olive
	color = "#727c58"

/obj/item/clothing/head/tank/tan
	color = "#ae9f79"

/obj/item/clothing/head/beanie
	name = "beanie"
	desc = "A head-hugging brimless winter cap. This one is tight."
	icon = 'icons/clothing/head/beanie.dmi'
	body_parts_covered = 0

/obj/item/clothing/head/helmet/facecover
	name = "face cover"
	desc = "A helmet made of plastic. It's completely opaque. This will stop the stare."
	icon = 'icons/clothing/head/facecover.dmi'
	tint = TINT_BLIND
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES
	flash_protection = FLASH_PROTECTION_MAJOR