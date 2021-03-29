## How to add a custom item
1. Pick the most relevant directory for your item, and examine the template inside.

2. Create a .json file in the directory with the following naming scheme: ckey-itemtype.json (e.g. babydoll-necklace.json)

3. Fill out the provided template in the directory of your choice. See chart below for an explanation of the values.

| Key                    | Expected Value   | Function                                                                                                                |
|------------------------|------------------|-------------------------------------------------------------------------------------------------------------------------|
| ckey                   | string           | Your ckey. This is not quite the same as your BYOND key, ask an admin or check the BYOND docs if you are unsure.        |
| character_name         | string           | The name of the character the item should spawn with.                                                                   |
| item_name              | string           | The name of your custom item ingame. For kits, the name of the kit product.                                             |
| item_desc              | string           | The description of your custom item ingame. For kits, the descriptor for the kit product.                               |
| item_icon              | file path        | The location of the icon file to load for your item (ex. icons/custom_icon_file.dmi)                                    |
| item_state             | string           | The icon state for your custom item. For kits, the icon state of the kit product, or the icon state of the mech decal.  |
| item_path              | string           | A fully specified BYOND object path (ie. /obj/item/foo/bar).                                                            |
| apply_to_target_type   | string           | A fully specified BYOND object path (ie. /obj/item/foo/bar) Only set this if you are reskinning an existing item.       |
| req_access             | array of strings | Access strings required for the character to have this item on spawn.                                                   |
| req_titles             | array of strings | Titles and alt titles that are allowed to spawn with this item.                                                         |
| additional_data        | array of values  | An associative list of other values. See each the relevant template for your item for more information on this field.   |

4. Read the notes section in the template you're using carefully, and set up `additional_data` as directed. If your template has no notes, skip this step.

5. You're done. Compile, test (see final section below), and discover you misspelled a state, etc.

## How to add a custom robot icon sheet
1. Add a config entry to custom_sprites.txt:
```
ckey-robotname
```

1. Create icon and eye states for each of the following modules: Standard, Engineering, Construction, Janitor, Surgeon, Crisis, Miner, Security, Service, Clerical, Research
1. Create maintenance panel states for: opened, cell removed, and wires cut.
1. Name your main states in the following format: `yourckey-ModuleName`
1. Name your eyes states in the following format: `eyes-yourckey-ModuleName`
1. The open panel should be named yourkey-openpanel +c; the panel with no cell should be named `yourckey-openpanel-c`; the wire panel should be named `yourckey-openpanel +w`

## How to add a custom AI display
1. Add a config entry to custom_sprites.txt. Either:
  ````
  ckey:ai_name
  ````
  or
  ````
  ckey:ai_name:icon_state
  ````

  - ckey should be your key with no spaces or underscores, all in lowercase. 
  - ai_name is the exact name you will use for the AI the display belongs to.
  - icon_state is the name of your AI icon states without the "-ai" or "-ai-crashed" suffixes. Defaults to the ckey value if unset.
  
  Multiple entries per player is possible, as long as the icon_state value is set and unique, i.e.:
  ````
  ckey:ai_name:custom_icon_1
  ckey:ai_name:custom_icon_2
  ````

2. Add the first or both of the following icon states to icons/custom_synthetic.dmi named {icon_state}-ai and {icon_state}-ai-crash (the ai-crash icon state is optional), replacing {icon_state} with the icon_state value you've selected.
  ````
  ckey_example:ExampleAIName
  ````
  With the example above the resulting icon state names would be "ckey_example-ai" (required) and "ckey_example-ai-crash" (optional).
  
  ````
  ckey_example:ExampleAIName:example_icon_state
  ````
  With the example above the resulting icon state names would be "example_icon_state-ai" (required) and "example_icon_state-ai-crash" (optional).

## How to locally test a custom item

1. Create a .json file as directed above, and place it in the `config/custom_items` directory of your local copy of your main repository (eg. Baystation12)
3. Change ckey in the definition to YOUR CKEY. Change name to a character name you will be using for testing, or just use their name.
4. Add the relevant icons to the relevant files in your main repo folder.
5. Compile and run the game. Ready up, taking note of any job or access restrictions, and start the round. If you did it all correctly, you will have spawned the custom item. If not, it should hopefully print an error to world.log. 
6. Once you're done testing, make sure you revert any changes made in your main repo folder. Do not push custom items related things to the main repo!