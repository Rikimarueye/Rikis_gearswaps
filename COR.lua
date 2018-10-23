-------------------------------------------------------------------------------------------------------------------
-- Rikimarueye's COR lua. Comment section below
-------------------------------------------------------------------------------------------------------------------


-- Maintained and fixed by Rikimarueye@pheonix
-- Original base lua created by Moten.

-- Version 1.0.0.6

--[[
	To do list:
	
	Fix and update and optimize DPS for all Facing sets.
	
]]

--[[
	Change log:
	
	1.0.0.6: Fixed the update to idle set after zoning when using a teleport ring 
	
	1.0.0.5: Added WS sets. A bit convoluted but it works!
	
	1.0.0.4: Fixed rules for aeonic aftermath.
	
	1.0.0.3: Fixed haste rules for bard songs and haste1/2. Added a rule for CombatForm to only apply when mythic is worn.
	
	1.0.0.2: Added haste rules.
	
	1.0.0.0: Personalized the lua and populated with my equipment.
]]



---------------------------------------------------------------------------------------------------
    -- Start of the setup, sets, and functions.
---------------------------------------------------------------------------------------------------


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


function job_setup()

	include('Mote-TreasureHunter')
    state.TreasureMode:set('Tag')
	
	get_combat_form()
	
	--Buff ID 359 for doom
	state.Buff.doom = buffactive.doom or false
    state.Buff.sleep = buffactive.sleep or false
	state.Buff.Terror = buffactive.Terror or false
    state.Buff.Stun = buffactive.Stun or false
    state.Buff.Petrification = buffactive.Petrification or false
	
	state.Buff['Triple Shot'] = buffactive['Triple Shot'] or false
	
    -- Whether to use Luzaf's Ring
    state.LuzafRing = M(true, "Luzaf's Ring")
    -- Whether a warning has been given for low ammo
    state.warned = M(false)
  
	--Haste mode
	state.HasteMode = M(false, 'Haste 2')
	
    define_roll_values()
	determine_haste_group()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Melee', 'Acc')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.CastingMode:options('Normal')
    state.IdleMode:options('Normal', 'Refresh')


    gear.RAbullet = "Chrono Bullet"
    gear.WSbullet = "Chrono Bullet"
    gear.MAbullet = "Orichalcum Bullet"
    gear.QDbullet = "Animikii Bullet"
    options.ammo_warning_limit = 15
	
	gear.shield = "Nusku Shield"
	gear.Moonshade = "Moonshade Earring"
	
	
	--Teleport Rings!
    state.WarpMode = M{['description']='Transportation Ring is now', 'Off', 'Warp', 'Jima: Holla', 'Jima: Dem'}
	

    -- Additional local binds
    send_command('bind ^` gs c toggle HasteMode')
    send_command('bind !` input /ja "Bolter\'s Roll" <me>')
	send_command('bind ^z gs c cycle WarpMode')
	
	
    select_default_macro_book()
end


function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
	send_command('unbind ^z')
end


function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    -- Precast Sets
	sets.TreasureHunter = {
	    body={ name="Herculean Vest", augments={'INT+4','Rng.Acc.+4 Rng.Atk.+4','"Treasure Hunter"+2','Mag. Acc.+19 "Mag.Atk.Bns."+19',}},
	    legs={ name="Herculean Trousers", augments={'CHR+5','Accuracy+2 Attack+2','"Treasure Hunter"+1','Mag. Acc.+6 "Mag.Atk.Bns."+6',}},
	    waist="Chaac Belt"}
	
	sets.Warp = {ring2="Warp Ring"}
  
    sets.Holla = {ring2="Dim. Ring (Holla)"}
	
	sets.Dem = {ring2="Dim. Ring (Dem)"}
	

    -- Precast sets to enhance JAs
    
    sets.precast.JA['Triple Shot'] = {	
		body="Chasseur's Frac +1",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Store TP"+10',}}}
		
    sets.precast.JA['Snake Eye'] = {legs="Lanun Trews +1"}
	
    sets.precast.JA['Wild Card'] = {feet="Lanun Bottes +2"}
	
    sets.precast.JA['Random Deal'] = {body="Lanun Frac +1"}

    
    sets.precast.CorsairRoll = {
		head="Lanun Tricorne +1",
		neck="Regal Necklace",
		hands="Chasseur's Gants +1",
		legs="Desultor Tassets",
		back="Camulus's Mantle"}
    
    sets.precast.CorsairRoll["Caster's Roll"] = set_combine(sets.precast.CorsairRoll, {legs="Chasseur's Culottes +1"})
    sets.precast.CorsairRoll["Courser's Roll"] = set_combine(sets.precast.CorsairRoll, {feet="Chasseur's Bottes +1"})
    sets.precast.CorsairRoll["Blitzer's Roll"] = set_combine(sets.precast.CorsairRoll, {head="Chasseur's Tricorne +1"})
    sets.precast.CorsairRoll["Tactician's Roll"] = set_combine(sets.precast.CorsairRoll, {body="Chasseur's Frac +1"})
    sets.precast.CorsairRoll["Allies' Roll"] = set_combine(sets.precast.CorsairRoll, {hands="Chasseur's Gants +1"})
    
    sets.precast.LuzafRing = {neck="Regal Necklace",ring2="Luzaf's Ring"}
    sets.precast.FoldDoubleBust = {hands="Lanun Gants +2"}
    
    sets.precast.CorsairShot = {body="Mirke Wardecors"}
    

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Anwig salade",
        body="Passion Jacket",
		hands={ name="Herculean Gloves", augments={'Accuracy+5','"Waltz" potency +11%',}},
		ring1="Asklepian Ring",
		ring2="Valseur's Ring",
		legs="Dashing Subligar",
		feet={ name="Herculean Boots", augments={'"Waltz" potency +11%','Attack+13',}}}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    -- Fast cast sets for spells
    
    sets.precast.FC = {
	  head={ name="Herculean Helm", augments={'Mag. Acc.+25','"Fast Cast"+5','MND+5','"Mag.Atk.Bns."+12',}},
	  neck="Orunmila's Torque",
	  ear1="Etiolation Earring",
	  ear2="Loquacious Earring",
	  body="Samnuha Coat",
	  hands="Leyline Gloves",
	  legs={ name="Herculean Trousers", augments={'Mag. Acc.+6','"Fast Cast"+6','INT+9','"Mag.Atk.Bns."+10',}},
	  ring1="Lebeche Ring",
	  ring2="Kishar Ring",
	  feet={ name="Herculean Boots", augments={'"Mag.Atk.Bns."+15','"Fast Cast"+5','Mag. Acc.+14',}}}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads",body="Passion Jacket"})


    sets.precast.RA = {
		ammo=gear.RAbullet,
        head={ name="Taeon Chapeau", augments={'"Snapshot"+5','"Snapshot"+2',}},
		body={ name="Taeon Tabard", augments={'Accuracy+25','"Snapshot"+5','"Snapshot"+4',}},
		hands="Lanun Gants +2",
		back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','"Snapshot"+10',}},
		waist="Impulse Belt",
		legs="Laksamana's Trews +3",
		feet="Meg. Jam. +2"}
       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
		head="Carmine Mask +1",
	    neck="Fotia Gorget",
		ear1="Ishvara Earring",
		ear2="Mache Earring +1",
        body="Adhemar Jacket +1",
		hands="Adhemar Wristbands +1",
		ring1="Regal Ring",
		ring2="Ilabrat Ring",
        back={ name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},
		waist="Fotia Belt",
		legs="Samnuha Tights",
		feet="Lanun Bottes +2"}


    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Evisceration'] = {
	    head={ name="Herculean Helm", augments={'Accuracy+18 Attack+18','Crit.hit rate+4','STR+6','Accuracy+11','Attack+12',}},
	    body="Abnoba Kaftan",
		neck="Fotia Gorget",
		ear1="Mache Earring +1",
		ear2="Moonshade Earring",
	    hands="Adhemar Wristbands +1",
		ring1="Regal Ring",
		ring2="Begrudging Ring",
		waist="Fotia Belt",
		legs="Lustratio Subligar +1",
		feet="Lanun Bottes +2"}

    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Requiescat'] =  {
	    head="Carmine Mask +1",
        body="Adhemar Jacket +1",
        hands="Meghanada Gloves +2",
        legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
        feet="Meg. Jam. +2",
        neck="Fotia Gorget",
        waist="Fotia Belt",
        ear1={ name="Moonshade Earring", augments={'Attack+4','TP Bonus +25',}},
        ear2="Telos Earring",
        ring1="Stikini Ring",
        ring2="Stikini Ring",
        back={ name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}}}
	
	sets.precast.WS['Salvage Blade'] = {
	    head={ name="Herculean Helm", augments={'Accuracy+23 Attack+23','Weapon skill damage +4%','DEX+15',}},
        body="Laksa. Frac +3",
        hands="Meghanada Gloves +2",
        neck="Caro Necklace",
		waist="Prosilio Belt +1",
		ear1="Ishvara Earring",
		ear2="Moonshade Earring",
		ring1="Regal Ring",
		ring2="Ilabrat Ring",
		legs="Meg. Chausses +2",
		feet="Lanun Bottes +2",
		back={ name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}}

    sets.precast.WS['Last Stand'] = {ammo=gear.WSbullet,
        head={ name="Herculean Helm", augments={'Accuracy+23 Attack+23','Weapon skill damage +4%','DEX+15',}},
	    neck="Fotia Gorget",
		ear1="Ishvara Earring",
		ear2="Dignitary's Earring",
		body="Laksamana's Frac +3",
		hands="Lanun Gants +2",
		ring1="Regal Ring",
		ring2="Dingir Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Weapon skill damage +10%',}},
		waist="Fotia Belt",
		legs="Meghanada Chausses +2",
		feet="Lanun Bottes +2"}

	sets.precast.WS['Last Stand'].Moonshade = set_combine(sets.precast.WS['Last Stand'], {
		ear2=gear.Moonshade})
	
	
	sets.precast.WS['Split Shot'] = sets.precast.WS['Last Stand']
	
	sets.precast.WS['Detonator'] = sets.precast.WS['Last Stand']

	sets.precast.WS['Hot Shot'] = {
		ammo=gear.WSbullet,
        head={ name="Herculean Helm", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','INT+8','"Mag.Atk.Bns."+11',}},
	    neck="Fotia Gorget",
		ear1="Friomisi Earring",
		ear2="Crematio Earring",
        body="Laksamana's Frac +3",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		ring1="Dingir Ring",
		ring2="Regal Ring",
		waist="Fotia Belt",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Weapon skill damage +10%',}},
		legs={ name="Herculean Trousers", augments={'Mag. Acc.+17 "Mag.Atk.Bns."+17','Weapon skill damage +2%','STR+5','"Mag.Atk.Bns."+14',}},
		feet="Lanun Bottes +2"}
		
	sets.precast.WS['Hot Shot'].Moonshade = set_combine(sets.precast.WS['Hot Shot'], {
		ear2=gear.Moonshade})
	
	sets.precast.WS['Hot Shot'].Obi = set_combine(sets.precast.WS['Hot Shot'].Moonshade, {waist="Hachirin-no-Obi"})	
	
	
    sets.precast.WS['Wildfire'] = {
		ammo=gear.MAbullet,
        head={ name="Herculean Helm", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','INT+8','"Mag.Atk.Bns."+11',}},
		neck="Sanctity Necklace",
		ear1="Friomisi Earring",
		ear2="Crematio Earring",
        body="Laksamana's Frac +3",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		ring1="Dingir Ring",
		ring2="Acumen Ring",
		waist="Eschan Stone",
		back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},
		legs={ name="Herculean Trousers", augments={'Mag. Acc.+17 "Mag.Atk.Bns."+17','Weapon skill damage +2%','STR+5','"Mag.Atk.Bns."+14',}},
		feet="Lanun Bottes +2"}

    sets.precast.WS['Wildfire'].Moonshade = set_combine(sets.precast.WS['Wildfire'], {
		ear2=gear.Moonshade})
	
	sets.precast.WS['Wildfire'].Obi = set_combine(sets.precast.WS['Wildfire'].Moonshade, {waist="Hachirin-no-Obi"})
	
    sets.precast.WS['Leaden Salute'] = set_combine(sets.precast.WS['Wildfire'], {
		ammo=gear.MAbullet,
        head="Pixie Hairpin +1",
		ear1="Ishvara Earring",
		ear2="Crematio Earring",
		ring2="Archon Ring",
		})
		
	sets.precast.WS['Leaden Salute'].Moonshade = set_combine(sets.precast.WS['Leaden Salute'], {
		ear2=gear.Moonshade})
	
	sets.precast.WS['Leaden Salute'].Obi = set_combine(sets.precast.WS['Leaden Salute'].Moonshade, {waist="Hachirin-no-Obi"})
	
    sets.precast.WS['Aeolian Edge'] = sets.precast.WS['Wildfire']
    
    -- Midcast Sets
    sets.midcast.FastRecast = {
        head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
		neck="Loricate Torque +1",
        body="Meghanada Cuirie +2",
		hands={ name="Herculean Gloves", augments={'Accuracy+21 Attack+21','Mag. Acc.+2','Damage taken-3%','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
		ring1="Defending Ring",
		ring2="Vocane Ring +1",
		legs="Meghanada Chausses +2",
		back="Agema Cape",
		feet={ name="Herculean Boots", augments={'Accuracy+28','Damage taken-3%','DEX+14','Attack+11',}}}
        
    -- Specific spells
    sets.midcast.Utsusemi = sets.midcast.FastRecast

    sets.midcast.CorsairShot = {
		ammo=gear.QDbullet,
        head={ name="Herculean Helm", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','INT+8','"Mag.Atk.Bns."+11',}},
		neck="Sanctity Necklace",
		ear1="Friomisi Earring",
		ear2="Dignitary's Earring",
        body="Samnuha Coat",
		hands={ name="Carmine Fin. Ga. +1", augments={'Rng.Atk.+20','"Mag.Atk.Bns."+12','"Store TP"+6',}},
		ring1="Dingir Ring",
		ring2="Stikini Ring",
		waist="Eschan Stone",
		back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%',}},
		legs={ name="Herculean Trousers", augments={'Mag. Acc.+17 "Mag.Atk.Bns."+17','Weapon skill damage +2%','STR+5','"Mag.Atk.Bns."+14',}},
		feet="Lanun Bottes +2"}

    sets.midcast.CorsairShot.Acc = sets.midcast.CorsairShot

    sets.midcast.CorsairShot['Light Shot'] = {ammo=gear.QDbullet,
        head="Dampening Tam",
		neck="Orunmila's Torque",
		ear1="Enchanter Earring +1",
		ear2="Dignitary's Earring",
        body="Chasseur's Frac +1",
		hands="Leyline Gloves",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
        back={ name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','"Snapshot"+10',}},
		waist="Eschan Stone",
		legs="Mummu Kecks +2",
		feet="Chasseur's Bottes +1"}

    sets.midcast.CorsairShot['Dark Shot'] = sets.midcast.CorsairShot['Light Shot']


    -- Ranged gear
    sets.midcast.RA = {
		ammo=gear.RAbullet,
        head="Meghanada Visor +2",
		neck="Iskur Gorget",
		ear1="Enervating Earring",
		ear2="Telos Earring",
		body="Laksamana's Frac +3",
		hands="Lanun Gants +2",
		ring1="Regal Ring",
		ring2="Dingir Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Store TP"+10',}},
		waist="Yemaya Belt",
		legs="Meghanada Chausses +2",
		feet="Meg. Jam. +2"}

    sets.midcast.RA.Acc = sets.midcast.RA
	
	sets.midcast.TS = {
		ammo=gear.RAbullet,
        head="Meghanada Visor +2",
		neck="Iskur Gorget",
		ear1="Enervating Earring",
		ear2="Telos Earring",
		body="Chasseur's Frac +1",
		hands="Lanun Gants +2",
		ring1="Regal Ring",
		ring2="Dingir Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Store TP"+10',}},
		waist="Yemaya Belt",
		legs="Meghanada Chausses +2",
		feet="Meg. Jam. +2"}

    sets.midcast['Sylvie (UC)'] = set_combine(sets.midcast.FastRecast, {body="Sylvie Unity Shirt"})
	
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {neck="Loricate Torque +1",ring1="Vocane Ring +1",ring2="Defending Ring"}
    

    -- Idle sets
    sets.idle = {
		ammo=gear.RAbullet,
        head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
		neck="Loricate Torque +1",
        body="Meghanada Cuirie +2",
		hands={ name="Herculean Gloves", augments={'Accuracy+21 Attack+21','Mag. Acc.+2','Damage taken-3%','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
		ring1="Defending Ring",
		ring2="Vocane Ring +1",
		waist="Flume Belt +1",
		legs="Carmine Cuisses +1",
		back="Agema Cape",
		feet={ name="Herculean Boots", augments={'Accuracy+28','Damage taken-3%','DEX+14','Attack+11',}}}

    sets.idle.Town = sets.idle
    
    -- Defense sets
    sets.defense.PDT = {
        head={ name="Herculean Helm", augments={'Accuracy+23','Damage taken-4%','AGI+7',}},
		neck="Loricate Torque +1",
        body="Meghanada Cuirie +2",
		hands={ name="Herculean Gloves", augments={'Accuracy+21 Attack+21','Mag. Acc.+2','Damage taken-3%','Mag. Acc.+5 "Mag.Atk.Bns."+5',}},
		ring1="Defending Ring",
		ring2="Vocane Ring +1",
		waist="Flume Belt +1",
		legs="Meghanada Chausses +2",
		back="Agema Cape",
		feet={ name="Herculean Boots", augments={'Accuracy+28','Damage taken-3%','DEX+14','Attack+11',}}}

    sets.defense.MDT = sets.defense.PDT
    

    sets.Kiting = {}

    
    -- Normal melee group
    sets.engaged = {
		ammo=gear.RAbullet,
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		neck="Combatant's Torque",
		waist="Windbuffet Belt +1",
		ear1="Brutal Earring",
		ear2="Telos Earring",
		ring1="Hetairoi Ring",
		ring2="Epona's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Store TP"+10',}},}
    
	sets.engaged.DW = {
		ammo=gear.RAbullet,
        head="Carmine Mask +1",
		neck="Combatant's Torque",
		ear1="Eabani Earring",
		ear2="Suppanomimi",
        body="Adhemar Jacket +1",
        hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},
	    ring1="Regal Ring",
		ring2="Ilabrat Ring",
        back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Carmine Cuisses",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
	
    sets.engaged.Acc = sets.engaged
	
	sets.engaged.Haste_10 = {
		ammo=gear.RAbullet,
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		neck="Combatant's Torque",
		waist="Windbuffet Belt +1",
		ear1="Brutal Earring",
		ear2="Telos Earring",
		ring1="Hetairoi Ring",
		ring2="Epona's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Store TP"+10',}},}
	
	
	sets.engaged.DW.Haste_10 = {
		ammo=gear.RAbullet,
        head="Carmine Mask +1",
		neck="Combatant's Torque",
		ear1="Eabani Earring",
		ear2="Suppanomimi",
        body="Adhemar Jacket +1",
        hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},
	    ring1="Regal Ring",
		ring2="Ilabrat Ring",
        back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Carmine Cuisses",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}} 
	
	
	sets.engaged.Haste_15 = {
		ammo=gear.RAbullet,
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		neck="Combatant's Torque",
		waist="Windbuffet Belt +1",
		ear1="Brutal Earring",
		ear2="Telos Earring",
		ring1="Hetairoi Ring",
		ring2="Epona's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Store TP"+10',}},}
  
	sets.engaged.DW.Haste_15 = {
		ammo=gear.RAbullet,
        head="Carmine Mask +1",
		neck="Combatant's Torque",
		ear1="Eabani Earring",
		ear2="Suppanomimi",
        body="Adhemar Jacket +1",
        hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},
	    ring1="Petrov Ring",
		ring2="Ilabrat Ring",
        back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Carmine Cuisses",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
	sets.engaged.Haste_25 = {	
		ammo=gear.RAbullet,
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		neck="Combatant's Torque",
		waist="Windbuffet Belt +1",
		ear1="Brutal Earring",
		ear2="Telos Earring",
		ring1="Hetairoi Ring",
		ring2="Epona's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Store TP"+10',}},}
		
		
	sets.engaged.DW.Haste_25 = {
		ammo=gear.RAbullet,
        head="Carmine Mask +1",
		neck="Combatant's Torque",
		ear1="Eabani Earring",
		ear2="Suppanomimi",
        body="Adhemar Jacket +1",
        hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},
	    ring1="Petrov Ring",
		ring2="Ilabrat Ring",
        back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Carmine Cuisses",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
	
	sets.engaged.Haste_30 = {
		ammo=gear.RAbullet,
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		neck="Combatant's Torque",
		waist="Windbuffet Belt +1",
		ear1="Brutal Earring",
		ear2="Telos Earring",
		ring1="Hetairoi Ring",
		ring2="Epona's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Store TP"+10',}},}
	
	
	sets.engaged.DW.Haste_30 = {
		ammo=gear.RAbullet,
        head="Carmine Mask +1",
		neck="Combatant's Torque",
		ear1="Eabani Earring",
		ear2="Suppanomimi",
        body="Adhemar Jacket +1",
        hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},
	    ring1="Petrov Ring",
		ring2="Ilabrat Ring",
        back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Carmine Cuisses",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
	
	sets.engaged.Haste_35 = {
		ammo=gear.RAbullet,
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		neck="Combatant's Torque",
		waist="Windbuffet Belt +1",
		ear1="Brutal Earring",
		ear2="Telos Earring",
		ring1="Hetairoi Ring",
		ring2="Epona's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Store TP"+10',}},}
	
	sets.engaged.DW.Haste_35 = {
		ammo=gear.RAbullet,
        head="Carmine Mask +1",
		neck="Combatant's Torque",
		ear1="Eabani Earring",
		ear2="Suppanomimi",
        body="Adhemar Jacket +1",
        hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},
	    ring1="Petrov Ring",
		ring2="Ilabrat Ring",
        back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Carmine Cuisses",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
	sets.engaged.Haste_40 = {
		ammo=gear.RAbullet,
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		neck="Combatant's Torque",
		waist="Windbuffet Belt +1",
		ear1="Brutal Earring",
		ear2="Telos Earring",
		ring1="Hetairoi Ring",
		ring2="Epona's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Store TP"+10',}},}
	
	sets.engaged.DW.Haste_40 = {
		ammo=gear.RAbullet,
        head="Carmine Mask +1",
		neck="Combatant's Torque",
		ear1="Eabani Earring",
		ear2="Suppanomimi",
        body="Adhemar Jacket +1",
        hands={ name="Floral Gauntlets", augments={'Rng.Acc.+15','Accuracy+15','"Triple Atk."+3','Magic dmg. taken -4%',}},
	    ring1="Petrov Ring",
		ring2="Ilabrat Ring",
        back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dual Wield"+10',}},
		waist="Reiki Yotai",
		legs="Carmine Cuisses",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
	
	sets.engaged.MaxHaste = {
		ammo=gear.RAbullet,
        head={ name="Adhemar Bonnet +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		body={ name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}},
		hands={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}},
		legs={ name="Samnuha Tights", augments={'STR+10','DEX+10','"Dbl.Atk."+3','"Triple Atk."+3',}},
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}},
		neck="Combatant's Torque",
		waist="Windbuffet Belt +1",
		ear1="Brutal Earring",
		ear2="Telos Earring",
		ring1="Hetairoi Ring",
		ring2="Epona's Ring",
		back={ name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Rng.Acc.+10','"Store TP"+10',}},}

    sets.engaged.DW.MaxHaste = {
		ammo=gear.RAbullet,
        head="Carmine Mask +1",
		neck="Combatant's Torque",
		ear1="Telos Earring",
		ear2="Suppanomimi",
        body="Adhemar Jacket +1",
        hands="Adhemar Wristbands +1",
	    ring1="Petrov Ring",
		ring2="Ilabrat Ring",
        back={ name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dual Wield"+10',}},
		waist="Windbuffet Belt +1",
		legs="Samnuha Tights",
		feet={ name="Herculean Boots", augments={'STR+10','Sklchn.dmg.+2%','Quadruple Attack +3','Accuracy+19 Attack+19','Mag. Acc.+4 "Mag.Atk.Bns."+4',}}}
    
	
	sets.Obi = {waist="Hachirin-no-Obi"}
	sets.buff.doom = {ring1="Blenmot's Ring",ring2="Purity Ring"}
	sets.buff.sleep = {head="Frenzy Sallet"}
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
    -- Check that proper ammo is available if we're using ranged attacks or similar.
    if spell.action_type == 'Ranged Attack' or spell.type == 'WeaponSkill' or spell.type == 'CorsairShot' then
        do_bullet_checks(spell, spellMap, eventArgs)
    end

    -- gear sets
    if (spell.type == 'CorsairRoll' or spell.english == "Double-Up") and state.LuzafRing.value then
        equip(sets.precast.LuzafRing)
    elseif spell.type == 'CorsairShot' and state.CastingMode.value == 'Resistant' then
        classes.CustomClass = 'Acc'
    elseif spell.english == 'Fold' and buffactive['Bust'] == 2 then
        if sets.precast.FoldDoubleBust then
            equip(sets.precast.FoldDoubleBust)
            eventArgs.handled = true
        end
    end
	
	
end

function job_post_precast(spell, action, spellMap, eventArgs)
	if spell.type == "WeaponSkill" then
		if spell.english == 'Leaden Salute' then
			if player.tp <= 2750 then
				if (world.weather_element == 'Dark' or world.day_element == 'Dark') then
					equip(sets.precast.WS['Leaden Salute'].Obi)
				else
					equip(sets.precast.WS['Leaden Salute'].Moonshade)
				end
			elseif player.tp > 2750 then
				if (world.weather_element == 'Dark' or world.day_element == 'Dark') then
					equip(sets.Obi)
				else
					equip(sets.precast.WS['Leaden Salute'])
				end
			end
		end
		
		
		if spell.english == 'Wildfire' then
			if player.tp <= 2750 then
				if (world.weather_element == 'Fire' or world.day_element == 'Fire') then
					equip(sets.precast.WS['Wildfire'].Obi)
				else
					equip(sets.precast.WS['Wildfire'].Moonshade)
				end
			elseif player.tp > 2750 then
				if (world.weather_element == 'Fire' or world.day_element == 'Fire') then
					equip(sets.Obi)
				else
					equip(sets.precast.WS['Wildfire'])
				end
			end
		end
		
		
		if spell.english == 'Hot Shot' then
			if player.tp <= 2750 then
				if (world.weather_element == 'Fire' or world.day_element == 'Fire') then
					equip(sets.precast.WS['Hot Shot'].Obi)
				else
					equip(sets.precast.WS['Hot Shot'].Moonshade)
				end
			elseif player.tp > 2750 then
				if (world.weather_element == 'Fire' or world.day_element == 'Fire') then
					equip(sets.Obi)
				else
					equip(sets.precast.WS['Hot Shot'])
				end
			end
		end
		
		
		if spell.english == 'Last Stand' then
			if player.tp <= 2750 then
					equip(sets.precast.WS['Last Stand'].Moonshade)
			
			else
				 equip(sets.precast.WS['Last Stand'])
				
			end
		end
	end
end
	
function job_midcast(spell, action, spellMap, eventArgs)
		--Cancels Ni shadows
	 if spell.name == 'Utsusemi: Ichi' and overwrite then
        send_command('cancel Copy Image|Copy Image (2)')
    end
end

function job_post_midcast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' and buffactive['Triple Shot'] then
            equip(sets.midcast.TS)
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
	
	if spell.type == 'CorsairRoll' and not spell.interrupted then
        display_roll_info(spell)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------


-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.


function job_buff_change(buff,gain, eventArgs)
    --If we gain or lose any haste buffs, adjust which gear set we target.
    if S{'haste','march','embrava','haste samba','indi-haste','geo-haste','mighty guard'}:contains(buff:lower()) then
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
	elseif buff:lower()=='stun' then
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
	
	elseif buff == 'Triple Shot' then
        handle_equipping_gear(player.status)
	
	end
	
	-- Used with Timers Plugin to create and delete custom timers for aftermath levels
    if player.equipment.main == 'Fomalhaut' and buff:startswith('Aftermath') then
        local times = {["Aftermath: Lv.1"]=180, ["Aftermath: Lv.2"]=180, ["Aftermath: Lv.3"]=180}
        
        if gain then
            send_command('timers c "'..buff..'" '..tostring(times[buff])..' down abilities/00027.png')
        else
            send_command('timers d "'..buff..'"')

        end
	end
end


function get_combat_form()
	if player.equipment.sub == gear.shield or player.equipment.sub == 'empty' then
        state.CombatForm:reset()
    else
        state.CombatForm:set('DW')
    end

end


--[[function get_combat_form()
    if player.equipment.sub == gear.dagger or 
	player.equipment.sub == gear.sword or 
	player.equipment.sub == gear.dagger2 then
    	state.CombatForm:set('DW')
    else
        state.CombatForm:reset()
    end
end]]

function job_status_change(new_status, old_status)
    if new_status == 'Engaged' then
		get_combat_form()
	    determine_haste_group()
    end
end


function job_update(cmdParams, eventArgs)
    get_combat_form()
	determine_haste_group()
end



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
				((buffactive.march == 2) and buffactive[33]) or
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
end



-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    local msg = ''
    
    msg = msg .. 'Off.: '..state.OffenseMode.current
    msg = msg .. ', Rng.: '..state.RangedMode.current
    msg = msg .. ', WS.: '..state.WeaponskillMode.current
    msg = msg .. ', QD.: '..state.CastingMode.current

    if state.DefenseMode.value ~= 'None' then
        local defMode = state[state.DefenseMode.value ..'DefenseMode'].current
        msg = msg .. ', Defense: '..state.DefenseMode.value..' '..defMode
    end
    

    msg = msg .. ', Roll Size: ' .. (state.LuzafRing.value and 'Large') or 'Small'
    
    add_to_chat(122, msg)

    eventArgs.handled = true
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function define_roll_values()
    rolls = {
        ["Corsair's Roll"]   = {lucky=5, unlucky=9, bonus="Experience Points"},
        ["Ninja Roll"]       = {lucky=4, unlucky=8, bonus="Evasion"},
        ["Hunter's Roll"]    = {lucky=4, unlucky=8, bonus="Accuracy"},
        ["Chaos Roll"]       = {lucky=4, unlucky=8, bonus="Attack"},
        ["Magus's Roll"]     = {lucky=2, unlucky=6, bonus="Magic Defense"},
        ["Healer's Roll"]    = {lucky=3, unlucky=7, bonus="Cure Potency Received"},
        ["Puppet Roll"]      = {lucky=4, unlucky=8, bonus="Pet Magic Accuracy/Attack"},
        ["Choral Roll"]      = {lucky=2, unlucky=6, bonus="Spell Interruption Rate"},
        ["Monk's Roll"]      = {lucky=3, unlucky=7, bonus="Subtle Blow"},
        ["Beast Roll"]       = {lucky=4, unlucky=8, bonus="Pet Attack"},
        ["Samurai Roll"]     = {lucky=2, unlucky=6, bonus="Store TP"},
        ["Evoker's Roll"]    = {lucky=5, unlucky=9, bonus="Refresh"},
        ["Rogue's Roll"]     = {lucky=5, unlucky=9, bonus="Critical Hit Rate"},
        ["Warlock's Roll"]   = {lucky=4, unlucky=8, bonus="Magic Accuracy"},
        ["Fighter's Roll"]   = {lucky=5, unlucky=9, bonus="Double Attack Rate"},
        ["Drachen Roll"]     = {lucky=3, unlucky=7, bonus="Pet Accuracy"},
        ["Gallant's Roll"]   = {lucky=3, unlucky=7, bonus="Defense"},
        ["Wizard's Roll"]    = {lucky=5, unlucky=9, bonus="Magic Attack"},
        ["Dancer's Roll"]    = {lucky=3, unlucky=7, bonus="Regen"},
        ["Scholar's Roll"]   = {lucky=2, unlucky=6, bonus="Conserve MP"},
        ["Bolter's Roll"]    = {lucky=3, unlucky=9, bonus="Movement Speed"},
        ["Caster's Roll"]    = {lucky=2, unlucky=7, bonus="Fast Cast"},
        ["Courser's Roll"]   = {lucky=3, unlucky=9, bonus="Snapshot"},
        ["Blitzer's Roll"]   = {lucky=4, unlucky=9, bonus="Attack Delay"},
        ["Tactician's Roll"] = {lucky=5, unlucky=8, bonus="Regain"},
        ["Allies's Roll"]    = {lucky=3, unlucky=10, bonus="Skillchain Damage"},
        ["Miser's Roll"]     = {lucky=5, unlucky=7, bonus="Save TP"},
        ["Companion's Roll"] = {lucky=2, unlucky=10, bonus="Pet Regain and Regen"},
        ["Avenger's Roll"]   = {lucky=4, unlucky=8, bonus="Counter Rate"},
    }
end

function display_roll_info(spell)
    rollinfo = rolls[spell.english]
    local rollsize = (state.LuzafRing.value and 'Large') or 'Small'

    if rollinfo then
        add_to_chat(104, spell.english..' provides a bonus to '..rollinfo.bonus..'.  Roll size: '..rollsize)
        add_to_chat(104, 'Lucky roll is '..tostring(rollinfo.lucky)..', Unlucky roll is '..tostring(rollinfo.unlucky)..'.')
    end
end


-- Determine whether we have sufficient ammo for the action being attempted.
function do_bullet_checks(spell, spellMap, eventArgs)
    local bullet_name
    local bullet_min_count = 1
    
    if spell.type == 'WeaponSkill' then
        if spell.skill == "Marksmanship" then
            if spell.element == 'None' then
                -- physical weaponskills
                bullet_name = gear.WSbullet
            else
                -- magical weaponskills
                bullet_name = gear.MAbullet
            end
        else
            -- Ignore non-ranged weaponskills
            return
        end
    elseif spell.type == 'CorsairShot' then
        bullet_name = gear.QDbullet
    elseif spell.action_type == 'Ranged Attack' then
        bullet_name = gear.RAbullet
        if buffactive['Triple Shot'] then
            bullet_min_count = 3
        end
    end
    
    local available_bullets = player.inventory[bullet_name] or player.wardrobe[bullet_name]
    
    -- If no ammo is available, give appropriate warning and end.
    if not available_bullets then
        if spell.type == 'CorsairShot' and player.equipment.ammo ~= 'empty' then
            add_to_chat(104, 'No Quick Draw ammo left.  Using what\'s currently equipped ('..player.equipment.ammo..').')
            return
        elseif spell.type == 'WeaponSkill' and player.equipment.ammo == gear.RAbullet then
            add_to_chat(104, 'No weaponskill ammo left.  Using what\'s currently equipped (standard ranged bullets: '..player.equipment.ammo..').')
            return
        else
            add_to_chat(104, 'No ammo ('..tostring(bullet_name)..') available for that action.')
            eventArgs.cancel = true
            return
        end
    end
    
    -- Don't allow shooting or weaponskilling with ammo reserved for quick draw.
    if spell.type ~= 'CorsairShot' and bullet_name == gear.QDbullet and available_bullets.count <= bullet_min_count then
        add_to_chat(104, 'No ammo will be left for Quick Draw.  Cancelling.')
        eventArgs.cancel = true
        return
    end
    
    -- Low ammo warning.
    if spell.type ~= 'CorsairShot' and state.warned.value == false
        and available_bullets.count > 1 and available_bullets.count <= options.ammo_warning_limit then
        local msg = '*****  LOW AMMO WARNING: '..bullet_name..' *****'
        --local border = string.repeat("*", #msg)
        local border = ""
        for i = 1, #msg do
            border = border .. "*"
        end
        
        add_to_chat(104, border)
        add_to_chat(104, msg)
        add_to_chat(104, border)

        state.warned:set()
    elseif available_bullets.count > options.ammo_warning_limit and state.warned then
        state.warned:reset()
    end
end

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


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 14)
end