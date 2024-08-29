/obj/item/tool/machete
	name                       = "machete"
	desc                       = "A long, sturdy blade with a rugged handle. Leading the way to cursed treasures since before space travel."
	icon                       = 'icons/obj/items/weapon/machetes/machete.dmi'
	w_class                    = ITEM_SIZE_NORMAL
	slot_flags                 = SLOT_LOWER_BODY
	material                   = /decl/material/solid/metal/titanium
	base_parry_chance          = 50
	origin_tech                = @'{"materials":2,"combat":1}'
	attack_verb                = list("chopped", "torn", "cut")
	_base_attack_force         = 20
	var/static/list/standard_machete_icons = list(
		'icons/obj/items/weapon/machetes/machete.dmi',
		'icons/obj/items/weapon/machetes/machete_red.dmi',
		'icons/obj/items/weapon/machetes/machete_blue.dmi',
		'icons/obj/items/weapon/machetes/machete_black.dmi',
		'icons/obj/items/weapon/machetes/machete_olive.dmi'
	)

/obj/item/tool/machete/Initialize()
	icon = pick(standard_machete_icons)
	. = ..()

/obj/item/tool/machete/get_handle_color()
	return null

/obj/item/tool/machete/get_initial_tool_qualities()
	var/static/list/tool_qualities = list(
		TOOL_HATCHET = TOOL_QUALITY_MEDIOCRE,
		TOOL_HAMMER  = TOOL_QUALITY_BAD
	)
	return tool_qualities

/obj/item/tool/machete/unbreakable
	max_health = ITEM_HEALTH_NO_DAMAGE

/obj/item/tool/machete/steel
	name = "fabricated machete"
	desc = "A long, machine-stamped blade with a somewhat ungainly handle. Found in military surplus stores, malls, and horror movies since before interstellar travel."
	base_parry_chance = 40
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/tool/machete/deluxe
	name = "deluxe machete"
	desc = "A fine example of a machete, with a polished blade, wooden handle and a leather cord loop."
	icon = 'icons/obj/items/weapon/machetes/machete_dx.dmi'
