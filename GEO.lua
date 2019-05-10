-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

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
    indi_timer = ''
    indi_duration = 270
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('None', 'Normal')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal', 'Regen', 'PDT')	
	
	
	state.MagicBurst = M(false, 'MagicBurst')
	state.MagicBurst = M{['description']='Mage Mode', 'Normal', 'MagicBurst'}
	
	--Teleport Rings!
    state.WarpMode = M{['description']='Transportation Ring is now', 'Off', 'Warp', 'Jima: Holla', 'Jima: Dem'}
	
	
	 -- Additional local binds
    send_command('bind ^` gs c cycle MagicBurst')
	send_command('bind ^z gs c cycle WarpMode')
    select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
	send_command('unbind ^z')
	
   -- send_command('unbind @`')
end

-- Define sets and vars used by this job file.
function init_gear_sets()

	
	---------------------------------------------------------------------------------------------------
    -- Teleport Rings
	---------------------------------------------------------------------------------------------------
	
	sets.Warp = {ring2="Warp Ring"}
  
    sets.Holla = {ring2="Dim. Ring (Holla)"}
	
	sets.Dem = {ring2="Dim. Ring (Dem)"}
	
	
---------------------------------------------------------------------------------------------------
-- Precast
---------------------------------------------------------------------------------------------------
	sets.precast.JA = {}
	
    -- Precast sets to enhance JAs
    sets.precast.JA.Bolster = {
		body="Bagua Tunic +3"}
	
    sets.precast.JA['Life cycle'] = {	
		head="Azimuth Hood +1",
		body="Geomancy Tunic +1",
		back="Nantosuelta's Cape"}

	---------------------------------------------------------------------------------------------------
    -- FastCast
	---------------------------------------------------------------------------------------------------

    sets.precast.FC = {
		main={ name="Grioavolr", augments={'Enfb.mag. skill +13','INT+15','Mag. Acc.+30','"Mag.Atk.Bns."+15','Magic Damage +1',}},
		range="Dunna",
        head={ name="Merlinic Hood", augments={'"Fast Cast"+7','CHR+6','"Mag.Atk.Bns."+8',}},
		neck="Orunmila's Torque",
		ear1="Enchanter Earring +1",
		ear2="Loquacious Earring",
        body="Zendik Robe",
		hands={ name="Merlinic Dastanas", augments={'"Mag.Atk.Bns."+7','"Fast Cast"+7','INT+10',}},
		ring1="Lebeche Ring",
		ring2="Kishar Ring",
        back="Perimede Cape",
		waist="Witful Belt",
		legs="Geomancy Pants +1",
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','"Fast Cast"+5','INT+5','Mag. Acc.+11',}}}

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
		main={ name="Grioavolr", augments={'Enfb.mag. skill +13','INT+15','Mag. Acc.+30','"Mag.Atk.Bns."+15','Magic Damage +1',}},
		sub="Genmei Shield",
		neck="Orunmila's Torque",
	    ear1="Mendicant's Earring",
	    ring1="Lebeche Ring",
	    feet="Vanya Clogs"})
   
	sets.precast.FC.Stoneskin = set_combine(sets.precast.FC, {waist="Siegel Sash"})
	
    sets.precast.FC['Elemental Magic'] = set_combine(sets.precast.FC, {
        head="Nahtirah Hat",
		range="Dunna",
		neck="Orunmila's Torque",
		ear1="Barkarole Earring",
		ear2="Loquacious Earring",
        body={ name="Merlinic Jubbah", augments={'Mag. Acc.+10','"Fast Cast"+5','"Mag.Atk.Bns."+1',}},
		hands="Bagua Mitaines +1",
		ring1="Kishar Ring",
        back="Lifestream Cape",
		waist="Witful Belt",
		legs="Geomancy Pants +1",
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','"Fast Cast"+5','INT+5','Mag. Acc.+11',}}})

    
---------------------------------------------------------------------------------------------------
-- WS sets
---------------------------------------------------------------------------------------------------
	
    sets.precast.WS = {
        ammo="Pemphredo Tathlum",
	    head={ name="Merlinic Hood", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','INT+15','Mag. Acc.+15','"Mag.Atk.Bns."+5',}},
		body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+4','"Mag.Atk.Bns."+11',}},
		ear1="Friomisi Earring",
		ear2="Barkarole Earring",
		hands="Bagua Mitaines +3",
	    ring1="Shiva Ring +1",
		ring2="Shiva Ring +1",
		waist="Eschan Stone",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic Damage +6','INT+14','Mag. Acc.+15','"Mag.Atk.Bns."+10',}},
		neck="Sanctity Necklace",
		back="Nantosuelta's Cape",
		feet="Jhakri Pigaches +2",}

    
    sets.precast.WS['Flash Nova'] = {
		ammo="Pemphredo Tathlum",
	    head={ name="Merlinic Hood", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','INT+15','Mag. Acc.+15','"Mag.Atk.Bns."+5',}},
		body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+4','"Mag.Atk.Bns."+11',}},
		ear1="Friomisi Earring",
		ear2="Barkarole Earring",
		hands="Bagua Mitaines +3",
	    ring1="Shiva Ring +1",
		ring2="Shiva Ring +1",
		waist="Eschan Stone",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic Damage +6','INT+14','Mag. Acc.+15','"Mag.Atk.Bns."+10',}},
		neck="Sanctity Necklace",back="Nantosuelta's Cape",
		feet="Jhakri Pigaches +2",}
		 
	sets.precast.WS['Aeolian Edge'] = {
		ammo="Pemphredo Tathlum",
	    head={ name="Merlinic Hood", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','INT+15','Mag. Acc.+15','"Mag.Atk.Bns."+5',}},
		body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+4','"Mag.Atk.Bns."+11',}},
		ear1="Friomisi Earring",
		ear2="Barkarole Earring",
		hands="Bagua Mitaines +3",
	    ring1="Shiva Ring +1",
		ring2="Shiva Ring +1",
		waist="Eschan Stone",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic Damage +6','INT+14','Mag. Acc.+15','"Mag.Atk.Bns."+10',}},
		neck="Sanctity Necklace",
		back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
		feet="Jhakri Pigaches +2",}

    sets.precast.WS['Starlight'] = {ear2="Moonshade Earring"}

    sets.precast.WS['Moonlight'] = {ear2="Moonshade Earring"}

	sets.precast.WS['Cataclysm'] = {
		ammo="Pemphredo Tathlum",
	    head={ name="Merlinic Hood", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','INT+15','Mag. Acc.+15','"Mag.Atk.Bns."+5',}},
		body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+4','"Mag.Atk.Bns."+11',}},
		ear1="Friomisi Earring",
		ear2="Barkarole Earring",
		hands="Bagua Mitaines +3",
	    ring1="Shiva Ring +1",
		ring2="Shiva Ring +1",
		waist="Eschan Stone",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic Damage +6','INT+14','Mag. Acc.+15','"Mag.Atk.Bns."+10',}},
		neck="Sanctity Necklace",
		back="Nantosuelta's Cape",
		feet="Jhakri Pigaches +2",}
		 
		 
		 
		 
		 
---------------------------------------------------------------------------------------------------
-- MidCast
---------------------------------------------------------------------------------------------------

	
    sets.midcast.FastRecast = {
		main={ name="Grioavolr", augments={'Enfb.mag. skill +13','INT+15','Mag. Acc.+30','"Mag.Atk.Bns."+15','Magic Damage +1',}},
		range="Dunna",
        head="Nahtirah Hat",
		ear1="Etiolation Earring",
		ear2="Loquacious Earring",
        body={ name="Merlinic Jubbah", augments={'Mag. Acc.+10','"Fast Cast"+5','"Mag.Atk.Bns."+1',}},
		ring1="Kishar Ring",
        back="Lifestream Cape",
		waist="Witful Belt",
		legs="Geomancy Pants +1",
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','"Fast Cast"+5','INT+5','Mag. Acc.+11',}}}

		
	---------------------------------------------------------------------------------------------------
    -- GEO specifics
	---------------------------------------------------------------------------------------------------
    sets.midcast.Geomancy = {
		main="Idris",
		range="Dunna",
		neck="Incanter's Torque",
	    head="Vanya Hood",
		body="Witching Robe",
		ear1="Calamitous Earring",
		ear2="Magnetic Earring",
		ring1="Defending Ring",
		ring2="Vocane Ring +1",
	    hands="Shrieker's Cuffs",
		waist="Austerity Belt +1",
		legs="Vanya Slops",
		feet={ name="Merlinic Crackows", augments={'"Mag.Atk.Bns."+22','"Conserve MP"+5',}},
		back="Lifestream Cape"}
    sets.midcast.Geomancy.Indi = {
		main="Idris",
		range="Dunna",
		neck="Incanter's Torque",
		head="Vanya Hood",
		body="Bagua Tunic +3",
		hands="Shrieker's Cuffs",
		waist="Austerity Belt +1",
		ring1="Defending Ring",
	    ring2="Vocane Ring +1",
	    legs="Bagua Pants +1",
		feet="Azimuth Gaiters +1",
		back="Nantosuelta's Cape"}
		
		
	sets.midcast.Entrust = set_combine(sets.midcast.Geomancy.Indi, {
		main={ name="Gada", augments={'Indi. eff. dur. +9','MND+1','Mag. Acc.+3','"Mag.Atk.Bns."+16','DMG:+2',}},})

	---------------------------------------------------------------------------------------------------
    -- Cure/Enchancing/DarkMagic
	---------------------------------------------------------------------------------------------------
	
	sets.midcast['Enfeebling Magic'] = {
	     main={ name="Grioavolr", augments={'Enfb.mag. skill +13','INT+15','Mag. Acc.+30','"Mag.Atk.Bns."+15','Magic Damage +1',}},
		 sub="Enki Strap",
	     head="Befouled Crown",
		 body="Vanya Robe",
		 ear1="Genmei Earring",
		 ear2="Dignitary's Earring",
		 hands="Azimuth Gloves +1",
	     ring1="Stikini Ring",
		 ring2="Stikini Ring",
		 waist="Rumination Sash",
		 legs="Volte Brais",
		 neck="Imbodla Necklace",
		 back="Lifestream Cape",
		 feet="Medium's Sabots"}
		 
    sets.midcast['Dark Magic'] = {
		main="Rubicundity",
		sub="Ammurapi Shield",
		ammo="Pemphredo Tathlum",
	    head="Pixie Hairpin +1",
		body={ name="Merlinic Jubbah", augments={'Mag. Acc.+17 "Mag.Atk.Bns."+17','Magic burst dmg.+10%','Mag. Acc.+10','"Mag.Atk.Bns."+9',}},
		ear1="Barkarole Earring",
		ear2="Dignitary's Earring",
		hands="Bagua Mitaines +3",
	    ring1="Evanescence Ring",
		ring2="Archon Ring",
		waist="Fucho-no-obi",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic Damage +6','INT+14','Mag. Acc.+15','"Mag.Atk.Bns."+10',}},
		neck="Erra Pendant",
		back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
		feet="Jhakri Pigaches +2",}
  
    sets.midcast['Enhancing Magic'] = {
		main="Gada",sub="Ammurapi Shield",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
		hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +7',}},
		legs={ name="Telchine Braconi", augments={'Accuracy+14 Attack+14','"Dbl.Atk."+3','Enh. Mag. eff. dur. +8',}},
		feet={ name="Telchine Pigaches", augments={'Song spellcasting time -5%','Enh. Mag. eff. dur. +8',}}}
		 
    sets.midcast.Cure = {
		main="Serenity",
		sub="Genmei Shield",
        head="Vanya Hood",
		neck="Nodens Gorget",
		legs="Vanya Slops",
		feet="Vanya Clogs",
		ring1="Lebeche Ring",
		back="Lifestream Cape"}
    
	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {neck="Nodens Gorget",ear1="Earthcry Earring",waist="Siegel Sash"})
    sets.midcast.Curaga = sets.midcast.Cure

    sets.midcast['Protect'] = sets.midcast['Enhancing Magic']

    sets.midcast['Shell'] = sets.midcast['Enhancing Magic']
	
	sets.midcast['Refresh'] = set_combine(sets.midcast['Enhancing Magic'], {waist="Gishdubar Sash"})
	
	sets.midcast['Aquaveil'] = sets.midcast['Enhancing Magic']

	sets.midcast['Regen'] = sets.midcast['Enhancing Magic']

	sets.midcast['Haste'] = sets.midcast['Enhancing Magic']
		
	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
	     neck="Nodens Gorget",
		 ear1="Earthcry Earring",
		 waist="Siegel Sash"})
		 

	
	
		 
		 
	---------------------------------------------------------------------------------------------------
    -- Elemental Magic
	---------------------------------------------------------------------------------------------------
	
	sets.midcast['Elemental Magic'] = {
		main="Idris",
	    sub="Ammurapi Shield",
	    head={ name="Merlinic Hood", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','INT+15','Mag. Acc.+15','"Mag.Atk.Bns."+5',}},
		body="Bagua Tunic +3",
		ear1="Friomisi Earring",
		ear2="Barkarole Earring",
		hands="Bagua Mitaines +3",
	    ring1="Shiva Ring +1",
		ring2="Acumen Ring",
		waist="Refoccilation Stone",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic Damage +6','INT+14','Mag. Acc.+15','"Mag.Atk.Bns."+10',}},
		neck="Sanctity Necklace",
		back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
		feet="Jhakri Pigaches +2",}
		
	--sets.midcast.Obi = set_combine(sets.midcast['Elemental Magic'].Resistant, {waist="Hachirin-no-Obi"})
		 
	sets.midcast['Elemental Magic'].Resistant = {
		main="Idris",
	    sub="Ammurapi Shield",
	    head={ name="Merlinic Hood", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','INT+15','Mag. Acc.+15','"Mag.Atk.Bns."+5',}},
		body="Bagua Tunic +3",
        ear1="Friomisi Earring",
		ear2="Barkarole Earring",
		hands="Bagua Mitaines +3",
	    ring1="Shiva Ring +1",
		ring2="Acumen Ring",
		waist="Refoccilation Stone",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic Damage +6','INT+14','Mag. Acc.+15','"Mag.Atk.Bns."+10',}},
		neck="Mizu. Kubikazari",
		back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
		feet="Jhakri Pigaches +2"}

		 
    sets.midcast['Elemental Magic'].MagicBurst = {
	    main="Idris",
	    sub="Ammurapi Shield",
	    head={ name="Merlinic Hood", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','INT+15','Mag. Acc.+15','"Mag.Atk.Bns."+5',}},
		body="Bagua Tunic +3",
		ear1="Friomisi Earring",
		ear2="Barkarole Earring",
		hands="Bagua Mitaines +3",
	    ring1="Locus Ring",
		ring2="Shiva Ring +1",
		waist="Hachirin-no-Obi",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic Damage +6','INT+14','Mag. Acc.+15','"Mag.Atk.Bns."+10',}},
		neck="Mizu. Kubikazari",
		back={ name="Nantosuelta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
		feet="Jhakri Pigaches +2"}
		 
		 
---------------------------------------------------------------------------------------------------
-- Idle/Defensive/Pet/Other sets
---------------------------------------------------------------------------------------------------

    sets.idle = {
		main="Bolelabunga",
		sub="Genmei Shield",
		range="Dunna",
        head="Befouled Crown",
		neck="Loricate Torque +1",
		ear1="Genmei Earring",
		ear2="Dignitary's Earring",
        body="Mallquis Saio +2",
		hands="Bagua Mitaines +1",
		ring1="Defending Ring",
		ring2="Vocane Ring +1",
        back="Lifestream Cape",
		waist="Eschan Stone",
		legs="Volte Brais",
		feet="Azimuth Gaiters +1"}

		
	sets.idle.Town = {
		main="Bolelabunga",
		sub="Genmei Shield",
		range="Dunna",
        head="Moogle Masque",
		neck="Loricate Torque +1",
		ear1="Genmei Earring",
		ear2="Dignitary's Earring",
        body="Mallquis Saio +2",
		hands="Bagua Mitaines +1",
		ring1="Defending Ring",
		ring2="Vocane Ring +1",
        back="Lifestream Cape",
		waist="Eschan Stone",
		legs="Volte Brais",
		feet="Azimuth Gaiters +1"}

    sets.idle.Weak = sets.idle
	
	
    sets.idle.PDT = {
		main="Idris",
		sub="Genmei Shield",
		range="Dunna",
        head="Befouled Crown",
		neck="Loricate Torque +1",
		ear1="Genmei Earring",
		ear2="Dignitary's Earring",
        body="Mallquis Saio +2",
		hands="Bagua Mitaines +1",
		ring1="Defending Ring",
		ring2="Vocane Ring +1",
        back="Lifestream Cape",
		waist="Eschan Stone",
		legs="Volte Brais",
		feet="Azimuth Gaiters +1"}

    
	---------------------------------------------------------------------------------------------------
    -- Bubble sets
    ---------------------------------------------------------------------------------------------------
    sets.idle.Pet = {
		main="Idris",
		sub="Genmei Shield",
		range="Dunna",
        head={ name="Telchine Cap", augments={'Pet: "Regen"+3','Pet: Damage taken -2%',}},
		neck="Loricate Torque +1",
		ear1="Genmei Earring",
		ear2="Sanare Earring",
        body="Mallquis Saio +2",
		hands="Shrieker's Cuffs",
		ring1="Defending Ring",
		ring2="Vocane Ring +1",
        back={ name="Nantosuelta's Cape", augments={'Eva.+20 /Mag. Eva.+20','Pet: "Regen"+10',}},
		waist="Isa Belt",
		legs={ name="Telchine Braconi", augments={'Pet: "Regen"+2','Pet: Damage taken -4%',}},
		feet={ name="Telchine Pigaches", augments={'Pet: "Regen"+3','Pet: Damage taken -3%',}}}

    sets.idle.PDT.Pet = {
		main="Idris",
		sub="Genmei Shield",
		range="Dunna",
        head="Azimuth Hood +1",
		neck="Loricate Torque +1",
		ear2="Loquacious Earring",
        body="Mallquis Saio +2",
		hands="Geomancy mitaines +1",
		ring1="Defending Ring",
		ring2="Vocane Ring +1",
        back="Lifestream Cape",
		legs="Volte Brais",
		feet="Merlinic Crackows"}
		
	sets.idle.Pet.Regen = set_combine(sets.idle.Pet, {back={ name="Nantosuelta's Cape", augments={'Eva.+20 /Mag. Eva.+20','Pet: "Regen"+10',}}})

    -- .Indi sets are for when an Indi-spell is active.
    sets.idle.Indi = set_combine(sets.idle, {main="Idris",})
    sets.idle.Pet.Indi = set_combine(sets.idle.Pet, {main="Idris", })
    sets.idle.PDT.Indi = set_combine(sets.idle.PDT, {main="Idris",})
    sets.idle.PDT.Pet.Indi = set_combine(sets.idle.PDT.Pet, {main="Idris", })

	---------------------------------------------------------------------------------------------------
    -- Defensive and Misc sets
	---------------------------------------------------------------------------------------------------

    sets.defense.PDT = {
		range="Dunna",
        head="Nahtirah Hat",
		neck="Loricate Torque +1",
		ring1="Defending Ring",
		ring2="Vocane Ring +1",
        back="Lifestream Cape"}

    sets.defense.MDT = {
		range="Dunna",
        head="Nahtirah Hat",
		neck="Loricate Torque +1",
        ring1="Defending Ring",
		ring2="Vocane Ring +1",
        back="Lifestream Cape"}

    sets.Kiting = {feet="Azimuth Gaiters +1"}

    sets.latent_refresh = {waist="Fucho-no-obi"}

	sets.defense.DT = {
	    }

	
	sets.defense.Resist = sets.defense.DT
---------------------------------------------------------------------------------------------------
-- Idle/Defensive/Pet/Other sets
---------------------------------------------------------------------------------------------------

    sets.engaged = sets.idle.PDT.Pet

    
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
     cancel_conflicting_buffs(spell, action, spellMap, eventArgs)
	 custom_aftermath_timers_precast(spell, action, spellMap, eventArgs)
	 refine_spells(spell, action, spellMap, eventArgs)
end

function job_midcast(spell, action, spellMap, eventArgs)
		--Cancels Ni shadows
	 if spell.name == 'Utsusemi: Ichi' and overwrite then
        send_command('cancel Copy Image|Copy Image (2)')
    end
end

function job_aftercast(spell, action, spellMap, eventArgs)
    if not spell.interrupted then
        if spell.english:startswith('Indi') then
            if not classes.CustomIdleGroups:contains('Indi') then
                classes.CustomIdleGroups:append('Indi')
            end
            send_command('@timers d "'..indi_timer..'"')
            indi_timer = spell.english
            send_command('@timers c "'..indi_timer..'" '..indi_duration..' down spells/00136.png')
        elseif spell.english == 'Sleep' or spell.english == 'Sleepga' then
            send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 60 down spells/00220.png')
        elseif spell.english == 'Sleep II' or spell.english == 'Sleepga II' then
            send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 90 down spells/00220.png')
        end
    elseif not player.indi then
        classes.CustomIdleGroups:clear()
    end
    
end


-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
	if state.MagicBurst.value == 'MagicBurst' and spell.skill == 'Elemental Magic' then
		equip(sets.midcast['Elemental Magic'].MagicBurst)
	end
	if spell.skill == 'Elemental Magic' then
        if spell.element == world.day_element or spell.element == world.weather_element then
            equip(sets.midcast['Elemental Magic'], {waist="Hachirin-no-Obi"})
        end
	end 
	if not spell.interrupted then
		if buffactive['Entrust'] and spell.english:startswith('Indi') then
			equip(sets.midcast.Entrust)
		end
	end
end
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if player.indi and not classes.CustomIdleGroups:contains('Indi')then
        classes.CustomIdleGroups:append('Indi')
        handle_equipping_gear(player.status)
    elseif classes.CustomIdleGroups:contains('Indi') and not player.indi then
        classes.CustomIdleGroups:clear()
        handle_equipping_gear(player.status)
    end
end

function job_state_change(stateField, newValue, oldValue)
    if stateField == 'Offense Mode' then
        if newValue == 'Normal' then
            disable('main','sub','range')
        else
            enable('main','sub','range')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_get_spell_map(spell, default_spell_map)
		if spell.skill == 'Geomancy' then
            if spell.english:startswith('Indi') then
                return 'Indi'
            end
        end
    end


-------------------------------------------------------------------------------------------------------------------
    -- Custom idle sets to keep warp rings on.
-------------------------------------------------------------------------------------------------------------------


function customize_idle_set(idleSet)
    if player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
    end
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


	

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    classes.CustomIdleGroups:clear()
    if player.indi then
        classes.CustomIdleGroups:append('Indi')
    end
end

-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end


--Refine Nuke Spells	
function refine_spells(spell, action, spellMap, eventArgs)
	
	aspirs = S{'Aspir','Aspir II','Aspir III'}
	sleeps = S{'Sleep II','Sleep'}
	sleepgas = S{'Sleepga II','Sleepga'}
	nukes = S{'Fire', 'Blizzard', 'Aero', 'Stone', 'Thunder', 'Water',
	'Fire II', 'Blizzard II', 'Aero II', 'Stone II', 'Thunder II', 'Water II',
	'Fire III', 'Blizzard III', 'Aero III', 'Stone III', 'Thunder III', 'Water III',
	'Fire IV', 'Blizzard IV', 'Aero IV', 'Stone IV', 'Thunder IV', 'Water IV',
	'Fire V', 'Blizzard V', 'Aero V', 'Stone V', 'Thunder V', 'Water V',
	'Fire VI', 'Blizzard VI', 'Aero VI', 'Stone VI', 'Thunder VI', 'Water VI',
	'Firaga', 'Blizzaga', 'Aeroga', 'Stonega', 'Thundaga', 'Waterga',
	'Firaga II', 'Blizzaga II', 'Aeroga II', 'Stonega II', 'Thundaga II', 'Waterga II',
	'Firaga III', 'Blizzaga III', 'Aeroga III', 'Stonega III', 'Thundaga III', 'Waterga III',	
	'Firaja', 'Blizzaja', 'Aeroja', 'Stoneja', 'Thundaja', 'Waterja',
	}
	
	cures = S{'Cure IV','Cure V','Cure VI','Cure III','Cure II','Cure','Curaga III','Curaga II', 'Curaga', 'Raise'}

	local newSpell = spell.english
	local spell_recasts = windower.ffxi.get_spell_recasts()
	local cancelling = 'All '..spell.english..' spells are on cooldown. Cancelling spell casting.'
	
	
	
	if spell.skill == 'Healing Magic' then
		if not cures:contains(spell.english) then
			eventArgs.cancel = true
			return
		end
	
		
		if spell_recasts[spell.recast_id] > 0 then
			if cures:contains(spell.english) then
				if spell.english == 'Cure' then
						add_to_chat(122,cancelling)	
					return
				elseif spell.english == 'Cure VI' then
						newSpell = 'Cure V'
				elseif spell.english == 'Cure V' then
						newSpell = 'Cure IV'
				elseif spell.english == 'Cure IV' then
						newSpell = 'Cure III'
				elseif spell.english == 'Cure III' then
						newSpell = 'Cure II'
				elseif spell.english == 'Cure II' then
						newSpell = 'Cure'
				
				
					end
				end
			end
			
		if newSpell ~= spell.english then
				send_command('@input /ma "'..newSpell..'" '..tostring(spell.target.raw))	
				return
		end
	elseif spell.skill == 'Dark Magic' then
		if not aspirs:contains(spell.english) then
			return
		end
		

		if spell_recasts[spell.recast_id] > 0 then
			if aspirs:contains(spell.english) then
				if spell.english == 'Aspir' then
					add_to_chat(122,cancelling)
					eventArgs.cancel = true
				return
				elseif spell.english == 'Aspir III' then
					newSpell = 'Aspir II'
				elseif spell.english == 'Aspir II' then
					newSpell = 'Aspir'
				
				end
			end
		end
		
		if newSpell ~= spell.english then
			send_command('@input /ma "'..newSpell..'" '..tostring(spell.target.raw))
			eventArgs.cancel = true
			return
		end
	elseif spell.skill == 'Elemental Magic' then
		if not sleepgas:contains(spell.english) and not sleeps:contains(spell.english) and not nukes:contains(spell.english) then
			return
		end

		if spell_recasts[spell.recast_id] > 0 then
			if sleeps:contains(spell.english) then
				if spell.english == 'Sleep' then
					add_to_chat(122,cancelling)
					eventArgs.cancel = true
				return
				elseif spell.english == 'Sleep II' then
					newSpell = 'Sleep'
				end
			elseif sleepgas:contains(spell.english) then
				if spell.english == 'Sleepga' then
					add_to_chat(122,cancelling)
					eventArgs.cancel = true
					return
				elseif spell.english == 'Sleepga II' then
					newSpell = 'Sleepga'
				end
			elseif nukes:contains(spell.english) then	
				if spell.english == 'Fire' then
					eventArgs.cancel = true
					return
				elseif spell.english == 'Fire VI' then
					newSpell = 'Fire V'
				elseif spell.english == 'Fire V' then
					newSpell = 'Fire IV'
				elseif spell.english == 'Fire IV' then
					newSpell = 'Fire III'	
				elseif spell.english == 'Fire III' then
					newSpell = 'Fire II'
				elseif spell.english == 'Fire II' then
					newSpell = 'Fire'
				end 
				if spell.english == 'Blizzard' then
					eventArgs.cancel = true
					return
				elseif spell.english == 'Blizzard VI' then
					newSpell = 'Blizzard V'
				elseif spell.english == 'Blizzard V' then
					newSpell = 'Blizzard IV'
				elseif spell.english == 'Blizzard IV' then
					newSpell = 'Blizzard III'	
				elseif spell.english == 'Blizzard III' then
					newSpell = 'Blizzard II'
				elseif spell.english == 'Blizzard II' then
					newSpell = 'Blizzard'
				end 
				if spell.english == 'Aero' then
					eventArgs.cancel = true
					return
				elseif spell.english == 'Aero VI' then
					newSpell = 'Aero V'
				elseif spell.english == 'Aero V' then
					newSpell = 'Aero IV'
				elseif spell.english == 'Aero IV' then
					newSpell = 'Aero III'	
				elseif spell.english == 'Aero III' then
					newSpell = 'Aero II'
				elseif spell.english == 'Aero II' then
					newSpell = 'Aero'
				end 
				if spell.english == 'Stone' then
					eventArgs.cancel = true
					return
				elseif spell.english == 'Stone VI' then
					newSpell = 'Stone V'
				elseif spell.english == 'Stone V' then
					newSpell = 'Stone IV'
				elseif spell.english == 'Stone IV' then
					newSpell = 'Stone III'	
				elseif spell.english == 'Stone III' then
					newSpell = 'Stone II'
				elseif spell.english == 'Stone II' then
					newSpell = 'Stone'
				
				end 
				if spell.english == 'Thunder' then
					eventArgs.cancel = true
					return
				elseif spell.english == 'Thunder VI' then
					newSpell = 'Thunder V'
				elseif spell.english == 'Thunder V' then
					newSpell = 'Thunder IV'
				elseif spell.english == 'Thunder IV' then
					newSpell = 'Thunder III'	
				elseif spell.english == 'Thunder III' then
					newSpell = 'Thunder II'
				elseif spell.english == 'Thunder II' then
					newSpell = 'Thunder'
				
				end 
				if spell.english == 'Water' then
					eventArgs.cancel = true
					return
				elseif spell.english == 'Water VI' then
					newSpell = 'Water V'
				elseif spell.english == 'Water V' then
					newSpell = 'Water IV'
				elseif spell.english == 'Water IV' then
					newSpell = 'Water III'	
				elseif spell.english == 'Water III' then
					newSpell = 'Water II'
				elseif spell.english == 'Water II' then
					newSpell = 'Water'
				end 
			end
		end

		if newSpell ~= spell.english then
			send_command('@input /ma "'..newSpell..'" '..tostring(spell.target.raw))
			eventArgs.cancel = true
			return
		end
	end
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    set_macro_page(1, 18)
end
