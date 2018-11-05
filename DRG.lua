-------------------------------------------------------------------------------------------------------------------
-- Rikimarueye's DRG lua. Comment section below
-------------------------------------------------------------------------------------------------------------------


-- Maintained and fixed by Rikimarueye@pheonix
-- Original base lua created by Moten.

-- Version 1.0.0.3

--[[
	To do list:
	
	Populate gearsets
	
]]

--[[
	Change log:
	
	1.0.0.3: Small tweaks to personalize this lua for DRG
	
	1.0.0.2: Updated sets as they were obtained
	
	1.0.0.0: Populate gear sets. Based lua is my RUN
	
]]



---------------------------------------------------------------------------------------------------
    -- Start of the setup, sets, and functions.
---------------------------------------------------------------------------------------------------

require('vectors')

function get_sets()
    mote_include_version = 2

	-- Load and initialize the include file.
	include('Mote-Include.lua')
	
	petcast = false
	
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
	
	
	get_combat_weapon()
	--get_combat_form()
	
	
	--Buff ID 359 for doom
	state.Buff.doom = buffactive.doom or false
    state.Buff.sleep = buffactive.sleep or false
	state.Buff.Terror = buffactive.Terror or false
    state.Buff.Stun = buffactive.Stun or false
    state.Buff.Petrification = buffactive.Petrification or false
	
	state.Buff["Samurai's Roll"] = buffactive["Samurai's Roll"] or false
	
	state.Buff['Ancient Circle'] = buffactive['Ancient Circle'] or false
	
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
	
	
	state.CombatWeapon = M{['description']='Weapon', 'Trishula', 'Reikikon'}
	
	
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
		neck="Loricate Torque +1",
		legs={ name="Valor. Hose", augments={'DEX+6','Enmity-3','"Treasure Hunter"+1','Accuracy+6 Attack+6',}},
		waist="Chaac Belt",
		left_ring="Moonbeam Ring",
		right_ring="Defending Ring",
	    }
	
	sets.Warp = {ring2="Warp Ring"}
  
    sets.Holla = {ring2="Dim. Ring (Holla)"}
	
	sets.Dem = {ring2="Dim. Ring (Dem)"}
	
	
	sets.Trishula = {main="Trishula"}
	
	sets.Reikikon = {main="Reikikon"}
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- JA Madness precasts
	----------------------------------------------------------------------------------------------------------------------------------
	
	sets.precast.JA = {
		
		}
	
	sets.precast.JA['Ancient Circle'] = {legs="Vishap Brais +2"}
	
	sets.precast.JA['Angon'] = {
	
		ammo="Angon",
		hands={ name="Ptero. Fin. G. +3", augments={'Enhances "Angon" effect',}},}
	
	sets.precast.JA['Call Wyvern'] = {
	
		body="Pteroslaver Mail +3",}
	
    sets.precast.JA.Jump = {
		ammo="Ginsen",
		head="Flam. Zucchetto +2",
		body="Pteroslaver Mail +3",
		hands="Vis. Fng. Gaunt. +3",
		legs={ name="Ptero. Brais +3", augments={'Enhances "Strafe" effect',}},
		feet="Ostro Greaves",
		neck="Anu Torque",
		waist="Ioskeha Belt +1",
		ear1="Telos Earring",
		ear2="Sherida Earring",
		ring1="Niqmaddu Ring",
		ring2="Petrov Ring",
		back={ name="Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},}
	
	sets.precast.JA['High Jump'] = set_combine(sets.precast.JA.Jump, {
	
		})
	
	sets.precast.JA['Spirit Jump'] = set_combine(sets.precast.JA.Jump, {
	
		})
	
	sets.precast.JA['Soul Jump'] = set_combine(sets.precast.JA.Jump, {
		
		body="Vishap Mail +2",
		hands={ name="Acro Gauntlets", augments={'Accuracy+18 Attack+18','"Store TP"+6','STR+7 DEX+7',}},})
	
    sets.precast.JA['Spirit Link'] =  {
		
		head="Vishap Armet +2",
		hands="Pel. Vambraces +1",
		feet="Pteroslaver Greaves +3",
		ear2="Pratik Earring",}
	
    sets.precast.JA['Spirit Surge'] = {
		
		neck="Lancer's Torque",
		hands="Despair Fin. Gaunt.",
		body="Pteroslaver Mail +3",
		legs="Vishap Brais +2",
		feet="Pteroslaver Greaves +3",
		ear1="Lancer's Earring",
		ear2="Anastasi Earring",
		back={ name="Updraft Mantle", augments={'STR+4','Pet: Breath+8',}},}
	
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- Wyvern breath Madness precasts
	----------------------------------------------------------------------------------------------------------------------------------
	
	sets.precast.Breath = {
	
		head="Pteroslaver Armet +3",
		neck="Lancer's Torque",
		body={ name="Acro Surcoat", augments={'Pet: Mag. Acc.+19','Pet: Breath+8',}},
		hands={ name="Acro Gauntlets", augments={'Pet: Breath+7',}},
		legs={ name="Acro Breeches", augments={'Pet: Mag. Acc.+22','Pet: Breath+8',}},
		feet="Pteroslaver Greaves +3",
		waist="Glassblower's Belt",
		back={ name="Updraft Mantle", augments={'STR+4','Pet: Breath+8',}},}
	
    sets.precast.JA['Steady Wing'] = {
		
		neck="Lancer's Torque",
		body={ name="Emicho Haubert", augments={'Pet: HP+100','Pet: INT+15','Pet: "Regen"+2',}},
		hands="Despair Fin. Gaunt.",
		legs="Vishap Brais +2",
		feet="Pteroslaver Greaves +3",
		ear1="Lancer's Earring",
		ear2="Anastasi Earring",
		back={ name="Updraft Mantle", augments={'STR+4','Pet: Breath+8',}},}
	
	
	
	sets.precast.JA['Healing Breath'] = {
	
		head="Pteroslaver Armet +3",
		neck="Lancer's Torque",
		body={ name="Acro Surcoat", augments={'Pet: Mag. Acc.+19','Pet: Breath+8',}},
		hands={ name="Acro Gauntlets", augments={'Pet: Breath+7',}},
		legs="Vishap Brais +2",
		feet="Pteroslaver Greaves +3",
		waist="Glassblower's Belt",
		ear1="Lancer's Earring",
		ear2="Anastasi Earring",
		back={ name="Updraft Mantle", augments={'STR+4','Pet: Breath+8',}},}
	
	sets.precast.JA['Elemental Breath'] = {
		
		head="Pteroslaver Armet +3",
		neck="Lancer's Torque",
		body={ name="Acro Surcoat", augments={'Pet: Mag. Acc.+19','Pet: Breath+8',}},
		hands={ name="Acro Gauntlets", augments={'Pet: Breath+7',}},
		legs={ name="Acro Breeches", augments={'Pet: Mag. Acc.+22','Pet: Breath+8',}},
		feet={ name="Acro Leggings", augments={'Pet: Mag. Acc.+23','Pet: Breath+6',}},
		waist="Glassblower's Belt",
		ear1="Lancer's Earring",
		ear2="Anastasi Earring",
		back={ name="Updraft Mantle", augments={'STR+4','Pet: Breath+8',}},}
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- RA set for pulling
	----------------------------------------------------------------------------------------------------------------------------------
	
	sets.precast.RA = {ranged="Trollbane"}
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- FC sets
	----------------------------------------------------------------------------------------------------------------------------------
	
	-- 70 FC/ 22 DT/ 20 PDT/ 27 MDT/ 2536 HP
    sets.precast.FC = {
        ammo="Sapience Orb",
		neck="Orunmila's Torque",
		ear1="Enchanter Earring +1",
		ear2="Loquacious Earring",
		body={ name="Taeon Tabard", augments={'"Fast Cast"+5','Phalanx +3',}},
		hands="Leyline Gloves",
		legs="Ayanmo Cosciales +2",
		ring1="Kishar Ring",
		ring2="Defending Ring",
		waist="Flume Belt +1", 
		feet="Carmine Greaves +1"}
    
	sets.precast.FC['Utsusemi: Ichi'] = set_combine(sets.precast.FC, {neck='Magoraga beads'})
	
	sets.precast.FC['Utsusemi: Ni'] = set_combine(sets.precast.FC['Utsusemi: Ichi'], {})

	
	
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- WeaponSkill
	----------------------------------------------------------------------------------------------------------------------------------
	
	-- Sub 2400 HP for all WSs
    sets.precast.WS = {
		ammo="Knobkierrie",
		head="Pteroslaver Armet +3",
		body="Sulevia's Plate. +2",
		hands="Sulev. Gauntlets +2",
		legs="Vishap Brais +2",
		feet="Sulev. Leggings +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
		left_ring="Niqmaddu Ring",
		right_ring="Regal Ring",
		back={ name="Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},}
	
	sets.precast.WS['Leg Sweep'] = {
		
		ammo="Pemphredo Tathlum",
		head="Flam. Zucchetto +2",
		body={ name="Ptero. Mail +3", augments={'Enhances "Spirit Surge" effect',}},
		hands="Flam. Manopolas +2",
		legs={ name="Ptero. Brais +3", augments={'Enhances "Strafe" effect',}},
		feet="Flam. Gambieras +2",
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
		right_ear="Digni. Earring",
		left_ring="Etana Ring",
		right_ring="Flamma Ring",
		back={ name="Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
	
	sets.precast.WS['Raiden Thrust'] = {
		
		ammo="Pemphredo Tathlum",
		head="Lustratio Cap +1",
		body="Sulevia's Plate. +2",
		hands="Carmine Finger Gauntlets +1",
		legs="Vishap Brais +2",
		feet="Sulev. Leggings +2",
		neck="Sanctity Necklace",
		waist="Eschan Stone",
		left_ear="Crematio Earring",
		right_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
		left_ring="Shiva Ring +1",
		right_ring="Regal Ring",
		back={ name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},}
		
	sets.precast.WS['Sonic Thrust'] = {
		
		ammo="Knobkierrie",
		head="Lustratio Cap +1",
		body="Sulevia's Plate. +2",
		hands={ name="Ptero. Fin. G. +3", augments={'Enhances "Angon" effect',}},
		legs="Vishap Brais +2",
		feet="Sulev. Leggings +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},}		
	
	sets.precast.WS['Sonic Thrust'].AC = set_combine(sets.precast.WS['Sonic Thrust'], {
	
		body={ name="Found. Breastplate", augments={'Accuracy+10','Attack+9','"Mag.Atk.Bns."+9',}},
		
		})
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- Staple of all WSs damage
	----------------------------------------------------------------------------------------------------------------------------------
	
	sets.precast.WS["Camlann's Torment"] = {
		
		ammo="Knobkierrie",
		head={ name="Valorous Mask", augments={'Accuracy+15 Attack+15','Weapon skill damage +2%','STR+7','Accuracy+4','Attack+5',}},
		body="Sulevia's Plate. +2",
		hands={ name="Ptero. Fin. G. +3", augments={'Enhances "Angon" effect',}},
		legs="Vishap Brais +2",
		feet="Sulev. Leggings +2",
		neck="Grunfeld Rope",
		waist="Caro Necklace",
		left_ear="Sherida Earring",
		right_ear="Ishvara Earring",
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}

	sets.precast.WS["Camlann's Torment"].AC = set_combine(sets.precast.WS["Camlann's Torment"], {
	
		body={ name="Found. Breastplate", augments={'Accuracy+10','Attack+9','"Mag.Atk.Bns."+9',}},
		
		})
	
	
    sets.precast.WS['Drakesbane'] = {
		ammo="Knobkierrie",
		head="Lustratio Cap +1",
		body={ name="Emicho Haubert +1", augments={'HP+65','STR+12','Attack+20',}},
		hands="Flam. Manopolas +2",
		legs="Pelt. Cuissots +1",
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Ioskeha Belt +1",
		left_ear="Sherida Earring",
		right_ear="Brutal Earring",
		left_ring="Niqmaddu Ring",
		right_ring="Regal Ring",
		back={ name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
		
    sets.precast.WS['Drakesbane'].AC = set_combine(sets.precast.WS['Drakesbane'], {
	
		body={ name="Found. Breastplate", augments={'Accuracy+10','Attack+9','"Mag.Atk.Bns."+9',}},
		
		})

    
	sets.precast.WS['Stardiver'] = {
		ammo="Knobkierrie",
		head="Pteroslaver Armet +3",
		body="Pteroslaver Mail +3",
		hands={ name="Ptero. Fin. G. +3", augments={'Enhances "Angon" effect',}},
		legs="Sulev. Cuisses +2",
		feet="Sulev. Leggings +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Sherida Earring",
		right_ear={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +250',}},
		left_ring="Epaminondas's Ring",
		right_ring="Regal Ring",
		back={ name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},}
	
	
	sets.precast.WS['Stardiver'].AC = set_combine(sets.precast.WS['Stardiver'], {
	
		body={ name="Found. Breastplate", augments={'Accuracy+10','Attack+9','"Mag.Atk.Bns."+9',}},
		
		})
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- Staff WSs
	----------------------------------------------------------------------------------------------------------------------------------
	
	sets.precast.WS['Retribution'] = sets.precast.WS
	
	sets.precast.WS['Shattersoul'] = sets.precast.WS


	----------------------------------------------------------------------------------------------------------------------------------
	-- Midcasts
	----------------------------------------------------------------------------------------------------------------------------------
	
	-- 2532 HP
    sets.midcast.FastRecast = {
		ammo="Staunch Tathlum",
	    head={ name="Taeon Chapeau", augments={'Spell interruption rate down -10%','Phalanx +3',}},
		neck="Moonlight Necklace",
        body={ name="Taeon Tabard", augments={'Spell interruption rate down -10%','"Regen" potency+3',}},
		ear1="Magnetic Earring",
		ear2="Odnowa Earring +1",
		hands="Rawhide Gloves",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		legs="Carmine Cuisses +1",
		waist="Rumination Sash",
		
		feet={ name="Taeon Boots", augments={'Spell interruption rate down -8%','"Regen" potency+3',}},}
	
	sets.midcast.Utsusemi = sets.midcast.FastRecast
		
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- Experimental Voodoo dark magic sets
	----------------------------------------------------------------------------------------------------------------------------------
	
	sets.midcast['Dark Magic'] = {}
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- Blue magics for h8 and stuff and stuff
	----------------------------------------------------------------------------------------------------------------------------------
	
	sets.midcast['Blue Magic'] = {}
	
	sets.midcast['Wild Carrot'] = set_combine(sets.enmity, {
		body="Vrikodara Jupon",
		neck="Phalaina Locket",
		waist="Gishdubar Sash",
		ear1="Roundel Earring",
		ear2="Mendi. Earring",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		
		})
		
	sets.midcast['Healing Breeze'] = sets.midcast['Wild Carrot']
	
	sets.midcast['Cocoon'] = {
		ammo="Staunch Tathlum",
		head="Flam. Zucchetto +2",
		body="Sulevia's Plate. +2",
		hands="Sulev. Gauntlets +2",
		legs="Sulev. Cuisses +2",
		feet="Flam. Gambieras +2",
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear="Eabani Earring",
		left_ring="Vocane Ring +1",
		right_ring="Defending Ring",
		back={ name="Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},}
		
	sets.midcast['Refueling'] = sets.midcast['Cocoon']
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- Other magics
	----------------------------------------------------------------------------------------------------------------------------------
	
	--sets.midcast['Yoran-Oran (UC)'] = set_combine(sets.midcast.FastRecast, {body="Yoran Unity Shirt"})
	

	sets.midcast['Sylvie (UC)'] = set_combine(sets.midcast.FastRecast, {body="Sylvie Unity Shirt"})
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- Idle/Defense/Resist sets
	----------------------------------------------------------------------------------------------------------------------------------

    sets.idle = {
		
		ammo="Staunch Tathlum",
		head="Peltast's Mezail +1",
		body="Sulevia's Plate. +2",
		hands="Sulev. Gauntlets +2",
		legs="Carmine Cuisses +1",
		feet="Pteroslaver Greaves +3",
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear="Eabani Earring",
		left_ring="Vocane Ring +1",
		right_ring="Defending Ring",
		back={ name="Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},}
		
	sets.idle.Town = {
		
		ammo="Ginsen",
		head="Flam. Zucchetto +2",
		body="Sulevia's Plate. +2",
		hands="Sulev. Gauntlets +2",
		legs="Carmine Cuisses +1",
		feet="Flam. Gambieras +2",
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear="Eabani Earring",
		left_ring="Vocane Ring +1",
		right_ring="Defending Ring",
		back={ name="Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},}
    
	sets.idle.Weak = sets.idle
	
	sets.idle.Refresh = set_combine(sets.idle, {waist="Fucho-no-obi"})
           
	sets.defense.PDT = {
		
		ammo="Staunch Tathlum",
		head="Flam. Zucchetto +2",
		body="Sulevia's Plate. +2",
		hands="Sulev. Gauntlets +2",
		legs="Sulev. Cuisses +2",
		feet="Flam. Gambieras +2",
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear="Eabani Earring",
		left_ring="Vocane Ring +1",
		right_ring="Defending Ring",
		back={ name="Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},}

	sets.defense.MDT = {
		
		ammo="Staunch Tathlum",
		head="Flam. Zucchetto +2",
		body="Sulevia's Plate. +2",
		hands="Sulev. Gauntlets +2",
		legs="Sulev. Cuisses +2",
		feet="Flam. Gambieras +2",
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear="Eabani Earring",
		left_ring="Vocane Ring +1",
		right_ring="Defending Ring",
		back={ name="Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},}

	-- 35 DT / 47 PDT / 35 MDT
	sets.defense.DT = {
		ammo="Staunch Tathlum",
		head="Peltast's Mezail +1",
		body="Sulevia's Platemail +2",
		hands="Leyline Gloves",
		legs={ name="Ptero. Brais +3", augments={'Enhances "Strafe" effect',}},
		feet="Sulev. Leggings +2",
		neck="Loricate Torque +1",
		waist="Asklepian Belt",
		left_ear="Genmei Earring",
		right_ear="Anastasi Earring",
		left_ring="Vocane Ring +1",
		right_ring="Defending Ring",
		back={ name="Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},}
		
		
	-- 2639HP/ 24 DT/ 35 PDT/ 28 MDT/ 522+40+15 MEVA/ 118 INT/ 133 MND
	sets.defense.Resist = sets.defense.DT

----------------------------------------------------------------------------------------------------------------------------------
	-- Melee sets
----------------------------------------------------------------------------------------------------------------------------------
	

	
	----------------------------------------------------------------------------------------------------------------------------------
	-- Trishula sets. Tanking, hybrid and DD sets.
	----------------------------------------------------------------------------------------------------------------------------------
	
	
    sets.engaged.Trishula = {
		sub="Utu Grip",
		ammo="Ginsen",
		head="Flam. Zucchetto +2",
		body="Pelt. Plackart +1",
		hands="Sulev. Gauntlets +2",
		legs="Sulev. Cuisses +2",
		feet="Flam. Gambieras +2",
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear="Eabani Earring",
		left_ring="Vocane Ring +1",
		right_ring="Defending Ring",
		back={ name="Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},}
			
	
	-- 14 PDT/ 4 MDT
	sets.engaged.Trishula.Hybrid = {
		sub="Utu Grip",
		ammo="Ginsen",
		head="Flam. Zucchetto +2",
		body="Pelt. Plackart +1",
		hands="Regal Gloves",
		legs={ name="Ptero. Brais +3", augments={'Enhances "Strafe" effect',}},
		feet="Flam. Gambieras +2",
		neck="Loricate Torque +1",
		waist="Ioskeha Belt +1",
		ear1="Telos Earring",
		ear2="Sherida Earring",
		left_ring="Vocane Ring +1",
		right_ring="Defending Ring",
		back={ name="Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
		}

	sets.engaged.Trishula.DD = {
		sub="Utu Grip",
		ammo="Ginsen",
		head="Flam. Zucchetto +2",
		body="Pelt. Plackart +1",
		hands={ name="Acro Gauntlets", augments={'Accuracy+18 Attack+18','"Store TP"+6','STR+7 DEX+7',}},
		legs={ name="Ptero. Brais +3", augments={'Enhances "Strafe" effect',}},
		feet="Flam. Gambieras +2",
		neck="Anu Torque",
		waist="Ioskeha Belt +1",
		ear1="Telos Earring",
		ear2="Sherida Earring",
		ring1="Niqmaddu Ring",
		ring2="Petrov Ring",
		back={ name="Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},}	
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- Reikikon sets. Tanking, hybrid and DD sets.
	----------------------------------------------------------------------------------------------------------------------------------
	
	sets.engaged.Reikikon = {
		sub="Utu Grip",
		ammo="Staunch Tathlum",
		head="Flam. Zucchetto +2",
		body="Sulevia's Plate. +2",
		hands="Sulev. Gauntlets +2",
		legs="Sulev. Cuisses +2",
		feet="Flam. Gambieras +2",
		neck="Loricate Torque +1",
		waist="Flume Belt +1",
		left_ear="Genmei Earring",
		right_ear="Eabani Earring",
		left_ring="Vocane Ring +1",
		right_ring="Defending Ring",
		back={ name="Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},}
			
	
	-- 51 PDT/ 37 MDT
	sets.engaged.Reikikon.Hybrid = {
		sub="Utu Grip",
		ammo="Ginsen",
		head="Flam. Zucchetto +2",
		body="Pelt. Plackart +1",
		hands="Regal Gloves",
		legs={ name="Ptero. Brais +3", augments={'Enhances "Strafe" effect',}},
		feet="Flam. Gambieras +2",
		neck="Loricate Torque +1",
		waist="Ioskeha Belt +1",
		ear1="Telos Earring",
		ear2="Sherida Earring",
		left_ring="Vocane Ring +1",
		right_ring="Defending Ring",
		back={ name="Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},
		}
		
	sets.engaged.Reikikon.DD = {
		sub="Utu Grip",
		ammo="Ginsen",
		head="Flam. Zucchetto +2",
		body="Pelt. Plackart +1",
		hands={ name="Acro Gauntlets", augments={'Accuracy+18 Attack+18','"Store TP"+6','STR+7 DEX+7',}},
		legs={ name="Ptero. Brais +3", augments={'Enhances "Strafe" effect',}},
		feet="Flam. Gambieras +2",
		neck="Anu Torque",
		waist="Ioskeha Belt +1",
		ear1="Telos Earring",
		ear2="Sherida Earring",
		ring1="Niqmaddu Ring",
		ring2="Petrov Ring",
		back={ name="Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}},}
		
	-- 51 PDT	
    sets.engaged.PDT = sets.engaged.Trishula
			
    
			
  
	----------------------------------------------------------------------------------------------------------------------------------
	-- Additional sets
	----------------------------------------------------------------------------------------------------------------------------------
	
		
	sets.buff.doom = {
		neck="Nicander's Necklace",
		waist="Gishdubar Sash", 
		ring1="Blenmot's Ring", 
		ring2="Purity Ring"}
		
	sets.buff.sleep = {head="Frenzy Sallet"}
	
		
	sets.buff["Samurai's Roll"] = {
		
		body="Emicho Haubert +1",
		hands="Sulev. Gauntlets +2",
		neck="Shulmanu Collar",
		left_ear="Brutal Earring",}
	
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
			if player.tp >= 700 then
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
	
	if spell.name == 'Dismiss' and pet.hpp < 100 then		
		cancel_spell() -- Dismiss resets the Call Wyvern recast IF your Wyvern is at 100% HP
		windower.add_to_chat(50,'  '..pet.name..'s HP is (<pethpp>), canceled Dismiss!')
	elseif spell.name == 'Call Wyvern' then
		if pet.isvalid then
			cancel_spell() -- Uses Spirit Link instead when your Wyvern is already present
			send_command('input /ja "Spirit Link" <me>')
		else
			equip(sets.precast.JA['Spirit Surge']) 
		end
		
	elseif spell.name == 'Spirit Link' then
		if pet.isvalid then
			equip(sets.precast.JA['Spirit Link'])
		else
			cancel_spell() -- Uses Call Wyvern instead when your Wyvern isn't present
			send_command('input /ja "Call Wyvern" <me>')
		end
	elseif string.find(spell.name,"Jump") then -- Any spell or ability with the word Jump in it
		if not pet.isvalid then -- If you don't have a pet
			if spell.name == "Spirit Jump" then -- Forces Spirit Jump into regular Jump when Wyvern is dead
				cancel_spell()
				send_command('input /ja "Jump" <t>')
				return
			elseif spell.name == "Soul Jump" then -- Forces Soul Jump into High Jump when Wyvern is dead
				cancel_spell()
				send_command('input /ja "High Jump" <t>')
				return
			end
		end
		equip(sets.precast.JA.Jump)
	end
end


	 
function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type == "WeaponSkill" then
        if state.Buff['Ancient Circle'] then
            equip(sets.buff['Ancient Circle'])
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

function job_post_midcast(spell, action, spellMap, eventArgs)
   
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
	
end



function job_pet_midcast(spell, action, spellMap, eventArgs)
    if spell.english:startswith('Healing Breath') or 
	spell.english == 'Restoring Breath' then
		equip(sets.precast.JA['Healing Breath'])
		
	elseif spell.english == 'Steady Wing' then
		send_command("wait 1.2;gs equip sets.precast.JA['Steady Wing']")
		
	
	elseif spell.english == 'Smiting Breath' then
		
		equip(sets.precast.JA['Elemental Breath'])
		
	elseif spell.english == 'Flame Breath' or 'Frost Breath' or 'Sand Breath' or 'Hydro Breath' or 'Gust Breath' or 'Lightning Breath' then
		
		equip(sets.precast.JA['Elemental Breath'])
	end
end

-- Pet Change: Occurs when your Pet is summoned or killed.
function pet_change(pet,gain)
	if gain == false then
		-- General announcement for when your Wyvern is killed, Dimissed, or eaten by Spirit Surge
		windower.add_to_chat(50,' *** '..string.upper(pet.name)..' RIP ***')
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
	
	elseif buff == "Samurai's Roll" then
        handle_equipping_gear(player.status)
		
	elseif buff == 'Ancient Circle' then
        handle_equipping_gear(player.status)
	
    end
	
	
	
	----------------------------------------------------------------------------------------------------------------------------------
	-- Aftermath timer
	----------------------------------------------------------------------------------------------------------------------------------	

	if player.equipment.main == 'Trishula' and buff:startswith('Aftermath') then
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
    if player.equipment.type == 'Polearm' then
		if state.CombatWeapon.value == 'Trishula' then
			state.CombatWeapon:set('Trishula')
        elseif state.CombatWeapon.value == 'Reikikon' then
			state.CombatWeapon:set('Reikikon') 
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
		if state.CombatWeapon.value == 'Lembing' then
			state.CombatForm:set('Lembing')
        elseif state.CombatWeapon.value == 'Trishula' then
			state.CombatForm:set('Trishula') 
        end
    else
			state.CombatForm:reset()
		
    end
end]]
 
function job_status_change(new_status, old_status)
    if new_status == 'Engaged' then
		get_combat_weapon()
		--get_combat_form()
    end          
end

function job_update(cmdParams, eventArgs)
	gearmode()
	get_combat_weapon()
	--get_combat_form()
end

--Automated use of Rudra's Storm.CF when buff is active.
function get_custom_wsmode(spell, spellMap, default_wsmode)
    local wsmode

    if state.Buff['Ancient Circle'] then
        wsmode = 'AC'
    end
    
    return wsmode
end



----------------------------------------------------------------------------------------------------------------------------------
	-- Set combine for melee
----------------------------------------------------------------------------------------------------------------------------------
	
function customize_melee_set(meleeSet)
	
	-- When Trishula is in tanking mode, I have heavy protection.
	if state.CombatWeapon.value == 'Trishula' then
		if state.OffenseMode.value == 'Normal' then
			if buffactive["Samurai's Roll"] then
				meleeSet = set_combine(meleeSet, sets.buff["Samurai's Roll"])
			end
		-- When Trishula is in hybrid mode, I have light protection.
		elseif state.OffenseMode.value == 'Hybrid' then
			if buffactive["Samurai's Roll"] then
				meleeSet = set_combine(meleeSet, sets.buff["Samurai's Roll"])
			end
		-- When Trishula is in DD mode, I have light protection.
		elseif state.OffenseMode.value == 'DD' then
			if buffactive["Samurai's Roll"] then
				meleeSet = set_combine(meleeSet, sets.buff["Samurai's Roll"])
			end
		end
	-- When Reikikon is in tanking mode, I have heavy protection.
	elseif state.CombatWeapon.value == 'Reikikon' then
		if state.OffenseMode.value == 'Normal' then
			if buffactive["Samurai's Roll"] then
				meleeSet = set_combine(meleeSet, sets.buff["Samurai's Roll"])
			end
		-- When Reikikon is in hybrid, I have light protection.
		elseif state.OffenseMode.value == 'Hybrid' then
			if buffactive["Samurai's Roll"] then
				meleeSet = set_combine(meleeSet, sets.buff["Samurai's Roll"])
			end
		-- When Reikikon is in DD mode, I have light protection.
		elseif state.OffenseMode.value == 'DD' then
			if buffactive["Samurai's Roll"] then
				meleeSet = set_combine(meleeSet, sets.buff["Samurai's Roll"])
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

  
----------------------------------------------------------------------------------------------------------------------------------
	-- Weapon changing
----------------------------------------------------------------------------------------------------------------------------------
function gearmode()
  if state.CombatWeapon.value == 'Trishula' then
		equip(sets.Trishula)
		handle_equipping_gear(player.status)
	elseif state.CombatWeapon.value == 'Reikikon' then
		equip(sets.Reikikon)
		handle_equipping_gear(player.status)
  end
end




-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'WAR' then
		set_macro_page(1, 19)
	elseif player.sub_job == 'NIN' then
		set_macro_page(1, 19)
	elseif player.sub_job == 'SAM' then
		set_macro_page(1, 19)
	else
		set_macro_page(1, 19)
	end
end
