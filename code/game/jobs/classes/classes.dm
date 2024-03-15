/datum/class_sheet
	var/list/classes // Key value pair, type = actual type. As a coder just put the outfits you want by themselves.

/datum/class_sheet/New()
	for(var/class_type in classes)
		classes[class_type] = new class_type

/datum/class
	var/name
	var/description = "<span class='danger'><b><font size=4>Example Description</font></b></span>"
	var/datum/attribute_sheet/attributes // The attributes given for this class
	var/default_outfit
	var/list/outfits // Equipment. Key/Value pair. Outfit Type = Probability. Sub-classes.
	var/probability // If set, this will have x chance of being selected. Not shown on the menu if set.

/datum/class/proc/equip(var/mob/living/carbon/human/H)
	if(LAZYLEN(outfits))
		for(var/outfit_type in outfits)
			if(prob(outfits[outfit_type]))
				var/decl/hierarchy/outfit/outfit = outfit_by_type(outfit_type)
				outfit.equip(H)
				attributes?.set_attributes(H)
				to_chat(H, description)
				post_equip(H, outfit_type)
				return
		var/decl/hierarchy/outfit/outfit = outfit_by_type(default_outfit) // Failed all rolls
		outfit.equip(H)
	else
		var/decl/hierarchy/outfit/outfit = outfit_by_type(default_outfit)
		outfit.equip(H)
	attributes?.set_attributes(H)
	to_chat(H, description)
	post_equip(H)

/datum/class/proc/post_equip(var/mob/living/carbon/human/H, var/rolled_outfit)
	H.stat = CONSCIOUS
	H.sleeping = 0
	to_chat(H, "<span class='goodmood'>+ You awaken from your slumber... +</span>\n")
	return FALSE

/mob/living/carbon/human/proc/class_select()
	set name = "Select your class"
	set category = "CHOOSE YOUR FATE"
	set desc = "Choose your new profession on this strange world."
	if(!ishuman(src))
		CRASH("Class selection verb given to invalid mob.")
		return
	if(src.stat == DEAD)
		to_chat(src, "<span class='notice'>Too late.</span>")
		return

	var/mob/living/carbon/human/U = src
	U.verbs -= list(/mob/living/carbon/human/proc/class_select,) //removes verb
	var/datum/job/jb = SSjobs.occupations_by_title[job]
	var/list/choices = list("ROLL DICE!!")
	var/list/class_list = list()
	for(var/class_type in GLOB.class_sheets[jb.class_sheet].classes)
		var/datum/class/class = GLOB.class_sheets[jb.class_sheet].classes[class_type]
		if(!class.probability)
			choices += class.name
		class_list += class

	var/classchoice = input("Choose your fate", "Available fates") as anything in choices

	if(classchoice == "ROLL DICE!!")
		for(var/datum/class/class in class_list)
			if(class.probability && prob(class.probability))
				class.equip(U)
				return
			if(class.probability)
				class_list -= class
		var/datum/class/class = pick(class_list)
		class.equip(U)
	for(var/datum/class/class in class_list)
		if(class.name == classchoice)
			class.equip(U)
