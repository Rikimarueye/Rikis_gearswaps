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

    include('Mote-TreasureHunter')
	
	get_combat_weapon()
	
	state.TreasureMode:set('Tag')
	
	state.Buff.doom = buffactive.doom or false
    state.Buff.Sleep = buffactive.Sleep or false
    state.Buff.Terror = buffactive.Terror or false
    state.Buff.Stun = buffactive.Stun or false
    state.Buff.Petrification = buffactive.Petrification or false
	
	--Teleport Rings!
    state.WarpMode = M{['description']='Transportation Ring is now', 'Off', 'Warp', 'Jima: Holla', 'Jima: Dem'}
	
	state.CombatWeapon = M{['description']='Weapon', 'Kali', 'Aeneas'}
	

    state.Buff['Pianissimo'] = buffactive['pianissimo'] or false
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal')
    state.CastingMode:options('Normal', 'Resistant')
    
    
    
    -- Additional local binds
    send_command('bind !` input /ma "Chocobo Mazurka" <me>')
	send_command('bind ^z gs c cycle WarpMode')
	send_command('bind ^` gs c cycle Carolpotency')
	send_command('bind ^a gs c cycle CombatWeapon')

    select_default_macro_book()
end


-- Called when this job file is unloaded (eg: job change)
function user_unload()
    send_command('unbind ^`')
    send_command('unbind !`')
	send_command('unbind ^z')
	send_command('unbind ^a')
end


-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Start defining the sets
    --------------------------------------
    
    sets.Warp = {ring2="Warp Ring"}
  
    sets.Holla = {ring2="Dim. Ring (Holla)"}
	
	sets.Dem = {ring2="Dim. Ring (Dem)"}
 
    sets.TreasureHunter = {waist="Chaac Belt"}
	
	sets.Kali = {main="Kali"}
	
	sets.Aeneas = {main="Aeneas"}
	
	-----------------------------------------------------------------------------------------------------------------------
	-- Precast sets
	-----------------------------------------------------------------------------------------------------------------------
    
    -- Fast cast sets for spells
    sets.precast.FC = {
		head="Nahtirah Hat",
        body="Zendik Robe",
        neck="Orunmila's Torque",
		legs="Ayanmo Cosciales +2",
		hands="Leyline Gloves",
		waist="Witful Belt",
        left_ear="Loquac. Earring",
		ear2="Enchanter Earring +1",
        left_ring="Lebeche Ring",
        right_ring="Kishar Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}}}

    sets.precast.FC.Cure = set_combine(sets.precast.FC, {
	    ear2="Mendicant's Earring"})

    sets.precast.FC.Stoneskin = set_combine(sets.precast.FC, {
	    head="Umuthi Hat",
		waist="Siegel Sash"})

    sets.precast.FC['Enhancing Magic'] = set_combine(sets.precast.FC, {})

    sets.precast.FC.BardSong = {
	    main="Kali",
	    ranged="Daurdabla",
	    head="Fili Calot +1",
        body="Zendik Robe",
        hands="Leyline Gloves",
        legs="Querkening Brais",
		feet={ name="Telchine Pigaches", augments={'Song spellcasting time -5%','Enh. Mag. eff. dur. +8',}},
        neck="Orunmila's Torque",
		waist="Witful Belt",
        ear1="Loquac. Earring",
		ear2="Enchanter Earring +1",
        left_ring="Lebeche Ring",
        right_ring="Kishar Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}}}

    sets.precast.FC["Honor March"] = set_combine(sets.precast.FC.BardSong,{range="Marsyas"})   
    
	-----------------------------------------------------------------------------------------------------------------------
	-- Precast for JAs
	-----------------------------------------------------------------------------------------------------------------------
   
    sets.precast.JA.Nightingale = {feet="Bihu Slippers +1"}
    sets.precast.JA.Troubadour = {body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}}}
    sets.precast.JA['Soul Voice'] = {legs="Bihu Cannions +1"}

    -- Waltz set (chr and vit)
    sets.precast.Waltz = {}
    
    -----------------------------------------------------------------------------------------------------------------------
	-- WS sets
	-----------------------------------------------------------------------------------------------------------------------   
    
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head="Lustratio Cap +1",
		neck="Bard's Charm",
		body={ name="Bihu Jstcorps. +3", augments={'Enhances "Troubadour" effect',}},
		ear1="Ishvara Earring",
	    ear2="Moonshade Earring",
	    ring1="Hetairoi Ring",
		ring2="Ilabrat Ring",
		waist="Grunfeld Rope",
		legs="Lustratio Subligar +1",
		feet="Lustratio Leggings +1"}
    
    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS)

    sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS)

    sets.precast.WS['Mordant Rime'] = {
		ear2="Handler's earring +1",
		ring2="Carbuncle Ring +1",
		waist="Aristo Belt"}
	
	
	-----------------------------------------------------------------------------------------------------------------------
	-- Staple of all damage.
	-----------------------------------------------------------------------------------------------------------------------
	
	sets.precast.WS["Rudra's Storm"] = {
	    head="Lustratio Cap +1",
	    neck="Caro Necklace",
		ear1="Ishvara Earring",
	    ear2="Moonshade Earring",
		body="Ayanmo Corazza +2",
		hands={ name="Chironic Gloves", augments={'Accuracy+11 Attack+11','"Dbl.Atk."+1','Accuracy+15','Attack+12',}},
	    ring1="Cacoethic Ring +1",
		ring2="Ilabrat Ring",
		back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}},
		waist="Grunfeld Rope",
		legs="Lustratio Subligar +1",
		feet="Lustratio Leggings +1"}
    
	sets.precast.WS['Aeolian Edge'] = sets.precast.WS
	    
    
	-----------------------------------------------------------------------------------------------------------------------
	-- Midcast sets
	-----------------------------------------------------------------------------------------------------------------------

    -- General set for recast times.
    sets.midcast.FastRecast = {
	    head="Nahtirah Hat",
        body="Zendik Robe",
        neck="Orunmila's Torque",
		waist="Witful Belt",
        left_ear="Loquac. Earring",
		ear2="Enchanter Earring +1",
        left_ring="Lebeche Ring",
        right_ring="Kishar Ring",
		back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}}}
        
   
    

	-----------------------------------------------------------------------------------------------------------------------
	-- Song Buffs (duration)
	-----------------------------------------------------------------------------------------------------------------------
   
    sets.midcast.SongEffect = {
	    range="Gjallarhorn",
	    main="Kali",
		sub="Ammurapi Shield",
        head="Fili Calot +1",
		neck="Moonbow Whistle +1",
		ear1="Loquacious Earring",
		ear2="Enchanter Earring +1",
        body="Fili Hongreline +1",
		hands="Fili Manchettes +1",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
        waist="Witful Belt",
		legs="Inyanga Shalwar +2",
		feet="Brioso Slippers +3"}

	-----------------------------------------------------------------------------------------------------------------------
	-- Song Debuffs (Duration and MAccuracy)
	-----------------------------------------------------------------------------------------------------------------------
	
    -- Duration
    sets.midcast.SongDebuff = {
	    main="Kali",
		sub="Ammurapi Shield",
		range="Gjallarhorn",
        head="Brioso Roundlet +3",
		neck="Moonbow Whistle +1",
		ear1="Dignitary's Earring",
		ear2="Regal Earring",
        body="Brioso Justau. +3",
		hands="Brioso Cuffs +3",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
        back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},
		waist="Eschan Stone",
		legs="Inyanga Shalwar +2",
		feet="Brioso Slippers +3"}

    -- MAccuracy
    sets.midcast.ResistantSongDebuff = {
	    main="Grioavolr",
		sub="Enki Strap",
	    head="Brioso Roundlet +3",
		neck="Moonbow Whistle +1",
		ear1="Dignitary's Earring",
		ear2="Regal Earring",
        body="Brioso Justau. +3",
		hands="Brioso Cuffs +3",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
        back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},
		waist="Eschan Stone",
		legs="Inyanga Shalwar +2",
		feet="Brioso Slippers +3"}

    -- Song-specific recast reduction
    sets.midcast.SongRecast = {
	    main="Kali",
		sub="Ammurapi Shield",
        head="Fili Calot +1",
		ear1="Loquacious Earring",
		ear2="Enchanter Earring +1",
        body="Fili Hongreline +1",
		hands="Fili Manchettes +1",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
        waist="Witful Belt",
		legs="Inyanga Shalwar +2",
		feet="Brioso Slippers +3"}

    
	-----------------------------------------------------------------------------------------------------------------------
	--Potency to BRD songs
	-----------------------------------------------------------------------------------------------------------------------
	
    sets.midcast.Lullaby = set_combine(sets.midcast.SongDebuff,{
	    range="Gjallarhorn",
		body="Fili Hongreline +1",
		hands="Brioso Cuffs +3"})
	
    sets.midcast.Madrigal = set_combine(sets.midcast.SongEffect,{
	   
		
		head="Fili Calot +1",
		back="Intarabus's Cape"})
	
    sets.midcast.March = set_combine(sets.midcast.SongEffect,{
	 
		
		hands="Fili Manchettes +1"})
	
	sets.midcast["Honor March"] = set_combine(sets.midcast.March,{range="Marsyas"})
	
    sets.midcast.Minuet = set_combine(sets.midcast.SongEffect,{
	 
		
		body="Fili Hongreline +1"})
	
    sets.midcast.Minne = set_combine(sets.midcast.SongEffect,{
	
		
		legs="Mousai Seraweels"})
	
    sets.midcast.Paeon = set_combine(sets.midcast.SongEffect,{
	
		
		head="Brioso Roundlet +3"})
	
    sets.midcast.Carol = set_combine(sets.midcast.SongEffect,{
	    
		head="Fili Calot +1",
        body="Fili Hongreline +1",
		hands="Mousai Gages",
        legs="Fili Rhingrave +1",
		feet="Fili Cothurnes +1"})
		
		
    sets.midcast["Sentinel's Scherzo"] = set_combine(sets.midcast.SongEffect,{
	   
	
		feet="Fili Cothurnes +1"})
	
    sets.midcast['Magic Finale'] = set_combine(sets.midcast.SongDebuff,{
	    range="Gjallarhorn",
		sub="Ammurapi Shield",
		})
	
	sets.midcast.Mazurka = set_combine(sets.midcast.SongEffect,{

        })
	
	sets.midcast.Threnody = set_combine(sets.midcast.SongDebuff,{

		body="Mousai Manteel",})
	
    sets.midcast.Prelude = set_combine(sets.midcast.SongEffect,{
	
	
		back="Intarabus's Cape"})
		
	sets.midcast.Ballad = set_combine(sets.midcast.SongEffect,{
	
	
		legs="Fili Rhingrave +1"})
		
		
	sets.midcast.Etude = {range="Daurdabla",neck="Loricate Torque +1"}
		
	-----------------------------------------------------------------------------------------------------------------------
	-- Midcasts: WHM Subbed
	-----------------------------------------------------------------------------------------------------------------------
   
    sets.midcast.Cure = {
		main="Serenity",
	    head={ name="Vanya Hood", augments={'MP+50','"Cure" potency +7%','Enmity-6',}},
        body="Vanya Robe",
        hands="Kaykaus Cuffs",
        legs={ name="Vanya Slops", augments={'MND+10','Spell interruption rate down +15%','"Conserve MP"+6',}},
        feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
        neck="Orunmila's Torque",
        waist="Witful Belt",
        ear2="Loquac. Earring",
		ear1="Mendicant's Earring",
        left_ring="Lebeche Ring",
        right_ring="Kishar Ring",
        }
        
    sets.midcast.Curaga = sets.midcast.Cure
        
    sets.midcast.Stoneskin = {
        neck="Nodens Gorget",
		ear1="Earthcry Earring",
		waist="Siegel Sash"}
        
    sets.midcast.Cursna = {hands="Hieros Mittens"}

	
	sets.midcast['Haste'] = {
		sub="Ammurapi Shield",
	    ring1="Stikini Ring",
		ring2="Stikini Ring",
		hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +7',}},
        legs={ name="Telchine Braconi", augments={'Accuracy+14 Attack+14','"Dbl.Atk."+3','Enh. Mag. eff. dur. +8',}},
        feet={ name="Telchine Pigaches", augments={'Song spellcasting time -5%','Enh. Mag. eff. dur. +8',}}}
		 
    sets.midcast['Enfeebling Magic'] = {
        main={ name="Grioavolr", augments={'Enfb.mag. skill +13','INT+15','Mag. Acc.+30','"Mag.Atk.Bns."+15','Magic Damage +1',}},
        head="Brioso Roundlet +3",
		neck="Moonbow Whistle +1",
		ear1="Genmei Earring",
		ear2="Regal Earring",
        body="Brioso Justau. +3",
		hands="Brioso Cuffs +3",
		ring1="Stikini Ring",
		ring2="Stikini Ring",
        back={ name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},
		waist="Eschan Stone",
		legs="Inyanga Shalwar +2",
		feet="Brioso Slippers +3"}
		 

    
	-----------------------------------------------------------------------------------------------------------------------
	-- Resting sets
	-----------------------------------------------------------------------------------------------------------------------
    
    sets.resting = {}
    
    
	-----------------------------------------------------------------------------------------------------------------------
	-- Idle sets
	-----------------------------------------------------------------------------------------------------------------------
    
    sets.idle = {
	    ranged="Daurdabla",
	    head="Bihu Roundlet +1",
		neck="Bard's Charm",
        body="Ayanmo Corazza +2",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
		ear2="Odnowa Earring +1",
        hands="Ayanmo Manopolas +2",
        legs="Assid. Pants +1",
        feet="Bihu Slippers +1",
        back="Moonbeam Cape"}

    sets.idle.Town = {
	    range="Daurdabla",
	    head="Bihu Roundlet +1",
		neck="Loricate Torque +1",
        body="Ayanmo Corazza +2",
		ring1="Vocane Ring +1",
		ring2="Defending Ring",
        hands="Leyline Gloves",
        legs="Assid. Pants +1",
        feet="Vanya Clogs",
        back="Moonbeam Cape"}
    
    sets.idle.Weak = {
        head="Bihu Roundlet +1",
		neck="Bard's Charm",
		ear1="Genmei Earring",
        ring1="Defending Ring",
		ring2="Vocane Ring +1",
		legs="Bihu Cannions +1",
		feet="Bihu Slippers +1",
        back="Moonbeam Cape"}
    
    
	-----------------------------------------------------------------------------------------------------------------------
	-- Defense sets
	-----------------------------------------------------------------------------------------------------------------------

    sets.defense.PDT = {
        head="Bihu Roundlet +1",
		neck="Loricate Torque +1",
		ear1="Genmei Earring",
        ring1="Defending Ring",
		ring2="Vocane Ring +1",
		legs="Ayanmo Cosciales +2",
		feet="Bihu Slippers +1",
        back="Moonbeam Cape"}

    sets.defense.MDT = {
	    neck="Loricate Torque +1",
        ring1="Defending Ring",
		ring2="Purity Ring",
        back="Moonbeam Cape"}
		
	sets.defense.DT = {
	    head="Bihu Roundlet +1",
		neck="Loricate Torque +1",
		ear1="Genmei Earring",
        ring1="Defending Ring",
		ring2="Vocane Ring +1",
		legs="Ayanmo Cosciales +2",
		feet="Bihu Slippers +1",
        back="Moonbeam Cape"}

    sets.Kiting = {}

    sets.latent_refresh = {waist="Fucho-no-obi"}

	
	-----------------------------------------------------------------------------------------------------------------------
	-- Engaged sets
	-----------------------------------------------------------------------------------------------------------------------
	
	-- Set if dual-wielding
    sets.engaged.Kali = {
        sub="Ammurapi Shield",
        head="Ayanmo Zucchetto +2",
        neck="Combatant's Torque",
        ear1="Eabani Earring",
        ear2="Suppanomimi",
        body="Ayanmo Corazza +2",
        hands="Ayanmo Manopolas +2",
        legs="Ayanmo Cosciales +2",
        feet="Aya. Gambieras +1",
        ring1="Petrov Ring",
	    ring2="Epona's Ring",
	    waist="Reiki Yotai",
        back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}}}
    
    sets.engaged.Aeneas = {
        sub="Twashtar",
		range="Linos",
        head="Ayanmo Zucchetto +2",
        neck="Bard's Charm",
        ear1="Eabani Earring",
        ear2="Suppanomimi",
        body="Ayanmo Corazza +2",
        hands="Ayanmo Manopolas +2",
        legs="Ayanmo Cosciales +2",
        feet="Aya. Gambieras +1",
        ring1="Hetairoi Ring",
	    ring2="Ilabrat Ring",
	    waist="Reiki Yotai",
        back={ name="Intarabus's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10',}}}


    
		

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------------------------------------------
	-- Prevent WS loss and Pianissimo automated use
	-----------------------------------------------------------------------------------------------------------------------
function job_precast(spell, action, spellMap, eventArgs)
    cancel_conflicting_buffs(spell, action, spellMap, eventArgs)
	custom_aftermath_timers_precast(spell, action, spellMap, eventArgs)
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
			else
				cancel_spell()
				windower.add_to_chat(121, ''..player.tp..'TP is not enough to WS')
			end
		else
			cancel_spell()
			windower.add_to_chat(121, 'You must be Engaged to WS')
    end
	
end	
	
	if spell.type == 'BardSong' then
        -- Auto-Pianissimo
        if ((spell.target.type == 'PLAYER' and not spell.target.charmed) or (spell.target.type == 'NPC' and spell.target.in_party)) and
            not state.Buff['Pianissimo'] then
            
            local spell_recasts = windower.ffxi.get_spell_recasts()
            if spell_recasts[spell.recast_id] < 2 then
                send_command('@input /ja "Pianissimo" <me>; wait 1.5; input /ma "'..spell.name..'" '..spell.target.name)
                eventArgs.cancel = true
                return
            end
        end
		
    end
end


-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
    if spell.action_type == 'Magic' then
        if spell.type == 'BardSong' then
            -- layer general gear on first, then let default handler add song-specific gear.
            local generalClass = get_song_class(spell)
            if generalClass and sets.midcast[generalClass] then
                equip(sets.midcast[generalClass])
            end
        end
    end
end



    -----------------------------------------------------------------------------------------------------------------------
	-- Ninjustsu cycling
	-----------------------------------------------------------------------------------------------------------------------


function job_post_midcast(spell, action, spellMap, eventArgs)
   
	if spell.name == 'Utsusemi: Ichi' and overwrite then
     send_command('cancel Copy Image|Copy Image (2)')
  end
end


    -----------------------------------------------------------------------------------------------------------------------
	-- Ninjustsu cycling continued
	-----------------------------------------------------------------------------------------------------------------------
	
function job_aftercast(spell, action, spellMap, eventArgs)
	custom_aftermath_timers_aftercast(spell, action, spellMap, eventArgs)
    if spell.type == 'Ninjutsu' and not spell.interrupted then
        if spell.name == 'Utsusemi: Ichi' then
            overwrite = false
        elseif spell.name == 'Utsusemi: Ni' then
            overwrite = true
        end
	end
end

  ----------------------------------------------------------------------------
  -- Aftermath notification, debuff equip DT set
  ----------------------------------------------------------------------------
function job_buff_change(buff,gain, eventArgs)
    

    
    if buff:lower()=='sleep' then
        if gain and player.hp > 120 and player.status == "Engaged" then 
            equip(sets.defense.DT)
        elseif not gain then 
            handle_equipping_gear(player.status)
        end
    elseif buff:lower()=='terror' then
        if gain and player.status == "Engaged" then 
           equip(sets.defense.DT)
			     disable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'left_ring' , 'right_ring')
        elseif not gain then 
		         enable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'left_ring' , 'right_ring')
           handle_equipping_gear(player.status)
        end
    elseif buff:lower()=='petrification' then
        if gain and player.status == "Engaged" then 
           equip(sets.defense.DT)
			     disable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'left_ring' , 'right_ring')
        elseif not gain then 
		         enable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'left_ring' , 'right_ring')
           handle_equipping_gear(player.status)
        end 
    elseif buff:lower()=='stun' then
        if gain and player.status == "Engaged" then 
           equip(sets.defense.DT)
			     disable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'left_ring' , 'right_ring')
        elseif not gain then 
		         enable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'left_ring' , 'right_ring')
           handle_equipping_gear(player.status)
        end     
    end
	-- Used with Timers Plugin to create and delete custom timers for aftermath levels
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
	end
end

---------------------------------------------------------------------------------------------------
-- CombatForm to take into account facing or AM. Always update here.
---------------------------------------------------------------------------------------------------	
function get_combat_weapon()
    if player.equipment.type == 'Dagger' then
		if state.CombatWeapon.value == 'Kali' then
			state.CombatWeapon:set('Kali')
        elseif state.CombatWeapon.value == 'Aeneas' then
			state.CombatWeapon:set('Aeneas') 
        end
    else
			state.CombatForm:reset()
		
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Handle notifications of general user state change.
function job_state_change(stateField, newValue, oldValue)
    if new_status == 'Engaged' then
		get_combat_weapon()
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    gearmode()
	get_combat_weapon()
end

function gearmode()
  if state.CombatWeapon.value == 'Kali' then
		equip(sets.Kali)
		handle_equipping_gear(player.status)
	elseif state.CombatWeapon.value == 'Aeneas' then
		equip(sets.Aeneas)
		handle_equipping_gear(player.status)
  end
end



-- Modify the default idle set after it was constructed.
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


-- Function to display the current relevant user state when doing an update.
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Determine the custom class to use for the given song.
function get_song_class(spell)
    -- Can't use spell.targets:contains() because this is being pulled from resources
    if set.contains(spell.targets, 'Enemy') then
        if state.CastingMode.value == 'Resistant' then
            return 'ResistantSongDebuff'
        else
            return 'SongDebuff'
        end
    else
        return 'SongEffect'
    end
end



-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
  if player.sub_job == 'WHM' then
        set_macro_page(1, 17)
  elseif player.sub_job == 'NIN' then
        set_macro_page(1, 17)
  elseif player.sub_job == 'DNC' then
        set_macro_page(1, 17)
  else
        set_macro_page(1, 17)
  end
end
