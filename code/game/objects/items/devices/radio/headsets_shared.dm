/obj/item/radio/headset/headset_cargo
	name = "supply radio headset"
	icon = 'icons/obj/items/device/radio/headsets/headset_cargo.dmi'
	encryption_keys = list(/obj/item/encryptionkey/cargo)

/obj/item/encryptionkey/cargo
	name = "supply radio encryption key"
	inlay_color = COLOR_ASSEMBLY_WHITE
	can_decrypt = list(access_cargo)

/obj/item/radio/headset/headset_mining
	name = "mining radio headset"
	desc = "Headset used by dwarves. It has an inbuilt subspace antenna for better reception."
	icon = 'icons/obj/items/device/radio/headsets/headset_mining.dmi'
	encryption_keys = list(/obj/item/encryptionkey/mining)

/obj/item/encryptionkey/mining
	name = "mining radio encryption key"
	inlay_color = COLOR_ASSEMBLY_WHITE
	can_decrypt = list(access_mining)
/obj/item/radio/headset/headset_sec
	name = "security radio headset"
	icon = 'icons/obj/items/device/radio/headsets/headset_security.dmi'
	encryption_keys = list(/obj/item/encryptionkey/sec)

/obj/item/encryptionkey/sec
	name = "security radio encryption key"
	inlay_color = COLOR_BLOOD_RED
	can_decrypt = list(access_security)

/obj/item/radio/headset/headset_med
	name = "medical radio headset"
	desc = "A headset for the trained staff of the medbay."
	icon = 'icons/obj/items/device/radio/headsets/headset_medical.dmi'
	encryption_keys = list(/obj/item/encryptionkey/med)

/obj/item/encryptionkey/med
	name = "medical radio encryption key"
	inlay_color = COLOR_ASSEMBLY_WHITE
	can_decrypt = list(access_medical)

/obj/item/radio/headset/headset_service
	name = "service radio headset"
	desc = "Headset used by the service staff, tasked with keeping everyone full, happy and clean."
	icon = 'icons/obj/items/device/radio/headsets/headset_service.dmi'
	encryption_keys = list(/obj/item/encryptionkey/service)

/obj/item/encryptionkey/service
	name = "service radio encryption key"
	inlay_color = COLOR_VERDANT_GREEN
	can_decrypt = list(access_bar)

/obj/item/radio/headset/headset_sci
	name = "science radio headset"
	desc = "A science-y headset. Like usual."
	icon = 'icons/obj/items/device/radio/headsets/headset_science.dmi'
	encryption_keys = list(/obj/item/encryptionkey/sci)

/obj/item/encryptionkey/sci
	name = "science radio encryption key"
	inlay_color = COLOR_SCIENCE_PURPLE
	can_decrypt = list(access_research)

/obj/item/radio/headset/headset_eng
	name = "engineering radio headset"
	desc = "When the engineers wish to gossip like high-schoolers."
	icon = 'icons/obj/items/device/radio/headsets/headset_engineering.dmi'
	encryption_keys = list(/obj/item/encryptionkey/eng)

/obj/item/encryptionkey/eng
	name = "engineering radio encryption key"
	inlay_color = PIPE_COLOR_YELLOW
	can_decrypt = list(access_engine)

/obj/item/radio/headset/heads
	icon_state = "com_headset"
	icon = 'icons/obj/items/device/radio/headsets/headset_command.dmi'
	encryption_keys = list(/obj/item/encryptionkey/command)

/obj/item/encryptionkey/command
	name = "command encryption key"
	inlay_color = COLOR_ROYAL_BLUE
	can_decrypt = list(access_bridge)

/obj/item/encryptionkey/heads
	color = COLOR_GOLD
	fill_color = COLOR_PALE_GOLD
	inlay_color = COLOR_ROYAL_BLUE

/obj/item/radio/headset/heads/ce
	name = "chief engineer's headset"
	desc = "The headset of the boss engineer."
	icon = 'icons/obj/items/device/radio/headsets/headset_engineering.dmi'
	encryption_keys = list(/obj/item/encryptionkey/heads/ce)

/obj/item/encryptionkey/heads/ce
	name = "chief engineer's encryption key"
	can_decrypt = list(
		access_bridge,
		access_engine
	)

/obj/item/radio/headset/heads/cmo
	name = "chief medical officer's headset"
	desc = "The headset of the boss medic."
	icon = 'icons/obj/items/device/radio/headsets/headset_medical.dmi'
	encryption_keys = list(/obj/item/encryptionkey/heads/cmo)

/obj/item/encryptionkey/heads/cmo
	name = "chief medical officer's encryption key"
	can_decrypt = list(
		access_bridge,
		access_medical
	)

/obj/item/radio/headset/heads/rd
	name = "research director's headset"
	desc = "The headset of the boss egghead."
	icon = 'icons/obj/items/device/radio/headsets/headset_science.dmi'
	encryption_keys = list(/obj/item/encryptionkey/heads/rd)

/obj/item/encryptionkey/heads/rd
	name = "research director's encryption key"
	can_decrypt = list(
		access_bridge,
		access_research
	)

/obj/item/radio/headset/heads/captain
	name = "captain's headset"
	desc = "The headset of the boss."
	encryption_keys = list(/obj/item/encryptionkey/heads/captain)

/obj/item/encryptionkey/heads/captain
	name = "captain's encryption key"
	can_decrypt = list(
		access_bridge,
		access_security,
		access_engine,
		access_research,
		access_medical,
		access_cargo,
		access_bar,
		access_explorer
	)

/obj/item/radio/headset/heads/hop
	name = "head of personnel's headset"
	desc = "The headset of the guy who will one day be captain."
	encryption_keys = list(/obj/item/encryptionkey/heads/hop)

/obj/item/encryptionkey/heads/hop
	name = "head of personnel's encryption key"
	can_decrypt = list(
		access_bar,
		access_cargo,
		access_bridge,
		access_security,
		access_mining,
		access_explorer
	)

/obj/item/radio/headset/heads/hos
	name = "head of security's headset"
	desc = "The headset of the man who protects your worthless lives."
	icon = 'icons/obj/items/device/radio/headsets/headset_security.dmi'
	encryption_keys = list(/obj/item/encryptionkey/heads/hos)

/obj/item/encryptionkey/heads/hos
	name = "head of security's encryption key"
	inlay_color = COLOR_BLOOD_RED
	can_decrypt = list(
		access_bridge,
		access_security
	)

/obj/item/encryptionkey/ert
	name = "\improper ERT radio encryption key"
	can_decrypt = list(access_cent_specops)

/obj/item/encryptionkey/ert/Initialize(ml, material_key)
	. = ..()
	can_decrypt |= get_all_station_access()

/obj/item/radio/headset/ert
	name = "emergency response team radio headset"
	desc = "The headset of the boss's boss."
	icon = 'icons/obj/items/device/radio/headsets/headset_admin.dmi'
	encryption_keys = list(/obj/item/encryptionkey/ert)

/obj/item/encryptionkey/mercenary
	origin_tech = @'{"esoteric":2}'
	can_decrypt = list(access_mercenary)

/obj/item/radio/headset/mercenary
	can_use_analog = TRUE
	origin_tech = @'{"esoteric":2}'
	encryption_keys = list(/obj/item/encryptionkey/mercenary)
	analog_secured = list((access_mercenary) = TRUE)

/obj/item/radio/headset/mercenary/commando
	encryption_keys = list(
		/obj/item/encryptionkey/mercenary,
		/obj/item/encryptionkey/hacked
	)

/obj/item/encryptionkey/entertainment
	name = "entertainment radio key"

/obj/item/radio/headset/entertainment
	name = "actor's radio headset"
	desc = "Specially made to make you sound less cheesy."
	icon = 'icons/obj/items/device/radio/headsets/headset_command.dmi'
	encryption_keys = list(/obj/item/encryptionkey/entertainment)

/obj/item/encryptionkey/raider
	origin_tech = @'{"esoteric":2}'
	can_decrypt = list(access_raider)

/obj/item/radio/headset/raider
	can_use_analog = TRUE
	origin_tech = @'{"esoteric":2}'
	encryption_keys = list(/obj/item/encryptionkey/raider)
	analog_secured = list((access_raider) = TRUE)

/obj/item/encryptionkey/hacked
	can_decrypt = list(access_hacked)
	origin_tech = @'{"esoteric":3}'

/obj/item/encryptionkey/hacked/Initialize(ml, material_key)
	. = ..()
	can_decrypt |= get_all_station_access()

/obj/item/radio/headset/hacked
	origin_tech = @'{"esoteric":3}'
	encryption_keys = list(/obj/item/encryptionkey/hacked)

// Bowman alts
/obj/item/radio/headset/headset_mining/bowman
	name = "mining bowman radio headset"
	icon = 'icons/obj/items/device/radio/headsets/headset_mining_alt.dmi'

/obj/item/radio/headset/headset_cargo/bowman
	name = "supply bowman headset"
	icon = 'icons/obj/items/device/radio/headsets/headset_cargo_alt.dmi'


/obj/item/radio/headset/corp_cmo/bowman
	name = "chief medical officer's bowman headset"
	icon = 'icons/obj/items/device/radio/headsets/headset_command_alt.dmi'

/obj/item/radio/headset/corp_ce/bowman
	name = "chief engineer's bowman headset"
	icon = 'icons/obj/items/device/radio/headsets/headset_command_alt.dmi'

/obj/item/radio/headset/corp_captain/bowman
	name = "captain's bowman headset"
	icon = 'icons/obj/items/device/radio/headsets/headset_command_alt.dmi'


/obj/item/radio/headset/heads/bowman
	name = "command bowman headset"
	desc = "A headset with a commanding channel."
	icon = 'icons/obj/items/device/radio/headsets/headset_command_alt.dmi'

/obj/item/radio/headset/headset_med/bowman
	name = "medical bowman headset"
	icon = 'icons/obj/items/device/radio/headsets/headset_medical_alt.dmi'

/obj/item/radio/headset/headset_eng/bowman
	name = "engineering bowman headset"
	icon = 'icons/obj/items/device/radio/headsets/headset_engineering_alt.dmi'

/obj/item/radio/headset/headset_sec/bowman
	name = "security bowman headset"
	icon = 'icons/obj/items/device/radio/headsets/headset_security_alt.dmi'