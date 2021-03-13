/datum/event/money_lotto
	var/winner_name = "John Smith"
	var/winner_sum = 0
	var/deposit_success = 0
	var/datum/money_account/winner_account

/datum/event/money_lotto/start()
	winner_sum = pick(5000, 10000, 50000, 100000, 500000, 1000000, 1500000)
	if(prob(50))
		if(all_money_accounts.len)
			winner_account = pick(all_money_accounts)
			winner_name = winner_account.owner_name
			deposit_success = winner_account.deposit(winner_sum, "Nyx Daily Loan Lottery winner!", "Biesel TCD Terminal #[rand(111,333)]")
	else
		winner_name = random_name(pick(MALE,FEMALE), species = GLOB.using_map.default_species)
		deposit_success = prob(50)

/datum/event/money_lotto/announce()
	var/author = "[GLOB.using_map.company_name] Editor"
	var/channel = "Nyx Daily"

	var/decl/currency/cur = GET_DECL(winner_account?.currency || GLOB.using_map.default_currency)
	var/body = "Nyx Daily wishes to congratulate <b>[winner_name]</b> for recieving the Nyx Stellar Slam Lottery, and receiving the out of this world sum of [cur.format_value(winner_sum)]!"
	if(!deposit_success)
		body += "<br>Unfortunately, we were unable to verify the account details provided, so we were unable to transfer the money. In order to have your winnings re-sent, send a cheque containing a processing fee of [cur.format_value(5000)] to the ND 'Stellar Slam' office on the Nyx gateway with your updated details."
	winner_account = null
	news_network.SubmitArticle(body, author, channel, null, 1)
