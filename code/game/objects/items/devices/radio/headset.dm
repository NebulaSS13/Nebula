/obj/item/radio/headset
	name = "radio headset"
	desc = "An updated, modular intercom that fits over the head. Takes encryption keys."
	icon = 'icons/obj/items/device/radio/headsets/headset.dmi'
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/metal/aluminium
	subspace_transmission = 1
	canhear_range = 0 // can't hear headsets from very far away

	slot_flags = SLOT_EARS
	cell = null
	power_usage = 0

	var/radio_desc = ""
	var/translate_binary = 0
	var/list/encryption_keys = list()
	var/max_keys = 2

	//left for backward compatability
	var/ks1type = /obj/item/encryptionkey
	var/ks2type = null

/obj/item/radio/headset/Initialize()
	. = ..()
	internal_channels.Cut()
	for(var/T in encryption_keys)
		if(ispath(T))
			encryption_keys = new T(src)
	if(ks1type)
		encryption_keys += new ks1type(src)
	if(ks2type)
		encryption_keys += new ks2type(src)
	recalculateChannels(1)

/obj/item/radio/headset/Destroy()
	QDEL_NULL_LIST(encryption_keys)
	return ..()

/obj/item/radio/headset/list_channels(var/mob/user)
	return list_secure_channels()

/obj/item/radio/headset/examine(mob/user, distance)
	. = ..()
	if(distance > 1 || !radio_desc)
		return

	to_chat(user, "The following channels are available:")
	to_chat(user, radio_desc)

/obj/item/radio/headset/handle_message_mode(mob/living/M, message, channel)
	if (channel == "special")
		if (translate_binary)
			var/decl/language/binary = decls_repository.get_decl(/decl/language/binary)
			binary.broadcast(M, message)
		return null

	return ..()

/obj/item/radio/headset/receive_range(freq, level, aiOverride = 0)
	if (aiOverride)
		return ..(freq, level)
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		if(H.l_ear == src || H.r_ear == src)
			return ..(freq, level)
	return -1

/obj/item/radio/headset/syndicate
	origin_tech = "{'esoteric':3}"
	syndie = 1
	ks1type = /obj/item/encryptionkey/syndicate

/obj/item/radio/headset/syndicate/alt
	icon = 'icons/obj/items/device/radio/headsets/headset_syndicate.dmi'

/obj/item/radio/headset/syndicate/Initialize()
	. = ..()
	set_frequency(SYND_FREQ)

/obj/item/radio/headset/raider
	origin_tech = "{'esoteric':2}"
	syndie = 1
	ks1type = /obj/item/encryptionkey/raider

/obj/item/radio/headset/raider/Initialize()
	. = ..()
	set_frequency(RAID_FREQ)

/obj/item/radio/headset/binary
	origin_tech = "{'esoteric':3}"
	ks1type = /obj/item/encryptionkey/binary

/obj/item/radio/headset/headset_sec
	name = "security radio headset"
	desc = "This is used by your elite security force."
	icon = 'icons/obj/items/device/radio/headsets/headset_security.dmi'
	ks1type = /obj/item/encryptionkey/headset_sec

/obj/item/radio/headset/headset_sec/alt
	name = "security bowman headset"
	icon = 'icons/obj/items/device/radio/headsets/headset_security_alt.dmi'

/obj/item/radio/headset/headset_eng
	name = "engineering radio headset"
	desc = "When the engineers wish to chat like girls."
	icon = 'icons/obj/items/device/radio/headsets/headset_engineering.dmi'
	ks1type = /obj/item/encryptionkey/headset_eng

/obj/item/radio/headset/headset_eng/alt
	name = "engineering bowman headset"
	icon = 'icons/obj/items/device/radio/headsets/headset_engineering_alt.dmi'

/obj/item/radio/headset/headset_rob
	name = "robotics radio headset"
	desc = "Made specifically for the roboticists who cannot decide between departments."
	icon = 'icons/obj/items/device/radio/headsets/headset_robotics.dmi'
	ks1type = /obj/item/encryptionkey/headset_rob

/obj/item/radio/headset/headset_med
	name = "medical radio headset"
	desc = "A headset for the trained staff of the medbay."
	icon = 'icons/obj/items/device/radio/headsets/headset_medical.dmi'
	ks1type = /obj/item/encryptionkey/headset_med

/obj/item/radio/headset/headset_med/alt
	name = "medical bowman headset"
	icon = 'icons/obj/items/device/radio/headsets/headset_medical_alt.dmi'

/obj/item/radio/headset/headset_sci
	name = "science radio headset"
	desc = "A sciency headset. Like usual."
	icon = 'icons/obj/items/device/radio/headsets/headset_science.dmi'
	ks1type = /obj/item/encryptionkey/headset_sci

/obj/item/radio/headset/headset_medsci
	name = "medical research radio headset"
	desc = "A headset that is a result of the mating between medical and science."
	icon = 'icons/obj/items/device/radio/headsets/headset_medical.dmi'
	ks1type = /obj/item/encryptionkey/headset_medsci

/obj/item/radio/headset/headset_com
	name = "command radio headset"
	desc = "A headset with a commanding channel."
	icon = 'icons/obj/items/device/radio/headsets/headset_command.dmi'
	ks1type = /obj/item/encryptionkey/headset_com

/obj/item/radio/headset/headset_com/alt
	name = "command bowman headset"
	desc = "A headset with a commanding channel."
	icon = 'icons/obj/items/device/radio/headsets/headset_command_alt.dmi'
	ks1type = /obj/item/encryptionkey/headset_com
	max_keys = 3

/obj/item/radio/headset/heads/captain
	name = "captain's headset"
	desc = "The headset of the boss."
	icon = 'icons/obj/items/device/radio/headsets/headset_command.dmi'
	ks1type = /obj/item/encryptionkey/heads/captain

/obj/item/radio/headset/heads/captain/alt
	name = "captain's bowman headset"
	icon = 'icons/obj/items/device/radio/headsets/headset_command_alt.dmi'
	max_keys = 3

/obj/item/radio/headset/heads/ai_integrated
	name = "\improper AI subspace transceiver"
	desc = "Integrated AI radio transceiver."
	ks1type = /obj/item/encryptionkey/heads/ai_integrated
	var/myAi = null    // Atlantis: Reference back to the AI which has this radio.
	var/disabledAi = 0 // Atlantis: Used to manually disable AI's integrated radio via inteliCard menu.

/obj/item/radio/headset/heads/ai_integrated/Destroy()
	myAi = null
	. = ..()

/obj/item/radio/headset/heads/ai_integrated/receive_range(freq, level)
	if (disabledAi)
		return -1 //Transciever Disabled.
	return ..(freq, level, 1)

/obj/item/radio/headset/heads/rd
	name = "chief science officer's headset"
	desc = "Headset of the researching God."
	icon = 'icons/obj/items/device/radio/headsets/headset_command.dmi'
	ks1type = /obj/item/encryptionkey/heads/rd

/obj/item/radio/headset/heads/hos
	name = "head of security's headset"
	desc = "The headset of the man who protects your worthless lives."
	icon = 'icons/obj/items/device/radio/headsets/headset_command.dmi'
	ks1type = /obj/item/encryptionkey/heads/hos

/obj/item/radio/headset/heads/ce
	name = "chief engineer's headset"
	desc = "The headset of the guy who is in charge of morons."
	icon = 'icons/obj/items/device/radio/headsets/headset_command.dmi'
	ks1type = /obj/item/encryptionkey/heads/ce

/obj/item/radio/headset/heads/ce/alt
	name = "chief engineer's bowman headset"
	icon = 'icons/obj/items/device/radio/headsets/headset_command_alt.dmi'

/obj/item/radio/headset/heads/cmo
	name = "chief medical officer's headset"
	desc = "The headset of the highly trained medical chief."
	icon = 'icons/obj/items/device/radio/headsets/headset_command_alt.dmi'
	ks1type = /obj/item/encryptionkey/heads/cmo

/obj/item/radio/headset/heads/cmo/alt
	name = "chief medical officer's bowman headset"
	icon = 'icons/obj/items/device/radio/headsets/headset_command_alt.dmi'

/obj/item/radio/headset/heads/hop
	name = "head of personnel's headset"
	desc = "The headset of the guy who will one day be captain."
	icon = 'icons/obj/items/device/radio/headsets/headset_command.dmi'
	ks1type = /obj/item/encryptionkey/heads/hop

/obj/item/radio/headset/headset_service
	name = "service radio headset"
	desc = "Headset used by the service staff, tasked with keeping everyone full, happy and clean."
	icon = 'icons/obj/items/device/radio/headsets/headset_service.dmi'
	ks1type = /obj/item/encryptionkey/headset_service

/obj/item/radio/headset/ert
	name = "emergency response team radio headset"
	desc = "The headset of the boss's boss."
	icon = 'icons/obj/items/device/radio/headsets/headset_command.dmi'
	ks1type = /obj/item/encryptionkey/ert

/obj/item/radio/headset/foundation
	name = "\improper Foundation radio headset"
	desc = "The headeset of the occult cavalry."
	icon = 'icons/obj/items/device/radio/headsets/headset_command.dmi'
	ks1type = /obj/item/encryptionkey/ert

/obj/item/radio/headset/ia
	name = "internal affair's headset"
	desc = "The headset of your worst enemy."
	icon = 'icons/obj/items/device/radio/headsets/headset_command.dmi'
	ks1type = /obj/item/encryptionkey/heads/hos

/obj/item/radio/headset/headset_mining
	name = "mining radio headset"
	desc = "Headset used by dwarves. It has an inbuilt subspace antenna for better reception."
	icon = 'icons/obj/items/device/radio/headsets/headset_mining.dmi'
	ks1type = /obj/item/encryptionkey/headset_mining

/obj/item/radio/headset/headset_mining/alt
	name = "mining bowman radio headset"
	icon = 'icons/obj/items/device/radio/headsets/headset_mining_alt.dmi'
	max_keys = 3

/obj/item/radio/headset/headset_cargo
	name = "supply radio headset"
	desc = "A headset used by the box-pushers."
	icon = 'icons/obj/items/device/radio/headsets/headset_cargo.dmi'
	ks1type = /obj/item/encryptionkey/headset_cargo

/obj/item/radio/headset/headset_cargo/alt
	name = "supply bowman headset"
	icon = 'icons/obj/items/device/radio/headsets/headset_cargo_alt.dmi'
	max_keys = 3

/obj/item/radio/headset/entertainment
	name = "actor's radio headset"
	desc = "specially made to make you sound less cheesy."
	icon = 'icons/obj/items/device/radio/headsets/headset_command.dmi'
	ks1type = /obj/item/encryptionkey/entertainment

/obj/item/radio/headset/specops
	name = "special operations radio headset"
	desc = "The headset of the spooks."
	icon = 'icons/obj/items/device/radio/headsets/headset_centcomm.dmi'
	ks1type = /obj/item/encryptionkey/specops

/obj/item/radio/headset/attackby(obj/item/W, mob/user)
//	..()
	user.set_machine(src)
	if (!( isScrewdriver(W) || (istype(W, /obj/item/encryptionkey/ ))))
		return

	if(isScrewdriver(W))
		if(encryption_keys.len)
			for(var/ch_name in channels)
				radio_controller.remove_object(src, radiochannels[ch_name])
				secure_radio_connections[ch_name] = null
			for(var/obj/ekey in encryption_keys)
				ekey.dropInto(user.loc)
				encryption_keys -= ekey

			recalculateChannels(1)
			to_chat(user, "You pop out the encryption keys in the headset!")

		else
			to_chat(user, "This headset doesn't have any encryption keys!  How useless...")

	if(istype(W, /obj/item/encryptionkey/))
		if(encryption_keys.len >= max_keys)
			to_chat(user, "The headset can't hold another key!")
			return
		if(user.unEquip(W, target = src))
			to_chat(user, "<span class='notice'>You put \the [W] into \the [src].</span>")
			encryption_keys += W
			recalculateChannels(1)

/obj/item/radio/headset/MouseDrop(var/obj/over_object)
	var/mob/M = usr
	if((!istype(over_object, /obj/screen)) && (src in M) && CanUseTopic(M))
		return attack_self(M)
	return

/obj/item/radio/headset/recalculateChannels(var/setDescription = 0)
	src.channels = list()
	src.translate_binary = 0
	src.syndie = 0
	for(var/obj/ekey in encryption_keys)
		import_key_data(ekey)
	for (var/ch_name in channels)
		if(!radio_controller)
			src.SetName("broken radio headset")
			return
		secure_radio_connections[ch_name] = radio_controller.add_object(src, radiochannels[ch_name],  RADIO_CHAT)

	if(setDescription)
		setupRadioDescription()

/obj/item/radio/headset/proc/import_key_data(obj/item/encryptionkey/key)
	if(!key)
		return
	for(var/ch_name in key.channels)
		if(ch_name in src.channels)
			continue
		src.channels[ch_name] = key.channels[ch_name]
	if(key.translate_binary)
		src.translate_binary = 1
	if(key.syndie)
		src.syndie = 1

/obj/item/radio/headset/proc/setupRadioDescription()
	var/radio_text = ""
	for(var/i = 1 to channels.len)
		var/channel = channels[i]
		var/key = get_radio_key_from_channel(channel)
		radio_text += "[key] - [channel]"
		if(i != channels.len)
			radio_text += ", "

	radio_desc = radio_text
