//	Observer Pattern Implementation: Merchant Arrived
//		Registration type: /datum
//
//		Raised when: A new merchant arrives at a trade hub.
//
//		Arguments that the called proc should expect:
//			/datum/merchant/arrival: The instance that just arrived.
//			/datum/trade_hub/hub: The hub where the merchant arrived at.

/decl/observ/merchant_arrived
	name = "Merchant Arrived"


//	Observer Pattern Implementation: Merchant Departed
//		Registration type: /datum
//
//		Raised when: A new merchant has left a trade hub (and is about to be deleted).
//
//		Arguments that the called proc should expect:
//			/datum/merchant/departure: The instance that just left.
//			/datum/trade_hub/hub: The hub where the merchant left from.

/decl/observ/merchant_departed
	name = "Merchant Departed"
