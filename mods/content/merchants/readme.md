# Merchant System Modpack
This modpack contains the systems for Merchants. The modpack does not contain any merchant content, meaning that there are no merchants included. Instead, a merchant content modpack, such as **Standard Merchants**, must also be included in order for players to be able to buy and sell things to merchants.

This readme is intended to give an overview of how the system works, primarily for those looking to create custom merchant content for downstream servers. Another good resource is to look at the Standard Merchants modpack's code to see how it works.


#### Note
The readme sometimes uses the term `item`, which in this context should be understood as `/atom/movable`, and not `/obj/item`.

# What is a...

## Merchant
Merchants are off-map NPCs that players can interact with through the merchant program on a computer, alongside a merchant pad, to buy and sell things.


## Merchant Program
An in-game computer program which is required in order to interact with the merchant NPCs. Note that access to this program is not automatically given out by default, so custom maps may need to override it, like Tradeship does.


## Merchant Pad
Merchant Pads are special teleporters that computers with the merchant program can use to teleport items to and from merchants. The computer needs to be adjacent to a merchant pad in order to buy or sell things.


## Trade Hub
Trade Hubs act as a container for existing merchant instances, as well as an in-game representation for where the merchants might be. They can hold up to a certain number of merchants.

Singleton Trade Hubs provide access to their merchants from anywhere, unconditionally. They are the simplest means to have players be able to access a set of merchants.

Trade Hubs can also be represented on the overmap as a physical location, using `/obj/effect/overmap/trade_hub` instances to determine where on the overmap they are. Players must be on the same overmap tile as the trade hub in order to interact with them.


## Commodity
A commodity represents a specific kind of thing that the merchant could buy or sell. They are held by each merchant instance inside of either `active_supply`, `inactive_supply`, `active_demand`, or `inactive_demand` lists, and are filled at runtime. The active lists hold commodities that are available to players at the moment, while the inactive hold things that failed to make the cut.

They are created in bulk by potential commodity subtypes, held inside of a merchant's `potential_supply` and `potential_demand`. You should never have to interact with commodities in the code directly, and instead use potential commodities to determine what merchants can buy or sell.


## Potential Commodity
Potential commodities are what ultimately determines what things a merchant wants to buy or sell. They are held inside of a merchant's `potential_supply`, and `potential_demand`, with supply being what merchants can sell to players, and demand being what they can buy from players. When merchants are initialized, they create commodity instances and put them in their active or inactive lists automatically.

Each merchant will generally have one or more potential commodity decls that contains the things they want to buy or sell. Alternatively, they can also re-use potential commoditiy decls from other merchants, or premade decls created for convenience, such as the one which contains all ores that can be mined.


## Commodity Requirements
Commodities can have a number of requirements attached to them, that must all evaluate to `TRUE` in order for the merchant to agree to buy (or rarely, to sell) something. The most common requirement are type checks, but those are not strictly required, and it is possible to create a merchant who's willing to buy anything. Other requirements can be things such as requiring that a particular item be made of a specific material, that a gas be of a certain temperature, or that a mob being sold be of a specific species. This allows for merchants to buy a wide range of items that the old typecheck-centric system could not, as well as preventing issues arising from things like mapped in material sheets technically being a different type compared to newly created sheets. The name of a commodity can change based on the requirements it has. For example, a commodity that has the requirements that the item be a wrench, and be made out of gold, will have the name `golden wrench`.

Like commodity instances themselves, requirements are added to them automatically by the potential commodity decl that created them.

You generally don't need to worry about requirements too much, as there are a number of helper types that already have the correct requirements included, for things like reagents or gases.


# How do I...

## Add a new Merchant?
Create a subtype of `/datum/merchant`, and fill out the relevant variables.

`/datum/merchant/transient` is used to signify subtypes which are expected to be temporary most of the time. This is mainly used for default Trade Hubs that accumulate transient merchants as the round goes on. Note that transient merchants can become permanent, and regular merchants can be made to be temporary. The type just automatically makes subtypes start out as temporary merchants.

`/datum/merchant/transient/rare` works similarly to the preceding type, but the default Trade Hub implementation has a low chance of choosing this type of merchant.

You do not need to conform to those types if you don't intend to use the default trade hub's implementation.

## Make Merchants buy or sell things?
Create a subtype of `/decl/merchant_potential_commodities`. This determines what merchants want to buy or sell, as well as other information, like how many of each item they have or want, or if the items need to conform to certain requirements.

The list `type_instructions` determines what types merchants want to buy or sell. It is an assocative list, with the keys being type paths, and the values being instructions on what each type should do.

There are a number of instructions available:
* `MERCHANT_INCLUDE_THIS_TYPE` makes merchants offer this type. Subtypes are not included.
* `MERCHANT_INCLUDE_SUBTYPES` makes merchants offer subtypes of this type. The base type is not included.
* `MERCHANT_INCLUDE_ALL` combines `MERCHANT_INCLUDE_THIS_TYPE` and `MERCHANT_INCLUDE_SUBTYPES`, making merchants offer this type and all subtypes derived from it.
* `MERCHANT_EXCLUDE_THIS_TYPE` makes merchants not offer the type specified. Subtypes might still be offered if a preceding instruction included them.
* `MERCHANT_EXCLUDE_SUBTYPES` makes merchants not offer subtypes of the type specified. The base type may still be offered if a preceding instruction included it.
* `MERCHANT_EXCLUDE_ALL` combines `MERCHANT_EXCLUDE_THIS_TYPE` and `MERCHANT_EXCLUDE_SUBTYPES`, making merchants not offer either this type, or any subtypes derived from it.

Instructions are evaluated sequentially, meaning that instructions lower in the list may override instructions above. Excludes should go underneath relevant includes, or they will not work.

`item_quantity_lower_bound` and `item_quantity_upper_bound` can be used if you wish to limit how much of a particular item is available to be bought or sold.

Here is an example of what a subtype could look like:
```
/decl/merchant_potential_commodities/example
	type_instructions = list(
		/obj/item/foo			= MERCHANT_INCLUDE_ALL,
		/obj/item/foo/bar		= MERCHANT_EXCLUDE_THIS_TYPE,
	)
    item_quantity_lower_bound = 2
    item_quantity_upper_bound = 5
```

This will cause a merchant that possesses this decl to either buy or sell the type `/obj/item/foo`, and all of its subtypes, except for `/obj/item/foo/bar`. Each distinct type will also have a limited amount, between 2 and 5.

To have the new merchant use the decl, place it inside of the merchant's `supply_potential` if you want merchants to sell things using the decl, or `demand_potential` if you want them to buy things with it. Multiple decls can be placed inside the lists, and they can be reused between different merchants.


## Make Merchants buy reagents/gases/material sheets?
To have merchants correctly **buy** non-standard items, create a subtype of one of the following:
* `/decl/merchant_potential_commodities/reagents`, for buying reagents (drinks, medicine, liquified metals).
* `/decl/merchant_potential_commodities/materials`, for buying lots of different kinds of materials, such as material stacks (ores, sheets).
* `/decl/merchant_potential_commodities/gases`, for gases (oxygen, air, steam, vaporized blood).

These subtypes automatically include some required information to have merchants correctly identify non-standard things.

Some of these types will need to have additional information added in order to function, such as `/material_stacks` having a `stack_types` list. You can either look at the code for the specific subtype you want to use, or consult the Standard Merchants modpack to see how it uses these types.

If you want merchants to **sell** these things, no special subtype is required, just have the merchant sell a prefilled type of something, like a gas canister.


## Make Merchants charge/pay for items differently?
Merchants use `/decl/merchant_price_modifier`s, alongside an object's base price, to determine how much something should cost to buy or sell. Price Modifiers are held inside of two assocative lists on the merchant type, `supply_price_modifiers` and `demand_price_modifiers`. Supply is used for things the merchant could sell to players, and demand is used for things the merchant could buy from players.

Modifiers are used alongside a value inside of the price modifiers lists. For example, `/decl/merchant_price_modifier/percentage = 1.5` will cause the price of an object to increased by 50%. Multiple modifiers can be stacked together to create more complex pricing structures for merchants. Disposition discounts and skill system price interactions are handled using specific price modifiers, and not having them will make those mechanics not apply, which may or may not be desirable.

You shouldn't need to create subtypes, unless you want to implement custom logic for pricing things.


## Make Merchants offer to buy or sell more (or less) distinct items at once?
A merchant's `supply_strategy` and `demand_strategy` contains a `/decl/merchant_inventory_strategy` type path which determines how merchants divide items between their 'active' and 'inactive' lists. The default implementation tries to avoid having merchants offer to buy or sell lots of items at once. You can change the strategy used in order to have them offer a more predetermined amount of items, or enable behaviors such as rotating items over time.

If you don't want anything to go into an inactive list, you can use `/decl/merchant_inventory_strategy/offer_everything` to opt out of this system.



## Make Merchants talk differently?
Create a subtype of `/decl/merchant_speech`, and fill out the variables according to how you want the merchant to sound to players.

Certain lines can use placeholders that can be replaced at runtime with an appropiate value. For example, `leaving_soon` can use `MERCHANT_TOKEN_TIME`, which will place a number for how many minutes the merchant is staying for. E.g. `leaving_soon = "I'll be gone in about "+MERCHANT_TOKEN_TIME+" minutes."`.

When you are done, assign the new speech decl's type path to the merchant's `speech` variable.


## Add Merchants to Trade Hubs?
The default Trade Hub implementation will automatically populate itself with most types of merchants randomly, some at the start and the rest over time. If this is what you want, then you don't need to do anything else.

If instead you want specific merchants to always show up, or specific merchants to have a chance to show up, you can create a subtype of `/datum/trade_hub`, and add the desired merchant types to the relevant list on that type. This is what the Tradeship map does to ensure that certain merchants are always present.


## Automatically spawn in Trade Hubs?
The modpack adds a stub to `/datum/map` called `create_trade_hubs()`, which is called during initialization. The default implementation spawns in a singleton trade hub. You can override it to use a custom type, or add custom logic.


## Test Merchants manually?
There are a number of admin verbs to make testing your new merchants easier. `Debug verbs` must be used first to access these verbs.

* `List Merchants` prints a list of every merchant instance currently exists, as well as their trade hubs. Also includes buttons to view the variables of a specific merchant or trade hub.
* `Add Merchant` lets you instantiate a specific merchant subtype in an existing trade hub.
* `Remove Merchant` deletes a specific merchant from existance.
* `Add Singleton Trade Hub` lets you instantiate a specific singleton trade hub subtype. Singleton trade hubs can be accessed from anywhere.
* `Add Overmap Trade Hub` lets you instantiate a specific overmap trade hub subtype. Your mob must be on an overmap tile for this to work, as it determines where the new hub will go. You can jump to the overmap with admin verbs.
* `Remove Trade Hub` deletes a specific trade hub, and all of their merchants, from existance.