#define BODYTYPE_GRAFADREKA           "drake body"
#define BODYTYPE_GRAFADREKA_HATCHLING "hatchling drake body"
#define BP_DRAKE_GIZZARD              "drake gizzard"

/decl/modpack/grafadreka
	name = "Grafadreka Species"

/obj/random/grafadreka
	name = "Random Grafadreka"
	desc = "This is a random grafadreka, either waking or hibernating."
	icon = 'mods/species/drakes/icons/body.dmi'
	icon_state = "preview"
	//mob_returns_home = 1
	//mob_wander_distance = 10

/obj/random/grafadreka/spawn_choices()
	var/static/list/spawn_choices = list(
		/mob/living/human/grafadreka/hatchling = 3,
		/mob/living/human/grafadreka           = 12
	)
	return spawn_choices
