#define TRADER_THIS_TYPE         BITFLAG(0)
#define TRADER_SUBTYPES_ONLY     BITFLAG(1)
#define TRADER_ALL               (TRADER_THIS_TYPE|TRADER_SUBTYPES_ONLY)
#define TRADER_BLACKLIST         BITFLAG(2)
#define TRADER_BLACKLIST_SUB     BITFLAG(3)
#define TRADER_BLACKLIST_ALL     (TRADER_BLACKLIST|TRADER_BLACKLIST_SUB)

#define TRADER_WANTED_ONLY       BITFLAG(0)             // Do they only trade for wanted goods?
#define TRADER_MONEY             BITFLAG(1)             // Do they only accept money in return for goods.
#define TRADER_GOODS             BITFLAG(2)             // Do they accept goods in return for other goods.
#define TRADER_WANTED_ALL        BITFLAG(3)             // Like TRADER_WANTED_ONLY but they buy all possible wanted goods rather than a subset.
#define TRADER_BRIBABLE          BITFLAG(4)             // Determines if the trader can be bribed (stations cannot as they can't leave)

// Tokens for constructing the hail tags (usually generic, species name or silicon).
// When merchants hail a person they use "trade_hail_[some token]".
#define TRADER_HAIL_START        "trade_hail_"
#define TRADER_HAIL_GENERIC_END  "generic"
#define TRADER_HAIL_SILICON_END  "silicon"
#define TRADER_HAIL_GENERIC      TRADER_HAIL_START + TRADER_HAIL_GENERIC_END // Default hail response token.
#define TRADER_HAIL_SILICON      TRADER_HAIL_START + TRADER_HAIL_SILICON_END // Used when hailed by a robot or AI.
#define TRADER_HAIL_DENY         TRADER_HAIL_START + "deny"                  // Used When merchant denies a hail.

//Possible response defines for when offering an item for something
#define TRADER_NO_MONEY          "trade_no_money"       // Used when money is offered to a trader who does not accept money.
#define TRADER_NO_GOODS          "trade_no_goods"       // Used when goods are offered to a trader who does not accept goodds.
#define TRADER_NOT_ENOUGH        "trade_not_enough"     // Used when there is not enough money for the trade.
#define TRADER_NO_BLACKLISTED    "trade_blacklist"      // Used when a blacklisted item is offered by the player.
#define TRADER_FOUND_UNWANTED    "trade_found_unwanted" // Used when an unwanted item is offered by the player.
#define TRADER_TRADE_COMPLETE    "trade_complete"       // When a trade is made successfully.
#define TRADER_HOW_MUCH          "how_much"             // When a merchant tells the player how much something is.
#define TRADER_WHAT_WANT         "what_want"            // What the person says when they are asked if they want something
#define TRADER_COMPLIMENT_DENY   "compliment_deny"      // When the merchant refuses a compliment
#define TRADER_COMPLIMENT_ACCEPT "compliment_accept"    // When the merchant accepts a compliment
#define TRADER_INSULT_GOOD       "insult_good"          // When the player insults a merchant while they are on good disposition
#define TRADER_INSULT_BAD        "insult_bad"           // When a player insults a merchatn when they are not on good disposition
#define TRADER_BRIBE_REFUSAL     "bribe_refusal"        // When the trader refuses a bribe to stay longer.
#define TRADER_BRIBE_ACCEPT      "bribe_accept"         // When the trader accepts a bribe to stay longer.

// Tokens replaced with strings at runtime.
#define TRADER_TOKEN_ORIGIN      "$ORIGIN$"             // The selected origin of the trader station.
#define TRADER_TOKEN_VALUE       "$VALUE$"              // The value of the trade.
#define TRADER_TOKEN_CURRENCY    "$CURRENCY$"           // The plural name of the currency in use
#define TRADER_TOKEN_CUR_SINGLE  "$CURRENCY_SINGULAR$"  // The singular name of the unit of currency in use.
#define TRADER_TOKEN_ITEM        "$ITEM$"               // The relevant item being traded or offered.
#define TRADER_TOKEN_MERCHANT    "$MERCHANT$"           // The name of the current trader.
#define TRADER_TOKEN_MOB         "$MOB$"                // The player currently interacting with the trader.
#define TRADER_TOKEN_TIME        "$TIME$"               // How much longer a successful bribe has gained.
