/// A decl which holds dialogue strings used by merchants.
/decl/merchant_speech
	var/hailed = "Greetings, "+MERCHANT_TOKEN_PLAYER_NAME+"!" //! Shown to the user when the merchant is hailed, by default.
	var/hailed_by_synth = null 							/*! Alternative hailing message for when a synthetic hails them.
														Synthetics include borgs, the AI, and full body prosthetics. If unset, they will see the standard hail message.*/
	var/hailed_by_species = list()						/*! Assoc list of special hail responses based on the user's species. Species not on the list use the standard message.
														Format is `/decl/species/foo::uid = "Bar bar barbar bar bar!"`. This takes priority over `hailed_by_synth` if both are applicable.*/
	var/denied_hail = "No, I'm not speaking with you."	//! Shown when the merchant denies the hail for any reason.
	var/no_anonymous = null								//! Shown when the merchant denies a hail due to refusing anonymous comms. If unset, `denied_hail` is used instead.
	var/how_much = "Hmm.... how about "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+"?" //! Shown when asked for the price of an item for sale.
	var/what_wanted_beginning = "Hm, I want"			//! Shown at the start when asked for what items they would buy. A list of items' names are appended to the end of this string.
	var/what_wanted_ending = null						//! Shown at the end when asked for what items they would buy, after the list of items' names. If unset, defaults to a period.
	var/want_nothing = "I don't want anything else right now."//! Shown when a user asks what items they would buy, but all of their demands were satisfied, and they could've bought items previously.
	var/trade_complete = "Thanks for your business!"	//! Shown after a transaction is completed. Bribes are not considered transactions.
	var/compliment_success = "Thank you!"				//! Shown when a user attempts to compliment the merchant, and they succeeded.
	var/compliment_failure = "Fuck you!"				//! Shown when a user attempts to compliment the merchant, and they failed.
	var/insult_high_opinion = "What? I thought we were cool!" //! Shown when a user insults the merchant with high disposition.
	var/insult_low_opinion = "Right back at you asshole!" //! Shown when a user insults the merchant with low disposition.
	var/bribe_success = "Sure, I'll take that money off of your hands." //! Shown when a user successfully bribes the merchant.
	var/bribe_failure = "How about... no?"				//! Shown when a user tries to bribe the merchant, and they refuse.
	var/gift_refused = "I can't accept that for free."	//! Shown when merchants refuse to be given free stuff.
	var/money_not_accepted = "I don't want cash."		//! Shown when users try to use cash, and the merchant doesn't want that.
	var/goods_not_accepted = "Cash only, sorry."		//! Shown when users try to barter, and the merchant doesn't want that.
	var/not_enough_value = "That's not enough."			/*! Shown when users don't have enough cash to buy something, or
															they try to barter with things that aren't valuable enough.*/
	var/no_haggling = "All prices are final."			//! Shown when merchants refuse to haggle.
	var/haggle_too_high = "I'm not paying "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+" for that." //! Shown when the merchant rejects an offer to buy something for too much.
	var/haggle_too_low = "I'm not selling you a "+MERCHANT_TOKEN_ITEM+" for only "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+"." //! Shown when the merchant rejects an offer to sell something too cheaply.
	var/forbidden_offer = "Nope. Nope nope nope."		//! Shown when users attempt to sell an item that's on the forbidden list. This has priority over `found_unwanted`.
	var/found_unwanted = "I'm not interested in that."	//! Shown when users attempt to sell an item that the trader doesn't want.
	var/appraise_offer = "I'd give you... "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+" for that." //! Shown when users ask the merchant how much they would pay for whatever is on the pad.
	var/out_of_money = "Sorry, but I'm out of cash."	//! Shown when the merchant has limited funds, and they don't have enough to cover the trade.
	var/sold_out = "Sorry, but I already sold my last "+MERCHANT_TOKEN_ITEM+"." //! Shown when the merchant is sold out of something.
	var/no_more_wanted = "I don't want any more "+MERCHANT_TOKEN_ITEM+"." //! Shown when the merchant doesn't want any more of something.
	var/too_many_items = "I only want "+MERCHANT_TOKEN_QUANTITY+" more "+MERCHANT_TOKEN_ITEM+"." //! Shown when the user tries to sell more stuff to the merchant than they have demand for.
	var/no_common_language = "What? I don't understand." //! Shown when users attempt to speak to the merchant without at least one of their languages.
	var/leaving_soon = "I'm leaving in about "+MERCHANT_TOKEN_TIME+" minutes." //! Shown when users ask how long the merchant will stick around for, and the merchant is temporary.
	var/staying_put = "I'm not going anywhere anytime soon." //! Shown when users ask how long the merchant will stick around for, but the merchant isn't gonna leave.
	var/refused_purchase = "I can't sell you that "+MERCHANT_TOKEN_ITEM+"." //! Shown when a merchant refuses to sell something specific to a player, due to a failed requirement.
	var/mob_transfer_message = "You are transported to "+MERCHANT_TOKEN_ORIGIN+"."	//! Message shown to mobs that are sold to this merchant. This is printed directly to the mob's chatlog.

	// These are defined as consts here so that it remains accessible by code external to the modpack.
	var/static/const/MERCHANT_TOKEN_MERCHANT_NAME = "%MERCHANT_NAME%"	//! The name of the current trader.
	var/static/const/MERCHANT_TOKEN_ORIGIN = "%MERCHANT_ORIGIN%"		//! The selected origin of the trader station.
	var/static/const/MERCHANT_TOKEN_VALUE = "%VALUE%"					//! The value of the trade, as a numerical value.
	var/static/const/MERCHANT_TOKEN_QUANTITY = "%QUANTITY%"				//! How many of a particular item is being bought or sold, as a numerical value.
	var/static/const/MERCHANT_TOKEN_CURRENCY = "%CURRENCY%"				//! The name of the currency in use. May use the singular name if applicable.
	var/static/const/MERCHANT_TOKEN_CURRENCY_SINGULAR = "%CURRENCY_SINGULAR%"	//! The singular name of the unit of currency in use.
	var/static/const/MERCHANT_TOKEN_ITEM = "%ITEM%"						//! The item's name that is being traded.
	var/static/const/MERCHANT_TOKEN_PLAYER_NAME = "%PLAYER_NAME%"		//! The user's visible name.
	var/static/const/MERCHANT_TOKEN_TIME = "%TIME%"						//! How much more time is left before the merchant leaves, in minutes.
	var/static/const/MERCHANT_TOKEN_PLAYER_HONORIFIC = "%PLAYER_HONORIFIC%"	//! The user's honorific.
