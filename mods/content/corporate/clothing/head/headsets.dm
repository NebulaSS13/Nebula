/obj/item/radio/headset/corp_sec
	name = "security radio headset"
	desc = "This is used by your elite security force."
	icon = 'mods/content/corporate/icons/headsets/headset_security.dmi'
	encryption_keys = list(/obj/item/encryptionkey/corp_sec)

/obj/item/encryptionkey/corp_sec
	name = "corporate security radio encryption key"
	icon_state = "srv_cypherkey"
	can_decrypt = list(access_security)

/obj/item/radio/headset/corp_sec/bowman
	name = "security bowman headset"
	icon = 'mods/content/corporate/icons/headsets/headset_security_alt.dmi'

/obj/item/radio/headset/corp_eng
	name = "engineering radio headset"
	desc = "When the engineers wish to share the office gossip."
	icon = 'mods/content/corporate/icons/headsets/headset_engineering.dmi'
	encryption_keys = list(/obj/item/encryptionkey/corp_eng)

/obj/item/encryptionkey/corp_eng
	name = "corporate engineering radio encryption key"
	icon_state = "eng_cypherkey"
	can_decrypt = list(access_engine)

/obj/item/radio/headset/corp_eng/bowman
	name = "engineering bowman headset"
	icon = 'mods/content/corporate/icons/headsets/headset_engineering_alt.dmi'

/obj/item/radio/headset/corp_rob
	name = "robotics radio headset"
	desc = "Made specifically for the roboticists who cannot decide between departments."
	icon = 'mods/content/corporate/icons/headsets/headset_robotics.dmi'
	encryption_keys = list(/obj/item/encryptionkey/corp_rob)

/obj/item/encryptionkey/corp_rob
	name = "corporate robotics radio encryption key"
	icon_state = "rob_cypherkey"
	can_decrypt = list(access_robotics, access_research, access_medical)

/obj/item/radio/headset/corp_med
	name = "medical radio headset"
	desc = "A headset for the trained staff of the medbay."
	icon = 'mods/content/corporate/icons/headsets/headset_medical.dmi'
	encryption_keys = list(/obj/item/encryptionkey/corp_med)

/obj/item/encryptionkey/corp_med
	name = "corporate medical radio encryption key"
	icon_state = "med_cypherkey"
	can_decrypt = list(access_medical)

/obj/item/radio/headset/corp_med/bowman
	name = "medical bowman headset"
	icon = 'mods/content/corporate/icons/headsets/headset_medical_alt.dmi'

/obj/item/radio/headset/corp_sci
	name = "science radio headset"
	desc = "A sciency headset. Like usual."
	icon = 'mods/content/corporate/icons/headsets/headset_science.dmi'
	encryption_keys = list(/obj/item/encryptionkey/corp_sci)

/obj/item/encryptionkey/corp_sci
	name = "corporate science radio encryption key"
	icon_state = "sci_cypherkey"
	can_decrypt = list(access_research)

/obj/item/radio/headset/corp_medsci
	name = "medical research radio headset"
	desc = "A headset that is a result of the mating between medical and science."
	icon = 'mods/content/corporate/icons/headsets/headset_medical.dmi'
	encryption_keys = list(/obj/item/encryptionkey/corp_sci, /obj/item/encryptionkey/corp_med)

/obj/item/radio/headset/corp_com
	name = "command radio headset"
	desc = "A headset with a commanding channel."
	icon = 'mods/content/corporate/icons/headsets/headset_command.dmi'
	encryption_keys = list(/obj/item/encryptionkey/corp_com)

/obj/item/encryptionkey/corp_com
	name = "corporate command encryption key"
	icon_state = "com_cypherkey"
	can_decrypt = list(access_bridge)

/obj/item/radio/headset/corp_com/bowman
	name = "command bowman headset"
	desc = "A headset with a commanding channel."
	icon = 'mods/content/corporate/icons/headsets/headset_command_alt.dmi'

/obj/item/radio/headset/corp_captain
	name = "captain's headset"
	desc = "The headset of the boss."
	icon = 'mods/content/corporate/icons/headsets/headset_command.dmi'
	encryption_keys = list(/obj/item/encryptionkey/corp_com)

/obj/item/encryptionkey/corp_cap
	name = "corporate captain encryption key"
	icon_state = "cap_cypherkey"

/obj/item/encryptionkey/corp_cap/Initialize(ml, material_key)
	can_decrypt = get_all_station_access()
	. = ..()

/obj/item/radio/headset/corp_captain/bowman
	name = "captain's bowman headset"
	icon = 'mods/content/corporate/icons/headsets/headset_command_alt.dmi'

/obj/item/radio/headset/corp_rd
	name = "chief science officer's headset"
	desc = "Headset of the researching God."
	icon = 'mods/content/corporate/icons/headsets/headset_command.dmi'
	encryption_keys = list(/obj/item/encryptionkey/corp_com, /obj/item/encryptionkey/corp_sci)

/obj/item/radio/headset/corp_hos
	name = "head of security's headset"
	desc = "The headset of the man who protects your worthless lives."
	icon = 'mods/content/corporate/icons/headsets/headset_command.dmi'
	encryption_keys = list(/obj/item/encryptionkey/corp_com, /obj/item/encryptionkey/corp_sec)

/obj/item/radio/headset/corp_ce
	name = "chief engineer's headset"
	desc = "The headset of the guy who is in charge of morons."
	icon = 'mods/content/corporate/icons/headsets/headset_command.dmi'
	encryption_keys = list(/obj/item/encryptionkey/corp_com, /obj/item/encryptionkey/corp_eng)

/obj/item/radio/headset/corp_ce/bowman
	name = "chief engineer's bowman headset"
	icon = 'mods/content/corporate/icons/headsets/headset_command_alt.dmi'

/obj/item/radio/headset/corp_cmo
	name = "chief medical officer's headset"
	desc = "The headset of the highly trained medical chief."
	icon = 'mods/content/corporate/icons/headsets/headset_command_alt.dmi'
	encryption_keys = list(/obj/item/encryptionkey/corp_com, /obj/item/encryptionkey/corp_med)

/obj/item/radio/headset/corp_cmo/bowman
	name = "chief medical officer's bowman headset"
	icon = 'mods/content/corporate/icons/headsets/headset_command_alt.dmi'

/obj/item/radio/headset/corp_hop
	name = "head of personnel's headset"
	desc = "The headset of the guy who will one day be captain."
	icon = 'mods/content/corporate/icons/headsets/headset_command.dmi'
	encryption_keys = list(/obj/item/encryptionkey/corp_com, /obj/item/encryptionkey/corp_srv)

/obj/item/radio/headset/corp_service
	name = "service radio headset"
	desc = "Headset used by the service staff, tasked with keeping everyone full, happy and clean."
	icon = 'mods/content/corporate/icons/headsets/headset_service.dmi'
	encryption_keys = list(/obj/item/encryptionkey/corp_srv)

/obj/item/encryptionkey/corp_srv
	name = "corporate service encryption key"
	icon_state = "srv_cypherkey"
	can_decrypt = list(access_bar)

/obj/item/radio/headset/corp_ert
	name = "emergency response team radio headset"
	desc = "The headset of the boss's boss."
	icon = 'mods/content/corporate/icons/headsets/headset_command.dmi'
	encryption_keys = list(/obj/item/encryptionkey/corp_ert, /obj/item/encryptionkey/corp_cap)

/obj/item/encryptionkey/corp_ert
	name = "corporate ERT radio encryption key"
	can_decrypt = list(access_cent_specops)

/obj/item/radio/headset/corp_ia
	name = "internal affair's headset"
	desc = "The headset of your worst enemy."
	icon = 'mods/content/corporate/icons/headsets/headset_command.dmi'
	encryption_keys = list(/obj/item/encryptionkey/corp_com)

/obj/item/radio/headset/corp_mining
	name = "mining radio headset"
	desc = "Headset used by dwarves. It has an inbuilt subspace antenna for better reception."
	icon = 'mods/content/corporate/icons/headsets/headset_mining.dmi'
	encryption_keys = list(/obj/item/encryptionkey/corp_srv)

/obj/item/radio/headset/corp_mining/bowman
	name = "mining bowman radio headset"
	icon = 'mods/content/corporate/icons/headsets/headset_mining_alt.dmi'

/obj/item/radio/headset/corp_cargo
	name = "supply radio headset"
	desc = "A headset used by the box-pushers."
	icon = 'mods/content/corporate/icons/headsets/headset_cargo.dmi'
	encryption_keys = list(/obj/item/encryptionkey/corp_cargo)

/obj/item/encryptionkey/corp_cargo
	name = "corporate supply encryption key"
	icon_state = "srv_cypherkey"
	can_decrypt = list(access_cargo)

/obj/item/radio/headset/corp_cargo/bowman
	name = "supply bowman headset"
	icon = 'mods/content/corporate/icons/headsets/headset_cargo_alt.dmi'
