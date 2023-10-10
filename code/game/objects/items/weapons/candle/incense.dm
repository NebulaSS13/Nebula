/obj/item/flame/candle/scented/incense
	name = "incense cone"
	desc = "An incense cone. It produces fragrant smoke when burned."
	icon_state = "incense1"

	available_colours = null
	icon_set = "incense"
	candle_range = 1

	scent_types = list(/decl/scent_type/rose,
					   /decl/scent_type/citrus,
					   /decl/scent_type/sage,
					   /decl/scent_type/frankincense,
					   /decl/scent_type/mint,
					   /decl/scent_type/champa,
					   /decl/scent_type/lavender,
					   /decl/scent_type/sandalwood)

/obj/item/storage/candle_box/incense
	name = "incense box"
	desc = "A pack of 'Tres' brand incense cones, in a variety of scents."
	icon_state = "incensebox"
	max_storage_space = 9

/obj/item/storage/candle_box/incense/WillContain()
	return list(/obj/item/flame/candle/scented/incense = 9)