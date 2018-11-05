-------------------------------------------------------------------------------------------------------------------
-- Rikimarueye's SAM lua. Comment section below
-------------------------------------------------------------------------------------------------------------------


-- Maintained and fixed and updated by Rikimarueye@pheonix
-- Original base lua created by Moten.

-- Version 1.0.0.0

--[[

	To do list:
	
	 Update and optimize DPS.
	 Personalize lua.
	
]]


--[[

 To user: Please feel free to DM, PM or open an issue if there is an error that I do not catch. Thank you ^^!

	]]

---------------------------------------------------------------------------------------------------
    -- Start of the setup, sets, and functions.
---------------------------------------------------------------------------------------------------

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
    state.Buff.Hasso = buffactive.Hasso or false
    state.Buff.Seigan = buffactive.Seigan or false
    state.Buff.Sekkanoki = buffactive.Sekkanoki or false
    state.Buff.Sengikori = buffactive.Sengikori or false
    state.Buff['Meikyo Shisui'] = buffactive['Meikyo Shisui'] or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.
function user_setup()
    state.OffenseMode:options('Normal')
    state.HybridMode:options('Normal')
    state.WeaponskillMode:options('Normal')
    state.PhysicalDefenseMode:options('PDT', 'MDT')

    update_combat_form()
	
	
	state.WarpMode = M{['description']='Transportation Ring is now', 'Off', 'Warp', 'Jima: Holla', 'Jima: Dem'}
    
    -- Additional local binds
	send_command('bind ^z gs c cycle WarpMode')
    send_command('bind ^` input /ja "Hasso" <me>')
    send_command('bind !` input /ja "Seigan" <me>')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind ^z')
    send_command('unbind ^`')
    send_command('unbind !-')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    
    sets.Warp	= {ring2="Warp Ring"}
  
    sets.Holla	= {ring2="Dim. Ring (Holla)"}
	
	sets.Dem	= {ring2="Dim. Ring (Dem)"}
    
    sets.precast.JA.Meditate = {
		head="Wakido Kabuto +1",
		hands="Sakonji Kote +1", 
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},}
		
    sets.precast.JA['Warding Circle'] = {head="Myochin Kabuto"}
    sets.precast.JA['Blade Bash'] = {hands="Sakonji Kote"}

    
    sets.precast.Waltz = {}
        
    
    sets.precast.Waltz['Healing Waltz'] = {}

    sets.precast.FC = {
		ammo="Sapience Orb",
		neck="Orunmila's Torque",
		ear1="Etiolation Earring",
		ear2="Loquacious Earring",
		hands="Leyline Gloves",
		ring1="Rahab Ring",
		ring2="Defending Ring",
		}
    
    sets.precast.WS = {
		sub="Utu Grip",
		ammo="Knobkierrie",
		head={ name="Valorous Mask", augments={'Accuracy+15 Attack+15','Weapon skill damage +2%','STR+7','Accuracy+4','Attack+5',}},
		neck="Fotia Gorget",
		ear1="Ishvara Earring",
		ear2="Moonshade Earring",
		body="Flamma Korazin +2",
		hands="Wakido Kote +2",
		ring1="Regal Ring",
		ring2="Epaminondas's Ring",
		legs="Hiza. Hizayoroi +2",
		feet="Flam. Gambieras +2",
		waist="Grunfeld Rope",
		back={ name="Smertrios's Mantle", augments={'STR+20','Accuracy+20 Attack+20','Weapon skill damage +10%',}},}
    

   
    sets.precast.WS['Tachi: Fudo'] = set_combine(sets.precast.WS, {})
    

    sets.precast.WS['Tachi: Shoha'] = set_combine(sets.precast.WS, {})
   
    sets.precast.WS['Tachi: Rana'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Tachi: Kasha'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Tachi: Gekko'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Tachi: Yukikaze'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Tachi: Ageha'] = set_combine(sets.precast.WS, {})

    sets.precast.WS['Tachi: Jinpu'] = set_combine(sets.precast.WS, {})


    -- Midcast Sets
    sets.midcast.FastRecast = {
		ammo="Sapience Orb",
		neck="Orunmila's Torque",
		ear1="Etiolation Earring",
		ear2="Loquacious Earring",
		hands="Leyline Gloves",
		ring1="Rahab Ring",
		ring2="Defending Ring",
        }

    
    

    -- Idle sets 
    sets.idle.Town = {
		ammo="Staunch Tathlum",
		neck="Loricate Torque +1",
		ear1="Genmei Earring",
		ear2="Eabani Earring",
        body="Emet Harness +1",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
        back="Agema Cape",
		waist="Flume Belt +1",}
    
    sets.idle = {
        ammo="Staunch Tathlum",
		neck="Loricate Torque +1",
		ear1="Genmei Earring",
		ear2="Eabani Earring",
        body="Emet Harness +1",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
        back="Agema Cape",
		waist="Flume Belt +1",}

    sets.idle.Weak = {
        ammo="Staunch Tathlum",
		neck="Loricate Torque +1",
		ear1="Genmei Earring",
		ear2="Eabani Earring",
        body="Emet Harness +1",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
        back="Agema Cape",
		waist="Flume Belt +1",}
    
    -- Defense sets
    sets.defense.PDT = {
		ammo="Staunch Tathlum",
		neck="Loricate Torque +1",
		ear1="Genmei Earring",
        body="Emet Harness +1",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
        back="Agema Cape",
		waist="Flume Belt +1",}


    sets.defense.MDT = sets.defense.PDT

    sets.defense.DT = sets.defense.PDT
	
	sets.defense.Resist = sets.defense.PDT

    -- Engaged sets

    sets.engaged = {
		sub="Utu Grip",
		ammo="Ginsen",
		head="Flam. Zucchetto +2",
		neck="Moonbeam Nodowa",
		body="Kasuga Domaru +1",
		ear1="Telos Earring",
		ear2="Dignitary's Earring",
		hands="Wakido Kote +2",
		ring1="Regal Ring",
		ring2="Niqmaddu Ring",
		legs="Hiza. Hizayoroi +2",
		feet="Ryuo Sune-Ate",
		waist="Ioskeha Belt +1",
		back="Agema Cape",}
    

    sets.buff.Sekkanoki = {}
    sets.buff.Sengikori = {}
    sets.buff['Meikyo Shisui'] = {}
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want any automatic target handling to be done.
function job_pretarget(spell, action, spellMap, eventArgs)
    if spell.type == 'WeaponSkill' then
        -- Change any GK weaponskills to polearm weaponskill if we're using a polearm.
        if player.equipment.main=='Quint Spear' or player.equipment.main=='Quint Spear' then
            if spell.english:startswith("Tachi:") then
                send_command('@input /ws "Penta Thrust" '..spell.target.raw)
                eventArgs.cancel = true
            end
        end
    end
end


function job_post_precast(spell, action, spellMap, eventArgs)
    if spell.type:lower() == 'weaponskill' then
        if state.Buff.Sekkanoki then
            equip(sets.buff.Sekkanoki)
        end
        if state.Buff.Sengikori then
            equip(sets.buff.Sengikori)
        end
        if state.Buff['Meikyo Shisui'] then
            equip(sets.buff['Meikyo Shisui'])
        end
    end
end


-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
   
end

-------------------------------------------------------------------------------------------------------------------
    -- Custom idle sets to keep warp rings on.
-------------------------------------------------------------------------------------------------------------------
	



function job_update(cmdParams, eventArgs)
    update_combat_form()
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


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function update_combat_form()
    
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(1, 5)
    elseif player.sub_job == 'DNC' then
        set_macro_page(2, 5)
    elseif player.sub_job == 'THF' then
        set_macro_page(3, 5)
    elseif player.sub_job == 'NIN' then
        set_macro_page(4, 5)
    else
        set_macro_page(1, 5)
    end
end