/datum/codex_entry/supermatter
	associated_paths = list(/obj/machinery/power/supermatter)
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
	antag_text = "Exposing the supermatter to oxygen or vaccum will cause it to start rapidly heating up.  Sabotaging the supermatter and making it explode will \
	cause a period of lag as the explosion is processed by the server, as well as irradiating the entire station and causing hallucinations to happen.  \
	Wearing radiation equipment will protect you from most of the delamination effects sans explosion."
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/datum/codex_entry/apc
	associated_paths = list(/obj/machinery/power/apc)
	mechanics_text = "An APC (Area Power Controller) regulates and supplies backup power for the area they are in. Their power channels are divided \
	out into 'environmental' (items that manipulate airflow and temperature), 'lighting' (the lights), and 'equipment' (everything else that consumes power).  \
	Power consumption and backup power cell charge can be seen from the interface, further controls (turning a specific channel on, off or automatic, \
	toggling the APC's ability to charge the backup cell, or toggling power for the entire area via master breaker) first requires the interface to be unlocked \
	with an ID with Engineering access or by one of the station's robots or the artificial intelligence."
	antag_text = "This can be emagged to unlock it.  It will cause the APC to have a blue error screen. \
	Wires can be pulsed remotely with a signaler attached to it.  A powersink will also drain any APCs connected to the same wire the powersink is on."
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/datum/codex_entry/inflatable_item
	associated_paths = list(/obj/item/inflatable, /obj/structure/inflatable, /obj/structure/inflatable/door)
	mechanics_text = "Inflate by using it in your hand.  The inflatable barrier will inflate on your tile.  To deflate it, use the 'deflate' verb. Hitting this with any object will probably puncture and break it forever.<br>Walls are static, but doors may be clicked to open or close them. They only stop air while closed."
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/datum/codex_entry/welding_pack
	associated_paths = list(/obj/item/chems/weldpack, /obj/item/chems/weldpack/empty)
	mechanics_text = "This pack acts as a portable source of welding fuel. Use a welder on it to refill its tank - but make sure it's not lit! You can use this kit on a fuel tank or appropriate reagent dispenser to replenish its reserves."
	lore_text = "The Shenzhen Chain of 2133 was an industrial accident of noteworthy infamy that occurred at Earth's L3 Lagrange Point. An apprentice welder, working for the Shenzhen Space Fabrication Group, failed to properly seal her fuel port, triggering a chain reaction that spread from laborer to laborer, instantly vaporizing a crew of fourteen. Don't let this happen to you!"
	antag_text = "In theory, you could hold an open flame to this pack and produce some pretty catastrophic results. The trick is getting out of the blast radius."
	disambiguator = "equipment"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/datum/codex_entry/gripper
	associated_paths = list(/obj/item/gripper)
	mechanics_text = "Click an item to pick it up with your gripper. Use it as you would normally use anything in your hand. The Drop Item verb will allow you to release the item."
	disambiguator = "equipment"
	include_subtypes = TRUE
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/datum/codex_entry/diffuser_item
	associated_paths = list(/obj/item/shield_diffuser)
	mechanics_text = "This device disrupts shields on directly adjacent tiles (in a + shaped pattern), in a similar way the floor mounted variant does. It is, however, portable and run by an internal battery. Can be recharged with a regular recharger."
	disambiguator = "equipment"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/datum/codex_entry/solars
	associated_paths = list(/obj/item/solar_assembly, /obj/machinery/power/solar, /obj/machinery/power/tracker, /obj/machinery/power/solar_control)
	associated_strings = list("solar array")
	lore_text = "'At Greencorps we love the environment, and space. With this package you are able to help mother nature and produce energy without any usage of fossil fuels! Singularity energy is dangerous while solar energy is safe, which is why it's better. Now here is how you set up your own solar array...''"
	mechanics_text = "A solar array is a source of power for your ship or station, utalizing a series of panels on the outside of the ship/station. A computer console is used to control the array, with the help of a solar tracker.<BR> \
	<BR><b>Using the console</b><BR> \
	The solar panel control console must be connected via cables to the solar panels and tracker to excercise control. Additionally, the user must use the 'Search for devices button' to finish the connection.<BR>Using the console, you can manually rotate the array orientation to match the direction of the nearest star, after which you can set a timed tracking rate, causing the array to rotate clockwise at the set rate. Ideally though a solar tracker is connected and you set the tracking settings to auto, allowing the array to rotate on its own. \
	<BR><BR><B>Setting up a solar array</B><BR> \
	Setting up a solar array requires solar panel assemblies, glass sheets, cables, tracker electronics, and all the parts to make a solar panel control computer. All of the panels and the tracker must be outside (exposed to the sun) but the computer can be inside, and probably should be.<BR> \
	1.) Lay down the <span codexlink='cables'>cables</span>. The computer and all the solar assemblies must each have a cable 'knot' underneath, so make sure there is a knot for everything you plan. All the cables must lead back to the computer (and of course the rest of the power network).<BR> \
	2.) Place solar panel assemblies upon the knots, and then wrench the assemblies into place.<BR> \
	3.) Insert the tracker electronics into one of the solar panel assemblies. <BR> \
	4.) Add glass to every solar panel assembly, including the one with the tracker electronics.<BR> \
	5.) Make a computer frame out of steel and install a circuit board (solar control console).<BR> \
	If at any point you need to move a solar panel, use a crowbar to remove the glass, a wrench to unsecure the assembly, and a wirecutter to remove the cables."
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/datum/codex_entry/cable
	associated_paths = list(/obj/structure/cable, /obj/item/stack/cable_coil)
	associated_strings = list("cables")
	mechanics_text = "Cables are used to transfer power and form power networks. Usually power is transfered via cables from a SMES to an APC for the majority of the ship/station. Cables also serve a purpose in constructing machinery, as a component. <BR>Hold a cable coil in one hand, and click it with the other to split the stack. Cables come in a variety of colours and can be painted using a cable painter. Right click on a cable coil to make cable restraints using 15 cables.<BR><BR> \
	<B>Laying Cables</B><ul> \
	<li>Cables can only be placed on plating. Tiles must be removed using a crowbar, if any.</li> \
	<li>When using a cable coil on the plating you are standing on, a cable 'knot' is created in the middle with the cable extending outwards in the direction you are facing.</li> \
	<li>When using a cable coil on an adjacent plating to the one you are standing upon, a knot is created with the cable extended towards you.</li> \
	<li>If you use a cable coil on a knot on an adjacent plating, the cable will be 'pulled' towards you from the knot end with the other end still in place, allowing you to curve cables for more complicated networks.</li> \
	<li>Knots are also used for certain machines to connect directly to a power network, usually by having the machine secured to the same plating as the knot is on, like the SMES. However, knots shouldn't exist within the network otherwise. Try to smooth those out.</li> \
	<li>To lay a cable between decks (z-levels), use a cable on an open space from the deck above, dropping it down to the level below.</li></ul>"
	antag_text = "Sometimes a carefully cut cable in the right place can cause power issues over a wide area once APCs start to run out. Just make sure to hide it after."
	include_subtypes = TRUE
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE