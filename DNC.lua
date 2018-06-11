-------------------------------------------------------------------------------------------------------------------
-- Rikimarueye's DNC lua. Comment section below
-------------------------------------------------------------------------------------------------------------------


-- Maintained and fixed by Rikimarueye@pheonix
-- Original base lua created by Moten.

-- Version 1.0.0.7

--[[
	To do list:
	
	Fix and update and optimize DPS for all Facing sets.
	
]]

--[[
	Change log:
	
	1.0.0.7: Fixed the update to idle set after zoning when using a teleport ring 
	
	1.0.0.6: Changed DT set to add more MEVA
	
	1.0.0.5: Added Horos Tights +3 to sets
	
	1.0.0.4: Added weapon toggle
	
	1.0.0.3: Fixed haste rules for bard songs and haste1/2. Added a rule for CombatForm to only apply when mythic is worn.
	
	1.0.0.2: Added a function with the help of dlsmd from BGforums to autopresto.
	
	1.0.0.0: Personalized the lua and populated with my equipment.
]]



---------------------------------------------------------------------------------------------------
    -- Start of the setup, sets, and functions.
---------------------------------------------------------------------------------------------------


-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
	include('organizer-lib')

	windower.register_event('zone change', function()
	state.WarpMode:reset()
	classes.CustomIdleGroups:clear()
	handle_equipping_gear(player.status)	
end)
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()

    include('Mote-TreasureHunter')
    state.TreasureMode:set('Tag')
	
	get_combat_form()
	
    state.Buff['Climactic Flourish'] = buffactive['climactic flourish'] or false
	
	--Buff ID 359 for doom
	state.Buff.doom = buffactive.doom or false
    state.Buff.sleep = buffactive.sleep or false
	state.Buff.Terror = buffactive.Terror or false
    state.Buff.Stun = buffactive.Stun or false
    state.Buff.Petrification = buffactive.Petrification or false
	
	--For Aftermath tracking
	state.Buff['Aftermath: Lv.3'] = buffactive['Aftermath: Lv.3'] or false

	state.Buff['Presto'] = buffactive['Presto'] or false
	
	
	
	--Haste mode
	state.HasteMode = M(false, 'Haste 2')
 
	
	 
    determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal' ,'Facing', 'Acc')
    state.HybridMode:options('Normal', 'PDT')
    state.WeaponskillMode:options('Normal', 'CF')
    state.PhysicalDefenseMode:options('PDT' , 'Parry')

    --Teleport Rings!
    state.WarpMode = M{['description']='Transportation Ring is now', 'Off', 'Warp', 'Jima: Holla', 'Jima: Dem'}
	
	state.WeaponMode = M{['description']='Weapon', 'Terpsichore', 'Aeneas'}
	
    -- Additional local binds
	send_command('wait 8;input /lockstyleset 16')
    send_command('bind ^` gs c toggle HasteMode')
    send_command('bind !` input /ja "Chocobo Jig II" <me>')
    send_command('bind ^z gs c cycle WarpMode')
	send_command('bind ^a gs c cycle WeaponMode')
	
	gear.Terpsichore = "Terpsichore"
	gear.Aeneas = "Aeneas"
	gear.Twashtar = "Twashtar"
	
    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind !=')
    send_command('unbind ^-')
    send_command('unbind !-')
	send_command('unbind ^z')
	send_command('unbind ^a')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
---------------------------------------------------------------------------------------------------
    -- Warp rings and TH tagging
---------------------------------------------------------------------------------------------------
    
	--TH on first hit
	sets.TreasureHunter = {
	    body={ name="Herculean Vest", augments={'INT+4','Rng.Acc.+4 Rng.Atk.+4','"Treasure Hunter"+2','Mag. Acc.+19 "Mag.Atk.Bns."+19',}},
	    legs={ name="Herculean Trousers", augments={'CHR+5','Accuracy+2 Attack+2','"Treasure Hunter"+1','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
	    waist="Chaac Belt"}
	
	sets.Warp = {ring2="Warp Ring"}
  
    sets.Holla = {ring2="Dim. Ring (Holla)"}
	
	sets.Dem = {ring2="Dim. Ring (Dem)"}
	
	
	sets.Terpsichore = {main=gear.Terpsichore, gear.Twashtar}
	sets.Aeneas = {main=gear.Aeneas, gear.Twashtar}
	
		
---------------------------------------------------------------------------------------------------
	-- Precast Sets
---------------------------------------------------------------------------------------------------
    
    -- Precast sets to enhance JAs

    sets.precast.JA['No Foot Rise'] = {
		ammo="Staunch Tathlum",
	    head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
		neck="Loricate Torque +1",
		-- Body for TP upon JA use
        body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		--
		ear2="Sanare Earring",
		hands={ name="Herculean Gloves", augments={'Accuracy+21 Attack+21','Mag. Acc.+2','Damage taken-3%','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		legs="Mummu Kecks +2",
		back="Agema Cape",
		feet={ name="Herculean Boots", augments={'Accuracy+28','Damage taken-3%','DEX+14','Attack+11',}}}

    sets.precast.JA['Trance'] = {head="Horos Tiara +3"}
    
	sets.precast.JA['Climactic Flourish'] = sets.buff['Climactic Flourish']

	
---------------------------------------------------------------------------------------------------
	-- JA sets
---------------------------------------------------------------------------------------------------
    
	---------------------------------------------------------------------------------------------------
    -- DT all the things possible! Stay alive!
	---------------------------------------------------------------------------------------------------
	
	-- Waltz set (chr and vit)
	
    sets.precast.Waltz = {
		ammo="Staunch Tathlum",
		head="Horos Tiara +3",
		ear1="Enchanter Earring +1",
		ear2="Handler's earring +1",
		body="Maxixi Casaque +3",
		neck="Unmoving Collar +1",
		hands="Regal Gloves",
		legs="Horos Tights +3",
		waist="Aristo Belt",
		ring1="Asklepian Ring",
		ring2="Carbuncle Ring +1",
		back={ name="Senuna's Mantle", augments={'CHR+20','Eva.+20 /Mag. Eva.+20','CHR+10','"Waltz" potency +10%',}},
	    feet="Maxixi ToeShoes +3"}
        
	---------------------------------------------------------------------------------------------------
    -- DT all the things! Stay alive!
	---------------------------------------------------------------------------------------------------
	
	
    sets.precast.Waltz['Healing Waltz'] = {
		ammo="Staunch Tathlum",
	    head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
		neck="Loricate Torque +1",
        body="Meghanada Cuirie +2",
		ear2="Sanare Earring",
		hands={ name="Herculean Gloves", augments={'Accuracy+21 Attack+21','Mag. Acc.+2','Damage taken-3%','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		legs="Mummu Kecks +2",
		back="Agema Cape",
		feet={ name="Herculean Boots", augments={'Accuracy+28','Damage taken-3%','DEX+14','Attack+11',}}}
    
    sets.precast.Samba = {
		ammo="Staunch Tathlum",
		--Tiara for Samba duration
	    head="Maxixi Tiara +3",
		--
		neck="Loricate Torque +1",
        body="Meghanada Cuirie +2",
		ear2="Sanare Earring",
		hands={ name="Herculean Gloves", augments={'Accuracy+21 Attack+21','Mag. Acc.+2','Damage taken-3%','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		legs="Mummu Kecks +2",
		--Mantle for Samba duration
		back="Senuna's Mantle",
		--
		feet={ name="Herculean Boots", augments={'Accuracy+28','Damage taken-3%','DEX+14','Attack+11',}}}

    sets.precast.Jig = {
		ammo="Staunch Tathlum",
	    head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
		neck="Loricate Torque +1",
        body="Meghanada Cuirie +2",
		ear2="Sanare Earring",
		hands={ name="Herculean Gloves", augments={'Accuracy+21 Attack+21','Mag. Acc.+2','Damage taken-3%','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		legs="Mummu Kecks +2",
		back="Agema Cape",
		--Shoes for duration
		feet="Maxixi ToeShoes +3"
		--
		}

    sets.precast.Step = {
		ammo="Yamarang",
		head="Maxixi Tiara +3",
		neck="Combatant's Torque",
		ear1="Zennaroi Earring",
		ear2="Mache Earring +1",
		body="Maxixi Casaque +3",
		hands="Maxixi Bangles +3",
		ring1="Regal Ring",
		ring2="Defending Ring",
		back="Agema Cape",
		waist="Olseni Belt",
		legs="Maxixi Tights +3",
		feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},}
		
    sets.precast.Step['Feather Step'] = set_combine(sets.precast.Step, {feet="Maculele Toeshoes +1"})
	
	sets.precast.Step['Stutter Step'] = set_combine(sets.precast.Step, {})

	---------------------------------------------------------------------------------------------------
	--Flourish 1 gear changes.
	---------------------------------------------------------------------------------------------------
	
    sets.precast.Flourish1 = {}
	
	--
	sets.precast.Flourish1['Animated Flourish'] = {
		ammo="Sapience Orb",
		head="Halitus Helm",
		body="Emet Harness +1",
		neck="Unmoving Collar +1",
		hands="Kurys Gloves",
	    ear1="Odnowa Earring +1",
		ear2="Cryptic Earring",
		ring1="Supershear Ring",
		ring2="Provocare Ring",
		legs="Mummu Kecks +2",
	    back={ name="Senuna's Mantle", augments={'VIT+20','Eva.+20 /Mag. Eva.+20','Enmity+10',}}}
		
	sets.precast.Provoke = sets.precast.Flourish1['Animated Flourish']
	
	--ACC/MACC Modded
    sets.precast.Flourish1['Violent Flourish'] = {
	    ammo="Yamarang",
		head="Horos Tiara +3",
		body="Horos Casaque +3",
		hands="Mummu Wrists +2",
		ring1="Mummu Ring",
		ring2="Stikini Ring",
		ear1="Genmei Earring",
		ear2="Dignitary's Earring",
		waist="Eschan Stone",
		neck="Sanctity Necklace",
		back={ name="Senuna's Mantle", augments={'DEX+20','Mag. Acc+20 /Mag. Dmg.+20','DEX+10','Weapon skill damage +10%',}},
		legs="Horos Tights +3",
		feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},}
	
	--ACC Modded	
    sets.precast.Flourish1['Desperate Flourish'] = sets.precast.Flourish1['Violent Flourish']
	    
    
	---------------------------------------------------------------------------------------------------
	--Flourish 2 gear changes.
	---------------------------------------------------------------------------------------------------
	
    sets.precast.Flourish2 = {}
    sets.precast.Flourish2['Reverse Flourish'] = {
		ammo="Staunch Tathlum",
	    head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
		neck="Loricate Torque +1",
        body="Meghanada Cuirie +2",
		ear2="Sanare Earring",
		--Gear for RF
		hands="Maculele Bangles +1",
		--
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		legs="Mummu Kecks +2",
		--
		back={ name="Toetapper Mantle", augments={'"Store TP"+1','"Dual Wield"+5','"Rev. Flourish"+30','Weapon skill damage +2%',}},
		--
		feet={ name="Herculean Boots", augments={'Accuracy+28','Damage taken-3%','DEX+14','Attack+11',}}
		}
		
    sets.precast.Flourish2['Wild Flourish'] = {
	    ammo="Yamarang",
		head="Maxixi Tiara +3",
		neck="Combatant's Torque",
		ear1="Zennaroi Earring",
		ear2="Mache Earring +1",
		body="Maxixi Casaque +3",
		hands="Maxixi Bangles +3",
		ring1="Regal Ring",
		ring2="Defending Ring",
		back="Agema Cape",
		waist="Olseni Belt",
		legs="Meghanada Chausses +2",
		feet="Maxixi ToeShoes +3"}
	  
	  
	---------------------------------------------------------------------------------------------------
	--Flourish 3 gear changes.
	---------------------------------------------------------------------------------------------------
	
    sets.precast.Flourish3 = {}
    sets.precast.Flourish3['Striking Flourish'] = {}
    sets.precast.Flourish3['Climactic Flourish'] = {head="Maculele Tiara +1"}
    
---------------------------------------------------------------------------------------------------
    -- Fast cast sets for spells
---------------------------------------------------------------------------------------------------
    
    sets.precast.FC = {
		ammo="Sapience Orb",
		head={ name="Herculean Helm", augments={'Mag. Acc.+25','"Fast Cast"+5','MND+5','"Mag.Atk.Bns."+12',}},
		neck="Voltsurge Torque",
		ear1="Etiolation Earring",
		ear2="Loquacious Earring",
		body="Samnuha Coat",
		hands="Leyline Gloves",
		legs={ name="Herculean Trousers", augments={'Mag. Acc.+6','"Fast Cast"+6','INT+9','"Mag.Atk.Bns."+10',}},
		ring1="Rahab Ring",
		ring2="Defending Ring",
		back={ name="Senuna's Mantle", augments={'AGI+20','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10',}},
		feet={ name="Herculean Boots", augments={'"Mag.Atk.Bns."+15','"Fast Cast"+5','Mag. Acc.+14',}}}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads",body="Passion Jacket"})

---------------------------------------------------------------------------------------------------	
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
---------------------------------------------------------------------------------------------------
	
    sets.precast.WS = {
		ammo="Yamarang",
		head={ name="Herculean Helm", augments={'Accuracy+16 Attack+16','"Triple Atk."+4','DEX+10','Accuracy+8','Attack+5',}},
		neck="Fotia Gorget",
		ear1="Ishvara Earring",
		ear2="Moonshade Earring",
		body="Adhemar Jacket +1",
		hands="Maxixi Bangles +3",
		ring1="Epona's Ring",
		ring2="Regal Ring",
		back="Senuna's Mantle",
		waist="Fotia Belt",
		legs="Horos Tights +3",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
    
---------------------------------------------------------------------------------------------------
    -- Specific weaponskill sets.  Uses the base set if not defined.
---------------------------------------------------------------------------------------------------
	
	sets.precast.WS['Shark Bite'] = {
	    ammo="Yamarang",
        head={ name="Adhemar Bonnet", augments={'STR+10','DEX+10','Attack+15',}},
        body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
        hands="Maxixi Bangles +3",
        legs="Meghanada Chausses +2",
        feet="Meghanada Jambeaux +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
        ear1="Sherida Earring",
		ear2="Mache Earring +1",
		ring1="Ilabrat Ring",
		ring2="Regal Ring",
        back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}}}
	
    sets.precast.WS['Exenterator'] = {
	    ammo="Yamarang",
        head={ name="Adhemar Bonnet", augments={'STR+10','DEX+10','Attack+15',}},
        body="Meghanada Cuirie +2",
        hands="Maxixi Bangles +3",
        legs="Horos Tights +3",
        feet="Meg. Jam. +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		ear1="Sherida Earring",
        ear2="Brutal Earring",
		ring1="Ilabrat Ring",
		ring2="Regal Ring",
        back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10',}},}
    
	---------------------------------------------------------------------------------------------------
    -- The Staple of all damage. PK! PK! PK! Wooooooooooooooooooooooooooooooooooooooooooooooooooo!
	---------------------------------------------------------------------------------------------------
	
    sets.precast.WS['Pyrrhic Kleos'] = {
	    ammo="Floestone",
	    head="Horos Tiara +3",
	    body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
        hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		neck="Fotia Gorget",
	    ear1="Sherida Earring",
		ear2="Mache Earring +1",
	    legs="Horos Tights +3",
		feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
    	waist="Fotia Belt",
		ring1="Ilabrat Ring",
		ring2="Regal Ring",
		back={ name="Senuna's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10',}}}

		
	---------------------------------------------------------------------------------------------------
    -- The Staple of all damage ends.
	---------------------------------------------------------------------------------------------------
	
    sets.precast.WS['Evisceration'] = {
	    ammo="Charis Feather",
	    head={ name="Adhemar Bonnet", augments={'STR+10','DEX+10','Attack+15',}},
	    body="Abnoba Kaftan",
		neck="Fotia Gorget",
		ear1="Mache Earring +1",
		ear2="Sherida Earring",
	    hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Begrudging Ring",
		ring2="Regal Ring",
		waist="Fotia Belt",
		legs="Lustratio Subligar +1",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Crit.hit rate+10',}},
		feet="Adhemar Gamashes +1"}
    
	---------------------------------------------------------------------------------------------------
    --Unstacked Rudra
	---------------------------------------------------------------------------------------------------
	
    sets.precast.WS["Rudra's Storm"] = {
	    ammo="Charis Feather",
        head={ name="Herculean Helm", augments={'Accuracy+23 Attack+23','Weapon skill damage +4%','DEX+15',}},
        body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
        hands="Maxixi Bangles +3",
        legs="Horos Tights +3",
        feet="Lustratio Leggings +1",
		neck="Caro Necklace",
		waist="Grunfeld Rope",
        ear1="Moonshade Earring",
		ear2="Mache Earring +1",
		ring1="Ilabrat Ring",
		ring2="Regal Ring",
        back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}}}
	
	---------------------------------------------------------------------------------------------------
    --Stacked Rudra with Climactic Flourish	(automated to use this set when CF is active)
	---------------------------------------------------------------------------------------------------
	
    sets.precast.WS["Rudra's Storm"].CF = {
	    ammo="Charis Feather",
	    head="Maculele Tiara +1",
	    neck="Caro Necklace",
	    ear1="Mache Earring +1",
	    ear2="Moonshade Earring",
		body="Meghanada Cuirie +2",
        hands="Maxixi Bangles +3",
		ring1="Ilabrat Ring",
		ring2="Regal Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},
		waist="Grunfeld Rope",
		legs="Horos Tights +3",
		feet="Lustratio Leggings +1"}
    
	---------------------------------------------------------------------------------------------------
	--Mostly MAB and AGI
	---------------------------------------------------------------------------------------------------
	
    sets.precast.WS['Aeolian Edge'] = {ammo="Pemphredo Tathlum",
        head={ name="Herculean Helm", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','INT+8','"Mag.Atk.Bns."+11',}},
		neck="Sanctity Necklace",
		ear1="Friomisi Earring",
		ear2="Ishvara Earring",
        body="Samnuha Coat",
		hands={ name="Herculean Gloves", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','STR+6','Mag. Acc.+13','"Mag.Atk.Bns."+12',}},
		ring1="Ilabrat Ring",
		ring2="Regal Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Mag. Acc+20 /Mag. Dmg.+20','DEX+10','Weapon skill damage +10%',}},
		waist="Eschan Stone",
		legs={ name="Herculean Trousers", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','"Fast Cast"+5','"Mag.Atk.Bns."+15',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Weapon skill damage +1%','MND+5','Mag. Acc.+12','"Mag.Atk.Bns."+11',}}}
    
    
---------------------------------------------------------------------------------------------------
    -- Midcast Sets
---------------------------------------------------------------------------------------------------
	
    sets.midcast.FastRecast = {
		ammo="Staunch Tathlum",
	    head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
		neck="Loricate Torque +1",
        body="Meghanada Cuirie +2",
		ear1="Odnowa Earring +1",
		ear2="Sanare Earring",
		hands={ name="Herculean Gloves", augments={'Accuracy+21 Attack+21','Mag. Acc.+2','Damage taken-3%','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		legs="Mummu Kecks +2",
		back="Agema Cape",
		feet={ name="Herculean Boots", augments={'Accuracy+28','Damage taken-3%','DEX+14','Attack+11',}}}
    
    ---------------------------------------------------------------------------------------------------	
    -- Specific spells
	---------------------------------------------------------------------------------------------------
	
    sets.midcast.Utsusemi = {
		ammo="Staunch Tathlum",
	    head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
		neck="Loricate Torque +1",
        body="Meghanada Cuirie +2",
		ear1="Odnowa Earring +1",
		ear2="Sanare Earring",
		hands={ name="Herculean Gloves", augments={'Accuracy+21 Attack+21','Mag. Acc.+2','Damage taken-3%','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		legs="Mummu Kecks +2",
		back="Agema Cape",
		feet={ name="Herculean Boots", augments={'Accuracy+28','Damage taken-3%','DEX+14','Attack+11',}}}
	
	
	sets.midcast.Cure = sets.precast.Flourish1['Animated Flourish']
	
	
	sets.midcast['Yoran-Oran (UC)'] = set_combine(sets.midcast.FastRecast, {body="Yoran Unity Shirt"})

    sets.midcast['Sylvie (UC)'] = set_combine(sets.midcast.FastRecast, {body="Sylvie Unity Shirt"})
	
---------------------------------------------------------------------------------------------------
    -- Resting sets (Sets to return to when not performing an action)
---------------------------------------------------------------------------------------------------
	
    sets.resting = {
	    head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
		neck="Loricate Torque +1",
        body="Meghanada Cuirie +2",
		hands={ name="Herculean Gloves", augments={'Accuracy+21 Attack+21','Mag. Acc.+2','Damage taken-3%','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		waist="Flume Belt +1",
		legs="Meghanada Chausses +2",
		back="Agema Cape",
		feet={ name="Herculean Boots", augments={'Accuracy+28','Damage taken-3%','DEX+14','Attack+11',}}}

    
---------------------------------------------------------------------------------------------------
    -- Idle sets
---------------------------------------------------------------------------------------------------
	
    sets.idle = {
		ammo="Staunch Tathlum",
		head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
		neck="Bathy Choker +1",
		ear1="Genmei Earring",
	    ear2="Infused Earring",
		body="Horos Casaque +3",
		hands="Turms Mittens",
		legs="Mummu Kecks +2",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		back={ name="Senuna's Mantle", augments={'AGI+20','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10',}},
		feet="Turms Leggings"}

	sets.idle.Town = {
		ammo="Staunch Tathlum",
	    head="Moogle Masque",
		neck="Bathy Choker +1",
		ear1="Genmei Earring",
	    ear2="Infused Earring",
		body="Tidal Talisman",
		hands={ name="Herculean Gloves", augments={'Accuracy+21 Attack+21','Mag. Acc.+2','Damage taken-3%','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		back={ name="Senuna's Mantle", augments={'AGI+20','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10',}},
		waist="Reiki Yotai",
		legs="Horos Tights +3",
		feet="Turms Leggings"}

	sets.idle.Weak = {
	    ammo="Staunch Tathlum",
	    head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
		neck="Loricate Torque +1",
        body="Meghanada Cuirie +2",
		ear2="Sanare Earring",
		hands={ name="Herculean Gloves", augments={'Accuracy+21 Attack+21','Mag. Acc.+2','Damage taken-3%','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		legs="Mummu Kecks +2",
		back="Agema Cape",
		feet={ name="Herculean Boots", augments={'Accuracy+28','Damage taken-3%','DEX+14','Attack+11',}}}
    
---------------------------------------------------------------------------------------------------
    -- Defense sets
---------------------------------------------------------------------------------------------------
	
    -- sets.defense.Evasion = {}
	
	
	-- 51PDT
    sets.defense.PDT = {
		neck="Loricate Torque +1",
        body="Meghanada Cuirie +2",
		hands={ name="Herculean Gloves", augments={'Accuracy+21 Attack+21','Mag. Acc.+2','Damage taken-3%','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
		ear1="Genmei Earring",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		legs="Mummu Kecks +2",
		waist="Flume Belt +1",
		feet={ name="Herculean Boots", augments={'Accuracy+28','Damage taken-3%','DEX+14','Attack+11',}}}

	-- 27 MDT
    sets.defense.MDT = {
	    ammo="Staunch Tathlum",
	    head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
        neck="Warder's Charm +1",
		hands="Turms Mittens",
        ring1="Vocane Ring +1",
		ring2="Defending Ring",
		ear1="Odnowa Earring +1",
		ear2="Sanare Earring",
		waist="Engraved Belt",
		legs="Mummu Kecks +2"
        }
		
	-- 49PDT and 29MDT and 464 MEVA
	sets.defense.DT = {
	    ammo="Staunch Tathlum",
	    head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
		neck="Warder's Charm +1",
        body="Meghanada Cuirie +2",
		ear1="Genmei Earring",
		ear2="Sanare Earring",
		hands="Turms Mittens",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		waist="Engraved Belt",
		legs="Mummu Kecks +2",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		feet="Turms Leggings"}

	
	sets.defense.Resist = {
	    ammo="Staunch Tathlum",
	    head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
        neck="Warder's Charm +1",
		body="Turms Harness",
		hands="Turms Mittens",
        ring1="Vocane Ring +1",
		ring2="Defending Ring",
		ear1="Odnowa Earring +1",
		ear2="Sanare Earring",
		waist="Engraved Belt",
		legs="Mummu Kecks +2",
        feet="Turms Leggings"}
		
	sets.defense.Parry = set_combine(sets.defense.PDT, {
		neck="Combatant's Torque",
		ear1="Genmei Earring",
		hands="Turms Mittens", 
		feet="Turms Leggings"})
	
	
    sets.Kiting = {}

---------------------------------------------------------------------------------------------------
	-- Engaged sets
---------------------------------------------------------------------------------------------------
	
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    -- NoDW is Single wield mode.
	
    -- Normal melee 
	-- 37DW
	
	sets.engaged = {
	    ammo="Yamarang",
		head="Maxixi Tiara +3",
		neck="Charis Necklace",
		ear1="Sherida Earring",
		ear2="Suppanomimi",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Hetairoi Ring",
		ring2="Epona's Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Samnuha Tights",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}

		--Aftermath set
	sets.engaged.AM = {
		ammo="Yamarang",
		head="Maxixi Tiara +3",
		neck="Charis Necklace",
		ear1="Sherida Earring",
		ear2="Suppanomimi",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Ilabrat Ring",
		ring2="Moonbeam Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Samnuha Tights",
		feet="Horos T. Shoes +3"}
	
	
	sets.engaged.Facing = {
		ammo="Yamarang",
		head="Maxixi Tiara +3",
		neck="Charis Necklace",
		ear1="Sherida Earring",
		ear2="Suppanomimi",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Ilabrat Ring",
		ring2="Moonbeam Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Samnuha Tights",
		feet="Horos T. Shoes +3"}
	
    sets.engaged.Acc = {
		ammo="Yamarang",
		head="Dampening Tam",
		neck="Anu Torque",
		ear1="Eabani Earring",
		ear2="Suppanomimi",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Ilabrat Ring",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Meghanada Chausses +2",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}  
	
    sets.engaged.PDT = {
		}  
    sets.engaged.Acc.PDT = {
		}
	
	---------------------------------------------------------------------------------------------------
	-- Haste at 10%
	---------------------------------------------------------------------------------------------------
	
	sets.engaged.Haste_10 = {
		ammo="Yamarang",
		head="Maxixi Tiara +3",
		neck="Charis Necklace",
		ear1="Sherida Earring",
		ear2="Telos Earring",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Hetairoi Ring",
		ring2="Epona's Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Samnuha Tights",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
		
			--Aftermath set
	sets.engaged.AM.Haste_10 = {
		ammo="Yamarang",
		head="Maxixi Tiara +3",
		neck="Charis Necklace",
		ear1="Sherida Earring",
		ear2="Telos Earring",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Ilabrat Ring",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Samnuha Tights",
		feet="Horos T. Shoes +3"}
	
	
	sets.engaged.Facing.Haste_10 = {
		ammo="Yamarang",
		head="Maxixi Tiara +3",
		neck="Charis Necklace",
		ear1="Sherida Earring",
		ear2="Telos Earring",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Ilabrat Ring",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Samnuha Tights",
		feet="Horos T. Shoes +3"}
	
    sets.engaged.Acc.Haste_10 = {
		ammo="Yamarang",
		head="Dampening Tam",
		neck="Anu Torque",
		ear1="Eabani Earring",
		ear2="Suppanomimi",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Ilabrat Ring",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Meghanada Chausses +2",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}  
	
    sets.engaged.PDT.Haste_10 = {
		}  
    sets.engaged.Acc.PDT.Haste_10 = {
		}
		
	---------------------------------------------------------------------------------------------------	
	-- Haste at 15%
	---------------------------------------------------------------------------------------------------
	
	-- 31DW
	
    sets.engaged.Haste_15 = {
		ammo="Yamarang",
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		neck="Anu Torque",
		ear1="Suppanomimi",
		ear2="Sherida Earring",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Hetairoi Ring",
		ring2="Epona's Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Samnuha Tights",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}

		--Aftermath set
	sets.engaged.AM.Haste_15 = {
		ammo="Yamarang",
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		neck="Anu Torque",
		ear1="Suppanomimi",
		ear2="Sherida Earring",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Ilabrat Ring",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Samnuha Tights",
		feet="Horos T. Shoes +3"}
	
    
	sets.engaged.Facing.Haste_15 = {
		ammo="Yamarang",
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		neck="Anu Torque",
		ear1="Sherida Earring",
		ear2="Suppanomimi",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Ilabrat Ring",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Samnuha Tights",
		feet="Horos T. Shoes +3"}	

    sets.engaged.Acc.Haste_15 = {
		ammo="Yamarang",
		head="Dampening Tam",
		neck="Anu Torque",
		ear1="Eabani Earring",
		ear2="Suppanomimi",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Ilabrat Ring",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Meghanada Chausses +2",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
    sets.engaged.PDT.Haste_15 = {
		}  
    sets.engaged.Acc.PDT.Haste_15 = {
		}

	---------------------------------------------------------------------------------------------------
    -- Haste 25%
	---------------------------------------------------------------------------------------------------
	
	-- 24DW
	
	sets.engaged.Haste_25 = {
		ammo="Yamarang",
		head="Maxixi Tiara +3",
		neck="Anu Torque",
		ear1="Suppanomimi",
		ear2="Telos Earring",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Hetairoi Ring",
		ring2="Epona's Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Windbuffet Belt +1",
		legs="Samnuha Tights",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
	--Aftermath set
	sets.engaged.AM.Haste_25 = {
		ammo="Yamarang",
		head="Maxixi Tiara +3",
		neck="Anu Torque",
		ear1="Suppanomimi",
		ear2="Telos Earring",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Ilabrat Ring",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Windbuffet Belt +1",
		legs="Samnuha Tights",
		feet="Horos T. Shoes +3"}
	
    
	sets.engaged.Facing.Haste_25 = {
		ammo="Yamarang",
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		neck="Anu Torque",
		ear1="Suppanomimi",
		ear2="Eabani Earring",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Ilabrat Ring",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Windbuffet Belt +1",
		legs="Samnuha Tights",
		feet="Horos T. Shoes +3"}

	
    sets.engaged.Acc.Haste_25 = {
		ammo="Yamarang",
		head={ name="Herculean Helm", augments={'Accuracy+16 Attack+16','"Triple Atk."+4','DEX+10','Accuracy+8','Attack+5',}},
		neck="Combatant's Torque",
		ear1="Telos Earring",
		ear2="Zennaroi Earring",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Ilabrat Ring",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Meghanada Chausses +2",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}} 
	
    sets.engaged.PDT.Haste_25 = {
		} 
    sets.engaged.Acc.PDT.Haste_25 = {
		}
	
    ---------------------------------------------------------------------------------------------------	
	-- Haste sets at 30%
	---------------------------------------------------------------------------------------------------
	
	-- 20DW
	
	sets.engaged.Haste_30 = {
		ammo="Yamarang",
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		neck="Charis Necklace",
		ear1="Sherida Earring",
		ear2="Eabani Earring",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Hetairoi Ring",
		ring2="Epona's Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Samnuha Tights",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
		
	--Aftermath set
	sets.engaged.AM.Haste_30 = {
		ammo="Yamarang",
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		neck="Charis Necklace",
		ear1="Sherida Earring",
		ear2="Eabani Earring",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Ilabrat Ring",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Samnuha Tights",
		feet="Horos T. Shoes +3"}
	
    
	sets.engaged.Facing.Haste_30 = {
		ammo="Yamarang",
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		neck="Anu Torque",
		ear1="Sherida Earring",
		ear2="Eabani Earring",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Ilabrat Ring",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Windbuffet Belt +1",
		legs="Samnuha Tights",
		feet="Horos T. Shoes +3"}
	
    sets.engaged.Acc.Haste_30 = {
		ammo="Yamarang",
		head={ name="Herculean Helm", augments={'Accuracy+16 Attack+16','"Triple Atk."+4','DEX+10','Accuracy+8','Attack+5',}},
		neck="Combatant's Torque",
		ear1="Telos Earring",
		ear2="Zennaroi Earring",
        body="Adhemar Jacket +1",
        hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Ilabrat Ring",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Meghanada Chausses +2",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
    sets.engaged.PDT.Haste_30 = {
		}
    sets.engaged.Acc.PDT.Haste_30 = {
		}	
		
	---------------------------------------------------------------------------------------------------	
    -- Haste 40%
	---------------------------------------------------------------------------------------------------
	
	-- 8DW
	
    sets.engaged.Haste_40 = {
		ammo="Yamarang",
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		neck="Charis Necklace",
		ear1="Suppanomimi",
		ear2="Telos Earring",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Hetairoi Ring",
		ring2="Epona's Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10',}},
		waist="Windbuffet Belt +1",
		legs="Samnuha Tights",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
		
	--Aftermath set
	sets.engaged.AM.Haste_40 = {
		ammo="Yamarang",
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		neck="Charis Necklace",
		ear1="Suppanomimi",
		ear2="Telos Earring",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Ilabrat Ring",
		ring2="Moonbeam Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},
		waist="Windbuffet Belt +1",
		legs="Samnuha Tights",
		feet="Horos T. Shoes +3"}
	
   
		
	sets.engaged.Facing.Haste_40 = {
		ammo="Yamarang",
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		neck="Anu Torque",
		ear1="Sherida Earring",
		ear2="Telos Earring",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Ilabrat Ring",
		ring2="Moonbeam Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},
		waist="Windbuffet Belt +1",
		legs="Samnuha Tights",
		feet="Horos T. Shoes +3"}
	
    sets.engaged.Acc.Haste_40 = {
		ammo="Yamarang",
		head={ name="Herculean Helm", augments={'Accuracy+16 Attack+16','"Triple Atk."+4','DEX+10','Accuracy+8','Attack+5',}},
		neck="Combatant's Torque",
		ear1="Telos Earring",
		ear2="Zennaroi Earring",
        body="Adhemar Jacket +1",
        hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Ilabrat Ring",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Meghanada Chausses +2",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
    sets.engaged.PDT.Haste_40 = {
		}
    sets.engaged.Acc.PDT.Haste_40 = {
		}

    ---------------------------------------------------------------------------------------------------
    -- Max Haste
	---------------------------------------------------------------------------------------------------
	

    sets.engaged.MaxHaste = {
	    ammo="Yamarang",
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		neck="Anu Torque",
		ear1="Sherida Earring",
		ear2="Telos Earring",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Hetairoi Ring",
		ring2="Epona's Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10',}},
		waist="Windbuffet Belt +1",
		legs="Samnuha Tights",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
    --Aftermath set
	sets.engaged.AM.MaxHaste= {
	    ammo="Yamarang",
		head="Maculele Tiara +1",
		neck="Anu Torque",
		ear1="Sherida Earring",
		ear2="Telos Earring",
		body="Turms Harness",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Ilabrat Ring",
		ring2="Moonbeam Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},
		waist="Kentarch Belt +1",
		legs="Samnuha Tights",
		feet="Horos T. Shoes +3"}
	
    

	sets.engaged.Facing.MaxHaste = {
		ammo="Yamarang",
		head="Maculele Tiara +1",
		neck="Anu Torque",
		ear1="Sherida Earring",
		ear2="Telos Earring",
		body="Turms Harness",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Ilabrat Ring",
		ring2="Moonbeam Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},
		waist="Kentarch Belt +1",
		legs="Samnuha Tights",
		feet="Horos T. Shoes +3"}
	
    sets.engaged.Acc.MaxHaste = {
		ammo="Yamarang",
		head={ name="Herculean Helm", augments={'Accuracy+16 Attack+16','"Triple Atk."+4','DEX+10','Accuracy+8','Attack+5',}},
		neck="Combatant's Torque",
		ear1="Telos Earring",
		ear2="Zennaroi Earring",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Epona's Ring",
		ring2="Hetairoi Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},
		waist="Olseni Belt",
		legs="Meghanada Chausses +2",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
    sets.engaged.PDT.MaxHaste = {
		}
    sets.engaged.Acc.PDT.MaxHaste = {
		}


---------------------------------------------------------------------------------------------------
    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
---------------------------------------------------------------------------------------------------
	
    sets.buff['Saber Dance'] = {}
    sets.buff['Climactic Flourish'] = {head="Maculele Tiara +1"}
	sets.buff.doom = {ring1="Blenmot's Ring",ring2="Purity Ring"}
	sets.buff.sleep = {head="Frenzy Sallet"}
    
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
     cancel_conflicting_buffs(spell, action, spellMap, eventArgs)
	 custom_aftermath_timers_precast(spell, action, spellMap, eventArgs)

	 -------------------------------------------------------------------------------------------------------------------
     -- Cancel WS when not in range.
     -------------------------------------------------------------------------------------------------------------------
     
	 if spell.type == "WeaponSkill" then
		if player.status == 'Engaged' then
			if player.tp >= 1000 then
				if spell.target.distance <= 7 then
					if sets.precast.WS[spell.name] then
						equip(sets.precast.WS[spell.name])
					else
						equip(sets.precast.WS)
					end
				else
					cancel_spell()
					windower.add_to_chat(121, 'Canceled '..spell.name..'.'..spell.target.name..' is Too Far')
				end
			end
		else
			cancel_spell()
			windower.add_to_chat(121, 'You must be Engaged to WS')
        end
     end

end


	 
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" then
        if state.Buff['Climactic Flourish'] then
            equip(sets.buff['Climactic Flourish'])
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
    -- Shadow cycling
-------------------------------------------------------------------------------------------------------------------
	
function job_midcast(spell, action, spellMap, eventArgs)
		--Cancels Ni shadows
	if spell.name == 'Utsusemi: Ichi' and overwrite then
        send_command('cancel Copy Image|Copy Image (2)')
    end
end




-- Return true if we handled the aftercast work.  Otherwise it will fall back
-- to the general aftercast() code in Mote-Include.
function job_aftercast(spell, action, spellMap, eventArgs)
   custom_aftermath_timers_aftercast(spell, action, spellMap, eventArgs)
   if not spell.interrupted then
        if spell.name == 'Utsusemi: Ichi' then
            overwrite = false
        elseif spell.name == 'Utsusemi: Ni' then
            overwrite = true
        end
    end
	
	
end

	

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain, eventArgs)
    --If we gain or lose any haste buffs, adjust which gear set we target.
    if S{'haste','march','embrava','haste samba','indi-haste','geo-haste','mighty guard', 'aftermath: lv.3'}:contains(buff:lower()) then
        get_combat_form()
		determine_haste_group()
        handle_equipping_gear(player.status)
	
	---------------------------------------------------------------------------------------------------
    -- Equipment for debuffs.
	---------------------------------------------------------------------------------------------------	
    
	elseif (buff == "sleep" and gain) and player.hp > 100 then 
        equip(sets.buff.sleep)
                if buffactive.stoneskin then
                    send_command('cancel Stoneskin')
                end
	elseif buff:lower()=='terror' then
        if gain and player.status == "Engaged" then 
            equip(sets.defense.DT)
			disable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'ring1' , 'ring2' , 'neck' , 'left_ear' , 'right_ear')
        elseif not gain then 
		    enable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'ring1' , 'ring2' , 'neck' , 'left_ear' , 'right_ear')
            handle_equipping_gear(player.status)
		end
	
	elseif buff:lower()=='petrification' then
        if gain and player.status == "Engaged" then 
            equip(sets.defense.DT)
			disable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'ring1' , 'ring2' , 'neck' , 'left_ear' , 'right_ear')
        elseif not gain then 
		    enable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'ring1' , 'ring2' , 'neck' , 'left_ear' , 'right_ear')
            handle_equipping_gear(player.status)
		end

	elseif buff:lower()=='stun'  then
        if gain and player.status == "Engaged" then 
            equip(sets.defense.DT)
			disable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'ring1' , 'ring2' , 'neck' , 'left_ear' , 'right_ear')
        elseif not gain then 
		    enable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'ring1' , 'ring2' , 'neck' , 'left_ear' , 'right_ear')
            handle_equipping_gear(player.status)
		end
		 
	elseif buff:lower()=='doom' then
        if gain and player.status == "Engaged" then 
            equip(sets.buff.doom)
			disable('ring1' , 'ring2')
			add_to_chat(8, 'Doomed!!! Use Holy Waters!!!')
        elseif not gain then 
		    enable('ring1' , 'ring2')
            handle_equipping_gear(player.status)
		end

    elseif buff == 'Saber Dance' or buff == 'Climactic Flourish' then
        handle_equipping_gear(player.status)
	end
	
	if player.equipment.main == 'Twashtar' and buff:startswith('Aftermath') then
        local times = {["Aftermath: Lv.1"]=180, ["Aftermath: Lv.2"]=180, ["Aftermath: Lv.3"]=180}
        
        if gain then
            send_command('timers c "'..buff..'" '..tostring(times[buff])..' down abilities/00027.png')
        else
            send_command('timers d "'..buff..'"')

        end
	elseif player.equipment.main == 'Aeneas' and buff:startswith('Aftermath') then
        local times = {["Aftermath: Lv.1"]=180, ["Aftermath: Lv.2"]=180, ["Aftermath: Lv.3"]=180}
        
        if gain then
            send_command('timers c "'..buff..'" '..tostring(times[buff])..' down abilities/00027.png')
        else
            send_command('timers d "'..buff..'"')

        end
	elseif player.equipment.main == 'Terpsichore' and buff:startswith('Aftermath') then
        local times = {["Aftermath: Lv.1"]=180, ["Aftermath: Lv.2"]=180, ["Aftermath: Lv.3"]=180}
        
        if gain then
            send_command('timers c "'..buff..'" '..tostring(times[buff])..' down abilities/00027.png')
        else
            send_command('timers d "'..buff..'"')

        end
	end
	
end		

---------------------------------------------------------------------------------------------------
-- CombatForm to take into account facing or AM. Always update here.
---------------------------------------------------------------------------------------------------	
function get_combat_form()
    if buffactive['Aftermath: Lv.3'] and player.equipment.main == gear.Terpsichore then
    	state.CombatForm:set('AM')
    else
        state.CombatForm:reset()
    end
end


function job_status_change(new_status, old_status)
    if new_status == 'Engaged' then
		get_combat_form()
	    determine_haste_group()
		 
    end
end




-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
    gearmode()
	get_combat_form()
	determine_haste_group()
end

--Automated use of Rudra's Storm.CF when buff is active.
function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    local wsmode

    if state.Buff['Climactic Flourish'] then
        wsmode = 'CF'
    end
    
    return wsmode
end


--Combining melee sets when buffs are active.
function customize_melee_set(meleeSet)
    if state.DefenseMode.value ~= 'None' then
        if buffactive['Saber dance'] then
            meleeSet = set_combine(meleeSet, sets.buff['Saber Dance'])
        end
        if state.Buff['Climactic Flourish'] then
            meleeSet = set_combine(meleeSet, sets.buff['Climactic Flourish'])
        end
    end
		
	if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end

-------------------------------------------------------------------------------------------------------------------
    -- Custom idle sets to keep warp rings on.
-------------------------------------------------------------------------------------------------------------------
	
function customize_idle_set(idleSet)
	if state.WarpMode.value == 'Warp' then
		idleSet = set_combine(idleSet, sets.Warp)
	elseif state.WarpMode.value == 'Jima: Holla' then
        idleSet = set_combine(idleSet, sets.Holla)
	elseif state.WarpMode.value == 'Jima: Dem' then
        idleSet = set_combine(idleSet, sets.Dem)
    elseif state.WarpMode.value == 'Off' then
		idleSet = set_combine(idleSet)	
	end
    return idleSet
end




-- Function to display the current relevant user state when doing an update.
-- Set eventArgs.handled to true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    if state.HybridMode.value ~= 'Normal' then
        msg = msg .. '/' .. state.HybridMode.value
    end
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
    end
	
    if state.Kiting.value then
        msg = msg .. ', Kiting'
    end

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
--[[function job_self_command(cmdParams, eventArgs)
end]]

-------------------------------------------------------------------------------------------------------------------
    -- Determine haste groups and amend current gear
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
   
    classes.CustomMeleeGroups:clear()

    -- Haste 						= 15%
	-- Haste II						= 30%
	-- GeoHaste						= 29.9%	(30% Used below)
	-- Haste Samba (Sub) 			=  5%
	-- Haste Samba (Merited DNC) 	= 10% 	(Only the subjob value is used below)
	-- Victory March +0/+3/+4/+5    = 10.4%	**NEW baseline (10% Used below)(Changed to 15% as of 11/2017)
	-- Advancing March +0/+3/+4/+5  = 15.9%	**NEW baseline (15% Used below)(Changed to 15% as of 11/2017)
	-- Embrava 						= 26.9% with 500 enhancing skill (25% Used below)
	-- Mighty Guard 				= 15%
	
	-- buffactive[580] 				= geo haste
	-- buffactive[33] 				= haste (1 & 2, shared icon)
	-- buffactive[604] 				= mighty guard
	-- buffactive[228] 				= embrava
	-- buffactive[370] 				= Haste Samba
	-- buffactive[214]				= March (Advancing and Victory and Honor March)
	
	
---------------------------------------------------------------------------------------------------
-- Haste Mode. Credit: Rikimarueye and Tiburon and Moten
---------------------------------------------------------------------------------------------------

	-- state.HasteMode = toggle for when you know Haste II is being cast on you
	if state.HasteMode.value == true then																					-- ***This Section is for Haste II*** --
		if 		(buffactive[228] and (buffactive[33] or (buffactive.march == 1) or buffactive[604])) or                 			-- Embrava + (HasteII or 2x march or MG) + Samba
				(buffactive[580] and (buffactive[33] or (buffactive.march == 1) or buffactive[604])) or   							-- GeoHaste + (HasteII or 1x march or MG)
				(buffactive[33] and ((buffactive.march == 1) or buffactive[604])) or												-- HasteII + (1x march or MG)
				(buffactive[604] and (buffactive.march == 2)) or												                    -- MG + 2x March 
				((buffactive.march == 2) and buffactive[33]) or																		-- 2x March + Haste
				((buffactive.march == 2) and buffactive[370]) or
				(buffactive[228] and buffactive[580]) then																			-- Embrava + GeoHaste
	        add_to_chat(8, '------------- Max Haste -------------')
	        classes.CustomMeleeGroups:append('MaxHaste')
        elseif  (buffactive[228] and buffactive.march == 1) or 																		-- Embrava + 1x march
				(buffactive[33] or buffactive[580]) and buffactive[370] or
				(buffactive.march == 2 and buffactive[370]) or                                                                      -- 2x march + Samba
				(buffactive[228] and buffactive[604]) then																			-- Embrava + MG
            add_to_chat(8, '-------------Haste 40%-------------')
		    classes.CustomMeleeGroups:append('Haste_40')	
        elseif 	(buffactive[228] and buffactive[370]) or                                                                     		-- Embrava + Samba
		        (buffactive[228] and buffactive.march == 1) then 																	-- Embrava + 1x march
		    add_to_chat(8, '-------------Haste 35%-------------')
			classes.CustomMeleeGroups:append('Haste_35')
		elseif 	(buffactive[604] and buffactive.march == 1) or							                    						-- MG + 1x march
				(buffactive.march == 2) or											     				                    		-- 2x march 
				(buffactive[228] and buffactive[370]) or																			-- Embrava + Samba
				(buffactive[33] or buffactive[580]) then																			-- HasteII or GeoHaste  
            add_to_chat(8, '-------------Haste 30%-------------')
            classes.CustomMeleeGroups:append('Haste_30')
        elseif 	(buffactive.march == 1 and buffactive[370]) or 																		-- 1x march + Samba
				(buffactive.march == 2) or																							-- 2x march
				(buffactive[228]) then																								-- Embrava
		    add_to_chat(8, '-------------Haste 25%-------------')
			classes.CustomMeleeGroups:append('Haste_25')
	    elseif 	(buffactive[604] or buffactive.march == 1) then																		-- MG or 1x march
            add_to_chat(8, '-------------Haste 15%-------------')
            classes.CustomMeleeGroups:append('Haste_15')
        elseif 	(buffactive[370]) then																						        -- Samba
            add_to_chat(8, '-------------Haste 10%-------------')
            classes.CustomMeleeGroups:append('Haste_10')
		end
    else																													-- ***This section is for Haste I*** --										
		if 		(buffactive[228] and buffactive.march == 1 and buffactive[370]) or	                                        		-- Embrava + march + Samba
				((buffactive[33] or buffactive[604]) and ((buffactive.march == 2) and buffactive[370])) or							-- (Haste or MG) + (2x march + Samba)
				(buffactive[580] and ((buffactive.march == 1) or buffactive[33] or buffactive[604])) or   							-- GeoHaste + (2x march or Haste or MG)
				(buffactive[580] and ((buffactive.march == 2) or buffactive[33] or buffactive[604])) or
				((buffactive[33] or buffactive[604]) and buffactive.march == 2) or													-- (Haste or MG) + 2x march
				(buffactive[228] and buffactive.march == 1) or													        			-- Embrava + 1x march
				(buffactive[228] and buffactive[580]) then																			-- Embrava + GeoHaste
	        add_to_chat(8, '------------- Max Haste -------------')
	        classes.CustomMeleeGroups:append('MaxHaste')
		elseif 	((buffactive[33] and buffactive[604] and buffactive[370])) or			                               				-- Haste + MG + Samba
				(buffactive[580] and buffactive[370]) or		                        											-- GeoHaste + Samba
				(buffactive.march == 2 and buffactive[370]) or                                                         				-- 2x march + Samba
				(buffactive.march == 1 and buffactive[370] and buffactive[33])  or                                                    -- 1x march + haste 1 + Samba
				((buffactive[33] or buffactive[604]) and buffactive[228]) then														-- (Haste or MG) + Embrava
            add_to_chat(8, '-------------Haste 40%-------------')
		    classes.CustomMeleeGroups:append('Haste_40')			
		elseif  (buffactive[228] and buffactive[370]) then                                                                    		-- Embrava + Samba    
            add_to_chat(8, '-------------Haste 35%-------------')
            classes.CustomMeleeGroups:append('Haste_35')
		elseif 	((buffactive[33] or buffactive[604]) and buffactive.march == 1) or 				                    				-- (Haste or MG) + 1x march						
				(buffactive.march == 2) or								                    										-- 2x march
				(buffactive[33] and buffactive[604]) or		                                                        				-- Haste + MG
				(buffactive[580]) then 																								-- GeoHaste
            add_to_chat(8, '-------------Haste 30%-------------')
            classes.CustomMeleeGroups:append('Haste_30')
		elseif 	(buffactive[33] and buffactive[370]) or                                                                             -- Haste + Samba																					-- 2x march
				(buffactive[228]) then																								-- Embrava
			add_to_chat(8, '-------------Haste 25%-------------')
			classes.CustomMeleeGroups:append('Haste_25')
		elseif  (buffactive[33] or buffactive[604] or buffactive.march == 1)  then						                            -- Haste or MG or 1x march
																					
            add_to_chat(8, '-------------Haste 15%-------------')
            classes.CustomMeleeGroups:append('Haste_15')
        elseif 	(buffactive[370]) then																		                        -- Samba
            add_to_chat(8, '-------------Haste 10%-------------')
            classes.CustomMeleeGroups:append('Haste_10')
        end
	end
	---------------------------------------------------------------------------------------------------
	-- Haste Mode with Aftermath. Credit: Rikimarueye and Tiburon and Moten
	---------------------------------------------------------------------------------------------------
	
	
	
	--[[if state.HasteMode.value == true and (state.Buff.Aftermath == buffactive['Aftermath: Lv.3']) then																					-- ***This Section is for Haste II*** --
		if 		(buffactive[228] and (buffactive[33] or (buffactive.march == 1) or buffactive[604])) or                 			-- Embrava + (HasteII or 2x march or MG) + Samba
				(buffactive[580] and (buffactive[33] or (buffactive.march == 1) or buffactive[604])) or   							-- GeoHaste + (HasteII or 1x march or MG)
				(buffactive[604] and ((buffactive.march == 2) )) or												                    -- MG + 2x March 
				(buffactive[33] and ((buffactive.march == 1) or buffactive[604])) or												-- HasteII + (1x march or MG)
				(buffactive[228] and buffactive[580]) then																			-- Embrava + GeoHaste
	        add_to_chat(8, '------------- Max Haste -------------')
	        classes.CustomMeleeGroups:append('MaxHaste.AM')
        elseif  (buffactive[228] and buffactive.march == 1) or 																		-- Embrava + 1x march
				(buffactive[33] or buffactive[580]) and buffactive[370] or
				(buffactive.march == 2 and buffactive[370]) or                                                                      -- 2x march + Samba
				(buffactive[228] and buffactive[604]) then																			-- Embrava + MG
            add_to_chat(8, '-------------Haste 40%-------------')
		    classes.CustomMeleeGroups:append('Haste_40.AM')	
        elseif 	(buffactive[228] and buffactive[370]) or                                                                     		-- Embrava + Samba
		        (buffactive[228] and buffactive.march == 1) then 																	-- Embrava + 1x march
		    add_to_chat(8, '-------------Haste 35%-------------')
			classes.CustomMeleeGroups:append('Haste_35.AM')
		elseif 	(buffactive[604] and buffactive.march == 1) or							                    						-- MG + 1x march
				(buffactive.march == 2) or											     				                    		-- 2x march 
				(buffactive[228] and buffactive[370]) or																			-- Embrava + Samba
				(buffactive[33] or buffactive[580]) then																			-- HasteII or GeoHaste  
            add_to_chat(8, '-------------Haste 30%-------------')
            classes.CustomMeleeGroups:append('Haste_30.AM')
        elseif 	(buffactive.march == 1 and buffactive[370]) or 																		-- 1x march + Samba
				(buffactive.march == 2) or																							-- 2x march
				(buffactive[228]) then																								-- Embrava
		    add_to_chat(8, '-------------Haste 25%-------------')
			classes.CustomMeleeGroups:append('Haste_25.AM')
	    elseif 	(buffactive[604] or buffactive.march == 1) then																		-- MG or 1x march
            add_to_chat(8, '-------------Haste 15%-------------')
            classes.CustomMeleeGroups:append('Haste_15.AM')
        elseif 	(buffactive[370]) then																						        -- Samba
            add_to_chat(8, '-------------Haste 10%-------------')
            classes.CustomMeleeGroups:append('Haste_10.AM')
		end
    else																													-- ***This section is for Haste I*** --										
		if 		(buffactive[228] and buffactive.march == 1 and buffactive[370]) or	                                        		-- Embrava + march + Samba
				((buffactive[33] or buffactive[604]) and ((buffactive.march == 2) and buffactive[370])) or							-- (Haste or MG) + (2x march + Samba)
				(buffactive[580] and ((buffactive.march == 1) or buffactive[33] or buffactive[604])) or   							-- GeoHaste + (2x march or Haste or MG)
				((buffactive[33] or buffactive[604]) and buffactive.march == 2) or													-- (Haste or MG) + 2x march
				(buffactive[228] and buffactive.march == 1) or													        			-- Embrava + 1x march
				(buffactive[228] and buffactive[580]) then																			-- Embrava + GeoHaste
	        add_to_chat(8, '------------- Max Haste -------------')
	        classes.CustomMeleeGroups:append('MaxHaste.AM')
		elseif 	((buffactive[33] and buffactive[604] and buffactive[370])) or			                               				-- Haste + MG + Samba
				(buffactive[580] and buffactive[370]) or		                        											-- GeoHaste + Samba
				(buffactive.march == 2 and buffactive[370]) or                                                         				-- 2x march + Samba
				(buffactive.march == 1 and buffactive[370] and buffactive[33])  or                                                    -- 1x march + haste 1 + Samba
				((buffactive[33] or buffactive[604]) and buffactive[228]) then														-- (Haste or MG) + Embrava
            add_to_chat(8, '-------------Haste 40%-------------')
		    classes.CustomMeleeGroups:append('Haste_40.AM')			
		elseif  (buffactive[228] and buffactive[370]) then                                                                    		-- Embrava + Samba    
            add_to_chat(8, '-------------Haste 35%-------------')
            classes.CustomMeleeGroups:append('Haste_35.AM')
		elseif 	((buffactive[33] or buffactive[604]) and buffactive.march == 1) or 				                    				-- (Haste or MG) + 1x march						
				(buffactive.march == 2) or								                    										-- 2x march
				(buffactive[33] and buffactive[604]) or		                                                        				-- Haste + MG
				(buffactive[580]) then 																								-- GeoHaste
            add_to_chat(8, '-------------Haste 30%-------------')
            classes.CustomMeleeGroups:append('Haste_30.AM')
		elseif 	(buffactive[33] and buffactive[370]) or                                                                             -- Haste + Samba																					-- 2x march
				(buffactive[228]) then																								-- Embrava
			add_to_chat(8, '-------------Haste 25%-------------')
			classes.CustomMeleeGroups:append('Haste_25.AM')
		elseif  (buffactive[33] or buffactive[604] or buffactive.march == 1)  then						                            -- Haste or MG or 1x march
																					
            add_to_chat(8, '-------------Haste 15%-------------')
            classes.CustomMeleeGroups:append('Haste_15.AM')
        elseif 	(buffactive[370]) then																		                        -- Samba
            add_to_chat(8, '-------------Haste 10%-------------')
            classes.CustomMeleeGroups:append('Haste_10.AM')
        end
    end]]
end



function gearmode()
	if state.WeaponMode.value == 'Terpsichore' then
		equip(sets.Terpsichore)
		handle_equipping_gear(player.status)
	elseif state.WeaponMode.value == 'Aeneas' then
		equip(sets.Aeneas)
		handle_equipping_gear(player.status)
  end
end

---------------------------------------------------------------------------------------------------
-- Automatically use Presto. The Working code. Credit: dlsmd
---------------------------------------------------------------------------------------------------

function job_pretarget(spell, action, spellMap, eventArgs)
	local fm_count = 0
    for i, v in pairs(buffactive) do
        if tostring(i):startswith('finishing move') or tostring(i):startswith('フィニシングムーブ') then
            fm_count = tonumber(string.match(i, '%d+')) or 1
        end
    end
    if spell.type == 'Step' and fm_count < 6 then
        if windower.ffxi.get_ability_recasts()[236] < 1 then
            cast_delay(1.1)
            send_command('input /ja "Presto" <me>')
        end
    end
	
end


    
-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
		set_macro_page(1, 15)
	elseif player.sub_job == 'NIN' then
		set_macro_page(1, 15)
	elseif player.sub_job == 'SAM' then
		set_macro_page(1, 15)
	else
		set_macro_page(1, 15)
    end
end
