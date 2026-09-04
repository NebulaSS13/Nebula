// Pendant with a setting for a stone.
/obj/item/pendant/setting
	abstract_type = /obj/item/pendant/setting

// Duplicating some logic here to consistently insert the gem name where appropriate.
/obj/item/pendant/setting/get_name_components()
	. = list()
	if(name_prefix)
		. += name_prefix
	if(material)
		. += material.adjective_name
	var/obj/item/gemstone/gem = locate() in contents
	if(gem)
		. += gem.name
	. += name // base_name has already been applied by parent call

// Subtypes below.
/obj/item/pendant/setting/square
	name_prefix = "square"
	desc        = "A square-shaped pendant."
	icon        = 'icons/clothing/accessories/jewelry/pendants/square.dmi'

/obj/item/pendant/setting/cross
	name        = "cross"
	desc        = "A hard-edged cross pendant."
	icon        = 'icons/clothing/accessories/jewelry/pendants/cross.dmi'

/obj/item/pendant/setting/diamond
	name_prefix = "diamond"
	desc        = "A diamond-shaped pendant."
	icon        = 'icons/clothing/accessories/jewelry/pendants/diamond.dmi'

/obj/item/pendant/setting/ornate
	name_prefix = "ornate"
	desc        = "An ornate set of pendants."
	icon        = 'icons/clothing/accessories/jewelry/pendants/ornate.dmi'
