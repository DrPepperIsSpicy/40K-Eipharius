/obj/item/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	fire_sound = 'sound/weapons/gunshot/auto1.ogg'
	damage = 60
	damage_type = BRUTE
	nodamage = 0
	check_armour = "bullet"
	embed = 1
	sharp = 1
	light_power = 2 //Tracers.
	light_range = 2
	light_color = "#E38F46"
	penetration_modifier = 1.0
	var/mob_passthrough_check = 0
	muzzle_type = /obj/effect/projectile/bullet/muzzle

/obj/item/projectile/bullet/on_hit(var/atom/target, var/blocked = 0)
	if (..(target, blocked))
		var/mob/living/L = target
		shake_camera(L, 3, 2)

/obj/item/projectile/bullet/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier)
	if(penetrating > 0 && damage > 100 && prob(damage))
		mob_passthrough_check = 1
	else
		mob_passthrough_check = 0
	. = ..()

	if(. == 1 && iscarbon(target_mob))
		damage *= 0.7 //squishy mobs absorb KE

/obj/item/projectile/bullet/can_embed()
	//prevent embedding if the projectile is passing through the mob
	if(mob_passthrough_check)
		return 0
	return ..()

/obj/item/projectile/bullet/before_move()
	..()
	if(istype(starting, /turf/simulated/floor/trench)) //We started out shooting from the trench.
		if(trench_counter > 1 || do_not_pass_trench) //We did not start out at the edge of the trench.
			if(!istype(loc, /turf/simulated/floor/trench)) //We cannot shoot out.
				playsound(src, wall_hitsound, 100, TRUE)
				qdel(src)

		if(istype(loc, /turf/simulated/floor/trench)) //We have travelled to a new trench.
			if(non_trench_counter > 3) //But we passed over open terrain for at least 3 tiles.
				if(istype(loc, get_turf(original)))//We're at our destination.
					playsound(src, wall_hitsound, 100, TRUE)
					qdel(src) //We cannot shoot in.


	if(!istype(starting, /turf/simulated/floor/trench))//We did not start out in the trench.
		if(non_trench_counter > 0)//We have travelled over open terrain.
			if(istype(original.loc, /turf/simulated/floor/trench))//If we clicked on the trench.
				if(istype(loc, /turf/simulated/floor/trench))//We're now at the trench.
					playsound(src, wall_hitsound, 100, TRUE)
					qdel(src) //We cannot shoot in.


/obj/item/projectile/bullet/after_move()
	..()
	if(istype(starting, /turf/simulated/floor/trench)) //Started from a trench.
		if(istype(loc, /turf/simulated/floor/trench)) //Shooting into the same trench.
			trench_counter++ //Add to the counter
		else //Shooting over open terrain?
			non_trench_counter++ //Add to the open terrain counter.

	if(!istype(starting, /turf/simulated/floor/trench)) //Didn't start out in the trench.
		if(!istype(loc, /turf/simulated/floor/trench)) //Not shooting into the trench.
			non_trench_counter++ //Add to the open terrain counter.

/obj/item/projectile/bullet/check_penetrate(var/atom/A)
	if(!A || !A.density) return 1 //if whatever it was got destroyed when we hit it, then I guess we can just keep going

	if(istype(A, /obj/mecha))
		return 1 //mecha have their own penetration handling

	if(ismob(A))
		if(!mob_passthrough_check)
			return 0
		return 1

	var/chance = damage
	if(istype(A, /turf/simulated/wall))
		var/turf/simulated/wall/W = A
		chance = round(damage/W.integrity*180)
	else if(istype(A, /obj/structure/dirt_wall))
		chance = 5
	else if(istype(A, /obj/machinery/door))
		var/obj/machinery/door/D = A
		chance = round(damage/D.maxhealth*180)
		if(D.glass) chance *= 2
	else if(istype(A, /obj/structure/girder))
		chance = 100


	if(prob(chance))
		if(A.opacity)
			//display a message so that people on the other side aren't so confused
			A.visible_message("<span class='warning'>\The [src] pierces through \the [A]!</span>")
		return 1

	return 0

//For projectiles that actually represent clouds of projectiles
/obj/item/projectile/bullet/pellet
	name = "shrapnel" //'shrapnel' sounds more dangerous (i.e. cooler) than 'pellet'
	damage = 60
	icon_state = "shot" //TODO: would be nice to have it's own icon state
	range = 10 	//These disappear after a short distance.
	var/pellets = 4			//number of pellets
	var/range_step = 3		//projectile will lose a fragment each time it travels this distance. Can be a non-integer.
	var/base_spread = 40	//lower means the pellets spread more across body parts. If zero then this is considered a shrapnel explosion instead of a shrapnel cone
	var/spread_step = 10	//higher means the pellets spread more across body parts with distance
	light_power = 9 //No tracers.
	light_range = 0
	light_color = null

/*
/obj/item/projectile/bullet/pellet/Bumped()
	. = ..()
	bumped = 0 //can hit all mobs in a tile. pellets is decremented inside attack_mob so this should be fine.
*/
/obj/item/projectile/bullet/pellet/proc/get_pellets(var/distance)
	var/pellet_loss = round((distance - 1)/range_step) //pellets lost due to distance
	return max(pellets - pellet_loss, 1)

/obj/item/projectile/bullet/pellet/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier)
	if (pellets < 0) return 1

	var/total_pellets = get_pellets(distance)
	var/spread = max(base_spread - (spread_step*distance), 0)

	//shrapnel explosions miss prone mobs with a chance that increases with distance
	var/prone_chance = 0
	if(!base_spread)
		prone_chance = max(spread_step*(distance - 2), 0)

	var/hits = 0
	for (var/i in 1 to total_pellets)
		if(target_mob.lying && target_mob != original && prob(prone_chance))
			continue

		//pellet hits spread out across different zones, but 'aim at' the targeted zone with higher probability
		//whether the pellet actually hits the def_zone or a different zone should still be determined by the parent using get_zone_with_miss_chance().
		var/old_zone = def_zone
		def_zone = ran_zone(def_zone, spread)
		if (..()) hits++
		def_zone = old_zone //restore the original zone the projectile was aimed at

	pellets -= hits //each hit reduces the number of pellets left
	if (hits >= total_pellets || pellets <= 0)
		return 1
	return 0

/obj/item/projectile/bullet/pellet/get_structure_damage()
	var/distance = get_dist(loc, starting)
	return ..() * get_pellets(distance)

/obj/item/projectile/bullet/pellet/Move()
	. = ..()

	//If this is a shrapnel explosion, allow mobs that are prone to get hit, too
	if(. && !base_spread && isturf(loc))
		for(var/mob/living/M in loc)
			if(M.lying || !M.CanPass(src, loc, 0.5, 0)) //Bump if lying or if we would normally Bump.
				if(Bump(M)) //Bump will make sure we don't hit a mob multiple times
					return

/* short-casing projectiles, like the kind used in pistols or SMGs */

/obj/item/projectile/bullet/pistol
	damage = 30 //9mm
	fire_sound = 'sound/weapons/gunshot/auto1.ogg'
	armor_penetration = 15

/obj/item/projectile/bullet/pistol/medium
	damage = 35 //.45
	armor_penetration = 15
	fire_sound = 'sound/weapons/gunshot/auto1.ogg'

/obj/item/projectile/bullet/pistol/medium/ap
	damage = 35 //.45
	armor_penetration = 20

/obj/item/projectile/bullet/pistol/medium/ms
	damage = 45 //.45
	armor_penetration = 15

/obj/item/projectile/bullet/pistol/medium/kp
	damage = 35 //.45
	armor_penetration = 25
	penetrating = 1

/obj/item/projectile/bullet/pistol/strong //matebas
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	damage = 45 //.50AE
	armor_penetration = 20

/obj/item/projectile/bullet/pistol/strong/ap
	damage = 54 //.50AE
	armor_penetration = 25

/obj/item/projectile/bullet/pistol/strong/kp
	damage = 54 //.50AE
	armor_penetration = 30
	penetrating = 1

/obj/item/projectile/bullet/pistol/strong/ms
	damage = 55 //.50AE
	armor_penetration = 20

/obj/item/projectile/bullet/pistol/revolver
	fire_sound = 'sound/weapons/gunshot/auto5.ogg'
	damage = 40 // .357
	armor_penetration = 20

/obj/item/projectile/bullet/pistol/revolver/ap
	damage = 49
	armor_penetration = 25

/obj/item/projectile/bullet/pistol/revolver/kp
	damage = 49
	armor_penetration = 30
	penetrating = 1

/obj/item/projectile/bullet/pistol/revolver/ms
	damage = 50
	armor_penetration = 20

/obj/item/projectile/bullet/pistol/medium/revolver
	fire_sound = 'sound/weapons/gunshot/gunshot_strong.ogg'
	damage = 40 //.44 magnum or something
	armor_penetration = 20

/obj/item/projectile/bullet/pistol/medium/revolver/ap
	damage = 40
	armor_penetration = 25

/obj/item/projectile/bullet/pistol/medium/revolver/kp
	damage = 40
	armor_penetration = 30
	penetrating = 1

/obj/item/projectile/bullet/pistol/medium/revolver/ms
	damage = 50
	armor_penetration = 20

/obj/item/projectile/bullet/pistol/strong/revolver
	damage = 40
	armor_penetration = 20

/obj/item/projectile/bullet/pistol/strong/revolver/ap
	damage = 40
	armor_penetration = 25

/obj/item/projectile/bullet/pistol/strong/revolver/kp
	damage = 40
	armor_penetration = 30
	penetrating = 1

/obj/item/projectile/bullet/pistol/strong/revolver/ms
	damage = 50
	armor_penetration = 20

/obj/item/projectile/bullet/pistol/rubber //"rubber" bullets
	name = "rubber bullet"
	check_armour = "bullet"
	damage = 0
	agony = 30
	embed = 0
	sharp = 0
	armor_penetration = 15

/* shotgun projectiles */

/obj/item/projectile/bullet/shotgun
	name = "slug"
	fire_sound = 'sound/weapons/gunshot/shotgun3.ogg'
	damage = 65
	armor_penetration = 25

/obj/item/projectile/bullet/shotgun/kp
	name = "KP slug"
	fire_sound = 'sound/weapons/gunshot/shotgun3.ogg'
	damage = 65
	armor_penetration = 35
	penetrating = 1

/obj/item/projectile/bullet/shotgun/ms
	name = "MS slug"
	fire_sound = 'sound/weapons/gunshot/shotgun3.ogg'
	damage = 75
	armor_penetration = 25

/obj/item/projectile/bullet/shotgun/beanbag		//because beanbags are not bullets
	name = "beanbag"
	check_armour = "melee"
	damage = 10
	armor_penetration = 20
	agony = 70
	embed = 0
	sharp = 0

//Should do about 80 damage at 1 tile distance (adjacent), and 50 damage at 3 tiles distance.
//Overall less damage than slugs in exchange for more damage at very close range and more embedding
/obj/item/projectile/bullet/pellet/shotgun
	name = "buckshot"
	fire_sound = 'sound/weapons/gunshot/shotgun3.ogg'
	damage = 25
	armor_penetration = 20
	pellets = 10
	range_step = 3
	spread_step = 8
	range = 8

/* "Rifle" rounds */

/obj/item/projectile/bullet/rifle/kroot
	fire_sound = 'sound/weapons/gunshot/auto5.ogg'
	penetrating = TRUE // fuck that shit penetrative rounds
	damage = 90
	armor_penetration = 30

/obj/item/projectile/bullet/rifle
	damage = 40
	armor_penetration = 20
	penetrating = TRUE

/obj/item/projectile/bullet/rifle/a556
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'
	damage = 40
	armor_penetration = 20

/obj/item/projectile/bullet/rifle/a556/ap
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'
	damage = 40
	armor_penetration = 25

/obj/item/projectile/bullet/rifle/a556/ms
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'
	damage = 50
	armor_penetration = 20

/obj/item/projectile/bullet/rifle/a556/kp
	fire_sound = 'sound/weapons/gunshot/gunshot3.ogg'
	damage = 40
	armor_penetration = 30
	penetrating = 1

/obj/item/projectile/bullet/rifle/a762
	fire_sound = 'sound/weapons/gunshot/gunshot2.ogg'
	damage = 50
	armor_penetration = 25

/obj/item/projectile/bullet/rifle/a762/ap
	fire_sound = 'sound/weapons/gunshot/gunshot2.ogg'
	damage = 50
	armor_penetration = 30

/obj/item/projectile/bullet/rifle/a762/kp
	fire_sound = 'sound/weapons/gunshot/gunshot2.ogg'
	damage = 50
	armor_penetration = 35
	penetrating = 1

/obj/item/projectile/bullet/rifle/a762/ms
	fire_sound = 'sound/weapons/gunshot/gunshot2.ogg'
	damage = 60
	armor_penetration = 25


/obj/item/projectile/bullet/rifle/a145
	fire_sound = 'sound/weapons/gunshot/loudbolt.ogg'
	damage = 110
	armor_penetration = 36
	//hitscan = 1 //so the PTR isn't useless as a sniper weapon
	penetration_modifier = 1
	penetrating = 2

/obj/item/projectile/bullet/rifle/a145/apds
	damage = 110
	armor_penetration = 43
	penetration_modifier = 1
	penetrating = 3

/obj/item/projectile/bullet/rifle/a145/apds/bos
	damage = 140
	armor_penetration = 46
	penetration_modifier = 1
	penetrating = 2

/obj/item/projectile/bullet/rifle/railrifle //Used KP ammo as baseline.
	damage = 90
	armor_penetration = 41
	penetration_modifier = 1.4
	penetrating = 2

/* Miscellaneous */

/obj/item/projectile/bullet/suffocationbullet//How does this even work?
	name = "CO2 bullet"
	damage = 65
	armor_penetration = 35
	damage_type = OXY

/obj/item/projectile/bullet/cyanideround
	name = "poison bullet"
	damage = 65
	armor_penetration = 35
	damage_type = TOX

/obj/item/projectile/bullet/burstbullet
	name = "exploding bullet"
	damage = 100
	armor_penetration = 35
	embed = 0
	edge = 1

/obj/item/projectile/bullet/blank
	invisibility = 101
	damage = 0
	embed = 0

/*
/obj/item/projectile/bullet/bpistol // This is .75 Bolt Pistol Round
	fire_sound = 'sound/effects/explosion1.ogg'
	damage = 68
	armor_penetration = 10
 Explosive aspect of bullets doesn't work so triaging the code for now.
/obj/item/projectile/bullet/bpistol/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target))
		explosion(target, -1, 0, 2)
	..()


/obj/item/projectile/bullet/bolt
	fire_sound = 'sound/effects/explosion1.ogg'
	damage = 75
	armor_penetration = 15
 Explosive aspect of bullets doesn't work so triaging the code for now.
 /obj/item/projectile/bullet/bolt/on_hit(var/atom/target, var/blocked = 0) // This shit is broken.
	if(isturf(target))
		explosion(target, -1, 0, 2)
	..()
*/

/* Practice */

/obj/item/projectile/bullet/pistol/practice
	damage = 5

/obj/item/projectile/bullet/rifle/a762/practice
	damage = 5

/obj/item/projectile/bullet/shotgun/practice
	name = "practice"
	damage = 5

/obj/item/projectile/bullet/pistol/cap
	name = "cap"
	invisibility = 101
	fire_sound = null
	damage_type = PAIN
	damage = 0
	nodamage = 1
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/pistol/cap/Process()
	loc = null
	qdel(src)

/obj/item/projectile/bullet/rock //spess dust
	name = "micrometeor"
	icon_state = "rock"
	damage = 40
	armor_penetration = 25
	range = 255
	light_power = 9 //No tracers.
	light_range = 0
	light_color = null

/obj/item/projectile/bullet/rock/New()
	icon_state = "rock[rand(1,3)]"
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	..()




	
/obj/item/projectile/bullet/rifle/plasma
	fire_sound = 'sound/weapons/guns/misc/laser_searwall.ogg'
	damage = 90
	damage_type = BURN
	armor_penetration = 41
	penetration_modifier = 1.4
	penetrating = TRUE


/obj/item/projectile/bullet/rifle/plasma/pistol
	fire_sound = 'sound/weapons/guns/misc/laser_searwall.ogg'
	damage = 80
	damage_type = BURN
	armor_penetration = 39
	penetration_modifier = 1.2



/obj/item/projectile/bullet/rifle/plasma/tau //TAU pulse weapons are plasma weapons bro
	fire_sound = 'sound/weapons/guns/misc/laser_searwall.ogg'
	damage = 51
	damage_type = BURN
	armor_penetration = 43
	penetration_modifier = 1.4



//ELDAR

/obj/item/projectile/bullet/rifle/shuriken/catapult
	fire_sound = 'sound/weapons/gunshot/needler.ogg'
	icon_state = "ion"
	damage = 24
	damage_type = BRUTE
	armor_penetration = 38
	penetration_modifier = 1

/obj/item/projectile/bullet/rifle/shuriken/pistol
	fire_sound = 'sound/weapons/gunshot/needler.ogg'
	icon_state = "ion"
	damage = 21
	damage_type = BRUTE
	armor_penetration = 38
	penetration_modifier = 1
	
// XENOS
/obj/item/projectile/bullet/rifle/pmag
	fire_sound = 'sound/weapons/gunshot/needler.ogg'
	icon_state = "pulse"
	damage = 50
	damage_type = BRUTE
	armor_penetration = 38
	penetration_modifier = 1
	
//MECHANICUS
/obj/item/projectile/bullet/rifle/galvanic
	fire_sound = 'sound/weapons/guns/misc/laser_searwall.ogg'
	icon_state = "ion"
	damage = 55
	damage_type = BRUTE
	armor_penetration = 36
	penetration_modifier = 2
	var/heavy_effect_range = 1
	var/light_effect_range = 1

/obj/item/projectile/bullet/rifle/galvanic/fire
	fire_sound = 'sound/weapons/guns/misc/laser_searwall.ogg'
	icon_state = "ion"
	damage = 35
	damage_type = BRUTE
	armor_penetration = 34
	penetration_modifier = 2
	
/obj/item/projectile/bullet/rifle/galvanic/fire/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!istype(H.wear_suit, /obj/item/clothing/suit/fire))
			H.adjust_fire_stacks(20)
			H.IgniteMob()
		new /obj/flamer_fire(H.loc, 12, 10, "red", 1)

/obj/item/projectile/bullet/rifle/galvanic/emp
	fire_sound = 'sound/weapons/guns/misc/laser_searwall.ogg'
	icon_state = "ion"
	damage = 15
	damage_type = BURN
	armor_penetration = 36
	penetration_modifier = 1
	on_impact(var/atom/A)
		empulse(A, 1, 2)
		return 1

/obj/item/projectile/bullet/rifle/galvanic/airburst
	fire_sound = 'sound/weapons/guns/misc/laser_searwall.ogg'
	icon_state = "ion"
	damage = 40
	damage_type = BRUTE
	armor_penetration = 36

/obj/item/projectile/bullet/rifle/galvanic/airburst/on_hit(var/atom/target)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/external/affecting = H.get_organ(pick("l_leg","l_arm","r_leg","r_arm", "head", "l_hand", "r_hand", "l_foot", "r_foot"))
		affecting.droplimb(0, DROPLIMB_BLUNT)
		if(prob(25))
			affecting = H.get_organ(pick("l_leg","l_arm","r_leg","r_arm", "head", "l_hand", "r_hand", "l_foot", "r_foot"))
			affecting.droplimb(0, DROPLIMB_BLUNT)
			if(prob(25))
				affecting = H.get_organ(pick("l_leg","l_arm","r_leg","r_arm", "head", "l_hand", "r_hand", "l_foot", "r_foot"))
				affecting.droplimb(0, DROPLIMB_BLUNT)
				return
			else
				return
		else
			return

/obj/item/projectile/bullet/rifle/galvanic/pain
	fire_sound = 'sound/weapons/guns/misc/laser_searwall.ogg'
	icon_state = "ion"
	damage = 5
	damage_type = BURN
	armor_penetration = 34
	agony = 150 //Might need reworking
	taser_effect = 1

/obj/item/projectile/bullet/pellet/shotgun/melta
	fire_sound = 'sound/weapons/lasgun.ogg'
	wall_hitsound = 'sound/weapons/guns/misc/laser_searwall.ogg'
	icon_state = "lasbolt"
	damage_type = BURN
	penetration_modifier = 1
	armor_penetration = 42
	damage = 35
	pellets = 1
	range_step = 4 // do not touch
	spread_step = 2
	range = 16

/obj/item/projectile/bullet/rifle/radcarbine
	fire_sound = 'sound/weapons/guns/misc/laser_searwall.ogg'
	icon_state = "shot"
	damage = 40
	damage_type = BRUTE //Initial poisoning effect
	armor_penetration = 37 
	penetration_modifier = 2

/obj/item/projectile/bullet/rifle/radcarbine/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		M.apply_effect((rand(20,60)),IRRADIATE,0)

/obj/item/projectile/bullet/rifle/radcarbine/radpistol
	fire_sound = 'sound/weapons/guns/misc/laser_searwall.ogg'
	icon_state = "shot"
	damage = 35
	damage_type = BRUTE //Initial poisoning effect
	armor_penetration = 35
	penetration_modifier = 2

/obj/item/projectile/bullet/rifle/radcarbine/radpistol/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		M.apply_effect((rand(20,50)),IRRADIATE,0)
	







//UNIMPLEMENTED BELOW, FIX WHEN POSSIBLE


/obj/item/projectile/bullet/rifle/plasma/cannon/orkish //three colors of green!
	fire_sound = 'sound/weapons/guns/misc/laser_searwall.ogg'
	damage = 100
	damage_type = BURN
	armor_penetration = 37
	penetration_modifier = 3
	
/obj/item/projectile/bullet/rifle/lascannon/melta/inferno
	fire_sound = 'sound/weapons/guns/misc/laser_searwall.ogg'
	icon_state = "lasbolt"
	damage = 25 //weaker than melta caus its a pistol
	armor_penetration = 42


/* ORKY BULLETS */

/obj/item/projectile/bullet/ork
	name = "scrap"
	fire_sound = 'sound/weapons/gunshot/loudbolt.ogg'
	damage = 38
	armor_penetration = 36

/*

/obj/item/projectile/bullet/bpistol/kp
	fire_sound = 'sound/effects/explosion1.ogg'
	damage = 75
	armor_penetration = 30
	penetration_modifier = 1.4
	penetrating = TRUE

/obj/item/projectile/bullet/bolt/kp
	fire_sound = 'sound/effects/explosion1.ogg'
	damage = 85
	armor_penetration = 40
	penetration_modifier = 1.8
	penetrating = TRUE

/obj/item/projectile/bullet/bpistol/ms // This is .75 Bolt Pistol Round
	fire_sound = 'sound/effects/explosion1.ogg'
	damage = 60
	armor_penetration = 50
/obj/item/projectile/bullet/gyro/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target))
		explosion(target, -1, 0, 2)
	..()

/obj/item/projectile/bullet/bolt/ms
	fire_sound = 'sound/effects/explosion1.ogg'
	damage = 70
	armor_penetration = 60
/obj/item/projectile/bullet/gyro/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target))
		explosion(target, -1, 0, 2)
	..()
*/
/obj/item/projectile/bullet/rifle/lascannon
	fire_sound = 'sound/weapons/guns/misc/laser_searwall.ogg'
	icon_state = "lasbolt"
	damage = 85
	damage_type = BURN
	armor_penetration = 37
	penetration_modifier = 2
	penetrating = TRUE

/obj/item/projectile/bullet/rifle/plasma/cannon //D E A T H
	fire_sound = 'sound/weapons/guns/misc/laser_searwall.ogg'
	damage = 120
	damage_type = BURN
	armor_penetration = 39
	penetration_modifier = 3
	
/obj/item/projectile/bullet/rifle/exitus
	name = "bullet"
	icon_state = "bullet"
	damage = 140
	damage_type = BRUTE
	check_armour = "bullet"
	armor_penetration = 39
	embed = 1
	sharp = 1
	light_power = 0
	light_range = 0
	penetration_modifier = 1
	penetrating = 200

/obj/item/projectile/bullet/rifle/exitus/explosive
	name = "bullet"
	icon_state = "bullet"
	damage = 25 //Admin only spawn for now.
	damage_type = BRUTE

/obj/item/projectile/bullet/rifle/exitus/explosive/on_hit(var/atom/target)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		M.gib()
		qdel(M)

/obj/item/projectile/bullet/rifle/exitus/toxin
	damage_type = TOX

/obj/item/projectile/bullet/rifle/exitus/fire

/obj/item/projectile/bullet/rifle/exitus/fire/on_hit(var/atom/target)
	damage = 40 //Admin only spawn for now.
	damage_type = BURN
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!istype(H.wear_suit, /obj/item/clothing/suit/armor/seolsuit))
			H.adjust_fire_stacks(60)
			H.IgniteMob()
		new /obj/flamer_fire(H.loc, 15, 14, "red", 1)

