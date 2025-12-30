/datum/map_template/fantasy/woods/fairy_ring
	name = "fairy ring"
	mappaths = list("mods/content/fantasy/submaps/woods/fairy_rings/fairy_ring.dmm")
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS | TEMPLATE_FLAG_ALLOW_DUPLICATES | TEMPLATE_FLAG_GENERIC_REPEATABLE
	template_categories = list(
		MAP_TEMPLATE_CATEGORY_FANTASY_WOODS
	)
	area_coherency_test_exempt_areas    = list(/area/fantasy/outside/point_of_interest/fairy_ring)

/datum/map_template/fantasy/woods/fairy_ring/glowing
	name = "glowing fairy ring"
	mappaths = list("mods/content/fantasy/submaps/woods/fairy_rings/fairy_ring_glowing.dmm")

/area/fantasy/outside/point_of_interest/fairy_ring
	name = "Point of Interest - Fairy Ring"
