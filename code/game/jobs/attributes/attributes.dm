// Stolen from bobstation

/datum/attribute_sheet
	var/list/attribute_variance // Range, key value pair. STAT = list(min, max)
	var/list/raw_attributes = list(
	/datum/stat/str = 1,
	/datum/stat/end = 1,
	/datum/stat/int = 1,
	/datum/stat/dex = 1,
	) // No variation. Key value pair. STAT = value

	var/list/skill_variance // Same as above, but for skills
	var/list/raw_skills = list(
	/datum/skill/auto_rifle = 6,
	/datum/skill/semi_rifle = 6,
	/datum/skill/sniper = 6,
	/datum/skill/shotgun = 6,
	/datum/skill/lmg = 6,
	/datum/skill/smg = 6,
	/datum/skill/surgery = 5,
	/datum/skill/engineering = 5,
	/datum/skill/medical = 5,
	/datum/skill/ranged = 5,
	/datum/skill/melee = 5,
	) // Defaults

/datum/attribute_sheet/proc/set_attributes(var/mob/living/carbon/human/H)
	for(var/attribute_path in raw_attributes)
		//could probably cache this
		H.my_stats[attribute_path]?.level = raw_attributes[attribute_path]

	for(var/attribute_path in attribute_variance)
		var/list/attribute_range = attribute_variance[attribute_path]
		H.my_stats[attribute_path]?.level = rand(attribute_range[1], attribute_range[2])

	for(var/skill_path in raw_skills)
		H.my_skills[skill_path]?.level = raw_skills[skill_path]

	for(var/skill_path in skill_variance)
		var/list/skill_range = skill_variance[skill_path]
		H.my_skills[skill_path]?.level = rand(skill_range[1], skill_range[2]) // TODO: It'd be cool if there was a proper dice roll system

/datum/attribute_sheet/pilgrim
	raw_attributes = list(
	/datum/stat/str = 20,
	/datum/stat/int = 20,
	)
	attribute_variance = list(
	/datum/stat/end = list(100, 200),
	)
