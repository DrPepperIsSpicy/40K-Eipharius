/datum/class_sheet/penitent
	classes = list(
	/datum/class/messiantribal,
	/datum/class/nomad,
	/datum/class/scum,
	/datum/class/witchhunter,
	/datum/class/mercenary,
	)

/datum/class/mercenary
	name = "Mercenary"
	default_outfit = /decl/hierarchy/outfit/job/mercenary

/datum/class/mercenary/post_equip(mob/living/carbon/human/H, rolled_outfit)
	if(!rolled_outfit)
		to_chat(H,"<span class='danger'><b><font size=4>THE BOUNTY HUNTER</font></b></span>")
		to_chat(H,"<span class='goodmood'>A vicious bounty hunter traveling from system to system in search of their next payday, you live luxuriously only for moments before being plunged back into poverty. Hitching a ride to Messina with the last of your thrones, you gamble on the hope of finding work out here.(A-Help if nobody is hiring bounty hunters for a bounty target+pay)</font></b></span>")
		H.add_stats(rand(13,17), rand(14,17), rand(14,17), rand (12,15))
		if(prob(60))
			new /obj/item/clothing/suit/armor/bountyhunter2(H.loc)
			new /obj/item/clothing/head/bountyhead(H.loc)
		else if(prob(50))
			new /obj/item/clothing/suit/armor/carapace3(H.loc)
			new /obj/item/clothing/head/helmet/marinehelm(H.loc)
		else if(prob(30))
			new /obj/item/clothing/suit/armor/vanpa(H.loc)
		else
			new /obj/item/ammo_magazine/c50(H.loc)
			if(prob(15))
				new /obj/item/device/radio/headset/red_team(H.loc)
				new /obj/item/card/id/key/middle/jail(H.loc)
			if(prob(3))
				new /obj/item/device/radio/headset/headset_sci(H.loc)
				new /obj/item/card/id/key/grand/monastary(H.loc)
		return ..()
	switch(rolled_outfit)
		if(/decl/hierarchy/outfit/job/merc_paladin)
			to_chat(H,"<span class='danger'><b><font size=4>THE PALADIN</font></b></span>")
			to_chat(H,"<span class='goodmood'>A holy warrior of your chosen god, you work on behalf of the Ecclesiarchy(or the cult) as a slayer of the heretical and unfaithful. Face against the dark and protect your flock... for a price.</font></b></span>")
			H.add_stats(rand(16,18), rand(14,16), rand(16,18), rand (10,12)) //veteran mercenary
			var/datum/heretic_deity/deity = GOD(H.client.prefs.cult)
			deity.add_cultist(H)
			if(prob(45))
				new /obj/item/device/radio/headset/headset_sci(H.loc)
		if(/decl/hierarchy/outfit/job/merc_operative)
			to_chat(H,"<span class='danger'><b><font size=4>THE OPERATIVE</font></b></span>")
			to_chat(H,"<span class='goodmood'>You are an operative sent here by your benefactors, mysterious patrons from worlds away to do work that may unlock the final steps to their ultimate plan((A-Help with your idea or even ask for a mission if you can't think of anything.))</font></b></span>")
			H.add_stats(rand(13,17), rand(14,17), rand(14,17), rand (10,12)) //veteran mercenary
			if(prob(2))
				new /obj/item/device/radio/headset/headset_eng(H.loc)
			if(prob(2))
				new /obj/item/device/radio/headset/red_team(H.loc)
			if(prob(3))
				new /obj/item/device/radio/headset/headset_sci(H.loc)
			if(prob(15))
				new /obj/item/device/radio/headset/blue_team/all(H.loc)

	return ..()

/decl/hierarchy/outfit/job/merc_operative
	name = "Operative outfit"
	uniform = /obj/item/clothing/under/rank/victorian
	shoes = /obj/item/clothing/shoes/jackboots/pilgrim_boots
	id_type = /obj/item/card/id/pilgrim/penitent
	back = /obj/item/storage/backpack/satchel/warfare
	l_ear = /obj/item/device/radio/headset/headset_service //Meant to be with the Mechanicus now.
	l_pocket = /obj/item/device/flashlight/lantern
	r_pocket = /obj/item/clothing/accessory/holster/hip
	backpack_contents = list(
	/obj/item/pen = 1,
	/obj/item/stack/thrones3/twenty = 1,
	/obj/item/paper/administratum/theta = 1,
	/obj/item/plastique = 1,
	/obj/item/grenade/spawnergrenade/manhacks = 1,
	/obj/item/ammo_casing/c45/ap = 2,
	/obj/item/paper/administratum/weapon4 = 1,
	)
	suit = /obj/item/clothing/suit/armor/armoredtrench
	l_hand = /obj/item/gun/projectile/talon/renegade

/decl/hierarchy/outfit/job/merc_paladin
	name = "Paladin outfit"
	uniform = /obj/item/clothing/under/rank/victorian
	shoes = /obj/item/clothing/shoes/jackboots/pilgrim_boots
	id_type = /obj/item/card/id/pilgrim/penitent
	head = /obj/item/clothing/head/helmet/hero
	back = /obj/item/storage/backpack/satchel/warfare
	l_ear = /obj/item/device/radio/headset/headset_service //Meant to be with the Mechanicus now.
	l_pocket = /obj/item/device/flashlight/lantern
	r_pocket = /obj/item/clothing/accessory/holster/hip
	backpack_contents = list(
	/obj/item/pen = 1,
	/obj/item/paper/administratum/theta = 1,
	/obj/item/paper/administratum/weapon3 = 1,
	)
	suit = /obj/item/clothing/suit/armor/brigandine
	l_hand = /obj/item/gun/energy/las/laspistol
	r_hand = /obj/item/melee/trench_axe/glaive/adamantine

/decl/hierarchy/outfit/job/mercenary
	name = "Mercenary outfit"
	uniform = /obj/item/clothing/under/rank/victorian
	shoes = /obj/item/clothing/shoes/jackboots/pilgrim_boots
	id_type = /obj/item/card/id/pilgrim/penitent
	back = /obj/item/storage/backpack/satchel/warfare
	l_ear = /obj/item/device/radio/headset/headset_service //Meant to be with the Mechanicus now.
	l_pocket = /obj/item/device/flashlight/lantern
	r_pocket = /obj/item/clothing/accessory/holster/hip
	backpack_contents = list(
	/obj/item/pen = 1,
	/obj/item/paper/administratum/theta = 1,
	/obj/item/paper/administratum/weapon4 = 1,
	)
	suit = /obj/item/clothing/suit/armor/witch
	l_hand = /obj/item/gun/energy/las/laspistol
	r_hand = /obj/item/melee/sword/cane

/datum/class/witchhunter
	name = "Witch Hunter"
	default_outfit = /decl/hierarchy/outfit/job/witchhunter

/datum/class/witchhunter/post_equip(mob/living/carbon/human/H, rolled_outfit)
	to_chat(H,"<span class='danger'><b><font size=4>THE WITCH HUNTER</font></b></span>")
	to_chat(H,"<span class='goodmood'>You are a Witch Hunter -- a unique subset of the Bounty Hunter Guild attached to the Chamber Militant, working both as Servant to the Ecclesiarchy and a 'bounty hunter' that the Ecclesiarchy can rely upon without tainting their own hands.</font></b></span>")
	return ..()

/decl/hierarchy/outfit/job/witchhunter
	name = "Witch Hunter outfit"
	uniform = /obj/item/clothing/under/rank/victorian
	shoes = /obj/item/clothing/shoes/jackboots/pilgrim_boots
	head = /obj/item/clothing/head/helmet/witch
	id_type = /obj/item/card/id/key/grand/monastary
	back = /obj/item/storage/backpack/satchel/warfare
	l_ear = /obj/item/device/radio/headset/headset_sci //Meant to be with the Mechanicus now.
	l_pocket = /obj/item/device/flashlight/lantern
	r_pocket = /obj/item/clothing/accessory/holster/hip
	backpack_contents = list(
	/obj/item/pen = 1,
	/obj/item/paper/administratum/theta = 1,
	/obj/item/paper/administratum/weapon4 = 1,
	)
	suit = /obj/item/clothing/suit/armor/witch
	l_hand = /obj/item/gun/energy/las/laspistol
	r_hand = /obj/item/melee/sword/cane

/datum/class/scum
	name = "Scum"
	default_outfit = /decl/hierarchy/outfit/job/scum
	outfits = list(/decl/hierarchy/outfit/job/obscura = 35)

/datum/class/scum/post_equip(mob/living/carbon/human/H, rolled_outfit)
	if(!rolled_outfit)
		to_chat(H,"<span class='danger'><b><font size=4>THE PENITENT</font></b></span>")
		to_chat(H,"<span class='goodmood'>You are a penitent, after committing several horrible crimes to the imperium, you were arrested and imprisoned for years before being released by the church. As per your punishment you are marked and must take upon the burdens of others to ease your own...</font></b></span>")
		H.add_stats(rand(16,17), rand(16,17), rand(12,16), rand (10,15))
		if(prob(25))
			new /obj/item/device/radio/headset/headset_sci(H.loc)
		return ..()
	else
		to_chat(H,"<span class='danger'><b><font size=4>THE OBSCURA DEALER</font></b></span>")
		to_chat(H,"<span class='goodmood'>You're a lowlife obscura dealer, with connections to the local gangs and heretical circles you make a nice living for yourself.</font></b></span>")
		H.add_stats(rand(13,16), rand(15,16), rand(12,16), rand (17,18))
		if(prob(50))
			new /obj/item/clothing/under/rank/victorian/redbl(H.loc)
		var/datum/heretic_deity/deity = GOD(H.client.prefs.cult)
		deity.add_cultist(H)
		if(prob(5))
			new /obj/item/device/radio/headset/blue_team/all(H.loc)
	return ..()

/decl/hierarchy/outfit/job/obscura
	name = "Obscura Dealer outfit"
	uniform = /obj/item/clothing/under/rank/victorian/blred
	shoes = /obj/item/clothing/shoes/jackboots/pilgrim_boots
	head = /obj/item/clothing/head/scum
	id_type = /obj/item/card/id/pilgrim/penitent
	back = /obj/item/storage/backpack/satchel/warfare
	l_ear = /obj/item/device/radio/headset/headset_sci //Meant to be with the Mechanicus now.
	l_pocket = /obj/item/device/flashlight/lantern
	backpack_contents = list(
	/obj/item/pen = 1,
	/obj/item/paper/administratum/weapon3 = 1,
	/obj/item/storage/fancy/cigarettes/dromedaryco = 2,
	/obj/item/storage/pill_bottle/happy = 2,
	/obj/item/storage/pill_bottle/zoom = 1,
	/obj/item/stack/thrones/five = 1,
	/obj/item/reagent_containers/food/snacks/threebread = 1,
	)
	suit = /obj/item/clothing/suit/scum
	l_hand = /obj/item/gun/projectile/slugrevolver/penitent

/decl/hierarchy/outfit/job/scum
	name = "Scuum outfit"
	uniform = /obj/item/clothing/under/rank/penitent
	shoes = /obj/item/clothing/shoes/jackboots/pilgrim_boots
	head = /obj/item/clothing/head/plebhood
	id_type = /obj/item/card/id/pilgrim/penitent
	back = /obj/item/storage/backpack/satchel/warfare
	l_ear = /obj/item/device/radio/headset/headset_sci //Meant to be with the Mechanicus now.
	l_pocket = /obj/item/torch/self_lit
	backpack_contents = list(
	/obj/item/pen = 1,
	/obj/item/paper/administratum/weapon3 = 1,
	/obj/item/ammo_magazine/c44 = 2,

	)
	suit = /obj/item/clothing/suit/raggedrobe
	l_hand = /obj/item/gun/projectile/slugrevolver/penitent

/datum/class/nomad
	name = "Nomad"
	default_outfit = /decl/hierarchy/outfit/job/nomad
	outfits = list(/decl/hierarchy/outfit/job/beast = 15)

/datum/class/nomad/post_equip(mob/living/carbon/human/H, rolled_outfit)
	if(!rolled_outfit)
		to_chat(H,"<span class='danger'><b><font size=4>THE EXPLORER</font></b></span>")
		to_chat(H,"<span class='goodmood'>A skilled explorer of frontier worlds, you've plied your trade aiding the most unsensible of imperials and even xenos survive otherwise suicidal treks into alien worlds. Here you are once again, upon a xenos tainted world likely a few steps from your grave.</font></b></span>")
		H.add_stats(rand(14,18), rand(15,18), rand(16,17), rand (14,16))
		if(prob(30))
			new /obj/item/gun/energy/las/lasgun/shitty(H.loc)
		else if(prob(30))
			new /obj/item/gun/energy/pulse/pulsepistol(H.loc)
		else if(prob(10))
			new /obj/item/gun/energy/pulse/plasma/pistol/glock(H.loc)
		else
			new /obj/item/gun/energy/las/triplex(H.loc)
		return ..()
	else
		to_chat(H,"<span class='danger'><b><font size=4>THE BEAST</font></b></span>")
		to_chat(H,"<span class='goodmood'>YOU ARE NOT MAN. YOU ARE BEAST MAN. GO OUT INTO WORLD AND DO BEAST THINGS.</font></b></span>")
		H.add_stats(rand(16,18), rand(12,16), rand(17,18), rand (12,14))
	return ..()

/decl/hierarchy/outfit/job/beast
	name = "Beast outfit"
	uniform = /obj/item/clothing/under/rank/victorian
	shoes = /obj/item/clothing/shoes/jackboots/pilgrim_boots
	head = /obj/item/clothing/head/helmet/dragon
	id_type = /obj/item/card/id/pilgrim/penitent
	belt = /obj/item/storage/belt/stalker
	back = /obj/item/storage/backpack/satchel/warfare
	l_ear = /obj/item/device/radio/headset/headset_service //Meant to be with the Mechanicus now.
	l_pocket = /obj/item/device/flashlight/lantern
	backpack_contents = list(
	/obj/item/paper/administratum = 1,
	/obj/item/pen = 1,
	/obj/item/stack/thrones3/twenty = 2,
	/obj/item/reagent_containers/food/snacks/threebread = 1,
	/obj/item/melee/sword/combat_knife/bowie = 1,
	)
	suit = /obj/item/clothing/suit/armor/bonearmor
	l_hand = /obj/item/melee/trench_axe/bardiche/beast

/decl/hierarchy/outfit/job/nomad
	name = "Nomad outfit"
	uniform = /obj/item/clothing/under/rank/victorian
	shoes = /obj/item/clothing/shoes/jackboots/pilgrim_boots
	head = /obj/item/clothing/head/ushanka2
	id_type = /obj/item/card/id/pilgrim/penitent
	belt = /obj/item/storage/belt/stalker
	back = /obj/item/storage/backpack/satchel/warfare
	l_ear = /obj/item/device/radio/headset/headset_service //Meant to be with the Mechanicus now.
	l_pocket = /obj/item/device/flashlight/lantern
	backpack_contents = list(
	/obj/item/paper/administratum = 1,
	/obj/item/pen = 1,
	/obj/item/stack/thrones3/twenty = 2,
	/obj/item/paper/administratum/theta = 1,
	/obj/item/paper/administratum/weapon4 = 1,
	)
	suit = /obj/item/clothing/suit/armor/ranger2

/datum/class/messiantribal
	name = "Messian Tribal"
	default_outfit = /decl/hierarchy/outfit/job/messiantribal
	outfits = list(/decl/hierarchy/outfit/job/venator = 15, /decl/hierarchy/outfit/job/hunter = 35, /decl/hierarchy/outfit/job/master = 15) // Equipment

/datum/class/messiantribal/post_equip(mob/living/carbon/human/H, rolled_outfit)
	if(!rolled_outfit)
		to_chat(H,"<span class='goodmood'><b><font size=3>You are a local hunter and tribal from one of the many wandering tribes of Messina, you've only recently learned of Low Gothic and are adjusting to imperial rule.. </font></b></span>")
		H.add_stats(rand(14,17), rand(14,17), rand(12,18), rand (12,14))
		return ..()
	switch(rolled_outfit)
		if(/decl/hierarchy/outfit/job/venator)
			to_chat(H,"<span class='danger'><b><font size=4>THE VENATOR</font></b></span>")
			to_chat(H,"<span class='goodmood'><b><font size=3>You have had glimpses of the future, in these waking dreams you see yourself fighting against a terrible foe. A dark and hideous creature, this day will come soon. Train and prepare yourself for this fight, track down the great beasts of the land. You are not hunted. You are the hunter. </font></b></span>")
			H.add_stats(rand(18,19), rand(14,16), rand(12,18), rand (12,14))
		if(/decl/hierarchy/outfit/job/master)
			to_chat(H,"<span class='danger'><b><font size=4>THE MASTER</font></b></span>")
			to_chat(H,"<span class='goodmood'><b><font size=3>You are the master of the sewer, ruler of sin, master of your own kingdom. Embrace the dark and grow evil in the deep dark. </font></b></span>")
			H.add_stats(rand(16,19), rand(16,19), rand(19,21), rand (14,16))
			H.add_skills(rand(5,8),rand(5,6),rand(5,6),rand(2,6),rand(5,6))
			var/datum/heretic_deity/deity = GOD(H.client.prefs.cult)
				deity.add_cultist(H)
			if(prob(2))
				new /obj/item/device/radio/headset/headset_eng(H.loc)
			if(prob(3))
				new /obj/item/device/radio/headset/red_team(H.loc)
			if(prob(5))
				new /obj/item/device/radio/headset/headset_sci(H.loc)
			if(prob(5))
				new /obj/item/device/radio/headset/blue_team/all(H.loc)
		if(/decl/hierarchy/outfit/job/hunter)
			to_chat(H,"<span class='danger'><b><font size=4>THE HUNTER</font></b></span>")
			to_chat(H,"<span class='goodmood'>You once were a traveller and a explorer, born with an innate gift for pathfinding among the Messian folk of the greater region. With the arrival of the Imperial Dogs came the shackling, forced servitude to a cruel governor and now you spend your days killing beasts to feed the fat nobles of the Imperium.</font></b></span>")
			H.add_stats(rand(12,16), rand(14,17), rand(15,16), rand (12,16))
			if(prob(40))
				H.equip_to_slot_or_del(new /obj/item/gun/projectile/shotgun/pump/boltaction/shitty/glory, slot_l_hand)
			else
				H.equip_to_slot_or_del(new /obj/item/gun/projectile/thrower, slot_l_hand)
				new /obj/item/storage/box/sniperammo/apds/bos(H.loc)
				new /obj/item/storage/box/sniperammo/apds/bos(H.loc)
	return ..()

/decl/hierarchy/outfit/job/messiantribal
	name = "Messian Tribal outfit"
	uniform = /obj/item/clothing/under/rank/victorian
	shoes = /obj/item/clothing/shoes/jackboots/pilgrim_boots
	back = /obj/item/storage/backpack/satchel/warfare
	l_ear = /obj/item/device/radio/headset/headset_service //Meant to be with the Mechanicus now.
	l_pocket = /obj/item/device/flashlight/lantern
	backpack_contents = list(
	/obj/item/paper/administratum = 1,
	/obj/item/pen = 1,
	/obj/item/stack/thrones3/twenty = 2,
	)
	suit = /obj/item/clothing/suit/armor/leather
	r_hand = /obj/item/melee/trench_axe/bspear/hunter

/decl/hierarchy/outfit/job/venator
	name = "Venator outfit"
	uniform = /obj/item/clothing/under/rank/victorian
	shoes = /obj/item/clothing/shoes/jackboots/pilgrim_boots
	back = /obj/item/storage/backpack/satchel/warfare
	l_ear = /obj/item/device/radio/headset/headset_service //Meant to be with the Mechanicus now.
	l_pocket = /obj/item/device/flashlight/lantern
	suit = /obj/item/clothing/suit/armor/exile
	r_hand = /obj/item/melee/sword/machete/chopper/heavy/slayer
	backpack_contents = list(
	/obj/item/paper/administratum = 1,
	/obj/item/pen = 1,
	/obj/item/stack/thrones3/twenty = 1,
	)

/decl/hierarchy/outfit/job/master
	name = "Master outfit"
	uniform = /obj/item/clothing/under/rank/victorian
	shoes = /obj/item/clothing/shoes/jackboots/pilgrim_boots
	back = /obj/item/storage/backpack/satchel/warfare
	l_ear = /obj/item/device/radio/headset/headset_service //Meant to be with the Mechanicus now.
	l_pocket = /obj/item/device/flashlight/lantern
	suit = /obj/item/clothing/suit/armor/scum2
	backpack_contents = list(
	/obj/item/paper/administratum = 1,
	/obj/item/pen = 1,
	/obj/item/stack/thrones3/twenty = 1,
	/obj/item/reagent_containers/food/snacks/threebread = 1,

	)

/decl/hierarchy/outfit/job/hunter
	name = "Hunter outfit"
	uniform = /obj/item/clothing/under/rank/victorian
	shoes = /obj/item/clothing/shoes/jackboots/pilgrim_boots
	suit = /obj/item/clothing/suit/sherpa
	back = /obj/item/storage/backpack/satchel/warfare
	l_ear = /obj/item/device/radio/headset/headset_service //Meant to be with the Mechanicus now.
	l_pocket = /obj/item/device/flashlight/lantern
	backpack_contents = list(
	/obj/item/paper/administratum = 1,
	/obj/item/pen = 1,
	/obj/item/ammo_magazine/handful/brifle_handful,
	/obj/item/ammo_magazine/handful/brifle_handful/ms,
	/obj/item/reagent_containers/food/snacks/threebread,
	)
