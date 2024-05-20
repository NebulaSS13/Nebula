#define NO_SCREEN 0
#define CHANGE_SECURITY_LEVEL 1
#define TRANSFER_FUNDS 2
#define VIEW_TRANSACTION_LOGS 3

/obj/machinery/atm
	name = "automatic teller machine"
	desc = "For all your monetary needs!"
	icon = 'icons/obj/terminals.dmi'
	icon_state = "atm"
	anchored = TRUE
	idle_power_usage = 10
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	directional_offset = @'{"NORTH":{"y":-32}, "SOUTH":{"y":32}, "EAST":{"x":-32}, "WEST":{"x":32}}'

	var/datum/money_account/authenticated_account
	var/number_incorrect_tries = 0
	var/previous_account_number = 0
	var/max_pin_attempts = 3
	var/ticks_left_locked_down = 0
	var/ticks_left_timeout = 0
	var/machine_id = ""
	var/obj/item/card/id/held_card
	var/view_screen = NO_SCREEN
	var/account_security_level = 0
	var/charge_stick_type = /obj/item/charge_stick

	uncreated_component_parts = null
	construct_state = /decl/machine_construction/wall_frame/panel_closed
	frame_type = /obj/item/frame/stock_offset/atm

/obj/machinery/atm/Initialize()
	. = ..()
	machine_id = "[station_name()] ATM #[num_financial_terminals++]"

/obj/machinery/atm/Destroy()
	QDEL_NULL(held_card)
	authenticated_account = null
	. = ..()

/obj/machinery/atm/Process()
	if(stat & NOPOWER)
		return

	if(ticks_left_timeout > 0)
		ticks_left_timeout--
		if(ticks_left_timeout <= 0)
			authenticated_account = null
	if(ticks_left_locked_down > 0)
		ticks_left_locked_down--
		if(ticks_left_locked_down <= 0)
			number_incorrect_tries = 0

	for(var/obj/item/cash/S in src)
		S.dropInto(loc)
		if(prob(50))
			playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
		else
			playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)
		break

/obj/machinery/atm/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		//short out the machine, shoot sparks, spew money!
		emagged = 1
		spark_at(src, amount = 5, holder = src)
		var/obj/item/cash/cash = new(get_turf(src))
		cash.adjust_worth(rand(100,500))

		//we don't want to grief people by locking their id in an emagged ATM
		release_held_id(user)

		//display a message to the user
		var/response = pick("Initiating withdraw. Have a nice day!", "CRITICAL ERROR: Activating cash chamber panic siphon.","PIN Code accepted! Emptying account balance.", "Jackpot!")
		to_chat(user, "[html_icon(src)] <span class='warning'>[src] beeps: \"[response]\"</span>")
		return 1

/obj/machinery/atm/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/card/id))
		if(emagged > 0)
			//prevent inserting id into an emagged ATM
			to_chat(user, "[html_icon(src)] <span class='warning'>CARD READER ERROR. This system has been compromised!</span>")
			return
		if(stat & NOPOWER)
			to_chat(user, "You try to insert your card into [src], but nothing happens.")
			return

		var/obj/item/card/id/idcard = I
		if(!held_card)
			if(!user.try_unequip(idcard, src))
				return
			held_card = idcard
			if(authenticated_account && held_card.associated_account_number != authenticated_account.account_number)
				authenticated_account = null
			attack_hand_with_interaction_checks(user)

	else if(authenticated_account)
		if(istype(I,/obj/item/cash))
			var/obj/item/cash/dolla = I

			//deposit the cash
			if(authenticated_account.deposit(dolla.absolute_worth, "Credit deposit", machine_id))
				playsound(loc, pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 50, 1)

				to_chat(user, "<span class='info'>You insert [I] into [src].</span>")
				attack_hand_with_interaction_checks(user)
				qdel(I)

		if(istype(I,/obj/item/charge_stick))
			var/obj/item/charge_stick/stick = I
			var/datum/extension/lockable/lock = get_extension(I, /datum/extension/lockable)
			if(lock.locked)
				to_chat(user, SPAN_WARNING("Cannot transfer funds from a locked [stick.name]."))
			else
				if(authenticated_account.deposit(stick.loaded_worth, "Credit deposit", machine_id))
					playsound(loc, pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 50, 1)

					to_chat(user, "<span class='info'>You insert [I] into [src].</span>")
					attack_hand_with_interaction_checks(user)
					qdel(I)
	else
		..()

/obj/machinery/atm/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/atm/interact(mob/user)

	if(issilicon(user))
		to_chat(user, "[html_icon(src)] <span class='warning'>Artificial unit recognized. Artificial units do not currently receive monetary compensation, as per system banking regulation #1005.</span>")
		return

	if(get_dist(src,user) <= 1)
		//make the window the user interacts with, divided out into welcome message, card 'slot', then login/data screen
		var/list/t = list()

		if(authenticated_account)
			t += "<span class='highlight'>Welcome <b>[authenticated_account.owner_name]</b>.</span><BR>"
		else
			t += "<span class='highlight'>Welcome. Please login below.</span><BR>"

		t += "<div class='statusDisplay'><span class='highlight'><b>Card: </b></span>"
		if(emagged > 0)
			t += "<span class='bad'><b>LOCKED</b><br>Unauthorized terminal access detected!<br>This ATM has been locked down.</span></div><BR>"
		else
			t += "<a href='byond://?src=\ref[src];choice=insert_card'>[held_card ? held_card.name : "No card inserted"]</a></div><BR>"
			t += "<div class='statusDisplay'>"
			if(ticks_left_locked_down > 0)
				t += "<span class='bad'>Maximum number of pin attempts exceeded! Access to this ATM has been temporarily disabled.</span></div>"
			else if(authenticated_account)
				if(authenticated_account.suspended)
					t += "<span class='bad'><b>Access to this account has been suspended, and the funds within frozen.</b></span></div>"
				else
					switch(view_screen)
						if(CHANGE_SECURITY_LEVEL)
							t += "Select a new security level for this account:<br><hr>"
							if(authenticated_account.security_level != 0)
								t += "<A href='byond://?src=\ref[src];choice=change_security_level;new_security_level=0'>Select Minimum Security</a><BR>"
							else
								t += "<span class='good'><b>Minimum security set: </b></span><BR>"
							t += "Either the account number or card is required to access this account. EFTPOS transactions will require a card and ask for a pin, but not verify the pin is correct.<hr>"
							if(authenticated_account.security_level != 1)
								t += "<A href='byond://?src=\ref[src];choice=change_security_level;new_security_level=1'>Select Moderate Security</a><BR>"
							else
								t += "<span class='average'><b>Moderate Security set: </b></span><BR>"
							t += "An account number and pin must be manually entered to access this account and process transactions.<hr>"
							if(authenticated_account.security_level != 2)
								t += "<A href='byond://?src=\ref[src];choice=change_security_level;new_security_level=2'>Select Maximum Security</a><BR>"
							else
								t += "<span class='bad'><b>Maximum security Set: </b></span><BR>"
							t += "High - In addition to account number, a pin and a card is required to access this account and process transactions.<hr><br>"
						if(VIEW_TRANSACTION_LOGS)
							t += "<b>Transaction logs</b><br>"
							t += "<table border=1 style='width:100%'>"
							t += "<tr>"
							t += "<td><b>Date</b></td>"
							t += "<td><b>Time</b></td>"
							t += "<td><b>Target</b></td>"
							t += "<td><b>Purpose</b></td>"
							t += "<td><b>Value</b></td>"
							t += "<td><b>Source terminal ID</b></td>"
							t += "</tr>"
							for(var/datum/transaction/T in authenticated_account.transaction_log)
								t += "<tr>"
								t += "<td>[T.date]</td>"
								t += "<td>[T.time]</td>"
								t += "<td>[T.get_target_name()]</td>"
								t += "<td>[T.purpose]</td>"
								t += "<td>[authenticated_account.format_value_by_currency(T.amount)]</td>"
								t += "<td>[T.get_source_name()]</td>"
								t += "</tr>"
							t += "</table>"
							t += "<A href='byond://?src=\ref[src];choice=print_transaction'>Print</a><br>"
						if(TRANSFER_FUNDS)
							t += "<b>Account balance:</b> [authenticated_account.format_value_by_currency(authenticated_account.money)]<br>"
							t += "<form name='transfer' action='byond://?src=\ref[src]' method='get'>"
							t += "<input type='hidden' name='src' value='\ref[src]'>"
							t += "<input type='hidden' name='choice' value='transfer'>"
							t += "Target account number: <input type='text' name='target_acc_number' value='' style='width:200px; background-color:white;'><br>"
							t += "Funds to transfer: <input type='text' name='funds_amount' value='' style='width:200px; background-color:white;'><br>"
							t += "Transaction purpose: <input type='text' name='purpose' value='Funds transfer' style='width:200px; background-color:white;'><br>"
							t += "<input type='submit' value='Transfer funds'><br>"
							t += "</form>"
						else
							t += "<b>Account balance:</b> [authenticated_account.format_value_by_currency(authenticated_account.money)]"
							t += "<form name='withdrawal' action='byond://?src=\ref[src]' method='get'>"
							t += "<input type='hidden' name='src' value='\ref[src]'>"
							t += "<input type='radio' name='choice' value='withdrawal' checked> Cash  <input type='radio' name='choice' value='e_withdrawal'> Chargecard<br>"
							t += "<input type='text' name='funds_amount' value='' style='width:200px; background-color:white;'><input type='submit' value='Withdraw'>"
							t += "</form>"
							t += "<A href='byond://?src=\ref[src];choice=view_screen;view_screen=1'>Change account security level</a><br>"
							t += "<A href='byond://?src=\ref[src];choice=view_screen;view_screen=2'>Make transfer</a><br>"
							t += "<A href='byond://?src=\ref[src];choice=view_screen;view_screen=3'>View transaction log</a><br>"
							t += "<A href='byond://?src=\ref[src];choice=balance_statement'>Print balance statement</a><br>"

					//Logout/back buttons, put here for some modularity and for less repeated code
					if(view_screen == NO_SCREEN)
						t += "<A href='byond://?src=\ref[src];choice=logout'>Logout</a><br></div>"
					else
						t += "<A href='byond://?src=\ref[src];choice=view_screen;view_screen=0'>Back</a></div>"

			else
				//change our display depending on account security levels
				if(!account_security_level)
					t += "To log in to your savings account, press 'submit' with ID clearly displayed. If you wish to log into another account, please enter the account number into the field below or insert a registered ID card into the slot above and then press 'submit'.<BR>"
				else if (account_security_level == 1)
					t += "This account requires a PIN to access. For security reasons the account # will need re-entered or ID bound to this account re-scanned."
				else
					t += "<span class='bad'><b>Due to the security settings on this account, all information needs to be re-entered and the ID bound to this account placed in the slot above.</b></span><BR>"
				t += "<form name='atm_auth' action='byond://?src=\ref[src]' method='get'>"
				t += "<input type='hidden' name='src' value='\ref[src]'>"
				t += "<input type='hidden' name='choice' value='attempt_auth'>"
				t += "<b>Account:</b> <input type='text' id='account_num' name='account_num' style='width:250px; background-color:white;'><BR><BR>"
				//Leave the PIN field out of sight until needed
				if(account_security_level)
					t += "<b>PIN:</b> <input type='text' id='account_pin' name='account_pin' style='width:250px; background-color:white;'><BR><BR>"
				t += "<input type='submit' value='Submit'><br>"
				t += "</div></form>"
				if(user?.mind?.initial_account)
					t += "<i>You recall your personal account number is <b>#[user.mind.initial_account.account_number]</b> and your PIN is <b>[user.mind.initial_account.remote_access_pin]</b>.</i><br/>"

		var/datum/browser/written_digital/popup = new(user, "ATM", machine_id)
		popup.set_content(jointext(t,null))
		popup.open()
	else
		return

/obj/machinery/atm/Topic(var/href, var/href_list)
	if((. = ..()))
		return
	if(href_list["choice"])
		switch(href_list["choice"])
			if("transfer")
				if(authenticated_account)
					var/transfer_amount = text2num(href_list["funds_amount"])
					transfer_amount = round(transfer_amount, 0.01)
					if(transfer_amount <= 0)
						alert("That is not a valid amount.")
					else if(transfer_amount <= authenticated_account.money)
						var/target_account_number = text2num(href_list["target_acc_number"])
						var/transfer_purpose = href_list["purpose"]
						var/datum/money_account/target_account = get_account(target_account_number)
						if(target_account && authenticated_account.transfer(target_account, transfer_amount, transfer_purpose))
							to_chat(usr, "[html_icon(src)]<span class='info'>Funds transfer successful.</span>")
						else
							to_chat(usr, "[html_icon(src)]<span class='warning'>Funds transfer failed.</span>")

					else
						to_chat(usr, "[html_icon(src)]<span class='warning'>You don't have enough funds to do that!</span>")
			if("view_screen")
				view_screen = text2num(href_list["view_screen"])
			if("change_security_level")
				if(authenticated_account)
					var/new_sec_level = max( min(text2num(href_list["new_security_level"]), 2), 0)
					authenticated_account.security_level = new_sec_level
			if("attempt_auth")

				//Look to see if we're holding an ID, if so scan the data from that and use it, if not scan the user for the data
				var/obj/item/card/id/login_card
				if(held_card)
					login_card = held_card
				else
					login_card = scan_user(usr)

				if(!ticks_left_locked_down)
					var/tried_account_num = text2num(href_list["account_num"])
					//We WILL need an account number entered manually if security is high enough, do not automagic account number
					if(!tried_account_num && login_card && (account_security_level != 2))
						tried_account_num = login_card.associated_account_number
					var/tried_pin = text2num(href_list["account_pin"])

					//We'll need more information if an account's security is greater than zero so let's find out what the security setting is
					var/datum/money_account/D
					//Below is to avoid a runtime
					if(tried_account_num)
						D = get_account(tried_account_num)

						if(D)
							account_security_level = D.security_level

					authenticated_account = attempt_account_access(tried_account_num, tried_pin, (login_card?.associated_account_number == tried_account_num))

					if(!authenticated_account)
						number_incorrect_tries++
						//let's not count an incorrect try on someone who just needs to put in more information
						if(previous_account_number == tried_account_num && tried_pin)
							if(number_incorrect_tries >= max_pin_attempts)
								//lock down the atm
								ticks_left_locked_down = 30
								playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)

								//create an entry in the account transaction log
								var/datum/money_account/failed_account = get_account(tried_account_num)
								if(failed_account)
									failed_account.log_msg("Unauthorized login attempt", machine_id)
							else
								to_chat(usr, "[html_icon(src)] <span class='warning'>Incorrect pin/account combination entered, [max_pin_attempts - number_incorrect_tries] attempts remaining.</span>")
								previous_account_number = tried_account_num
								playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 1)
						else
							to_chat(usr, "[html_icon(src)] <span class='warning'>Unable to log in to account, additional information may be required.</span>")
							number_incorrect_tries = 0
					else
						playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
						ticks_left_timeout = 120
						view_screen = NO_SCREEN

						//create a transaction log entry
						authenticated_account.log_msg("Remote terminal access", machine_id)

						to_chat(usr, "[html_icon(src)] <span class='info'>Access granted. Welcome user '[authenticated_account.owner_name].'</span>")

					previous_account_number = tried_account_num
			if("e_withdrawal")
				var/amount = max(text2num(href_list["funds_amount"]),0)
				amount = round(amount, 0.01)
				var/obj/item/charge_stick/E = charge_stick_type
				if(amount <= 0)
					alert("That is not a valid amount.")
				else if(amount > initial(E.max_worth))
					var/decl/currency/cur = GET_DECL(initial(E.currency) || global.using_map.default_currency)
					alert("That amount exceeds the maximum amount holdable by charge sticks from this machine ([cur.format_value(initial(E.max_worth))]).")
				else if(authenticated_account && amount > 0)
					//create an entry in the account transaction log
					if(authenticated_account.withdraw(amount, "Credit withdrawal", machine_id))
						playsound(src, 'sound/machines/chime.ogg', 50, 1)
						E = new charge_stick_type(loc)
						E.adjust_worth(amount)
						E.creator = authenticated_account.owner_name
						usr.put_in_hands(E)
					else
						to_chat(usr, "[html_icon(src)]<span class='warning'>You don't have enough funds to do that!</span>")
			if("withdrawal")
				var/amount = max(text2num(href_list["funds_amount"]),0)
				amount = round(amount, 0.01)
				if(amount <= 0)
					alert("That is not a valid amount.")
				else if(authenticated_account && amount > 0)
					//remove the money
					if(authenticated_account.withdraw(amount, "Credit withdrawal", machine_id))
						playsound(src, 'sound/machines/chime.ogg', 50, 1)
						var/obj/item/cash/cash = new(get_turf(usr))
						cash.adjust_worth(amount)
						usr.put_in_hands(src)
					else
						to_chat(usr, "[html_icon(src)]<span class='warning'>You don't have enough funds to do that!</span>")
			if("balance_statement")
				if(authenticated_account)
					var/txt
					txt = "<b>Automated Teller Account Statement</b><br><br>"
					txt += "<i>Account holder:</i> [authenticated_account.owner_name]<br>"
					txt += "<i>Account number:</i> [authenticated_account.account_number]<br>"
					txt += "<i>Balance:</i> [authenticated_account.format_value_by_currency(authenticated_account.money)]<br>"
					txt += "<i>Date and time:</i> [stationtime2text()], [stationdate2text()]<br><br>"
					txt += "<i>Service terminal ID:</i> [machine_id]<br>"

					var/obj/item/paper/R = new(src.loc, null, txt, "Account balance: [authenticated_account.owner_name]")
					R.apply_custom_stamp(
						overlay_image('icons/obj/bureaucracy.dmi', "paper_stamp-boss", flags = RESET_COLOR),
						"by the [machine_id]")

				if(prob(50))
					playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
				else
					playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)
			if ("print_transaction")
				if(authenticated_account)
					var/txt

					txt = "<b>Transaction logs</b><br>"
					txt += "<i>Account holder:</i> [authenticated_account.owner_name]<br>"
					txt += "<i>Account number:</i> [authenticated_account.account_number]<br>"
					txt += "<i>Date and time:</i> [stationtime2text()], [stationdate2text()]<br><br>"
					txt += "<i>Service terminal ID:</i> [machine_id]<br>"
					txt += "<table border=1 style='width:100%'>"
					txt += "<tr>"
					txt += "<td><b>Date</b></td>"
					txt += "<td><b>Time</b></td>"
					txt += "<td><b>Target</b></td>"
					txt += "<td><b>Purpose</b></td>"
					txt += "<td><b>Value</b></td>"
					txt += "<td><b>Source terminal ID</b></td>"
					txt += "</tr>"
					for(var/datum/transaction/T in authenticated_account.transaction_log)
						txt += "<tr>"
						txt += "<td>[T.date]</td>"
						txt += "<td>[T.time]</td>"
						txt += "<td>[T.get_target_name()]</td>"
						txt += "<td>[T.purpose]</td>"
						txt += "<td>[authenticated_account.format_value_by_currency(T.amount)]</td>"
						txt += "<td>[T.get_source_name()]</td>"
						txt += "</tr>"
					txt += "</table>"
					var/obj/item/paper/R = new(src.loc, null, txt, "Transaction logs: [authenticated_account.owner_name]")
					R.apply_custom_stamp(
						overlay_image('icons/obj/bureaucracy.dmi', "paper_stamp-boss", flags = RESET_COLOR),
						"by the [machine_id]")

				if(prob(50))
					playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
				else
					playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)

			if("insert_card")
				if(!held_card)
					//this might happen if the user had the browser window open when somebody emagged it
					if(emagged > 0)
						to_chat(usr, "[html_icon(src)] <span class='warning'>The ATM card reader rejected your ID because this machine has been sabotaged!</span>")
					else
						var/obj/item/I = usr.get_active_held_item()
						if (istype(I, /obj/item/card/id))
							if(!usr.try_unequip(I, src))
								return
							held_card = I
				else
					release_held_id(usr)
			if("logout")
				authenticated_account = null
				account_security_level = 0

	interact(usr)

/obj/machinery/atm/proc/scan_user(mob/living/human/human_user)
	if(!authenticated_account)
		var/obj/item/card/id/I = human_user.GetIdCard()
		if(istype(I))
			return I

// put the currently held id on the ground or in the hand of the user
/obj/machinery/atm/proc/release_held_id(mob/living/human/human_user)
	if(!held_card)
		return

	held_card.dropInto(loc)
	authenticated_account = null
	account_security_level = 0

	if(ishuman(human_user) && !human_user.get_active_held_item())
		human_user.put_in_hands(held_card)
	held_card = null
