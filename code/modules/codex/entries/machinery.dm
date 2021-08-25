/datum/codex_entry/airlock
	associated_paths = list(/obj/machinery/door/airlock)
	associated_strings = list("airlock", "door", "hatch")
	mechanics_text = "An airtight mechanical door. Most airlocks require an ID to open (wearing it on your ID slot is enough), and many have special access requirements to be on your ID. You can open an airlock by clicking on one, or simply walking into it, and clicking on an open airlock will close it. If the lights on the door flash red, you don't have the required access to open the airlock, and if they're consistently red, the door is bolted. Airlocks also require power to operate. In a situation without power, a crowbar can be used to force it open. <BR><BR>Airlocks can also be <span codexlink='hacking'>hacked</span>.<BR>Airlock hacking information:<BR>* Door bolts will lock the door, preventing it from being opened by any means until the bolts are raised again. Pulsing the correct wire will toggle the bolts, but cutting it will only drop them.<BR>* IDscan light indicates the door can scan ID cards. If the wire for this is pulsed it will cause the door to flash red, and cutting it will cause doors with restricted access to be unable to scan ID, essentially locking it.<BR>* The AI control light shows whether or not AI and robots can control the door. Pulsing is only temporary, while cutting is more permanent.<BR>* The test light shows whether the door has power or not. When turned off, the door can be opened with a crowbar.<BR>* If the door sparks, it is electrified. Pulsing the corresponding wire causes this to happen for 30 seconds, and cutting it electrifies the door until mended.<BR>* The check wiring light will turn on if the safety is turned off. This causes the airlock to close even when someone is standing on it, crushing them.<BR>* If the Check Timing Mechanism light is on then the door will close much faster than normal. Dangerous in conjuction with the Check Wiring light.<BR><BR><B>Deconstruction</B><BR>To pull apart an airlock, you must open the maintenance panel, disable the power via hacking (or any other means), weld the door shut, and crowbar the electroncs out, cut the wires with a wirecutter, unsecure the whole assembly with a wrench, and then cut it into metal sheets with a welding tool."
	antag_text = "Electrifying a door makes for a good trap, hurting and stunning whoever touches it. The same goes for a combination of disabling the safety and timing mechanisms. Bolting a door can also help ensure privacy, or slow down those in search of you. It's also a good idea to disable AI interaction when needed."

/datum/codex_entry/computer
	associated_paths = list(/obj/machinery/computer, /obj/machinery/constructable_frame/computerframe)
	associated_strings = list("computer","console")
	mechanics_text = "(This entry refers to the older single-purpose computers, not <span codexlink='modular computer'>modular computers</span>.)<BR><BR> \
	Computers are used primarily for controlling other machines and systems, or for providing information about said systems. They require power to function and run off the Equipment power channel on an APC. and sometimes requries ID access. \
	<BR><BR><b>Constructing a computer:</b><BR> \
	1.) Use 5 steel sheets to construct a computer frame at your location. You may then move it by dragging, or rotate it with alt+click, if desired. <BR> \
	2.) Use a wrench on the frame to secure it to the floor.<BR> \
	3.) Use a cable coil on the frame. It will require 5 lengths of cables.<BR> \
	4.) Insert a circuit board into the frame. The circuit board you use determines what function the computer will have. It must also be a circuit board for a computer, not a different kind of machine.<BR> \
	5.) Use a screwdriver on the frame to secure the board.<BR> \
	6.) Insert a console screen, and an input controller.<BR> \
	7.) Insert a tesla link receptor so the computer may receive power from a local APC.<BR> \
	8.) Use a screwdriver to close the panel. \
	<BR><BR><B>Deconstructing a computer</B><BR> \
	1.) Use a screwdriver to open the panel. <BR> \
	2.) Use a crowbar to remove all of the parts. If you only want to remove SOME parts, use a wrench.<BR> \
	3.) Use a wirecutter to remove the cables.<BR> \
	4.) Use a wrench on to take the frame apart.<BR> \
	5.) Use a welder to cut the frame into sheets."

/datum/codex_entry/computer/modular
	associated_paths = list(/obj/machinery/computer/modular)
	associated_strings = list("modular computer")
	lore_text = "Modular computers allow for customized hardware and downloadable software, enabling users to create their own workplace experience."
	mechanics_text = "(This entry is for Modular Computers. Modular Computers are not the same as regular <span codexlink='computer'>computers</span>.)<BR><BR> \
	Modular computers can have a variety of functions depending on the installed hardware and software. They also come available as tablets, laptops, wallscreens and PDA.<BR>\
	* The computer can be shutdown via the interface to save power, and can also be forced to shutdown by right clicking the computer itself(or using the verb Force-Shutdown).<BR> \
	* Hardware can be disabled/enabled from the Computer Configuration Tool, software can be downloaded using the Software Download Tool(if a network card is installed), and programs/files can be removed from the computer using the File Manager.<BR> \
	* Portable storage can be inserted by hand, and removed using right click(or the verb Eject-Portable-Storage).<BR>\
	* If the computer has a RFID card slot, ID cards can be inserted by hand, and removed using right click(or the verb Remove-ID)<BR> \
	* PDA usually come with a pen, which can be remove with the right click menu(or Remove-Pen verb). The pen can be inserted again by using it on the PDA."
	antag_text = "You can use an emag on the computer to reveal a secret list of downloadable software."

/datum/codex_entry/conveyor_construct
	associated_paths = list(/obj/machinery/conveyor, /obj/item/conveyor_construct)
	mechanics_text = "This device must be connected to a switch assembly before placement by clicking the switch on the conveyor belt assembly. When active it will move objects on top of it to the adjacent space based on its direction and if it is runnnig in forward or reverse mode. Can be removed with a crowbar."

/datum/codex_entry/conveyor_construct
	associated_paths = list(/obj/machinery/conveyor_switch,/obj/machinery/conveyor_switch/oneway,/obj/item/conveyor_switch_construct,/obj/item/conveyor_switch_construct/oneway)
	mechanics_text = "This device can connect to a number of conveyor belts and control their movement. A two-way switch will allow you to make the conveyors run in forward and reverse mode, the one-way switch will only allow one direction. Can be removed with a crowbar."

/datum/codex_entry/cryopod
	associated_paths = list(/obj/machinery/cryopod)
	mechanics_text = "To enter a cryopod, or put someone in a cryopod, click+drag. When someone is in a cryopod, and they use the <i>ghost</i> verb, their character will despawn, be removed from the game round along with all their belongings, and freeing their job slot for someone else to take. This also occurs if a character is inside a cryopod for 15 minutes. Any particularly important belongings that the game can't do without will be stored. The item can then be retrieved from the nearby oversight console."

/datum/codex_entry/diffuser_machine
	associated_paths = list(/obj/machinery/shield_diffuser)
	mechanics_text = "This device disrupts shields on directly adjacent tiles (in a + shaped pattern). They are commonly installed around exterior airlocks to prevent shields from blocking EVA access."

/datum/codex_entry/disposal
	associated_paths = list(/obj/machinery/disposal)
	mechanics_text = "A high-tech garbage bin. Inserting an item causes the disposal unit (after a delay) to pneumatically launch the item through a series of pipes leading to either a garbage processing room, or space, depending on the ship/station. Larger objects can be inserted via click+drag. <BR> You can remove a disposal unit by turning it off, using a screwdriver, then a welding tool, and removing the floor tile underneath it."
	antag_text = "People can be inserted into the disposal unit. If they're capable of moving however, it's easy for them to get out. Be careful though, putting things in disposal units doesn't always mean they're gone forever. <BR>If you turn it off, it can be used to hide in. Just be careful no one turns it back on while you're still in there!"

/datum/codex_entry/emitter
	associated_paths = list(/obj/machinery/power/emitter)
	mechanics_text = "You must secure this in place with a wrench and weld it to the floor before using it. The emitter will only fire if it is installed above a cable endpoint. Clicking will toggle it on and off, at which point, so long as it remains powered, it will fire in a single direction in bursts of four."
	lore_text = "Lasers like this one have been in use for ages, in applications such as mining, cutting, and in the startup sequence of many advanced space station and starship engines."
	antag_text = "This baby is capable of slicing through walls, sealed lockers, and people."

/datum/codex_entry/fusion_fuel_injector
	associated_paths = list(/obj/machinery/fusion_fuel_injector, /obj/machinery/computer/fusion/fuel_control)
	associated_strings = list("fuel injector","fuel injection control computer")
	lore_text = "A simple magnetic accelerator used to inject small pellets of fuel into a fusion field."
	mechanics_text = "Accepts a fuel rod produced by the fuel compressor and regularly fires fuel pellets into the fusion field. Rods can be swapped by hand when the injector is not firing. Power outages will require the injector to be turned on again. If there is no electromagnetic field active to catch the injected fuel, the results can be very unhealthy for anyone standing in the firing path. <BR>Controlled via the fuel injection control computer."

/datum/codex_entry/fusion_core
	associated_paths = list(/obj/machinery/power/fusion_core, /obj/machinery/computer/fusion/core_control)
	associated_strings = list("R-UST Mk. 8 Tokamak core","\improper R-UST Mk. 8 core control","rust","fusion","tokamak")
	lore_text = "An old but more or less reliable fusion field generator. Probably sourced from a retired cargo freighter."
	mechanics_text = "Generates the field used to contain reaction material from fuel injectors, and dumps power into the power network under it based on plasma heat. Needs 500W or more in the network to start the field. Field will become unstable if it intersects with windows or other objects, and from some reactions, and will eventually rupture violently if not stabilized by a gyrotron. Turning the field off without letting it cool below 1000K will cause a violent explosion and EMP depending on the contents of the field. <BR>Controlled via the R-UST Mk. 8 core control. Make careful note of the instability."
	antag_text = "Be careful when blowing this thing up. The blast is fairly large and can happen instantly depending how you do it."

/datum/codex_entry/fuel_compressor
	associated_paths = list(/obj/machinery/fuel_compressor)
	lore_text = "A highly secret design that can compress many varieties of solid and liquid matter into fuel rods for nuclear power production."
	mechanics_text = "Uses sheets of material or units of reagents to produce fuel rods. Material/units are inserted by hand. Can also have some objects click-dragged onto it for more exotic fuel."

/datum/codex_entry/gyrotron
	associated_paths = list(/obj/machinery/power/emitter/gyrotron, /obj/machinery/computer/fusion/gyrotron)
	associated_strings = list ("gyrotron","gyrotron control console")
	lore_text = "A high-power industrial laser used to excite plasma for fusion reactions. Also used to excite careless engineers, usually fatally."
	mechanics_text = "Fires in pulses and will heat up a plasma toroid that is below 1000K. Mostly used to lower field instability after heating it to ignition point. Very power hungry, uses 20k per point of power. <BR>Controlled via the gyrotron control console."

/datum/codex_entry/pacman
	associated_paths = list(/obj/machinery/power/port_gen/pacman)
	mechanics_text = "Lends itself to being portable thanks to the small size and ease of use. Some versions use radioactive fuel and as such produces radiation, while others may produce dangerous byproducts as gasses. Ideally one should wear protective gear while interacting with an active generator. While active it also produces heat and will eventually overheat and explode. While the power output can be increased, doing this causes it to heat up faster. Must be secured using a wrench before use."
	antag_text = "Can be used as a makeshift delayed explosive when power output is set to unsafe levels, though it may take some time to go off."

/datum/codex_entry/replicator
	associated_paths = list(/obj/machinery/fabricator/replicator)
	mechanics_text = "The food replicator is operated through voice commands. To inquire available dishes on the menu, say 'menu'. To dispense a dish, say the name of the dish listed in its menu. Dishes can only be produced as long as the replicator has biomass. To check on the biomass level of the replicator, say 'status'. Various food items or plants may be inserted to refill biomass."

/datum/codex_entry/smes
	associated_paths = list(/obj/machinery/power/smes)
	mechanics_text = "It's a big battery. An important part of the power network that ensures that you still have power when your generators eventually explode. Maximum input and output settings are available. <BR>The lights on the front show the status of the SMES: The column on the left shows stored power, a blinking red light at top right shows that it's on but receiving no power, blinking yellow shows that the SMES is charging, and the little light on the middle right shows whether it's outputting power or not. <BR>A floor terminal puts power into the SMES, and power is output to a wire underneath."

/datum/codex_entry/vending
	associated_paths = list(/obj/machinery/vending)
	associated_strings = list("vendomat","vending machine")
	mechanics_text = "A machine that dispenses items from a category of items at the user's selection.<BR>Vending machines sometimes require payment via an ID card, cash or charge card. Some dispense items for free, and such vending machines are usually access restricted. Items that have been dispensed can sometimes be returned simply by inserting it back into the vending machine by hand. Vending machines can also be restocked with an appropriate Vendor Restock, usually ordered via supply management, and then click+dragged onto the vending machine.<BR><BR>Vending machines can be <span codexlink='hacking'>hacked</span>.<BR><b>Vending machine hacking</b><BR>* The orange light shows if the vending machine is electrified.<BR>* The red light indicates whether or not the vending machine is firing out its contents randomly. Sometimes this can happen as a random event.<BR>* The green light indicates whether or not the vending machine is dispensing it's hidden inventory. Nearly every vending machine has a list of secret goods that are usually considered to be contraband.<BR>* The purple or yellow light shows whether or not the ID scanner for the vending machine is working. When this function is disabled, anyone can access the vending machine, even if it normally has restricted access."
	antag_text = "Accessing the secret inventory of a vending machine can sometimes be very useful, especially for department focused machines."