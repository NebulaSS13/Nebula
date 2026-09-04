/decl/species
	available_background_info = list(
		/decl/background_category/citizenship = list(
			/decl/background_detail/citizenship/other
		),
		/decl/background_category/homeworld = list(
			/decl/background_detail/location/fantasy,
			/decl/background_detail/location/fantasy/mountains,
			/decl/background_detail/location/fantasy/steppe,
			/decl/background_detail/location/fantasy/woods,
			/decl/background_detail/location/other
		),
		/decl/background_category/faction =   list(
			/decl/background_detail/faction/fantasy,
			/decl/background_detail/faction/other
		),
		/decl/background_category/heritage =   list(
			/decl/background_detail/heritage/fantasy,
			/decl/background_detail/heritage/fantasy/steppe,
			/decl/background_detail/heritage/other
		),
		/decl/background_category/religion =  list(
			/decl/background_detail/religion/ancestors,
			/decl/background_detail/religion/folk_deity,
			/decl/background_detail/religion/anima_materialism,
			/decl/background_detail/religion/virtuist,
			/decl/background_detail/religion/other
		)
	)
	default_background_info = list(
		/decl/background_category/citizenship = /decl/background_detail/citizenship/other,
		/decl/background_category/homeworld   = /decl/background_detail/location/fantasy,
		/decl/background_category/faction     = /decl/background_detail/faction/fantasy,
		/decl/background_category/heritage    = /decl/background_detail/heritage/fantasy,
		/decl/background_category/religion    = /decl/background_detail/religion/other
	)

// Rename wooden prostheses
/decl/bodytype/prosthetic/wooden
	name = "carved wooden" // weird to call it 'crude' when it's cutting-edge for the setting

// Just some fun overrides for when robot debris shows up in maint.
/obj/effect/decal/cleanable/blood/gibs/robot
	name = "mysterious debris"
	desc = "Some kind of complex, oily detritus. What could it be?"

/obj/item/remains/robot
	name = "mysterious remains"
	desc = "The oily remains of some complex, metallic object. What could they be from?"

// Override to remove non-fantasy stuff.
/obj/random/trash/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/remains/lizard,
		/obj/effect/decal/cleanable/blood/gibs/robot,
		/obj/effect/decal/cleanable/spiderling_remains,
		/obj/item/remains/mouse,
		/obj/effect/decal/cleanable/vomit,
		/obj/effect/decal/cleanable/blood/splatter,
		/obj/effect/decal/cleanable/ash,
		/obj/effect/decal/cleanable/generic,
		/obj/effect/decal/cleanable/flour,
		/obj/effect/decal/cleanable/filth,
		/obj/effect/decal/cleanable/dirt/visible,
		/obj/item/remains/robot
	)
	return spawnable_choices
