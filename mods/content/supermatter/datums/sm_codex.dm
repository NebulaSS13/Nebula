
/datum/codex_entry/guide/supermatter
	name = "Guide to Supermatter Engines"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/datum/codex_entry/supermatter
	associated_paths = list(/obj/structure/supermatter)
	mechanics_text = "When energized by a laser (or something hitting it), it emits radiation and heat.  If the heat reaches above 7000 kelvin, it will send an alert and start taking damage. \
	After integrity falls to zero percent, it will delaminate, causing a massive explosion, station-wide radiation spikes, and hallucinations. \
	Supermatter reacts badly to oxygen in the atmosphere.  It'll also heat up really quick if it is in vacuum.<br>\
	<br>\
	Supermatter cores are extremely dangerous to be close to, and requires protection to handle properly.  The protection you will need is:<br>\
	Optical meson scanners on your eyes, to prevent hallucinations when looking at the supermatter.<br>\
	Radiation helmet and suit, as the supermatter is radioactive.<br>\
	<br>\
	Touching the supermatter will result in *instant death*, with no corpse left behind!  You can drag the supermatter, but anything else will kill you. \
	It is advised to obtain a genetic backup before trying to drag it."
	antag_text = "Exposing the supermatter to oxygen or vacuum will cause it to start rapidly heating up.  Sabotaging the supermatter and making it explode will \
	cause a period of lag as the explosion is processed by the server, as well as irradiating the entire station and causing hallucinations to happen.  \
	Wearing radiation equipment will protect you from most of the delamination effects sans explosion."
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE