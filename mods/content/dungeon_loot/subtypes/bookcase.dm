// Contains generic mundane/fantasy loot.
/obj/structure/loot_pile/bookcase
	name = "bookcase"
	desc = "A bookcase that has long since fallen into disrepair. It may still have some useful things left on its shelves..."
	icon = 'icons/obj/structures/bookcase.dmi'
	icon_state = "bookcase-damaged" // preview
	material = /decl/material/solid/organic/wood/walnut
	color = /decl/material/solid/organic/wood/walnut::color
	material_alteration = MAT_FLAG_ALTERATION_ALL
	/// 1-indexed, pick a random overlay to add corresponding to "loot[rand(1, loot_states)]".
	var/loot_states = 3
	/// A text string corresponding to the icon_state of the loot overlay we're using.
	var/loot_state

/obj/structure/loot_pile/bookcase/update_material_name(override_name)
	. = ..()
	SetName("[pick("ruined", "destroyed", "dilapidated")] [name]")

/obj/structure/loot_pile/bookcase/ebony
	material = /decl/material/solid/organic/wood/ebony
	color = /decl/material/solid/organic/wood/ebony::color

/obj/structure/loot_pile/bookcase/get_icon_states_to_use()
	var/static/list/icon_states_to_use = list("bookcase-damaged", "fancy-damaged")
	return icon_states_to_use

/obj/structure/loot_pile/bookcase/Initialize(ml, _mat, _reinf_mat)
	if(isnum(loot_states) && loot_states > 0)
		loot_state = "loot[rand(1, loot_states)]"
	. = ..()

/obj/structure/loot_pile/bookcase/on_update_icon()
	. = ..()
	if(loot_state)
		add_overlay(overlay_image(icon, loot_state, null, RESET_COLOR|RESET_ALPHA))

/obj/structure/loot_pile/bookcase/get_common_loot()
	var/static/list/common_loot = list(
		/obj/item/paper/scroll,
		/obj/item/paper/scroll,
		/obj/item/paper/scroll,
		/obj/item/pen/fancy/quill,
		/obj/item/pen/fancy/quill,
		/obj/item/clothing/neck/prayer_beads/random,
		/obj/item/hourglass,
	)
	return common_loot

/obj/structure/loot_pile/bookcase/get_uncommon_loot()
	var/static/list/uncommon_loot = list(
		/obj/item/chems/glass/inkwell,
		/obj/item/clothing/glasses/prescription/pincenez,
		/obj/item/chems/drinks/bottle/wine,
		/obj/item/stack/medical/ointment/crafted,
		/obj/item/stack/medical/bandage/crafted,
	)
	return uncommon_loot

/obj/structure/loot_pile/bookcase/get_rare_loot()
	var/static/list/rare_loot = list(
		/obj/item/bone/skull, // unlucky!
		/obj/item/pen/fancy/quill/goose,
		/obj/item/clothing/gloves/ring/seal/signet,
		/obj/item/chems/drinks/bottle/champagne,
		/obj/item/chems/drinks/bottle/premiumwine,
	)
	return rare_loot

/// This spawns either a normal bookcase (20%), a damaged normal bookcase (60%), or a lootable decaying bookcase (20%).
/// There's also 20% chance to just spawn nothing.
/obj/random/dungeon_bookcase
	name = "random dungeon bookcase"
	icon = 'icons/obj/structures/bookcase.dmi'
	icon_state = "bookcase-random"
	spawn_nothing_percentage = 20

/obj/random/dungeon_bookcase/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/structure/bookcase/ebony = 40,
		/obj/structure/bookcase/fancy/ebony = 40,
		/obj/structure/loot_pile/bookcase/ebony = 20
	)
	return spawnable_choices

/obj/random/dungeon_bookcase/spawn_item()
	. = ..()
	for(var/obj/structure/bookcase/bookcase in .)
		if(prob(25))
			continue
		var/bookcase_max_health = bookcase.get_max_health()
		bookcase.take_damage(bookcase_max_health * rand(51, 70)/100)
		bookcase.update_icon()