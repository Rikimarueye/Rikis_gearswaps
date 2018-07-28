-------------------------------------------------------------------------------------------------------------------
-- Rikimarueye's RUN lua. Comment section below
-------------------------------------------------------------------------------------------------------------------


-- Maintained and fixed by Rikimarueye@pheonix
-- Original base lua created by Moten.

-- Version 1.0.0.9

--[[
	To do list:
	
	Optimize Battuta set for Critical Parry
	
]]

--[[
	Change log:
	
	1.0.0.9: Minor fix to positional function
	
	1.0.0.8: Added the a function to accurately use embolden during the post_midcast
	
	1.0.0.7: Preping for item replacements and rework of BSV
	
	1.0.0.6: Changed DT set to add more MEVA
	
	1.0.0.5: Added Battuta state variability (BSV)
	
	1.0.0.4: Added weapon toggle
	
	1.0.0.3: Added CombatWeapon for the two weapons I only use
	
	1.0.0.2: Added extra functions to help with shadow cycling, status ailments and various other misc things
	
	1.0.0.0: Wrote the base lua from scratch using moten as a template
]]



---------------------------------------------------------------------------------------------------
    -- Start of the setup, sets, and functions.
---------------------------------------------------------------------------------------------------

require('vectors')

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


-- Setup vars that are user-independent.
function job_setup()
    include('Mote-TreasureHunter')
    state.TreasureMode:set('Tag')
	
	check_facing()
	get_combat_weapon()
	--get_combat_form()
	define_rune_info()
	
	state.Buff['Battuta'] = buffactive['Battuta'] or false
	
	--Buff ID 359 for doom
	state.Buff.doom = buffactive.doom or false
    state.Buff.sleep = buffactive.sleep or false
	state.Buff.Terror = buffactive.Terror or false
    state.Buff.Stun = buffactive.Stun or false
    state.Buff.Petrification = buffactive.Petrification or false
	
	state.Buff['Vallation'] = buffactive['Vallation'] or false
	
	state.Buff['Valiance'] = buffactive['Valiance'] or false
	
	state.Buff['Embolden'] = buffactive['Embolden'] or false
	
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

function user_setup()
    state.OffenseMode:options('Normal', 'Hybrid', 'DD')
    state.WeaponskillMode:options('Normal')
    state.PhysicalDefenseMode:options('PDT')
    state.IdleMode:options('Regen', 'Refresh')

	
	--Teleport Rings!
    state.WarpMode = M{['description']='Transportation Ring is now', 'Off', 'Warp', 'Jima: Holla', 'Jima: Dem'}
	
	
	state.CombatWeapon = M{['description']='Weapon', 'Lionheart', 'Epeolatry'}
	
	
    -- Additional local binds
    send_command('bind ^z gs c cycle WarpMode')
    send_command('bind ^a gs c cycle CombatWeapon')
	
	
	
	select_default_macro_book()
end

function user_unload()
    
	send_command('unbind ^z')
	send_command('unbind ^a')
end


function init_gear_sets()

---------------------------------------------------------------------------------------------------
    -- Warp rings and TH tagging
---------------------------------------------------------------------------------------------------
    
	--TH on first hit
	sets.TreasureHunter = {
		ammo="Staunch Tathlum",
		head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
		body={ name="Herculean Vest", augments={'INT+4','Rng.Acc.+4 Rng.Atk.+4','"Treasure Hunter"+2','Mag. Acc.+19 "Mag.Atk.Bns."+19',}},
		hands={ name="Herculean Gloves", augments={'Accuracy+21 Attack+21','Mag. Acc.+2','Damage taken-3%','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
		legs={ name="Herculean Trousers", augments={'CHR+5','Accuracy+2 Attack+2','"Treasure Hunter"+1','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
		feet={ name="Herculean Boots", augments={'Accuracy+28','Damage taken-3%','DEX+14','Attack+11',}},
		neck="Loricate Torque +1",
		waist="Chaac Belt",
		left_ear="Genmei Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Moonbeam Ring",
		right_ring="Defending Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Damage taken-5%',}},
	    }
	
	sets.Warp = {ring2="Warp Ring"}
  
    sets.Holla = {ring2="Dim. Ring (Holla)"}
	
	sets.Dem = {ring2="Dim. Ring (Dem)"}
	
	sets.Lionheart = {main="Lionheart"}
	
	sets.Epeolatry = {main="Epeolatry"}
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- Enmity set
	----------------------------------------------------------------------------------------------------------------------------------
	
	-- 89 (+5 merits)(+18 epo) enmity/ 19 PDT/ 2556 HP
    sets.enmity = {
		ammo="Sapience Orb",
		head="Halitus Helm",
		body="Emet Harness +1",
		neck="Moonbeam Necklace",
		hands="Kurys Gloves",
		legs="Eri. Leg Guards +1",
		ear1="Cryptic Earring",
	    ear2="Trux Earring",
		ring1="Supershear Ring",
		ring2="Provocare Ring", 
		feet="Ahosi Leggings",
		waist="Goading Belt",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Damage taken-5%',}},} 

	----------------------------------------------------------------------------------------------------------------------------------
	-- JA Madness precasts
	----------------------------------------------------------------------------------------------------------------------------------
	
	sets.precast.JA = {
		ammo="Staunch Tathlum",
		head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
		body="Runeist's Coat +3",
		hands={ name="Herculean Gloves", augments={'Accuracy+21 Attack+21','Mag. Acc.+2','Damage taken-3%','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
		legs="Rune. Trousers +3",
		feet={ name="Herculean Boots", augments={'Accuracy+28','Damage taken-3%','DEX+14','Attack+11',}},
		neck="Loricate Torque +1",
		waist="Engraved Belt",
		ear1="Eabani Earring",
		ear2="Sanare Earring",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Damage taken-5%',}},}
	
    sets.precast.JA['Vallation'] = set_combine(sets.enmity, {
		body="Runeist's Coat +3",
		legs="Futhark Trousers +3",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Damage taken-5%',}},})
	
    sets.precast.JA['Valiance'] = sets.precast.JA['Vallation']
	
    sets.precast.JA['Pflug'] =  set_combine(sets.enmity, {feet="Runeist's Boots +3"})
	
    sets.precast.JA['Battuta'] = {head="Futhark Bandeau +3"}
	
    sets.precast.JA['Liement'] = set_combine(sets.enmity, {body="Futhark Coat +3"})
	
    sets.precast.JA['Lunge'] = {
		head={ name="Herculean Helm", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','INT+8','"Mag.Atk.Bns."+11',}},
		neck="Sanctity Necklace",
		ear1="Friomisi Earring",
		ear2="Crematio Earring",
        body="Samnuha Coat",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		ring1="Shiva Ring +1",
		ring2="Acumen Ring",
		waist="Eschan Stone",
		legs={ name="Herculean Trousers", augments={'Mag. Acc.+17 "Mag.Atk.Bns."+17','Weapon skill damage +2%','STR+5','"Mag.Atk.Bns."+14',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Weapon skill damage +1%','MND+5','Mag. Acc.+12','"Mag.Atk.Bns."+11',}}}
			
    sets.precast.JA['Swipe'] = sets.precast.JA['Lunge']
	
    sets.precast.JA['Gambit'] = set_combine(sets.enmity, {hands="Runeist's Mitons +3"})
	
    sets.precast.JA['Rayke'] = set_combine(sets.enmity, {feet="Futhark Boots +3",})
	
    sets.precast.JA['Elemental Sforzo'] = set_combine(sets.enmity, {body="Futhark Coat +3"})
	
	sets.precast.JA['Odyllic Subterfuge'] = sets.enmity
	
    sets.precast.JA['Swordplay'] = set_combine(sets.enmity, {hands="Futhark Mitons +3"})
	
    sets.precast.JA['Embolden'] = set_combine(sets.enmity, {
		back={ name="Evasionist's Cape", augments={'Enmity+6','"Embolden"+15',}}})
	
    sets.precast.JA['Vivacious Pulse'] = {
		head="Erilaz Galea +1",
		neck="Incanter's Torque",
		legs="Rune. Trousers +3",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		waist="Bishop's Sash",
		back="Altruistic Cape"}
	
    sets.precast.JA['One For All'] = {
		head="Halitus Helm",
		body="Runeist's Coat +3",
		hands="Turms Mittens +1",
		legs="Eri. Leg Guards +1",
		feet="Runeist's Boots +3",
		neck="Loricate Torque +1",
		waist="Eschan Stone",
		ear1="Etiolation Earring",
		ear2="Odnowa Earring +1",
		ring1="Moonbeam Ring",
		ring2="Regal Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Damage taken-5%',}},}
		
	
	
    sets.precast.JA['Provoke'] = sets.enmity
	
	sets.precast.JA['Souleater'] = sets.enmity
	
	sets.precast.JA['Last Resort'] = sets.enmity
	
	sets.precast.JA['Weapon Bash'] = sets.enmity
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- FC sets
	----------------------------------------------------------------------------------------------------------------------------------
	
	-- 63 FC/ 22 DT/ 28 PDT/ 25 MDT/ 2536 HP
    sets.precast.FC = {
        ammo="Staunch Tathlum",
		head="Rune. Bandeau +3",
		neck="Voltsurge Torque",
		ear1="Etiolation Earring",
		ear2="Loquacious Earring",
		body={ name="Taeon Tabard", augments={'"Fast Cast"+5','Phalanx +3',}},
		hands="Leyline Gloves",
		legs="Ayanmo Cosciales +2",
		ring1="Kishar Ring",
		ring2="Defending Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Damage taken-5%',}},
		waist="Flume Belt +1", 
		feet={ name="Herculean Boots", augments={'"Mag.Atk.Bns."+15','"Fast Cast"+5','Mag. Acc.+14',}}}
			
    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {waist="Siegel Sash", legs="Futhark Trousers +3"})
    
	sets.precast.FC['Utsusemi: Ichi'] = set_combine(sets.precast.FC, {neck='Magoraga beads'})
	
	sets.precast.FC['Utsusemi: Ni'] = set_combine(sets.precast.FC['Utsusemi: Ichi'], {})


	----------------------------------------------------------------------------------------------------------------------------------
	-- WeaponSkill
	----------------------------------------------------------------------------------------------------------------------------------
	
	-- Sub 2400 HP for all WSs
    sets.precast.WS['Resolution'] = {
		ammo="Knobkierrie",
		head={ name="Herculean Helm", augments={'Accuracy+16 Attack+16','"Triple Atk."+4','DEX+10','Accuracy+8','Attack+5',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands="Futhark Mitons +3",
		legs="Meghanada Chausses +2",
		feet={ name="Adhe. Gamashes +1", augments={'STR+12','DEX+12','Attack+20',}},
		neck="Fotia Gorget",
		waist="Fotia Belt",
		ear1="Sherida Earring",
		ear2={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +25',}},
		ring1="Regal Ring",
		ring2="Niqmaddu Ring",
		back={ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
			
		
    sets.precast.WS['Dimidiation'] = {
		ammo="Knobkierrie",
		head={ name="Herculean Helm", augments={'Accuracy+23 Attack+23','Weapon skill damage +4%','DEX+15',}},
        body="Meghanada Cuirie +2",
        hands="Meghanada Gloves +2",
        legs="Lustratio Subligar +1",
        feet="Lustratio Leggings +1",
		neck="Caro Necklace",
		waist="Grunfeld Rope",
        ear1="Moonshade Earring",
		ear2="Sherida Earring",
		ring1="Regal Ring",
		ring2="Ilabrat Ring",
		back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
			
    
    
	sets.precast.WS['Herculean Slash'] = set_combine(sets.precast['Lunge'], {})
	



	----------------------------------------------------------------------------------------------------------------------------------
	-- Midcasts
	----------------------------------------------------------------------------------------------------------------------------------
	
	-- 2532 HP
    sets.midcast.FastRecast = {
		ammo="Staunch Tathlum",
	    head={ name="Taeon Chapeau", augments={'Spell interruption rate down -10%','Phalanx +3',}},
		neck="Moonbeam Necklace",
        body={ name="Taeon Tabard", augments={'Spell interruption rate down -10%','"Regen" potency+3',}},
		ear1="Magnetic Earring",
		ear2="Odnowa Earring +1",
		hands="Rawhide Gloves",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		legs="Carmine Cuisses +1",
		waist="Rumination Sash",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Damage taken-5%',}},
		feet={ name="Taeon Boots", augments={'Spell interruption rate down -8%','"Regen" potency+3',}},}
	
	sets.midcast.Utsusemi = sets.midcast.FastRecast
		
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- Experimental Voodoo dark magic sets
	----------------------------------------------------------------------------------------------------------------------------------
	
	sets.midcast['Dark Magic'] = {}
	
	sets.midcast.Absorb = {
		
		head="Futhark Bandeau +3",
		neck="Sanctity Necklace",
		body="Futhark Coat +3",
		ear1="Enchanter's Earring +1",
		ear2="Dignitary's Earring",
		hands="Futhark Mitons +3",
		ring1="Stikini Ring",
		ring2="Defending Ring",
		legs="Futhark Trousers +3",
		waist="Eschan Stone",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Damage taken-5%',}},
		feet={ name="Herculean Boots", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Weapon skill damage +1%','MND+5','Mag. Acc.+12','"Mag.Atk.Bns."+11',}},
		}
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- Blue magics for h8 and stuff and stuff
	----------------------------------------------------------------------------------------------------------------------------------
	
	sets.midcast['Blue Magic'] = {}
	
	sets.midcast['Jettatura'] = sets.enmity
	
	sets.midcast['Blank Gaze'] = sets.enmity
	
	sets.midcast['Wild Carrot'] = sets.enmity
	
	sets.midcast['Cocoon'] = {
		ammo="Staunch Tathlum",
		head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
		body="Futhark Coat +3",
		hands="Turms Mittens +1",
		legs="Meg. Chausses +2",
		feet="Turms Leggings +1",
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		ear1="Genmei Earring",
		ear2="Eabani Earring",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Damage taken-5%',}},}
		
	sets.midcast['Refueling'] = sets.midcast['Cocoon']
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- Midcast for h8 spells and buffing. Enhancing is in alphabetaical order
	----------------------------------------------------------------------------------------------------------------------------------
	
	sets.midcast['Flash'] = sets.enmity
	
	sets.midcast['Foil'] = sets.enmity
	
	sets.midcast['Stun'] = sets.enmity
	
	sets.midcast['Poisonga'] = sets.enmity
	
    sets.midcast['Enhancing Magic'] = {
		ammo="Staunch Tathlum",
		head="Carmine Mask +1", 
		neck="Incanter's Torque", 
		ear1="Andoaa Earring",
		ear2="Augmenting Earring",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		hands="Runeist's Mitons +3", 
		waist="Olympus Sash", 
		legs="Futhark Trousers +3",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Damage taken-5%',}},}
		
	
	sets.midcast['Aquaveil'] = set_combine(sets.midcast['Enhancing Magic'], {
		head="Carmine Mask +1", 
		legs={ name="Carmine Cuisses +1", augments={'Accuracy+12','DEX+12','MND+20',}},
		back="Merciful Cape"
		})
	
	sets.midcast['Crusade'] = set_combine(sets.midcast['Enhancing Magic'], {
		head="Erilaz Galea +1",
		})
		
	-- +18 Phalanx/ 460 skill/ 2459 HP
	sets.midcast['Phalanx'] = {
		ammo="Staunch Tathlum",
	    head="Futhark Bandeau +3",
		neck="Loricate Torque +1",
        body={ name="Taeon Tabard", augments={'Phalanx +3',}},
		ear1="Andoaa Earring",
		ear2="Odnowa Earring +1",
		ring1="Moonbeam Ring",
		ring2="Defending Ring",
		hands={ name="Taeon Gloves", augments={'"Snapshot"+4','Phalanx +3',}},
		legs={ name="Taeon Tights", augments={'Accuracy+20 Attack+20','"Snapshot"+3','Phalanx +3',}},
		feet={ name="Taeon Boots", augments={'"Snapshot"+5','Phalanx +3',}},
		waist="Olympus Sash",
		back="Merciful Cape"
		}
    
	sets.midcast['Refresh'] = set_combine(sets.midcast['Enhancing Magic'], {
		head="Erilaz Galea +1",
		waist="Gishdubar Sash"})
	
	sets.midcast['Regen'] = set_combine(sets.midcast['Enhancing Magic'], {
		head="Rune. Bandeau +3", 
		body={ name="Taeon Tabard", augments={'"Regen" potency+3',}},
		hands={ name="Taeon Gloves", augments={'"Regen" potency+3',}},
		legs="Futhark Trousers +3",
		feet={ name="Taeon Boots", augments={'"Regen" potency+3',}},
		})
		
	sets.midcast['Stoneskin'] = set_combine(sets.midcast['Enhancing Magic'], {
		neck="Stone Gorget",
		ear2="Earthcry Earring",
		waist="Siegel Sash",
		ring2="Defending Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Damage taken-5%',}},})
    
	sets.midcast['Temper'] = set_combine(sets.midcast['Enhancing Magic'], {
		head="Carmine Mask +1", 
		back="Merciful Cape"
		})
		
	sets.midcast.Cure = {feet="Futhark Boots +3",}
	
	--sets.midcast['Yoran-Oran (UC)'] = set_combine(sets.midcast.FastRecast, {body="Yoran Unity Shirt"})

	sets.midcast['Sylvie (UC)'] = set_combine(sets.midcast.FastRecast, {body="Sylvie Unity Shirt"})
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- Idle/Defense/Resist sets
	----------------------------------------------------------------------------------------------------------------------------------

    sets.idle = {
		
		ammo="Homiliary",
		head="Futhark Bandeau +3",
		body="Runeist's Coat +3",
		hands={ name="Herculean Gloves", augments={'Accuracy+21 Attack+21','Mag. Acc.+2','Damage taken-3%','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
		legs={ name="Herculean Trousers", augments={'VIT+5','"Refresh"+2','Accuracy+5 Attack+5',}},
		feet={ name="Herculean Boots", augments={'"Store TP"+1','Accuracy+18','"Refresh"+2',}},
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		ear1="Genmei Earring",
		ear2="Eabani Earring",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Damage taken-5%',}},}
		
	sets.idle.Town = {
		
		ammo="Homiliary",
		head="Futhark Bandeau +3",
		body="Runeist's Coat +3",
		hands={ name="Herculean Gloves", augments={'Accuracy+21 Attack+21','Mag. Acc.+2','Damage taken-3%','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
		legs="Carmine Cuisses +1",
		feet={ name="Herculean Boots", augments={'"Store TP"+1','Accuracy+18','"Refresh"+2',}},
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		ear1="Genmei Earring",
		ear2="Odnowa Earring +1",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Damage taken-5%',}},}
    
	sets.idle.Weak = sets.idle
	
	sets.idle.Refresh = set_combine(sets.idle, {body="Runeist's Coat +3", waist="Fucho-no-obi"})
           
	sets.defense.PDT = {
		
		ammo="Staunch Tathlum",
		head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
		body="Futhark Coat +3",
		hands={ name="Herculean Gloves", augments={'Accuracy+21 Attack+21','Mag. Acc.+2','Damage taken-3%','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
		legs="Eri. Leg Guards +1",
		feet={ name="Herculean Boots", augments={'Accuracy+28','Damage taken-3%','DEX+14','Attack+11',}},
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		ear1="Genmei Earring",
		ear2="Odnowa Earring +1",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Damage taken-5%',}},}

	sets.defense.MDT = {
		
		ammo="Staunch Tathlum",
		head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Herculean Gloves", augments={'Accuracy+21 Attack+21','Mag. Acc.+2','Damage taken-3%','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
		legs="Meg. Chausses +2",
		feet={ name="Herculean Boots", augments={'Accuracy+28','Damage taken-3%','DEX+14','Attack+11',}},
		neck="Warder's Charm +1",
		waist="Engraved Belt",
		ear1="Etiolation Earring",
		ear2="Odnowa Earring +1",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','HP+20','"Fast Cast"+10','Damage taken-5%',}},}

	-- 2579~ HP/ 40 DT/ 51 PDT/ 40 MDT/ 548+20+15 MEVA/ 118 INT/ 133 MND
	sets.defense.DT = {
		ammo="Staunch Tathlum",
		head="Futhark Bandeau +3",
		body="Futhark Coat +3",
		hands="Turms Mittens +1",
		legs="Rune. Trousers +3",
		feet="Turms Leggings +1",
		neck="Loricate Torque +1",
		waist="Engraved Belt",
		ear1="Eabani Earring",
		ear2="Sanare Earring",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Damage taken-5%',}},}
		
		
	-- 2639HP/ 24 DT/ 35 PDT/ 28 MDT/ 522+40+15 MEVA/ 118 INT/ 133 MND
	sets.defense.Resist = set_combine(sets.defense.DT, {
		ammo="Yamarang",
		neck="Warder's Charm +1",
		ring1="Purity Ring",
		back={ name="Ogma's cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Damage taken-5%',}},
		ear1="Hearty Earring",
		ear2="Eabani Earring",})

----------------------------------------------------------------------------------------------------------------------------------
	-- Melee sets
----------------------------------------------------------------------------------------------------------------------------------
	

	
	----------------------------------------------------------------------------------------------------------------------------------
	-- Lionheart sets. Tanking, hybrid and DD sets.
	----------------------------------------------------------------------------------------------------------------------------------
	
	
    sets.engaged.Lionheart = {
		sub="Irenic Strap +1",
		ammo="Staunch Tathlum",
		head="Futhark Bandeau +3",
		body="Futhark Coat +3",
		hands="Turms Mittens +1",
		legs="Eri. Leg Guards +1",
		feet="Turms Leggings +1",
		neck="Loricate Torque +1",
		waist="Engraved Belt",
		ear1="Genmei Earring",
		ear2="Odnowa Earring +1",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+1','"Store TP"+10','Parrying rate+5%',}},}
			
	
	-- 51 PDT/ 37 MDT
	sets.engaged.Lionheart.Hybrid = {
		sub="Utu Grip",
		ammo="Yamarang",
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		body="Futhark Coat +3",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs="Meghanada chausses +2",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		neck="Loricate Torque +1",
		waist="Windbuffet Belt +1",
		ear1="Telos Earring",
		ear2="Sherida Earring",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		}

	sets.engaged.Lionheart.DD = {
		sub="Utu Grip",
		ammo="Yamarang",
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs={ name="Adhemar Kecks +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		ear1="Telos Earring",
		ear2="Sherida Earring",
		ring1="Niqmaddu Ring",
		ring2="Epona's Ring",
		back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}	
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- Epo sets. Tanking, hybrid and DD sets.
	----------------------------------------------------------------------------------------------------------------------------------
	
	sets.engaged.Epeolatry = {
		sub="Irenic Strap +1",
		ammo="Staunch Tathlum",
		head="Futhark Bandeau +3",
		body="Futhark Coat +3",
		hands="Turms Mittens +1",
		legs="Eri. Leg Guards +1",
		feet="Turms Leggings +1",
		neck="Loricate Torque +1",
		waist="Engraved Belt",
		ear1="Genmei Earring",
		ear2="Odnowa Earring +1",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+1','"Store TP"+10','Parrying rate+5%',}},}
			
	
	-- 51 PDT/ 37 MDT
	sets.engaged.Epeolatry.Hybrid = {
		sub="Utu Grip",
		ammo="Yamarang",
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		body="Futhark Coat +3",
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs="Meghanada chausses +2",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		neck="Loricate Torque +1",
		waist="Windbuffet Belt +1",
		ear1="Telos Earring",
		ear2="Sherida Earring",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
		}
		
	sets.engaged.Epeolatry.DD = {
		sub="Utu Grip",
		ammo="Yamarang",
		head={ name="Dampening Tam", augments={'DEX+10','Accuracy+15','Mag. Acc.+15','Quadruple Attack +3',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs={ name="Adhemar Kecks +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		neck="Anu Torque",
		waist="Windbuffet Belt +1",
		ear1="Telos Earring",
		ear2="Sherida Earring",
		ring1="Niqmaddu Ring",
		ring2="Ilabrat Ring",
		back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},}
		
	-- 51 PDT	
    sets.engaged.PDT = sets.engaged.Lionheart
			
    
			
  
	----------------------------------------------------------------------------------------------------------------------------------
	-- Additional sets
	----------------------------------------------------------------------------------------------------------------------------------
	
	sets.buff['Battuta'] = {
		hands="Turms Mittens +1",
		legs="Eri. Leg Guards +1",
		feet="Turms Leggings +1",
		back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+1','"Store TP"+10','Parrying rate+5%',}},}
		
	sets.buff['Battuta'].Melee = {
		feet="Turms Leggings +1",
		back={ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+1','"Store TP"+10','Parrying rate+5%',}},}
		
	sets.buff['Battuta'].Facing = {feet="Futhark Boots +3",}
	
		
	sets.buff.doom = {waist="Gishdubar Sash", ring1="Blenmot's Ring", ring2="Purity Ring"}
	sets.buff.sleep = {head="Frenzy Sallet"}
	sets.buff['Embolden'] = {back={ name="Evasionist's Cape", augments={'Enmity+6','"Embolden"+15',}}}
end


----------------------------------------------------------------------------------------------------------------------------------
	-- Function land
----------------------------------------------------------------------------------------------------------------------------------


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

function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Blue Magic' then
		if spell.english == 'Geist Wall' or spell.english == 'Sheep Song' then
				if buffactive['Vallation'] or buffactive['Valiance'] then
						equip(sets.enmity)
				else
						equip(sets.midcast.FastRecast)
				end
		else
				equip(sets.enmity)
			
		end
	end
	

		if buffactive['Embolden'] then 
			if spell.skill == 'Enhancing Magic' then
				equip(sets.buff['Embolden'])
		end
	end
end

function job_aftercast(spell, action, spellMap, eventArgs)
   custom_aftermath_timers_aftercast(spell, action, spellMap, eventArgs)
   
   if not spell.interrupted then
        if spell.name == 'Utsusemi: Ichi' then
            overwrite = false
        elseif spell.name == 'Utsusemi: Ni' then
            overwrite = true
        end
    end
	if spell.type == 'Rune' and not spell.interrupted then
        display_rune_info(spell)
    end
end


function job_buff_change(buff,gain, eventArgs)
   
	
    ---------------------------------------------------------------------------------------------------
    -- Equipment for debuffs.
	---------------------------------------------------------------------------------------------------	
	
	
	if buff:lower()=='sleep' then
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
			add_to_chat(123, 'Doomed!!! Use Holy Waters!!!')
        elseif not gain then 
		    enable('ring1' , 'ring2')
            handle_equipping_gear(player.status)
		end
		
	elseif buff == 'Battuta' then
        handle_equipping_gear(player.status)
		
	elseif buff == 'Souleater' then
        send_command('cancel Souleater')
		
	elseif buff == 'Vallation' or 'Valiance' then
        handle_equipping_gear(player.status)
		
	elseif buff == 'Embolden' then
		handle_equipping_gear(player.status)
    end
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- Aftermath timer
	----------------------------------------------------------------------------------------------------------------------------------
	
	if player.equipment.main == 'Lionheart' and buff:startswith('Aftermath') then
        local times = {["Aftermath: Lv.1"]=180, ["Aftermath: Lv.2"]=180, ["Aftermath: Lv.3"]=180}
        
        if gain then
            send_command('timers c "'..buff..'" '..tostring(times[buff])..' down abilities/00027.png')
        else
            send_command('timers d "'..buff..'"')

        end
	elseif player.equipment.main == 'Epeolatry' and buff:startswith('Aftermath') then
        local times = {["Aftermath: Lv.1"]=180, ["Aftermath: Lv.2"]=180, ["Aftermath: Lv.3"]=180}
        
        if gain then
            send_command('timers c "'..buff..'" '..tostring(times[buff])..' down abilities/00027.png')
        else
            send_command('timers d "'..buff..'"')

        end
	end
end

---------------------------------------------------------------------------------------------------
-- CombatWeapon to take into account AM. Always update here.
---------------------------------------------------------------------------------------------------	
function get_combat_weapon()
    if player.equipment.type == 'Great Sword' then
		if state.CombatWeapon.value == 'Lionheart' then
			state.CombatWeapon:set('Lionheart')
        elseif state.CombatWeapon.value == 'Epeolatry' then
			state.CombatWeapon:set('Epeolatry') 
        end
    else
			state.CombatForm:reset()
		
    end
end
 
---------------------------------------------------------------------------------------------------
-- CombatForm to take into account TP type
---------------------------------------------------------------------------------------------------	
--[[function get_combat_form()
    if player.equipment.type == 'Great Sword' then
		if state.CombatWeapon.value == 'Lionheart' then
			state.CombatForm:set('Lionheart')
        elseif state.CombatWeapon.value == 'Epeolatry' then
			state.CombatForm:set('Epeolatry') 
        end
    else
			state.CombatForm:reset()
		
    end
end]]
 
function job_status_change(new_status, old_status)
    if new_status == 'Engaged' then
		check_facing()
		get_combat_weapon()
		--get_combat_form()
    end          
end

function job_update(cmdParams, eventArgs)
	gearmode()
	check_facing()
	get_combat_weapon()
	--get_combat_form()
end

----------------------------------------------------------------------------------------------------------------------------------
	-- Set combine for melee
----------------------------------------------------------------------------------------------------------------------------------
	
function customize_melee_set(meleeSet)
	
	-- When Lionheart is in tanking mode, I have heavy protection.
	if state.CombatWeapon.value == 'Lionheart' then
		if state.OffenseMode.value == 'Normal' then
			if buffactive['Battuta'] then
				meleeSet = set_combine(meleeSet, sets.buff['Battuta'])
			end
		-- When Lionheart is in hybrid mode, I have light protection.
		elseif state.OffenseMode.value == 'Hybrid' then
			if buffactive['Battuta'] then
				meleeSet = set_combine(meleeSet, sets.buff['Battuta'].Melee)
			end
		-- When Lionheart is in DD mode, I have light protection.
		elseif state.OffenseMode.value == 'DD' and check_facing() == true then
			if buffactive['Battuta'] then
				meleeSet = set_combine(meleeSet, sets.buff['Battuta'].Facing)
			end
		end
	-- When Epo is in tanking mode, I have heavy protection.
	elseif state.CombatWeapon.value == 'Epeolatry' then
		if state.OffenseMode.value == 'Normal' then
			if buffactive['Battuta'] then
				meleeSet = set_combine(meleeSet, sets.buff['Battuta'])
			end
		-- When Epo is in hybrid, I have light protection.
		elseif state.OffenseMode.value == 'Hybrid' then
			if buffactive['Battuta'] then
				meleeSet = set_combine(meleeSet, sets.buff['Battuta'].Melee)
			end
		-- When Epo is in DD mode, I have light protection.
		elseif state.OffenseMode.value == 'DD' and check_facing() == true then
			if buffactive['Battuta'] then
				meleeSet = set_combine(meleeSet, sets.buff['Battuta'].Facing)
			end
		end
	end
	
	if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end

    return meleeSet
end



----------------------------------------------------------------------------------------------------------------------------------
	-- Custom Warp rings
----------------------------------------------------------------------------------------------------------------------------------
	
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

-- Special thanks to the ppl on the FFXIAH forums for coming up with this working bit of code!
function define_rune_info()
    rune_info = {
        ["Ignis"]   = {damage="Fire", resistance="Ice"},
        ["Gelus"]   = {damage="Ice", resistance="Wind"},
        ["Flabra"]  = {damage="Wind", resistance="Earth"},
        ["Tellus"]  = {damage="Earth", resistance="Lightning"},
        ["Sulpor"]  = {damage="Lightning", resistance="Water"},
        ["Unda"]    = {damage="Water", resistance="Fire"},
        ["Lux"]     = {damage="Light", resistance="Darkness"},
        ["Tenebrae"]= {damage="Darkness", resistance="Light"},
    }
end

function display_rune_info(spell)
    runeinfo = rune_info[spell.english]
    if runeinfo then
        add_to_chat(158, '***'..spell.english..' : '..runeinfo.damage..' damage and '..runeinfo.resistance..' resistance.***')
    end
end
  
----------------------------------------------------------------------------------------------------------------------------------
	-- Weapon changing
----------------------------------------------------------------------------------------------------------------------------------
function gearmode()
  if state.CombatWeapon.value == 'Lionheart' then
		equip(sets.Lionheart)
		handle_equipping_gear(player.status)
	elseif state.CombatWeapon.value == 'Epeolatry' then
		equip(sets.Epeolatry)
		handle_equipping_gear(player.status)
  end
end

---------------------------------------------------------------------------------------------------
-- Voodoo magic that makes my relic boots equip under radial conditions. Credit: Whoever made the Gaze addon.
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
		set_macro_page(1, 20)
	elseif player.sub_job == 'NIN' then
		set_macro_page(1, 20)
	elseif player.sub_job == 'SAM' then
		set_macro_page(1, 20)
	else
		set_macro_page(1, 20)
	end
end
