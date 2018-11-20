-------------------------------------------------------------------------------------------------------------------
-- Rikimarueye's DNC lua. Comment section below
-------------------------------------------------------------------------------------------------------------------


-- Maintained and fixed and updated by Rikimarueye@pheonix
-- Original base lua created by Moten.

-- Version 1.0.3.0

--[[

	To do list:
	
	 Update and optimize DPS.
	 Add new features to help facilitate ease of use and lessen the macro/key press burden
	
]]

--[[
	Change log:
	
	1.0.3.0: Added Eternal Stances framework. I will need to add more features to it at a later date
	
	1.0.2.3: Cut out most of the hybrid sets and ACC sets since my normal engaged set is high ACC
	
	1.0.2.2: Updated sets for Etoile Gorget +2 ( need only to replace Anu Torque for ease of modify ) 
	
	1.0.2.1: refine_divine needed some much needed debugging but seems to work intandem with other Waltz while being independant
	
	1.0.2.0: refine_divine was added to downgrade Divine Waltz independant of the refine_waltz arguments in the utility ( thanks to the devs )
	
	1.0.1.5: Chat log displays (stances and steps) to keep information from getting lost in the battle log ( aka tooltips ) 
	
	1.0.1.4: Updated JA sets and DT sets to include more MEVA
	
	1.0.1.3: Removed some of the experimental builds due to ineffectiveness 
	
	1.0.1.2: Added experimental builds for the WSD bug
	
	1.0.1.1: Minor fix to positional function
	
	1.0.1.0: A major developments in my GS. I was able to borrow code from an addon to make a conditional gear swap based on position ( thank you KenshiDRK )
	
	1.0.0.7: Fixed the update to idle set after zoning when using a teleport ring 
	
	1.0.0.6: Changed DT set to add more MEVA
	
	1.0.0.5: Added Horos Tights +3 to sets
	
	1.0.0.4: Added weapon toggle
	
	1.0.0.3: Fixed haste rules for bard songs and haste1/2. Added a rule for CombatForm to only apply when mythic is worn. ( thanks tiburon for clean up )
	
	1.0.0.2: Added a function with the help of dlsmd from BGforums to autopresto.
	
	1.0.0.0: Personalized the lua and populated with my equipment.
]]

--[[

 To user: Please feel free to DM, PM or open an issue if there is an error that I do not catch. Thank you ^^!

	]]

---------------------------------------------------------------------------------------------------
    -- Start of the setup, sets, and functions.
---------------------------------------------------------------------------------------------------

require('vectors')

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2
    
    -- Load and initialize the include file.
    include('Mote-Include.lua')
	

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
	
	check_facing()
	
	define_dance_stance()
	
	define_step_stats()
	
	get_combat_form()
	
	IsStanceEnabled()
	
	
	
    state.Buff['Climactic Flourish'] = buffactive['climactic flourish'] or false
	
	state.Buff.doom = buffactive.doom or false
    state.Buff.sleep = buffactive.sleep or false
	state.Buff.Terror = buffactive.Terror or false
    state.Buff.Stun = buffactive.Stun or false
    state.Buff.Petrification = buffactive.Petrification or false
	state.Buff.Stoneskin = buffactive.stoneskin or false
	
	--For Aftermath tracking
	state.Buff['Aftermath: Lv.3'] = buffactive['Aftermath: Lv.3'] or false

	state.Buff['Presto'] = buffactive['Presto'] or false
	
	state.Buff['Saber Dance'] = buffactive['Saber Dance'] or false
	
	state.Buff['Fan Dance'] = buffactive['Fan Dance'] or false
	
	
	--Haste mode
	state.HasteMode = M(false, 'Haste 2')
 
	state.DanceMode = M{['description']='Eternal Dance', 'None', 'Saber', 'Fan'}
	 
    determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal')
    state.HybridMode:options('Normal')
    state.WeaponskillMode:options('Normal', 'CF')
    state.PhysicalDefenseMode:options('PDT' , 'Parry')

    --Teleport Rings!
    state.WarpMode = M{['description']='Transportation Ring is now', 'Off', 'Warp', 'Jima: Holla', 'Jima: Dem'}
	
	state.WeaponMode = M{['description']='Weapon', 'Terpsichore', 'Aeneas', 'Twashtar'}
	
	

	
	
    -- Additional local binds
	send_command('wait 10;input /lockstyleset 16')
    send_command('bind ^` gs c toggle HasteMode')
    send_command('bind !` gs c cycle DanceMode')
    send_command('bind ^z gs c cycle WarpMode')
	send_command('bind ^a gs c cycle WeaponMode')
	
	gear.Terpsichore	= "Terpsichore"
	gear.Aeneas			= "Aeneas"
	gear.Twashtar		= "Twashtar"
	gear.shield			= "Airy Buckler"
	
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
	
	sets.Warp	= {ring2="Warp Ring"}
  
    sets.Holla	= {ring2="Dim. Ring (Holla)"}
	
	sets.Dem	= {ring2="Dim. Ring (Dem)"}
	
	
	sets.Terpsichore	= {main=gear.Terpsichore, sub=gear.Twashtar}
	sets.Aeneas			= {main=gear.Aeneas, sub=gear.Twashtar}
	sets.Twashtar		= {sub=gear.shield}
	sets.shield			= {main=gear.Twashtar}
	
---------------------------------------------------------------------------------------------------
	-- Precast Sets
---------------------------------------------------------------------------------------------------
    
    -- Precast sets to enhance JAs

    sets.precast.JA['No Foot Rise'] = {
		
		-- Body for TP upon JA use
        body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		--
		}

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
		head="Horos Tiara +3",			-- WP 15%
		ear1="Enchanter Earring +1",
		ear2="Handler's earring +1",
		body="Maxixi Casaque +3",		-- WP 19%
		neck="Etoile Gorget +2",		-- WP 10%
		hands="Regal Gloves",
		legs="Mummu Kecks +2",
		waist="Aristo Belt",
		ring1="Asklepian Ring",
		ring2="Carbuncle Ring +1",
		back={ name="Senuna's Mantle", augments={'CHR+20','Eva.+20 /Mag. Eva.+20','CHR+10','Enmity-10','Phys. dmg. taken-10%',}},
	    feet="Maxixi ToeShoes +3"}	-- WP 14%
        
	---------------------------------------------------------------------------------------------------
    -- DT all the things! Stay alive!
	---------------------------------------------------------------------------------------------------
	
	
    sets.precast.Waltz['Healing Waltz'] = {
		ammo="Staunch Tathlum",
	    head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
		neck="Loricate Torque +1",
        body="Meghanada Cuirie +2",
		ear1="Eabani Earring",
		ear2="Sanare Earring",
		hands="Turms Mittens +1",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		legs="Mummu Kecks +2",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		waist="Flume Belt +1",
		feet="Turms Leggings +1"}
    
    sets.precast.Samba = {
		--Tiara for Samba duration
	    head="Maxixi Tiara +3",
		--
		--Mantle for Samba duration
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		--
		}

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
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		--Shoes for duration
		feet="Maxixi ToeShoes +3"
		--
		}

    sets.precast.Step = {
		ammo="Yamarang",
		head="Maxixi Tiara +3",
		neck="Etoile Gorget +2",
		ear1="Telos Earring",
		ear2="Mache Earring +1",
		body="Maxixi Casaque +3",
		hands="Maxixi Bangles +3",
		ring1="Regal Ring",
		ring2="Defending Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
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
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		ear1="Genmei Earring",
		ear2="Dignitary's Earring",
		waist="Eschan Stone",
		neck="Etoile Gorget +2",
		back={ name="Senuna's Mantle", augments={'DEX+20','Mag. Acc+20 /Mag. Dmg.+20','DEX+10','Weapon skill damage +10%',}},
		legs="Horos Tights +3",
		feet="Mummu Gamashes +2"}
	
	--ACC Modded	
    sets.precast.Flourish1['Desperate Flourish'] = sets.precast.Flourish1['Violent Flourish']
	    
    
	---------------------------------------------------------------------------------------------------
	--Flourish 2 gear changes.
	---------------------------------------------------------------------------------------------------
	
    sets.precast.Flourish2 = {}
    sets.precast.Flourish2['Reverse Flourish'] = {
		
		--Gear for RF
		hands="Maculele Bangles +1",
		--
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		
		--
		back={ name="Toetapper Mantle", augments={'"Store TP"+1','"Dual Wield"+5','"Rev. Flourish"+30','Weapon skill damage +2%',}},
		--
		}
		
    sets.precast.Flourish2['Wild Flourish'] = {
	    ammo="Yamarang",
		head="Maxixi Tiara +3",
		neck="Etoile Gorget +2",
		ear1="Telos Earring",
		ear2="Mache Earring +1",
		body="Maxixi Casaque +3",
		hands="Maxixi Bangles +3",
		ring1="Regal Ring",
		ring2="Defending Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
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
		neck="Orunmila's Torque",
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
		ammo="Floestone",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
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
	    ammo="Floestone",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
        hands="Maxixi Bangles +3",
        legs="Meghanada Chausses +2",
        feet="Meghanada Jambeaux +2",
		neck="Etoile Gorget +2",
		waist="Fotia Belt",
        ear1="Sherida Earring",
		ear2="Mache Earring +1",
		ring1="Ilabrat Ring",
		ring2="Regal Ring",
        back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}}}
	
    sets.precast.WS['Exenterator'] = {
	    ammo="Floestone",
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
        body="Meghanada Cuirie +2",
        hands="Maxixi Bangles +3",
        legs="Horos Tights +3",
        feet="Meg. Jam. +2",
		neck="Etoile Gorget +2",
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
	    head={ name="Herculean Helm", augments={'Accuracy+23 Attack+23','Weapon skill damage +4%','DEX+15',}},
	    body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
        hands="Maxixi Bangles +3",
		neck="Etoile Gorget +2",
	    ear1="Sherida Earring",
		ear2="Ishvara Earring",
	    legs="Horos Tights +3",
		feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
    	waist="Fotia Belt",
		ring1="Epaminondas's Ring",
		ring2="Regal Ring",
		back={ name="Senuna's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
		
	-- Semi-real WS set
	--[[sets.precast.WS['Pyrrhic Kleos'] = {
	    ammo="Floestone",
	    head="Horos Tiara +3",
	    body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
        hands="Maxixi Bangles +3",
		neck="Fotia Gorget",
	    ear1="Sherida Earring",
		ear2="Mache Earring +1",
	    legs="Meghanada Chausses +2",
		feet={ name="Horos T. Shoes +3", augments={'Enhances "Closed Position" effect',}},
    	waist="Fotia Belt",
		ring1="Ilabrat Ring",
		ring2="Regal Ring",
		back={ name="Senuna's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
		
		]]

		
	---------------------------------------------------------------------------------------------------
    -- The Staple of all damage ends.
	---------------------------------------------------------------------------------------------------
	
	-- Experimental build for the WSD bug
    sets.precast.WS['Evisceration'] = {
	    ammo="Charis Feather",
        head={ name="Herculean Helm", augments={'Accuracy+23 Attack+23','Weapon skill damage +4%','DEX+15',}},
        body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
        hands="Maxixi Bangles +3",
        legs="Horos Tights +3",
        feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
        ear1="Sherida Earring",
		ear2="Ishvara Earring",
		ring1="Epaminondas's Ring",
		ring2="Regal Ring",
        back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}}}
    
	
	-- My actual build for Evisceration
	--[[sets.precast.WS['Evisceration'] = {
	    ammo="Charis Feather",
	    head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
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
		feet="Adhemar Gamashes +1"}]]
	
	
	
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
		neck="Etoile Gorget +2",
		waist="Grunfeld Rope",
        ear1="Moonshade Earring",
		ear2="Ishvara Earring",
		ring1="Epaminondas's Ring",
		ring2="Regal Ring",
        back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},
		}
	
	---------------------------------------------------------------------------------------------------
    --Stacked Rudra with Climactic Flourish	(automated to use this set when CF is active)
	---------------------------------------------------------------------------------------------------
	
    sets.precast.WS["Rudra's Storm"].CF = {
	    ammo="Charis Feather",
	    head="Maculele Tiara +1",
	    neck="Etoile Gorget +2",
	    ear1="Moonshade Earring",
		ear2="Ishvara Earring",
		body="Meghanada Cuirie +2",
        hands="Maxixi Bangles +3",
		ring1="Epaminondas's Ring",
		ring2="Regal Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}},
		waist="Grunfeld Rope",
		legs="Horos Tights +3",
		feet={ name="Herculean Boots", augments={'Accuracy+18','Crit. hit damage +4%','DEX+10','Attack+14',}},
		}
    
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
		ring1="Epaminondas's Ring",
		ring2="Regal Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Mag. Acc+20 /Mag. Dmg.+20','DEX+10','Weapon skill damage +10%',}},
		waist="Eschan Stone",
		legs={ name="Herculean Trousers", augments={'Mag. Acc.+17 "Mag.Atk.Bns."+17','Weapon skill damage +2%','STR+5','"Mag.Atk.Bns."+14',}},
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
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
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
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
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
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		feet={ name="Herculean Boots", augments={'Accuracy+28','Damage taken-3%','DEX+14','Attack+11',}}}

    
---------------------------------------------------------------------------------------------------
    -- Idle sets
---------------------------------------------------------------------------------------------------
	
    sets.idle = {
		ammo="Staunch Tathlum",
		head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
		neck="Etoile Gorget +2",
		ear1="Genmei Earring",
	    ear2="Odnowa Earring +1",
		body="Horos Casaque +3",
		hands="Turms Mittens +1",
		legs="Mummu Kecks +2",
		waist="Flume Belt +1",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		back={ name="Senuna's Mantle", augments={'AGI+20','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10',}},
		feet="Turms Leggings +1",}

	sets.idle.Town = {
		ammo="Staunch Tathlum",
	    head="Moogle Masque",
		neck="Loricate Torque +1",
		ear1="Genmei Earring",
	    ear2="Odnowa Earring +1",
		body="Tidal Talisman",
		hands="Turms Mittens +1",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		back={ name="Senuna's Mantle", augments={'AGI+20','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10',}},
		waist="Flume Belt +1",
		legs="Horos Tights +3",
		feet="Turms Leggings +1",}

	sets.idle.Weak = {
	    neck="Etoile Gorget +2",
        body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		ear1="Genmei Earring",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		legs="Mummu Kecks +2",
		waist="Flume Belt +1",}
    
---------------------------------------------------------------------------------------------------
    -- Defense sets
---------------------------------------------------------------------------------------------------

	-- 51PDT
    sets.defense.PDT = {
		neck="Etoile Gorget +2",
        body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		ear1="Genmei Earring",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		legs="Mummu Kecks +2",
		waist="Flume Belt +1",
		}

	-- 27 MDT
    sets.defense.MDT = {
	    ammo="Staunch Tathlum",
	    head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
        neck="Warder's Charm +1",
		hands="Turms Mittens +1",
        ring1="Vocane Ring +1",
		ring2="Defending Ring",
		ear1="Odnowa Earring +1",
		ear2="Sanare Earring",
		waist="Engraved Belt",
		legs="Mummu Kecks +2"
        }
		
	-- 49 PDT / 31 MDT / 31 DT / 518+20 MEVA / +114 INT / +127 MND
	sets.defense.DT = {
	    ammo="Staunch Tathlum",
	    head="Maxixi Tiara +3",
		neck="Loricate Torque +1",
        body="Horos Casaque +3",
		ear1="Genmei Earring",
		ear2="Sanare Earring",
		hands="Turms Mittens +1",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		waist="Engraved Belt",
		legs="Mummu Kecks +2",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		feet="Turms Leggings +1",}

	
	sets.defense.Resist = sets.defense.DT
		
	sets.defense.Parry = set_combine(sets.defense.PDT, {
		neck="Combatant's Torque",
		ear1="Genmei Earring",
		hands="Turms Mittens +1", 
		feet="Turms Leggings +1",})
	

---------------------------------------------------------------------------------------------------
	-- Engaged sets
---------------------------------------------------------------------------------------------------
	
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    -- NoDW is Single wield mode.
	
    -- Normal melee 
	-- 40DW
	
	sets.engaged = {
	    ammo="Yamarang",
		head="Maxixi Tiara +3",
		neck="Etoile Gorget +2",
		ear1="Eabani Earring",
		ear2="Suppanomimi",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Epona's Ring",
		ring2="Moonbeam Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Adhemar Kecks +1",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}

		--Aftermath set
	sets.engaged.AM = {
		ammo="Yamarang",
		head="Maxixi Tiara +3",
		neck="Etoile Gorget +2",
		ear1="Eabani Earring",
		ear2="Suppanomimi",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Chirich Ring +1",
		ring2="Moonbeam Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Adhemar Kecks +1",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
	
	sets.engaged.Facing = {
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		neck="Etoile Gorget +2",
		ear1="Sherida Earring",
		ear2="Telos Earring",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Epona's Ring",
		ring2="Moonbeam Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10',}},
		waist="Windbuffet Belt +1",
		legs="Adhemar Kecks +1",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
    
	
	---------------------------------------------------------------------------------------------------
	-- Haste at 10%
	---------------------------------------------------------------------------------------------------
	
	--35 DW
	sets.engaged.Haste_10 = {
		ammo="Yamarang",
		head="Maxixi Tiara +3",
		neck="Etoile Gorget +2",
		ear1="Eabani Earring",
		ear2="Telos Earring",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Epona's Ring",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Adhemar Kecks +1",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
		
			--Aftermath set
	sets.engaged.AM.Haste_10 = {
		ammo="Yamarang",
		head="Maxixi Tiara +3",
		neck="Etoile Gorget +2",
		ear1="Eabani Earring",
		ear2="Telos Earring",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Chirich Ring +1",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Adhemar Kecks +1",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
	
	sets.engaged.Facing.Haste_10 = {
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		neck="Anu Torque",
		ear1="Sherida Earring",
		ear2="Telos Earring",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Epona's Ring",
		ring2="Moonbeam Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10',}},
		waist="Windbuffet Belt +1",
		legs="Adhemar Kecks +1",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
    
		
	---------------------------------------------------------------------------------------------------	
	-- Haste at 15%
	---------------------------------------------------------------------------------------------------
	
	-- 31DW
	
    sets.engaged.Haste_15 = {
		ammo="Yamarang",
		head="Maxixi Tiara +3",
		neck="Etoile Gorget +2",
		ear1="Sherida Earring",
		ear2="Telos Earring",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Epona's Ring",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Adhemar Kecks +1",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}

		--Aftermath set
	sets.engaged.AM.Haste_15 = {
		ammo="Yamarang",
		head="Maxixi Tiara +3",
		neck="Etoile Gorget +2",
		ear1="Sherida Earring",
		ear2="Telos Earring",
		body="Adhemar Jacket +1",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Chirich Ring +1",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Adhemar Kecks +1",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
    
	sets.engaged.Facing.Haste_15 = {
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		neck="Anu Torque",
		ear1="Sherida Earring",
		ear2="Telos Earring",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Epona's Ring",
		ring2="Moonbeam Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10',}},
		waist="Windbuffet Belt +1",
		legs="Adhemar Kecks +1",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}	

    

	---------------------------------------------------------------------------------------------------
    -- Haste 25%
	---------------------------------------------------------------------------------------------------
	
	-- 22DW
	
	sets.engaged.Haste_25 = {
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		neck="Etoile Gorget +2",
		ear1="Suppanomimi",
		ear2="Telos Earring",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Epona's Ring",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Adhemar Kecks +1",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
	--Aftermath set
	sets.engaged.AM.Haste_25 = {
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		neck="Etoile Gorget +2",
		ear1="Suppanomimi",
		ear2="Telos Earring",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Chirich Ring +1",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Adhemar Kecks +1",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
    
	sets.engaged.Facing.Haste_25 = {
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		neck="Anu Torque",
		ear1="Sherida Earring",
		ear2="Telos Earring",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Epona's Ring",
		ring2="Moonbeam Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10',}},
		waist="Windbuffet Belt +1",
		legs="Adhemar Kecks +1",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}

	
    
	
    ---------------------------------------------------------------------------------------------------	
	-- Haste sets at 30%
	---------------------------------------------------------------------------------------------------
	
	-- 21DW
	
	sets.engaged.Haste_30 = {
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		neck="Etoile Gorget +2",
		ear1="Eabani Earring",
		ear2="Telos Earring",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Epona's Ring",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Adhemar Kecks +1",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
		
	--Aftermath set
	sets.engaged.AM.Haste_30 = {
		ammo="Yamarang",
		head="Maculele Tiara +1",
		neck="Etoile Gorget +2",
		ear1="Sherida Earring",
		ear2="Telos Earring",
		body="Turms Harness",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Chirich Ring +1",
		ring2="Moonbeam Ring",
		 back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Adhemar Kecks +1",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
    
	sets.engaged.Facing.Haste_30 = {
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		neck="Anu Torque",
		ear1="Sherida Earring",
		ear2="Telos Earring",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Epona's Ring",
		ring2="Moonbeam Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10',}},
		waist="Windbuffet Belt +1",
		legs="Adhemar Kecks +1",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
    
		
	---------------------------------------------------------------------------------------------------	
    -- Haste 40%
	---------------------------------------------------------------------------------------------------
	
	-- 8DW
	
    sets.engaged.Haste_40 = {
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		neck="Etoile Gorget +2",
		ear1="Sherida Earring",
		ear2="Telos Earring",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Epona's Ring",
		ring2="Moonbeam Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10',}},
		waist="Reiki Yotai",
		legs="Adhemar Kecks +1",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
		
	--Aftermath set
	sets.engaged.AM.Haste_40 = {
		ammo="Yamarang",
		head="Maculele Tiara +1",
		neck="Etoile Gorget +2",
		ear1="Sherida Earring",
		ear2="Telos Earring",
		body="Turms Harness",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Chirich Ring +1",
		ring2="Moonbeam Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},
		waist="Reiki Yotai",
		legs="Adhemar Kecks +1",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
   
		
	sets.engaged.Facing.Haste_40 = {
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		neck="Anu Torque",
		ear1="Sherida Earring",
		ear2="Telos Earring",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Epona's Ring",
		ring2="Moonbeam Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10',}},
		waist="Windbuffet Belt +1",
		legs="Adhemar Kecks +1",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
    

    ---------------------------------------------------------------------------------------------------
    -- Max Haste
	---------------------------------------------------------------------------------------------------
	
	-- 4 hit average build with no DA/TA procs
    sets.engaged.MaxHaste = {
	    ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		neck="Etoile Gorget +2",
		ear1="Sherida Earring",
		ear2="Telos Earring",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Epona's Ring",
		ring2="Hetairoi Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},
		waist="Windbuffet Belt +1",
		legs="Adhemar Kecks +1",
		feet="Horos T. Shoes +3"}
	
	
    -- Aftermath set
	
	--[[ 
	
		2-hit build average with DA/TA procs and /SAM ( with 11 SAM roll and facing )
		
		or 
		
		6-hit build /WAR 
		
		or 
		
		4 hit with SAM roll and /SAM ( SAM roll must be 11 non-facing or 6+ facing )
		
		I need a lot more sTP so that I can 4-hit with a SAM roll of 1
	
		The better the sTP gear I have, the less reliant I am on rolls to hit my 4-hit build
		
		39 more sTP is needed to achieve the true 3-hit build or 1-hit on average
	
		]]
		
	-- 28 DA / 4 TA in gear + 40 DA / 20 TA from Terp AM ( 79 sTP base and 94 when facing + 15 from /SAM )
	sets.engaged.AM.MaxHaste = {
	    ammo="Yamarang",																							-- 3 sTP
		head="Maculele Tiara +1",																					-- 8 sTP	
		neck="Etoile Gorget +2",																					-- 3 sTP																						
		ear1="Sherida Earring",																						-- 5 sTP
		ear2="Dedition Earring",																					-- 8 sTP
		body="Turms Harness",																						-- 9 sTP
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},								-- 7 sTP
		ring1="Chirich Ring +1",																					-- 6 sTP
		ring2="Ilabrat Ring",																						-- 5 sTP
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10',}},		-- 10 sTP
		waist="Windbuffet Belt +1",																					-- 
		legs="Adhemar Kecks +1",																					-- 8 sTP
		feet="Horos T. Shoes +3"}																					-- 7 sTP (+15 when facing)
	
    

	sets.engaged.Facing.MaxHaste = {
		ammo="Yamarang",
		head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		neck="Anu Torque",
		ear1="Sherida Earring",
		ear2="Telos Earring",
		body={ name="Horos Casaque +3", augments={'Enhances "No Foot Rise" effect',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		ring1="Epona's Ring",
		ring2="Moonbeam Ring",
		back={ name="Senuna's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10',}},
		waist="Windbuffet Belt +1",
		legs="Adhemar Kecks +1",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
    

---------------------------------------------------------------------------------------------------
    -- Buff sets: Gear that needs to be worn to actively enhance a current player buff.
---------------------------------------------------------------------------------------------------
	
    sets.buff['Saber Dance'] = {}
    sets.buff['Climactic Flourish'] = {head="Maculele Tiara +1"}
	sets.buff.doom = {neck="Nicander's Necklace",ring1="Blenmot's Ring",ring2="Purity Ring"}
	sets.buff.sleep = {head="Frenzy Sallet"}
	sets.facing = {
		
		feet="Horos T. Shoes +3"}
   
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
     cancel_conflicting_buffs(spell, action, spellMap, eventArgs)
	 custom_aftermath_timers_precast(spell, action, spellMap, eventArgs)
	 refine_divine(spell, action, spellMap, eventArgs)
	 -------------------------------------------------------------------------------------------------------------------
     -- Cancel WS when not in range.
     -------------------------------------------------------------------------------------------------------------------
     
	 if spell.type == "WeaponSkill" then
		if player.status == 'Engaged' then
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
	
	
	-------------------------------------------------------------------------------------------------------------------
    -- Accompanying code for tooltips
	-------------------------------------------------------------------------------------------------------------------
	
	if spell.name:lower()=='saber dance' or 'fan dance' and not spell.interrupted then
		display_dance_stance(spell)
		
	end
	
	if spell.name:lower()=='quickstep' or 'box Step' or 'stutter Step' or 'feather Step' and not spell.interrupted then
		display_step_stats(spell)
		
	end
end

	

-------------------------------------------------------------------------------------------------------------------
-- Changes to the Buff Bar causes updates to sets
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain, eventArgs)

    --If we gain or lose any haste buffs, adjust which gear set we target.
    if S{'haste','march','embrava','haste samba','indi-haste',
		'geo-haste','mighty guard', 'aftermath: lv.1', 'aftermath: lv.2', 'aftermath: lv.3'}:contains(buff:lower()) then
       
		
		get_combat_form()
		determine_haste_group()
        handle_equipping_gear(player.status)
	
	---------------------------------------------------------------------------------------------------
    -- Equipment for debuffs.
	---------------------------------------------------------------------------------------------------	
    
	elseif buff:lower()=='sleep' then
        if gain and player.hp > 100 then 
            equip(sets.buff.sleep)
			add_to_chat(8, 'Nap time!!!')
				if buffactive.stoneskin then
                    send_command('cancel Stoneskin')
				end
        elseif not gain then 
            handle_equipping_gear(player.status)
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
        if gain then 
            equip(sets.buff.doom)
			disable('ring1' , 'ring2')
			add_to_chat(8, 'Doomed!!! Use Holy Waters!!!')
        elseif not gain then 
		    enable('ring1' , 'ring2')
            handle_equipping_gear(player.status)
		end

    elseif buff == 'Saber Dance' or buff == 'Fan Dance' then
        eternal_stance()
		
	elseif buff == 'Climactic Flourish' then
		handle_equipping_gear(player.status)
	end
	
	
	-------------------------------------------------------------------------------------------------------------------
    -- Aftermath Timers since no one seems to have one that works properly
	-------------------------------------------------------------------------------------------------------------------

	if player.equipment.main == 'Twashtar' and buff:startswith('Aftermath') then
        local times = {["Aftermath: Lv.1"]=180, ["Aftermath: Lv.2"]=180, ["Aftermath: Lv.3"]=180}
        
        if gain then
            send_command('timers c "'..buff..'" '..tostring(times[buff])..' down abilities/00027.png')
			add_to_chat(122, ''..buff..' on.')
        else
            send_command('timers d "'..buff..'"')
			add_to_chat(122, ''..buff..' off.')

        end
	elseif player.equipment.main == 'Aeneas' and buff:startswith('Aftermath') then
        local times = {["Aftermath: Lv.1"]=180, ["Aftermath: Lv.2"]=180, ["Aftermath: Lv.3"]=180}
        
        if gain then
            send_command('timers c "'..buff..'" '..tostring(times[buff])..' down abilities/00027.png')
			add_to_chat(122, ''..buff..' on.')
        else
            send_command('timers d "'..buff..'"')
			add_to_chat(122, ''..buff..' off.')

        end
	elseif player.equipment.main == 'Terpsichore' and buff:startswith('Aftermath') then
        local times = {["Aftermath: Lv.1"]=180, ["Aftermath: Lv.2"]=180, ["Aftermath: Lv.3"]=180}
        
        if gain then
            send_command('timers c "'..buff..'" '..tostring(times[buff])..' down abilities/00027.png')
			add_to_chat(122, ''..buff..' on.')
        else
            send_command('timers d "'..buff..'"')
			add_to_chat(122, ''..buff..' off.')

        end
	end
	
	
end		

-------------------------------------------------------------------------------------------------------------------
    -- When a status change is called upon. Check for: Directional, weapon selection and refreshes haste groups
-------------------------------------------------------------------------------------------------------------------

function job_status_change(new_status, old_status)
    if new_status == 'Engaged' then
		eternal_stance()
		check_facing()
		get_combat_form()
	    determine_haste_group()
		 
    end
end



-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the default 'update' self-command.
function job_update(cmdParams, eventArgs)
	eternal_stance()
    gearmode()
	check_facing()
	get_combat_form()
	determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
    -- Automated use of Rudra's Storm.CF when buff is active
-------------------------------------------------------------------------------------------------------------------

function get_custom_wsmode(spell, spellMap, default_wsmode)
    local wsmode

    if state.Buff['Climactic Flourish'] then
        wsmode = 'CF'
    end
    
    return wsmode
end



-------------------------------------------------------------------------------------------------------------------
    -- Combining melee sets when buffs are active. Covers: Stances, facing and TH
-------------------------------------------------------------------------------------------------------------------
function customize_melee_set(meleeSet)
    if state.DefenseMode.value ~= 'None' then
        if buffactive['Saber Dance'] then
            meleeSet = set_combine(meleeSet, sets.buff['Saber Dance'])
        end
        if state.Buff['Climactic Flourish'] then
            meleeSet = set_combine(meleeSet, sets.buff['Climactic Flourish'])
        end
    end
	
    if check_facing() == true then
            meleeSet = set_combine(meleeSet, sets.facing)
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


-------------------------------------------------------------------------------------------------------------------
    -- Similar to the Waltz refiner in utility (some of the code is from there too) but is not HP dependant
-------------------------------------------------------------------------------------------------------------------

function refine_divine(spell, action, spellMap, eventArgs)
	if spell.type ~= 'Waltz' then
		return
	end
	
	divine = S{'Divine Waltz', 'Divine Waltz II'}
	
	local waltz_tp_cost = {['Divine Waltz'] = 400, ['Divine Waltz II'] = 800}
	local newWaltz = spell.english
	local cancelling = ''..spell.english..' is on cooldown. Cancelling.'
	local tpCost = waltz_tp_cost[newWaltz]
	local notp = 'Not enough TP to complete '..newWaltz..'.'
	
	local downgrade
	
	if divine:contains(spell.english) then
			
	
	if player.tp < tpCost and not buffactive.trance then
								
					if player.tp < 400 then
							add_to_chat(122,notp)
							return
					elseif player.tp < 800 then
							newWaltz = 'Divine Waltz'
					elseif player.tp < 3000 then
							newWaltz = 'Divine Waltz II'
				
					end
				
		end
	end
	
	downgrade = 'Insufficient TP ['..tostring(player.tp)..']. Downgrading to '..newWaltz..'.'
	
	
	if newWaltz ~= spell.english then
		send_command('@input /ja "'..newWaltz..'" '..tostring(spell.target.raw))
		if downgrade then
			add_to_chat(122, downgrade)
		end
		eventArgs.cancel = true
		return
	end
end


---------------------------------------------------------------------------------------------------
-- CombatForm to take into account facing or AM. Always update here.
---------------------------------------------------------------------------------------------------	
function get_combat_form()
    if buffactive['Aftermath: Lv.3'] and player.equipment.main == gear.Terpsichore then
    	state.CombatForm:set('AM')
	elseif player.equipment.sub == gear.shield then
		state.CombatForm:set('Facing')
    else
        state.CombatForm:reset()
    end
end


-------------------------------------------------------------------------------------------------------------------
    -- Tooltip functions for stances and steps
-------------------------------------------------------------------------------------------------------------------

function define_dance_stance()
	dance_stance = {
	
					["Saber Dance"]	= {effect="Double Attack+20%", restriction="No Waltz"},
					
					["Fan Dance"]	= {effect="PDT-20%", restriction="No Samba"}
					
					}
end

function display_dance_stance(spell)
	dancestance = dance_stance[spell.english]
	
	if dancestance then
        add_to_chat(158, '***'..spell.english..' : '..dancestance.effect..' and '..dancestance.restriction..'.***')
    end
end

function define_step_stats()
	step_stats = {
	
					["Quickstep"]		= {Lv1="EVA -8", Lv10="EVA -44"},
					
					["Box Step"]		= {Lv1="DEF -5%", Lv10="DEF -23%"},
					
					["Stutter Step"]	= {Lv1="MEVA -3", Lv10="MEVA -30"},
					
					["Feather Step"]	= {Lv1="Crit Rate +5%", Lv10="Crit Rate +14%"}
					
					}
end

function display_step_stats(spell)
	stepstats = step_stats[spell.english]
	
	if stepstats then
        add_to_chat(158, '***'..spell.english..' : '..stepstats.Lv1..' to '..stepstats.Lv10..'.***')
    end
end

-------------------------------------------------------------------------------------------------------------------
    -- Determine your eternal_stance~
-------------------------------------------------------------------------------------------------------------------

function eternal_stance(spell, action, spellMap, eventArgs)

		if IsStanceEnabled() == false then
			if state.DanceMode.value == 'None' and player.in_combat then
				return	
					
			elseif state.DanceMode.value == 'Saber' and player.in_combat then
					if windower.ffxi.get_ability_recasts()[219] == 0 then
						send_command('input /ja "Saber Dance" <me>')
						
					end
			
			elseif state.DanceMode.value == 'Fan' and player.in_combat then
					if windower.ffxi.get_ability_recasts()[224] == 0 then
						send_command('input /ja "Fan Dance" <me>')
						
				
					end
			end
		else
			IsStanceEnabled()
		end
	return
end

function IsStanceEnabled(spell, action, spellMap, eventArgs)

		if buffactive['Saber Dance'] or buffactive['Fan Dance'] then
			
			return true
			
			
		--[[if state.eternal_stance ~= 'None' then
			
			if windower.ffxi.get_ability_recasts()[219] < 1 then
				if (buff == 'Saber Dance') then
						return true
				else
						return false
						
					
				end
			elseif windower.ffxi.get_ability_recasts()[236] < 1 then
			
				if (buff == 'Fan Dance') then
						return true
				else
						return false
						
					
				end]]
				
			
		else
			
			return false
			
		end
	
	return false
	
end

-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
    -- Determine haste groups and amend current gear
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()
   
    classes.CustomMeleeGroups:clear()
	--[[
     Haste							= 15%
	 Haste II						= 30%
	 GeoHaste						= 29.9%	(30% Used below)
	 Haste Samba (Sub) 				=  5%
	 Haste Samba (Merited DNC) 		= 10% 	(Only the subjob value is used below)
	 Victory March +0/+3/+4/+5		= 10.4%	**NEW baseline (10% Used below)(Changed to 15% as of 11/2017)
	 Advancing March +0/+3/+4/+5	= 15.9%	**NEW baseline (15% Used below)(Changed to 15% as of 11/2017)
	 Embrava 						= 26.9% with 500 enhancing skill (25% Used below)
	 Mighty Guard					= 15%
	
	 buffactive[580]				= geo haste
	 buffactive[33]				= haste (1 & 2, shared icon)
	 buffactive[604]				= mighty guard
	 buffactive[228]				= embrava
	 buffactive[370]				= Haste Samba
	 buffactive[214]				= March (Advancing and Victory and Honor March) 
	
	]]
	
	
---------------------------------------------------------------------------------------------------
-- Haste Mode. Credit: Rikimarueye and Tiburon and Moten
---------------------------------------------------------------------------------------------------

	-- state.HasteMode = toggle for when you know Haste II is being cast on you
	if state.HasteMode.value == true then																					-- ***This Section is for Haste II*** --
		if 		(buffactive[228] and (buffactive[33] or (buffactive.march == 1) or buffactive[604])) or                 	-- Embrava + (HasteII or 2x march or MG) + Samba
				(buffactive[580] and (buffactive[33] or (buffactive.march == 1) or buffactive[604])) or   					-- GeoHaste + (HasteII or 1x march or MG)
				(buffactive[33] and ((buffactive.march == 1) or buffactive[604])) or										-- HasteII + (1x march or MG)
				(buffactive.march == 2 and buffactive[370]) or                                                              -- 2x march + Samba
				(buffactive[604] and (buffactive.march == 2)) or												            -- MG + 2x March 
				((buffactive.march == 2) and buffactive[33]) or																-- 2x March + Haste
				((buffactive.march == 2) and buffactive[370]) or
				(buffactive[228] and buffactive[580]) then																	-- Embrava + GeoHaste
	        add_to_chat(8, '------------- Max Haste -------------')
	        classes.CustomMeleeGroups:append('MaxHaste')
        elseif  (buffactive[228] and buffactive.march == 1) or 																-- Embrava + 1x march
				(buffactive[33] or buffactive[580]) and buffactive[370] or
				(buffactive[228] and buffactive[604]) then																	-- Embrava + MG
            add_to_chat(8, '-------------Haste 40%-------------')
		    classes.CustomMeleeGroups:append('Haste_40')	
        elseif 	(buffactive[228] and buffactive[370]) or                                                                    -- Embrava + Samba
		        (buffactive[228] and buffactive.march == 1) then 															-- Embrava + 1x march
		    add_to_chat(8, '-------------Haste 35%-------------')
			classes.CustomMeleeGroups:append('Haste_35')
		elseif 	(buffactive[604] and buffactive.march == 1) or							                    				-- MG + 1x march
				(buffactive.march == 2) or											     				                    -- 2x march 
				(buffactive[228] and buffactive[370]) or																	-- Embrava + Samba
				(buffactive[33] or buffactive[580]) then																	-- HasteII or GeoHaste  
            add_to_chat(8, '-------------Haste 30%-------------')
            classes.CustomMeleeGroups:append('Haste_30')
        elseif 	(buffactive.march == 1 and buffactive[370]) or 																-- 1x march + Samba
				(buffactive.march == 2) or																					-- 2x march
				(buffactive[228]) then																						-- Embrava
		    add_to_chat(8, '-------------Haste 25%-------------')
			classes.CustomMeleeGroups:append('Haste_25')
	    elseif 	(buffactive[604] or buffactive.march == 1) then																-- MG or 1x march
            add_to_chat(8, '-------------Haste 15%-------------')
            classes.CustomMeleeGroups:append('Haste_15')
        elseif 	(buffactive[370]) then																						-- Samba
            add_to_chat(8, '-------------Haste 10%-------------')
            classes.CustomMeleeGroups:append('Haste_10')
		end
    else																													-- ***This section is for Haste I*** --										
		if 		(buffactive[228] and buffactive.march == 1 and buffactive[370]) or	                                        -- Embrava + march + Samba
				(buffactive.march == 2 and buffactive[370]) or                                                         		-- 2x march + Samba
				((buffactive[33] or buffactive[604]) and ((buffactive.march == 2) and buffactive[370])) or					-- (Haste or MG) + (2x march + Samba)
				(buffactive[580] and ((buffactive.march == 1) or buffactive[33] or buffactive[604])) or   					-- GeoHaste + (2x march or Haste or MG)
				(buffactive[580] and ((buffactive.march == 2) or buffactive[33] or buffactive[604])) or
				((buffactive[33] or buffactive[604]) and buffactive.march == 2) or											-- (Haste or MG) + 2x march
				(buffactive[228] and buffactive.march == 1) or													        	-- Embrava + 1x march
				(buffactive[228] and buffactive[580]) then																	-- Embrava + GeoHaste
	        add_to_chat(8, '------------- Max Haste -------------')
	        classes.CustomMeleeGroups:append('MaxHaste')
		elseif 	((buffactive[33] and buffactive[604] and buffactive[370])) or			                               		-- Haste + MG + Samba
				(buffactive[580] and buffactive[370]) or		                        									-- GeoHaste + Samba
				(buffactive.march == 1 and buffactive[370] and buffactive[33])  or                                          -- 1x march + haste 1 + Samba
				((buffactive[33] or buffactive[604]) and buffactive[228]) then												-- (Haste or MG) + Embrava
            add_to_chat(8, '-------------Haste 40%-------------')
		    classes.CustomMeleeGroups:append('Haste_40')			
		elseif  (buffactive[228] and buffactive[370]) then                                                                  -- Embrava + Samba    
            add_to_chat(8, '-------------Haste 35%-------------')
            classes.CustomMeleeGroups:append('Haste_35')
		elseif 	((buffactive[33] or buffactive[604]) and buffactive.march == 1) or 				                    		-- (Haste or MG) + 1x march						
				(buffactive.march == 2) or								                    								-- 2x march
				(buffactive[33] and buffactive[604]) or		                                                        		-- Haste + MG
				(buffactive[580]) then 																						-- GeoHaste
            add_to_chat(8, '-------------Haste 30%-------------')
            classes.CustomMeleeGroups:append('Haste_30')
		elseif 	(buffactive[33] and buffactive[370]) or                                                                     -- Haste + Samba																					-- 2x march
				(buffactive[228]) then																						-- Embrava
			add_to_chat(8, '-------------Haste 25%-------------')
			classes.CustomMeleeGroups:append('Haste_25')
		elseif  (buffactive[33] or buffactive[604] or buffactive.march == 1)  then						                    -- Haste or MG or 1x march
																					
            add_to_chat(8, '-------------Haste 15%-------------')
            classes.CustomMeleeGroups:append('Haste_15')
        elseif 	(buffactive[370]) then																		                -- Samba
            add_to_chat(8, '-------------Haste 10%-------------')
            classes.CustomMeleeGroups:append('Haste_10')
        end
	end
	
end

-------------------------------------------------------------------------------------------------------------------
    -- Weapon Selection 
-------------------------------------------------------------------------------------------------------------------

function gearmode()
	if state.WeaponMode.value == 'Terpsichore' then
		equip(sets.Terpsichore)
		handle_equipping_gear(player.status)
	elseif state.WeaponMode.value == 'Aeneas' then
		equip(sets.Aeneas)
		handle_equipping_gear(player.status)
	elseif state.WeaponMode.value == 'Twashtar' then
		equip(sets.Twashtar)
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

---------------------------------------------------------------------------------------------------
-- Voodoo magic that makes my relic boots equip under radial conditions. Credit: KenshiDRK
---------------------------------------------------------------------------------------------------

function check_facing()
	if player.target.type == 'MONSTER' then
		local target = windower.ffxi.get_mob_by_target('t')
		local player = windower.ffxi.get_mob_by_target('me')
		local dir_target = V{player.x, player.y} - V{target.x, target.y}
		local dir_player = V{target.x, target.y} - V{player.x, player.y}
		local player_heading = V{}.from_radian(player.facing)
		local target_heading = V{}.from_radian(target.facing)
		local player_angle = V{}.angle(dir_player, player_heading):degree():abs()
		local target_angle = V{}.angle(dir_target, target_heading):degree():abs()
		if player_angle < 90 and target_angle < 90 then
			return true
		else 
			return false
		end
	end		
		return false
end

function getAngle(index)
    local P = windower.ffxi.get_mob_by_target('me') --get player
    local M = index and windower.ffxi.get_mob_by_id(index) or windower.ffxi.get_mob_by_target('t') --get target
    local delta = {Y = (P.y - M.y),X = (P.x - M.x)} --subtracts target pos from player pos
    local angleInDegrees = (math.atan2( delta.Y, delta.X) * 180 / math.pi)*-1 
    local mult = 10^0
    return math.floor(angleInDegrees * mult + 0.5) / mult
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
		set_macro_page(1, 15)
	elseif player.sub_job == 'NIN' then
		set_macro_page(2, 15)
	elseif player.sub_job == 'SAM' then
		set_macro_page(3, 15)
	else
		set_macro_page(1, 15)
    end
end