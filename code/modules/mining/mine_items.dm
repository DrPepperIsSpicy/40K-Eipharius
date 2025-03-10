/**********************Miner Lockers**************************/

/obj/structure/closet/secure_closet/miner
	name = "miner's equipment"
	icon_state = "miningsec1"
	icon_closed = "miningsec"
	icon_locked = "miningsec1"
	icon_opened = "miningsecopen"
	icon_broken = "miningsecbroken"
	icon_off = "miningsecoff"
	req_access = list(access_mining)

/obj/structure/closet/secure_closet/miner/New()
	..()
	sleep(2)
	if(prob(50))
		new /obj/item/storage/backpack/industrial(src)
	else
		new /obj/item/storage/backpack/satchel/satchel_eng(src)
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/clothing/under/rank/miner(src)
	new /obj/item/clothing/gloves/thick(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/storage/ore(src)
	new /obj/item/device/flashlight/lantern(src)
	new /obj/item/shovel(src)
	new /obj/item/pickaxe(src)
	new /obj/item/clothing/glasses/meson(src)

/******************************Lantern*******************************/

/obj/item/device/flashlight/lantern
	name = "lantern"
	icon_state = "lantern"
	desc = "A mining lantern."
	brightness_on = 9			// luminosity when on

/*****************************Pickaxe********************************/

/obj/item/pickaxe
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	name = "pickaxe"
	desc = "It's a pickaxe. You hit rocks with it. And people with it too if you feel like."
	icon = 'icons/obj/mining.dmi'
	slot_flags = SLOT_BELT|SLOT_BACK|SLOT_ICLOTHING
	force = 25
	armor_penetration = 4
	throwforce = 15
	icon_state = "pickaxe"
	item_state = "spickaxe"
	w_class = ITEM_SIZE_NORMAL
	matter = list(DEFAULT_WALL_MATERIAL = 3750)
	var/digspeed = 40 //moving the delay to an item var so R&D can make improved picks. --NEO
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	attack_verb = list("hit", "pierced", "sliced", "attacked")
	var/list/drill_sound = list('sound/items/pickaxe1.ogg','sound/items/pickaxe2.ogg','sound/items/pickaxe3.ogg','sound/items/pickaxe4.ogg')
	var/drill_verb = "drilling"
	sharp = TRUE
	edge = FALSE
	hitsound = "stab_sound"

	var/excavation_amount = 200

/obj/item/pickaxe/newpick
	icon_state = "ospickaxe"

/obj/item/pickaxe/hammer
	name = "sledgehammer"
	//icon_state = "sledgehammer" Waiting on sprite
	desc = "A mining hammer made of reinforced metal. You feel like smashing your boss in the face with this."

/obj/item/pickaxe/silver
	name = "silver pickaxe"
	icon_state = "spickaxe"
	item_state = "spickaxe"
	digspeed = 45
	origin_tech = list(TECH_MATERIAL = 2)
	desc = "This makes no metallurgic sense."

/obj/item/pickaxe/mechanicus
	name = "mechanicus pickaxe"
	icon_state = "spickaxe"
	item_state = "spickaxe"
	digspeed = 35
	origin_tech = list(TECH_MATERIAL = 2)
	desc = "This makes no metallurgic sense."

/obj/item/pickaxe/drill
	name = "advanced mining drill" // Can dig sand as well!
	icon_state = "handdrill"
	item_state = "jackhammer"
	digspeed = 25
	origin_tech = list(TECH_MATERIAL = 2, TECH_POWER = 2, TECH_ENGINEERING = 2)
	desc = "Yours is the drill that will pierce through the rock walls."
	drill_verb = "drilling"

/obj/item/pickaxe/jackhammer
	name = "sonic jackhammer"
	icon_state = "jackhammer"
	item_state = "jackhammer"
	digspeed = 25 //faster than drill, but cannot dig
	origin_tech = list(TECH_MATERIAL = 2, TECH_POWER = 2, TECH_ENGINEERING = 2)
	desc = "Cracks rocks with sonic blasts, perfect for killing cave lizards."
	drill_verb = "hammering"

/obj/item/pickaxe/gold
	name = "golden pickaxe"
	icon_state = "gpickaxe"
	item_state = "gpickaxe"
	digspeed = 47
	origin_tech = list(TECH_MATERIAL = 2)
	desc = "This makes no metallurgic sense."
	drill_verb = "picking"

/obj/item/pickaxe/diamond
	name = "diamond pickaxe"
	icon_state = "dpickaxe"
	item_state = "dpickaxe"
	digspeed = 31
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	desc = "A pickaxe with a diamond pick head."
	drill_verb = "picking"

/obj/item/pickaxe/diamonddrill //When people ask about the badass leader of the mining tools, they are talking about ME!
	name = "diamond mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	digspeed = 22 //Digs through walls, girders, and can dig up sand
	origin_tech = list(TECH_MATERIAL = 2, TECH_POWER = 2, TECH_ENGINEERING = 2)
	desc = "Yours is the drill that will pierce the heavens!"
	drill_verb = "drilling"

/obj/item/pickaxe/borgdrill
	name = "cyborg mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	digspeed = 15
	desc = ""
	drill_verb = "drilling"

/*****************************Shovel********************************/

/obj/item/shovel
	name = "shovel"
	desc = "A large tool for digging and moving dirt."
	icon = 'icons/obj/tools.dmi'
	icon_state = "shovel"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 15
	throwforce = 10
	armor_penetration = 3
	item_state = "shovel"
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 50)
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	swing_sound = "shovel_swing"
	hitsound = "shovel_hit"
	drop_sound = 'sound/items/shovel_drop.ogg'
	sharp = TRUE
	edge = FALSE

/obj/item/shovel/spade
	name = "spade"
	desc = "A small tool for digging and moving dirt."
	icon_state = "spade"
	item_state = "spade"
	force = 8
	throwforce = 7
	w_class = ITEM_SIZE_SMALL

/obj/item/shovel/krieg
	name = "krieg shovel"
	desc = "A small tool for digging and moving dirt."
	icon_state = "entrenching_tool"
	item_state = "trench"
	force = 28
	sharp = 1
	armor_penetration = 5
	throwforce = 25
	block_chance = 25
	weapon_speed_delay = 8
	w_class = ITEM_SIZE_SMALL


/obj/item/farmshovel
	name = "shovel"
	desc = "A large tool for digging and moving dirt."
	icon = 'icons/obj/hydroponics_misc.dmi'
	icon_state = "shovel"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 8
	throwforce = 4
	item_state = "shovel"
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 50)
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	swing_sound = "shovel_swing"
	hitsound = "shovel_hit"
	drop_sound = 'sound/items/shovel_drop.ogg'

/**********************Mining car (Crate like thing, not the rail car)**************************/

/obj/structure/closet/crate/miningcar
	desc = "A mining car. This one doesn't work on rails, but has to be dragged."
	name = "Mining car (not for rails)"
	icon = 'icons/obj/storage.dmi'
	icon_state = "miningcar"
	density = 1
	icon_opened = "miningcar"
	icon_closed = "miningcar"

// Flags.

/obj/item/stack/flag
	name = "flags"
	desc = "Some colourful flags."
	singular_name = "flag"
	amount = 10
	max_amount = 10
	icon = 'icons/obj/mining.dmi'

	var/upright = 0
	var/fringe = null

/obj/item/stack/flag/red
	name = "red flags"
	singular_name = "red flag"
	icon_state = "redflag"
	fringe = "redflag_fringe"
	light_color = COLOR_RED

/obj/item/stack/flag/yellow
	name = "yellow flags"
	singular_name = "yellow flag"
	icon_state = "yellowflag"
	fringe = "yellowflag_fringe"
	light_color = COLOR_YELLOW

/obj/item/stack/flag/green
	name = "green flags"
	singular_name = "green flag"
	icon_state = "greenflag"
	fringe = "greenflag_fringe"
	light_color = COLOR_LIME

/obj/item/stack/flag/solgov
	name = "sol gov flags"
	singular_name = "sol gov flag"
	icon_state = "solgovflag"
	fringe = "solgovflag_fringe"
	desc = "A portable flag with the Sol Government symbol on it. I claim this land for Sol!"
	light_color = COLOR_BLUE

/obj/item/stack/flag/attackby(var/obj/item/W, var/mob/user)
	if(upright)
		attack_hand(user)
		return
	return ..()

/obj/item/stack/flag/attack_hand(var/mob/user)
	if(upright)
		knock_down()
		user.visible_message("\The [user] knocks down \the [singular_name].")
		return
	return ..()

/obj/item/stack/flag/attack_self(var/mob/user)
	var/turf/T = get_turf(src)

	if(istype(T, /turf/space) || istype(T, /turf/simulated/open))
		to_chat(user, "<span class='warning'>There's no solid surface to plant the flag on.</span>")
		return

	for(var/obj/item/stack/flag/F in T)
		if(F.upright)
			to_chat(user, "<span class='warning'>\The [F] is already planted here.</span>")
			return

	if(use(1)) // Don't skip use() checks even if you only need one! Stacks with the amount of 0 are possible, e.g. on synthetics!
		var/obj/item/stack/flag/newflag = new src.type(T, 1)
		newflag.set_up()
		if(istype(T, /turf/simulated/floor/asteroid) || istype(T, /turf/simulated/floor/exoplanet))
			user.visible_message("\The [user] plants \the [newflag.singular_name] firmly in the ground.")
		else
			user.visible_message("\The [user] attaches \the [newflag.singular_name] firmly to the ground.")

/obj/item/stack/flag/proc/set_up()
	pixel_x = 0
	pixel_y = 0
	upright = 1
	anchored = 1
	icon_state = "[initial(icon_state)]_open"
	if(fringe)
		set_light(2, 0.1) // Very dim so the rest of the flag is barely visible - if the turf is completely dark, you can't see anything on it, no matter what
		var/image/addon = image(icon = src.icon, icon_state = fringe) // Bright fringe
		addon.layer = ABOVE_LIGHTING_LAYER
		addon.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		overlays += addon

/obj/item/stack/flag/proc/knock_down()
	pixel_x = rand(-randpixel, randpixel)
	pixel_y = rand(-randpixel, randpixel)
	upright = 0
	anchored = 0
	icon_state = initial(icon_state)
	overlays.Cut()
	set_light(0)



/**************************Plasma Cutter*****************************/

/obj/item/gun/energy/plasmacutter/mounted
	name = "mounted plasma cutter"
	self_recharge = 1
	use_external_power = 1

/obj/item/gun/energy/plasmacutter
	name = "plasma cutter"
	desc = "A mining tool capable of expelling concentrated plasma bursts. You could use it to cut limbs off of xenos! Or, you know, mine stuff."
	charge_meter = 0
	icon = 'icons/obj/tools.dmi'
	icon_state = "plasmacutter"
	item_state = "plasmacutter"
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = 3
	force = 15
	sharp = 1
	edge = 1
	origin_tech = list(TECH_MATERIAL = 2, TECH_PHORON = 3, TECH_ENGINEERING = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 4000)
	projectile_type = /obj/item/projectile/beam/plasmacutter
	max_shots = 10
	self_recharge = 1

/obj/item/projectile/beam/plasmacutter
	name = "plasma arc"
	icon_state = "omnilaser"
	damage = 15
	damage_type = BURN
	check_armour = "laser"
	range =  5
	pass_flags = PASS_FLAG_TABLE

	muzzle_type = /obj/effect/projectile/trilaser/muzzle
	tracer_type = /obj/effect/projectile/trilaser/tracer
	impact_type = /obj/effect/projectile/trilaser/impact

/obj/item/projectile/beam/plasmacutter/on_impact(var/atom/A)
	if(istype(A, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = A
		if(prob(33))
			M.GetDrilled(1)
			return
		else
			M.emitter_blasts_taken += 2
	. = ..()
