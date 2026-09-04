/obj/item/eftpos
	name = "\improper EFTPOS scanner"
	desc = "Swipe your ID card to make purchases electronically."
	icon = 'icons/obj/items/device/eftpos.dmi'
	icon_state = "eftpos"
	material = /decl/material/solid/organic/plastic
	matter = list(/decl/material/solid/silicon = MATTER_AMOUNT_REINFORCEMENT, /decl/material/solid/metal/copper = MATTER_AMOUNT_REINFORCEMENT)
	var/machine_id = ""
	var/eftpos_name = "Default EFTPOS scanner"
	var/transaction_locked = 0
	var/transaction_paid = 0
	var/transaction_amount = 0
	var/transaction_purpose = "Default charge"
	var/access_code = 0
	var/currency
	var/datum/money_account/linked_account

/obj/item/eftpos/Initialize()
	. = ..()
	machine_id = "[station_name()] EFTPOS #[num_financial_terminals++]"
	access_code = rand(1111,111111)
	print_reference()

	if(!ispath(currency, /decl/currency))
		currency = global.using_map.default_currency

	//create a short manual as well
	//Temptative new manual:
	var/txt
	txt =  "<b>First EFTPOS setup:</b><br>"
	txt += "1. Memorise your EFTPOS command code (provided with all EFTPOS devices).<br>"
	txt += "2. Connect the EFTPOS to the account in which you want to receive the funds.<br><br>"
	txt += "<b>When starting a new transaction:</b><br>"
	txt += "1. Enter the amount of money you want to charge and a purpose message for the new transaction.<br>"
	txt += "2. Lock the new transaction. If you want to modify or cancel the transaction, you simply have to reset your EFTPOS device.<br>"
	txt += "3. Give the EFTPOS device to your customer, he/she must finish the transaction by swiping their ID card or a charge card with enough funds.<br>"
	txt += "4. If everything is done correctly, the money will be transferred. To unlock the device you will have to reset the EFTPOS device.<br>"

	var/obj/item/paper/R = new(src.loc, null, txt, "Steps to success: Correct EFTPOS Usage")
	R.apply_custom_stamp('icons/obj/items/stamps/stamp_boss.dmi', "by \the [src]")

	//by default, connect to the station account
	//the user of the EFTPOS device can change the target account though, and no-one will be the wiser (except whoever's being charged)
	linked_account = get_default_account()

/obj/item/eftpos/proc/get_default_account()
	return global.station_account

/obj/item/eftpos/departmental
	var/decl/department/default_department

/obj/item/eftpos/departmental/get_default_account()
	return (default_department && global.department_accounts[default_department]) || ..()

/obj/item/eftpos/proc/print_reference()
	var/obj/item/paper/R = new(src.loc, null,
		"<b>[eftpos_name] reference</b><br><br>Access code: [access_code]<br><br><b>Do not lose or misplace this code.</b><br>",
		"Reference: [eftpos_name]")
	R.apply_custom_stamp('icons/obj/items/stamps/stamp_boss.dmi', "by \the [src]")
	var/obj/item/parcel/D = new(R.loc, null, R, "EFTPOS access code")
	D.attach_label(null, null, "EFTPOS access code")

/obj/item/eftpos/attack_self(mob/user)
	if(get_dist(src,user) <= 1)
		var/dat = "<b>[eftpos_name]</b><br>"
		dat += "<i>This terminal is</i> [machine_id]. <i>Report this code when contacting IT Support</i><br>"
		var/decl/currency/cur = GET_DECL(currency)
		if(transaction_locked)
			dat += "<a href='byond://?src=\ref[src];choice=toggle_lock'>Back[transaction_paid ? "" : " (authentication required)"]</a><br><br>"
			dat += "Transaction purpose: <b>[transaction_purpose]</b><br>"
			dat += "Value: <b>[cur.format_value(transaction_amount)]</b><br>"
			dat += "Linked account: <b>[linked_account ? linked_account.owner_name : "None"]</b><hr>"
			if(transaction_paid)
				dat += "<i>This transaction has been processed successfully.</i><hr>"
			else
				dat += "<i>Swipe your card below the line to finish this transaction.</i><hr>"
				dat += "<a href='byond://?src=\ref[src];choice=scan_card'>\[------\]</a>"
		else
			dat += "<a href='byond://?src=\ref[src];choice=toggle_lock'>Lock in new transaction</a><br><br>"

			dat += "<a href='byond://?src=\ref[src];choice=trans_purpose'>Transaction purpose: [transaction_purpose]</a><br>"
			dat += "Value: <a href='byond://?src=\ref[src];choice=trans_value'>[cur.format_value(transaction_amount)]</a><br>"
			dat += "Linked account: <a href='byond://?src=\ref[src];choice=link_account'>[linked_account ? linked_account.owner_name : "None"]</a><hr>"
			dat += "<a href='byond://?src=\ref[src];choice=change_code'>Change access code</a><br>"
			dat += "<a href='byond://?src=\ref[src];choice=change_id'>Change EFTPOS ID</a><br>"
			dat += "Scan card to reset access code <a href='byond://?src=\ref[src];choice=reset'>\[------\]</a>"
		show_browser(user, dat, "window=eftpos")
	else
		close_browser(user, "window=eftpos")

/obj/item/eftpos/attackby(obj/item/used_item, user)

	var/obj/item/card/id/I = used_item.GetIdCard()

	if(I)
		if(linked_account)
			scan_card(I, used_item)
		else
			to_chat(user, "[html_icon(src)]<span class='warning'>Unable to connect to linked account.</span>")
		return TRUE
	else if (istype(used_item, /obj/item/charge_stick))
		var/obj/item/charge_stick/E = used_item
		if (linked_account)
			if(transaction_locked && !transaction_paid)
				if(!E.is_locked() && transaction_amount <= E.loaded_worth)
					//transfer the money
					var/purpose = (transaction_purpose ? transaction_purpose : "None supplied.")
					purpose += ", paid by [E.id]"
					if(linked_account.deposit(transaction_amount, purpose, machine_id))
						E.adjust_worth(-(transaction_amount))
						playsound(src, 'sound/machines/chime.ogg', 50, 1)
						visible_message("[html_icon(src)] \The [src] chimes.")
						transaction_paid = 1
					else
						to_chat(user, "[html_icon(src)]<span class='warning'>Transaction failed! Please try again.</span>")
				else
					to_chat(user, "[html_icon(src)]<span class='warning'>\The [used_item] doesn't have that much money!</span>")
		else
			to_chat(user, "[html_icon(src)]<span class='warning'>EFTPOS is not connected to an account.</span>")
		return TRUE
	else
		return ..()

/obj/item/eftpos/Topic(var/href, var/href_list)
	if(href_list["choice"])
		switch(href_list["choice"])
			if("change_code")
				var/attempt_code = input("Re-enter the current EFTPOS access code", "Confirm old EFTPOS code") as num
				if(attempt_code == access_code)
					var/trycode = input("Enter a new access code for this device (4-6 digits, numbers only)", "Enter new EFTPOS code") as num
					if(trycode >= 1000 && trycode <= 999999)
						access_code = trycode
					else
						alert("That is not a valid code!")
					print_reference()
				else
					to_chat(usr, "[html_icon(src)]<span class='warning'>Incorrect code entered.</span>")
			if("change_id")
				var/attempt_code = text2num(input("Re-enter the current EFTPOS access code", "Confirm EFTPOS code"))
				if(attempt_code == access_code)
					eftpos_name = sanitize(input("Enter a new terminal ID for this device", "Enter new EFTPOS ID"), MAX_NAME_LEN) + " EFTPOS scanner"
					print_reference()
				else
					to_chat(usr, "[html_icon(src)]<span class='warning'>Incorrect code entered.</span>")
			if("link_account")
				var/attempt_account_num = input("Enter account number to pay EFTPOS charges into", "New account number") as num
				var/attempt_pin = input("Enter pin code", "Account pin") as num
				linked_account = attempt_account_access(attempt_account_num, attempt_pin, FALSE)
				if(linked_account)
					if(linked_account.suspended)
						linked_account = null
						to_chat(usr, "[html_icon(src)]<span class='warning'>Account has been suspended.</span>")
				else
					to_chat(usr, "[html_icon(src)]<span class='warning'>Account not found.</span>")
			if("trans_purpose")
				var/choice = sanitize(input("Enter reason for EFTPOS transaction", "Transaction purpose"))
				if(choice) transaction_purpose = choice
			if("trans_value")
				var/try_num = input("Enter amount for EFTPOS transaction", "Transaction amount") as num
				if(try_num < 0)
					alert("That is not a valid amount!")
				else
					transaction_amount = try_num
			if("toggle_lock")
				if(transaction_locked)
					if (transaction_paid)
						transaction_locked = 0
						transaction_paid = 0
					else
						var/attempt_code = input("Enter EFTPOS access code", "Reset Transaction") as num
						if(attempt_code == access_code)
							transaction_locked = 0
							transaction_paid = 0
				else if(linked_account)
					transaction_locked = 1
				else
					to_chat(usr, "[html_icon(src)]<span class='warning'>No account connected to send transactions to.</span>")
			if("scan_card")
				if(linked_account)
					var/obj/item/I = usr.get_active_held_item()
					if (istype(I, /obj/item/card))
						scan_card(I)
				else
					to_chat(usr, "[html_icon(src)]<span class='warning'>Unable to link accounts.</span>")
			if("reset")
				//reset the access code - requires HoP/captain access
				var/obj/item/I = usr.get_active_held_item()
				if (istype(I, /obj/item/card))
					var/obj/item/card/id/C = I
					if((access_cent_captain in C.access) || (access_hop in C.access) || (access_captain in C.access))
						access_code = 0
						to_chat(usr, "[html_icon(src)]<span class='info'>Access code reset to 0.</span>")
				else if (istype(I, /obj/item/card/emag))
					access_code = 0
					to_chat(usr, "[html_icon(src)]<span class='info'>Access code reset to 0.</span>")

	src.attack_self(usr)

/obj/item/eftpos/proc/scan_card(var/obj/item/card/I, var/obj/item/ID_container)
	if (istype(I, /obj/item/card/id))
		var/obj/item/card/id/C = I
		if(I==ID_container || ID_container == null)
			usr.visible_message("<span class='info'>\The [usr] swipes a card through \the [src].</span>")
		else
			usr.visible_message("<span class='info'>\The [usr] swipes \the [ID_container] through \the [src].</span>")
		if(transaction_locked && !transaction_paid)
			if(linked_account)
				if(!linked_account.suspended)
					var/attempt_pin = ""
					var/datum/money_account/D = get_account(C.associated_account_number)
					if(D && D.security_level)
						attempt_pin = input("Enter pin code", "EFTPOS transaction") as num
						D = null
					D = attempt_account_access(C.associated_account_number, attempt_pin, TRUE)
					if(D)
						//transfer the money
						if(D.transfer(linked_account, transaction_amount, "[transaction_purpose] (via [eftpos_name]/[machine_id])"))
							playsound(src, 'sound/machines/chime.ogg', 50, 1)
							src.visible_message("[html_icon(src)] \The [src] chimes.")
							transaction_paid = 1
						else
							to_chat(usr, "[html_icon(src)]<span class='warning'>Transaction failed! Please try again.</span>")
					else
						to_chat(usr, "[html_icon(src)]<span class='warning'>Unable to access account. Check security settings and try again.</span>")
				else
					to_chat(usr, "[html_icon(src)]<span class='warning'>Connected account has been suspended.</span>")
			else
				to_chat(usr, "[html_icon(src)]<span class='warning'>EFTPOS is not connected to an account.</span>")
	else if (istype(I, /obj/item/card/emag))
		if(transaction_locked)
			if(transaction_paid)
				to_chat(usr, "[html_icon(src)]<span class='info'>You stealthily swipe \the [I] through \the [src].</span>")
				transaction_locked = 0
				transaction_paid = 0
			else
				usr.visible_message("<span class='info'>\The [usr] swipes a card through \the [src].</span>")
				playsound(src, 'sound/machines/chime.ogg', 50, 1)
				src.visible_message("[html_icon(src)] \The [src] chimes.")
				transaction_paid = 1

	//emag?
