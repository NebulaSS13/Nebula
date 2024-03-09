/obj/random/plush
	name = "random plush"
	desc = "This is a random plush toy."
	icon = 'icons/obj/toy/plush_corgi.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/plush/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/random/plush/animal,
		/obj/random/plush/therapy
	)
	return spawnable_choices

/obj/random/plush/animal
	name = "random animal plush"
	icon = 'icons/obj/toy/plush_deer.dmi'

/obj/random/plush/animal/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/toy/plushie/nymph,
		/obj/item/toy/plushie/deer,
		/obj/item/toy/plushie/mouse,
		/obj/item/toy/plushie/kitten,
		/obj/item/toy/plushie/lizard,
		/obj/item/toy/plushie/spider,
		/obj/item/toy/plushie/corgi,
		/obj/item/toy/plushie/corgi/ribbon,
		/obj/item/toy/plushie/robo_corgi,
		/obj/item/toy/plushie/octopus,
		/obj/item/toy/plushie/face_hugger,
		/obj/random/plush/carp,
		/obj/random/plush/fox,
		/obj/random/plush/cat,
		/obj/random/plush/squid
	)
	return spawnable_choices

/obj/random/plush/therapy
	name = "random therapy doll"
	icon = 'icons/obj/toy/plush_therapy_blue.dmi'

/obj/random/plush/therapy/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/toy/plushie/therapy,
		/obj/item/toy/plushie/therapy/orange,
		/obj/item/toy/plushie/therapy/yellow,
		/obj/item/toy/plushie/therapy/green,
		/obj/item/toy/plushie/therapy/purple,
		/obj/item/toy/plushie/therapy/blue
	)
	return spawnable_choices

/obj/random/plush/carp
	name = "random carp plush"
	icon = 'icons/obj/toy/plush_carp.dmi'

/obj/random/plush/carp/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/toy/plushie/carp,
		/obj/item/toy/plushie/carp/ice,
		/obj/item/toy/plushie/carp/silent,
		/obj/item/toy/plushie/carp/electric,
		/obj/item/toy/plushie/carp/gold,
		/obj/item/toy/plushie/carp/toxin,
		/obj/item/toy/plushie/carp/dragon,
		/obj/item/toy/plushie/carp/pink,
		/obj/item/toy/plushie/carp/candy,
		/obj/item/toy/plushie/carp/nebula,
		/obj/item/toy/plushie/carp/void
	)
	return spawnable_choices

/obj/random/plush/fox
	name = "random fox plush"
	icon = 'icons/obj/toy/plush_fox.dmi'

/obj/random/plush/fox/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/toy/plushie/fox,
		/obj/item/toy/plushie/fox/black,
		/obj/item/toy/plushie/fox/marble,
		/obj/item/toy/plushie/fox/blue,
		/obj/item/toy/plushie/fox/orange,
		/obj/item/toy/plushie/fox/coffee,
		/obj/item/toy/plushie/fox/pink,
		/obj/item/toy/plushie/fox/purple,
		/obj/item/toy/plushie/fox/crimson,
	)
	return spawnable_choices

/obj/random/plush/cat
	name = "random cat plush"
	icon = 'icons/obj/toy/plush_cat.dmi'

/obj/random/plush/cat/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/toy/plushie/cat,
		/obj/item/toy/plushie/cat/grey,
		/obj/item/toy/plushie/cat/white,
		/obj/item/toy/plushie/cat/orange,
		/obj/item/toy/plushie/cat/siamese,
		/obj/item/toy/plushie/cat/tabby,
		/obj/item/toy/plushie/cat/tuxedo
	)
	return spawnable_choices

/obj/random/plush/squid
	name = "random squid plush"
	icon = 'icons/obj/toy/plush_squid.dmi'

/obj/random/plush/squid/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/toy/plushie/squid,
		/obj/item/toy/plushie/squid/mint,
		/obj/item/toy/plushie/squid/blue,
		/obj/item/toy/plushie/squid/orange,
		/obj/item/toy/plushie/squid/yellow,
		/obj/item/toy/plushie/squid/pink
	)
	return spawnable_choices

/obj/random/toy
	name = "random toy"
	desc = "This is a random toy."
	icon = 'icons/obj/toy/toy.dmi'
	icon_state = "ship"

/obj/random/toy/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/toy/bosunwhistle,
		/obj/random/plush,
		/obj/item/sword/cult_toy,
		/obj/item/sword/katana/toy,
		/obj/item/toy/snappop,
		/obj/item/energy_blade/sword/toy,
		/obj/item/chems/water_balloon,
		/obj/item/gun/launcher/foam/crossbow,
		/obj/item/toy/blink,
		/obj/item/toy/prize/powerloader,
		/obj/item/toy/prize/fireripley,
		/obj/item/toy/prize/deathripley,
		/obj/item/toy/prize/gygax,
		/obj/item/toy/prize/durand,
		/obj/item/toy/prize/honk,
		/obj/item/toy/prize/marauder,
		/obj/item/toy/prize/seraph,
		/obj/item/toy/prize/mauler,
		/obj/item/toy/prize/odysseus,
		/obj/item/toy/prize/phazon,
		/obj/item/toy/spinningtoy,
		/obj/item/deck/cards
	)
	return spawnable_choices

/obj/random/plushie
	name = "random plushie"
	desc = "This is a random plushie."
	icon = 'icons/obj/toy/plush_cat.dmi'
	icon_state = ICON_STATE_WORLD

/obj/random/plushie/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/toy/plushie/mouse,
		/obj/item/toy/plushie/kitten,
		/obj/item/toy/plushie/lizard
	)
	return spawnable_choices

/obj/random/plushie/large
	name = "random large plushie"
	desc = "This is a random large plushie."
	icon = 'icons/obj/structures/plushie.dmi'
	icon_state = "droneplushie"

/obj/random/plushie/large/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/structure/plushie/ian,
		/obj/structure/plushie/drone,
		/obj/structure/plushie/carp,
		/obj/structure/plushie/beepsky
	)
	return spawnable_choices

/obj/random/action_figure
	name = "random action figure"
	desc = "This is a random action figure."
	icon = 'icons/obj/toy/toy.dmi'
	icon_state = "assistant"

/obj/random/action_figure/spawn_choices()
	var/static/list/spawnable_choices = list(
		/obj/item/toy/figure/cmo,
		/obj/item/toy/figure/assistant,
		/obj/item/toy/figure/atmos,
		/obj/item/toy/figure/bartender,
		/obj/item/toy/figure/borg,
		/obj/item/toy/figure/gardener,
		/obj/item/toy/figure/captain,
		/obj/item/toy/figure/cargotech,
		/obj/item/toy/figure/ce,
		/obj/item/toy/figure/chaplain,
		/obj/item/toy/figure/chef,
		/obj/item/toy/figure/chemist,
		/obj/item/toy/figure/clown,
		/obj/item/toy/figure/corgi,
		/obj/item/toy/figure/detective,
		/obj/item/toy/figure/dsquad,
		/obj/item/toy/figure/engineer,
		/obj/item/toy/figure/geneticist,
		/obj/item/toy/figure/hop,
		/obj/item/toy/figure/hos,
		/obj/item/toy/figure/qm,
		/obj/item/toy/figure/janitor,
		/obj/item/toy/figure/agent,
		/obj/item/toy/figure/librarian,
		/obj/item/toy/figure/md,
		/obj/item/toy/figure/mime,
		/obj/item/toy/figure/miner,
		/obj/item/toy/figure/ninja,
		/obj/item/toy/figure/wizard,
		/obj/item/toy/figure/rd,
		/obj/item/toy/figure/roboticist,
		/obj/item/toy/figure/scientist,
		/obj/item/toy/figure/syndie,
		/obj/item/toy/figure/secofficer,
		/obj/item/toy/figure/warden,
		/obj/item/toy/figure/psychologist,
		/obj/item/toy/figure/paramedic,
		/obj/item/toy/figure/ert
	)
	return spawnable_choices
