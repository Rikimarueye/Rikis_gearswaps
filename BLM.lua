  -------------------------------------------------------------------------------------------------------------------
  -- Setup functions for this job.  Generally should not be modified.
  -------------------------------------------------------------------------------------------------------------------
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

  --------------------------------------------------------------------------------------------------------------------
  -- Setup independent variables 
  --------------------------------------------------------------------------------------------------------------------
function job_setup()
    include('Mote-TreasureHunter')
  
    state.TreasureMode:set('Tag')
	state.Buff.doom = buffactive.doom or false
    state.Buff.Sleep = buffactive.Sleep or false
    state.Buff.Terror = buffactive.Terror or false
    state.Buff.Stun = buffactive.Stun or false
    state.Buff.Petrification = buffactive.Petrification or false
	 
	state.Buff['Mana Wall'] = buffactive['Mana Wall'] or false
	
	
	-- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
 
end

  --------------------------------------------------------------------------------------------------------------------
  -- USER SETUP FUNCTIONS FOR THIS JOB FILE.  
  --------------------------------------------------------------------------------------------------------------------
function user_setup()
    state.OffenseMode:options('Normal')
    state.IdleMode:options('Normal', 'Death')

    ---------------------------------------------------------------
	-- Cycle between warp gear and normal
	----------------------------------------------------------------

    	
	state.MagicBurst = M{['description']='Mage Mode', 'Normal', 'MagicBurst'}
	
	---------------------------------------------------------------
	-- Cycle between warp gear and normal
	----------------------------------------------------------------	
	state.WarpMode = M{['description']='Transportation Ring is now', 'Off', 'Warp', 'Jima: Holla', 'Jima: Dem'}


	----------------------------------------------------------------
	-- Additional local binds
	----------------------------------------------------------------    
	send_command('bind ^` gs c cycle MagicBurst')
	send_command('bind ^z gs c cycle WarpMode')
	

	----------------------------------------------------------------
	-- Select macro book
	----------------------------------------------------------------
    select_default_macro_book()
end

  ----------------------------------------------------------------------------
  -- Called when this job file is unloaded (eg: job change)
  ----------------------------------------------------------------------------
function user_unload()
	send_command('unbind ^`')
	
	send_command('unbind ^z')
end

function init_gear_sets()
  --------------------------------------------------------------------------------------------------------------------
  -- DEFINE SPECIAL SETS
  --------------------------------------------------------------------------------------------------------------------
	sets.CP = {back="Mecisto. Mantle"}
	
	sets.Warp = {right_ring="Warp Ring"}
  
	sets.Holla = {ring2="Dim. Ring (Holla)"}
	
	sets.Dem = {ring2="Dim. Ring (Dem)"}
 
	sets.TreasureHunter = {waist="Chaac Belt"}

	sets.buff.doom = {
		waist="Gishdubar sash",
		left_ring="Saida ring",
		right_ring="Purity ring"}
  
	sets.latent_refresh = {waist="Fucho-no-obi"}
  
	sets.buff['Mana Wall'] = {
		feet="Wicce Sabots +1",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}
    
  --------------------------------------------------------------------------------------------------------------------
  -- DEFINE JOB ABILITY PRECAST SETS
  --------------------------------------------------------------------------------------------------------------------
	sets.precast.JA['Mana Wall'] = {
		feet="Wicce Sabots +1",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},}
  
	sets.precast.JA['Manafont'] = {}
  
	sets.precast.JA.Convert = {}

  --------------------------------------------------------------------------------------------------------------------
  -- DEFINE WEAPONSKILL SETS 
  --------------------------------------------------------------------------------------------------------------------
	sets.precast.WS = {}
 
	sets.precast.WS['Vidohunir'] = {}
	
	sets.precast.WS['Myrkr'] = {
		main={ name="Grioavolr", augments={'Magic burst dmg.+5%','Mag. Acc.+24','"Mag.Atk.Bns."+23','Magic Damage +1',}},
	    sub="Enki Strap",
		ammo="Strobilus",
	    head="Pixie Hairpin +1",
		body={ name="Weather. Robe +1", augments={'MP+120',}},
		ear1="Etiolation Earring",
		ear2="Moonshade Earring",
		hands="Amalric Gages",
	    ring1="Mephitas's Ring +1",
		ring2="Mephitas's Ring",
		waist="Shinjutsu-no-obi +1",
		legs="Amalric Slops",
		neck="Dualism Collar +1",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Mag.Atk.Bns."+10',}},
		feet="Psycloth Boots"}
 
  ----------------------------------------------------------------
  -- DEFINE FAST CAST SET
  ----------------------------------------------------------------
	sets.precast.FC = {
		main={ name="Grioavolr", augments={'Magic burst dmg.+5%','Mag. Acc.+24','"Mag.Atk.Bns."+23','Magic Damage +1',}},
		sub="Enki Strap",
		ammo="Sapience Orb",
        head={ name="Merlinic Hood", augments={'"Fast Cast"+7','CHR+6','"Mag.Atk.Bns."+8',}},
		neck="Voltsurge Torque",
		ear1="Etiolation Earring",
		ear2="Loquacious Earring",
        body={ name="Merlinic Jubbah", augments={'Mag. Acc.+10','"Fast Cast"+5','"Mag.Atk.Bns."+1',}},
		hands={ name="Merlinic Dastanas", augments={'"Mag.Atk.Bns."+7','"Fast Cast"+7','INT+10',}},
		ring1="Rahab Ring",
		ring2="Kishar Ring",
        back={ name="Taranus's Cape", augments={'MP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10',}},
	    waist="Witful Belt",
		legs="Psycloth Lappas",
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','"Fast Cast"+5','INT+5','Mag. Acc.+11',}}}
  
	sets.precast.FC['Death'] = {
		 sub="Enki Strap",ammo="Strobilus",
	     head={ name="Merlinic Hood", augments={'"Fast Cast"+7','CHR+6','"Mag.Atk.Bns."+8',}},
		 body={ name="Merlinic Jubbah", augments={'Mag. Acc.+10','"Fast Cast"+5','"Mag.Atk.Bns."+1',}},
		 ear1="Etiolation Earring",
		 ear2="Evans Earring",
		 hands="Amalric Gages",
	     ring1="Mephitas's Ring +1",
		 ring2="Mephitas's Ring",
		 waist="Shinjutsu-no-obi +1",
		 legs="Psycloth Lappas",
		 neck="Voltsurge Torque",
		 back={ name="Taranus's Cape", augments={'MP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10',}},
		 feet={ name="Merlinic Crackows", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','"Fast Cast"+5','INT+5','Mag. Acc.+11',}}}
  
	sets.precast.FC['Enhancing Magic'] = sets.precast.FC
	
	sets.precast.FC['Stoneskin'] = set_combine(sets.precast.FC, {head="Umuthi Hat",waist="Siegel Sash",legs="Doyen Pants"})
  
	sets.precast.FC['Elemental Magic'] = {
		main={ name="Grioavolr", augments={'Magic burst dmg.+5%','Mag. Acc.+24','"Mag.Atk.Bns."+23','Magic Damage +1',}},
		sub="Enki Strap",
		ammo="Sapience Orb",
        head={ name="Merlinic Hood", augments={'"Fast Cast"+7','CHR+6','"Mag.Atk.Bns."+8',}},
		neck="Voltsurge Torque",
		ear1="Barkarole Earring",
		ear2="Loquacious Earring",
        body={ name="Merlinic Jubbah", augments={'Mag. Acc.+10','"Fast Cast"+5','"Mag.Atk.Bns."+1',}},
		hands={ name="Merlinic Dastanas", augments={'"Mag.Atk.Bns."+7','"Fast Cast"+7','INT+10',}},
		ring1="Rahab Ring",
		ring2="Kishar Ring",
        back={ name="Taranus's Cape", augments={'MP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10',}},
	    waist="Witful Belt",
		legs="Psycloth Lappas",
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','"Fast Cast"+5','INT+5','Mag. Acc.+11',}}}
  
	sets.precast.FC.Cure = set_combine(sets.precast.FC, {legs="Doyen Pants"})
  
	sets.precast.FC.Curaga = sets.precast.FC.Cure
  
  
  --------------------------------------------------------------------------------------------------------------------
  -- DEFINE MIDCAST SETS
  --------------------------------------------------------------------------------------------------------------------
	sets.midcast.FastRecast = {
		ear1="Etiolation Earring",
		ear2="Loquacious Earring",
        body={ name="Merlinic Jubbah", augments={'Mag. Acc.+10','"Fast Cast"+5','"Mag.Atk.Bns."+1',}},
		ring1="Kishar Ring",
		back={ name="Taranus's Cape", augments={'MP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10',}},
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+19 "Mag.Atk.Bns."+19','"Fast Cast"+5','INT+5','Mag. Acc.+11',}}}

	sets.midcast.Cure = {
		head="Vanya Hood",
		body="Vrikodara Jupon",
		neck="Nodens Gorget",
		legs="Vanya Slops",
		feet="Vanya Clogs",
		ring1="Lebeche Ring",
		}
  
	sets.midcast.Curaga = sets.midcast.Cure
  
	sets.midcast['Enhancing Magic'] = {
		ring1="Stikini Ring",
		ring2="Stikini Ring",
	    hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +7',}},
        legs={ name="Telchine Braconi", augments={'Accuracy+14 Attack+14','"Dbl.Atk."+3','Enh. Mag. eff. dur. +8',}},
        feet={ name="Telchine Pigaches", augments={'Song spellcasting time -5%','Enh. Mag. eff. dur. +8',}}}
  
	sets.midcast['Haste'] = {
		ring1="Mephitas's Ring +1",
		ring2="Mephitas's Ring",
		hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +7',}},
        legs={ name="Telchine Braconi", augments={'Accuracy+14 Attack+14','"Dbl.Atk."+3','Enh. Mag. eff. dur. +8',}},
        feet={ name="Telchine Pigaches", augments={'Song spellcasting time -5%','Enh. Mag. eff. dur. +8',}}}

	sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
	    neck="Nodens Gorget",
		ear1="Earthcry Earring",
		waist="Siegel Sash"})
  
	sets.midcast.Refresh = sets.midcast['Enhancing Magic']
  
	sets.midcast.Regen = sets.midcast['Enhancing Magic']
  
	sets.midcast.Aquaveil = sets.midcast['Enhancing Magic']
  
	sets.midcast['Enfeebling Magic'] = {
        ammo="Pemphredo Tathlum",
	    head="Befouled Crown",
		body="Vanya Robe",
		ear1="Genmei Earring",
		ear2="Regal Earring",
		hands="Amalric Gages",
	    ring1="Stikini Ring",
		ring2="Stikini Ring",
		waist="Rumination Sash",
		legs="Psycloth Lappas",
		neck="Imbodla Necklace",
		feet="Medium's Sabots"}
  
	sets.midcast.ElementalEnfeeble = sets.midcast['Enfeebling Magic']
  
	sets.midcast['Dark Magic'] = {
		ammo="Pemphredo Tathlum",
	    head="Pixie Hairpin +1",
		body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+4','"Mag.Atk.Bns."+11',}},
		ear1="Regal Earring",
		ear2="Hirudinea Earring",
		hands="Amalric Gages",
	    ring1="Evanescence Ring",
		ring2="Archon Ring",
		waist="Fucho-no-obi",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic Damage +6','INT+14','Mag. Acc.+15','"Mag.Atk.Bns."+10',}},
		neck="Erra Pendant",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Fast Cast"+2','MND+3','Mag. Acc.+12','"Mag.Atk.Bns."+15',}}}
  
	sets.midcast.Drain = sets.midcast['Dark Magic']
  
	sets.midcast.Aspir = sets.midcast.Drain
  
	sets.midcast.Stun = {
		main={ name="Grioavolr", augments={'Magic burst dmg.+5%','Mag. Acc.+24','"Mag.Atk.Bns."+23','Magic Damage +1',}},
	    sub="Enki Strap",ammo="Pemphredo Tathlum",
	    head={ name="Merlinic Hood", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','INT+15','Mag. Acc.+15','"Mag.Atk.Bns."+5',}},
		body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+4','"Mag.Atk.Bns."+11',}},
		ear1="Etiolation Earring",
		ear2="Loquacious Earring",
		hands="Amalric Gages",
	    ring1="Shiva Ring +1",
		ring2="Shiva Ring +1",
		waist="Refoccilation Stone",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic Damage +6','INT+14','Mag. Acc.+15','"Mag.Atk.Bns."+10',}},
		neck="Sanctity Necklace",
		back={ name="Taranus's Cape", augments={'MP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10',}},
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Fast Cast"+2','MND+3','Mag. Acc.+12','"Mag.Atk.Bns."+15',}}}
   
	sets.midcast['Elemental Magic'] = {
		main={ name="Grioavolr", augments={'Magic burst dmg.+5%','Mag. Acc.+24','"Mag.Atk.Bns."+23','Magic Damage +1',}},
	    sub="Enki Strap",
		ammo="Pemphredo Tathlum",
	    head={ name="Merlinic Hood", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','INT+15','Mag. Acc.+15','"Mag.Atk.Bns."+5',}},
		body="Spaekona's Coat +3",
		ear1="Friomisi Earring",
		ear2="Regal Earring",
		hands="Amalric Gages",
	    ring1="Acumen Ring",
		ring2="Shiva Ring +1",
		waist="Refoccilation Stone",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic Damage +6','INT+14','Mag. Acc.+15','"Mag.Atk.Bns."+10',}},
		neck="Saevus Pendant +1",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Fast Cast"+2','MND+3','Mag. Acc.+12','"Mag.Atk.Bns."+15',}}}
    
	sets.midcast['Elemental Magic'].MagicBurst =  {
		main={ name="Grioavolr", augments={'Magic burst dmg.+5%','Mag. Acc.+24','"Mag.Atk.Bns."+23','Magic Damage +1',}},
		sub="Enki Strap",
		ammo="Pemphredo Tathlum",
	    head={ name="Merlinic Hood", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','INT+15','Mag. Acc.+15','"Mag.Atk.Bns."+5',}},
		body="Spaekona's Coat +3",
		ear1="Friomisi Earring",
		ear2="Regal Earring",
		hands="Amalric Gages",
	    ring1="Locus Ring",
		ring2="Mujin Band",
		waist="Hachirin-no-Obi",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic Damage +6','INT+14','Mag. Acc.+15','"Mag.Atk.Bns."+10',}},
		neck="Mizu. Kubikazari",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
		feet="Jhakri Pigaches +2"}
  
	sets.midcast.Death = {
		main={ name="Grioavolr", augments={'Magic burst dmg.+5%','Mag. Acc.+24','"Mag.Atk.Bns."+23','Magic Damage +1',}},
	    sub="Enki Strap",ammo="Strobilus",
	    head="Pixie Hairpin +1",
		body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+4','"Mag.Atk.Bns."+11',}},
		ear1="Etiolation Earring",
		ear2="Regal Earring",
		hands="Amalric Gages",
	    ring1="Mephitas's Ring +1",
		ring2="Archon Ring",
		waist="Hachirin-no-Obi",
		legs="Amalric Slops",
		neck="Mizu. Kubikazari",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Mag.Atk.Bns."+10',}},
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Fast Cast"+2','MND+3','Mag. Acc.+12','"Mag.Atk.Bns."+15',}}}
  
	sets.midcast.Death.MagicBurst = {
		main={ name="Grioavolr", augments={'Magic burst dmg.+5%','Mag. Acc.+24','"Mag.Atk.Bns."+23','Magic Damage +1',}},
	    sub="Enki Strap",ammo="Strobilus",
	    head="Pixie Hairpin +1",
		body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+4','"Mag.Atk.Bns."+11',}},
		ear1="Etiolation Earring",
		ear2="Regal Earring",
		hands="Amalric Gages",
	    ring1="Mephitas's Ring +1",
		ring2="Archon Ring",
		waist="Hachirin-no-Obi",
		legs="Amalric Slops",
		neck="Mizu. Kubikazari",
		back={ name="Taranus's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','MP+20','"Mag.Atk.Bns."+10',}},
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Fast Cast"+2','MND+3','Mag. Acc.+12','"Mag.Atk.Bns."+15',}}}
  
	sets.midcast.Comet = {
		main={ name="Grioavolr", augments={'Magic burst dmg.+5%','Mag. Acc.+24','"Mag.Atk.Bns."+23','Magic Damage +1',}},
	    sub="Enki Strap",
		ammo="Pemphredo Tathlum",
	    head="Pixie Hairpin +1",
		body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+4','"Mag.Atk.Bns."+11',}},
		ear1="Friomisi Earring",
		ear2="Regal Earring",
		hands="Amalric Gages",
	    ring1="Shiva Ring +1",
		ring2="Archon Ring",
		waist="Refoccilation Stone",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic Damage +6','INT+14','Mag. Acc.+15','"Mag.Atk.Bns."+10',}},
		neck="Sanctity Necklace",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
		feet={ name="Merlinic Crackows", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','"Fast Cast"+2','MND+3','Mag. Acc.+12','"Mag.Atk.Bns."+15',}}}
  
	sets.midcast.Comet.MagicBurst = {
		main={ name="Grioavolr", augments={'Magic burst dmg.+5%','Mag. Acc.+24','"Mag.Atk.Bns."+23','Magic Damage +1',}},
	    sub="Enki Strap",
		ammo="Strobilus",
	    head="Pixie Hairpin +1",
		body={ name="Merlinic Jubbah", augments={'Mag. Acc.+24 "Mag.Atk.Bns."+24','INT+8','Mag. Acc.+4','"Mag.Atk.Bns."+11',}},
		ear1="Friomisi Earring",
		ear2="Regal Earring",
		hands="Amalric Gages",
	    ring1="Mujin Band",
		ring2="Archon Ring",
		waist="Hachirin-no-Obi",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic Damage +6','INT+14','Mag. Acc.+15','"Mag.Atk.Bns."+10',}},
		neck="Mizu. Kubikazari",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
		feet="Jhakri Pigaches +2"}
  
	sets.midcast['Dia'] = {feet={ name="Merlinic Crackows", augments={'Pet: Attack+19 Pet: Rng.Atk.+19','Pet: Mag. Acc.+11 Pet: "Mag.Atk.Bns."+11','"Treasure Hunter"+1','Accuracy+8 Attack+8','Mag. Acc.+10 "Mag.Atk.Bns."+10',}}}
  --------------------------------------------------------------------------------------------------------------------
  -- DEFINE IDLE SETS
  --------------------------------------------------------------------------------------------------------------------
	sets.idle = {
		sub="Enki Strap",
		ammo="Strobilus",
		head={ name="Merlinic Hood", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','INT+15','Mag. Acc.+15','"Mag.Atk.Bns."+5',}},
		body="Mallquis Saio +2",
		ear1="Etiolation Earring",
		ear2="Evans Earring",
		hands="Amalric Gages",
	    ring1="Vocane Ring +1",
		ring2="Defending Ring",
		waist="Shinjutsu-no-obi +1",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic Damage +6','INT+14','Mag. Acc.+15','"Mag.Atk.Bns."+10',}},
		neck="Dualism Collar +1",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
		feet="Psycloth Boots"}
  
	sets.idle.Death = {
		sub="Enki Strap",
		ammo="Strobilus",
		head={ name="Merlinic Hood", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','INT+15','Mag. Acc.+15','"Mag.Atk.Bns."+5',}},
		body={ name="Weather. Robe +1", augments={'MP+120',}},
		ear1="Etiolation Earring",
		ear2="Evans Earring",
		hands="Amalric Gages",
	    ring1="Vocane Ring +1",
		ring2="Defending Ring",
		waist="Shinjutsu-no-obi +1",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic Damage +6','INT+14','Mag. Acc.+15','"Mag.Atk.Bns."+10',}},
		neck="Dualism Collar +1",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
		feet="Psycloth Boots"}
  
	sets.idle.Weak = sets.idle
  
	sets.idle.Town = {
		sub="Enki Strap",ammo="Strobilus",
	    head={ name="Merlinic Hood", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','INT+15','Mag. Acc.+15','"Mag.Atk.Bns."+5',}},
		body="Mallquis Saio +2",
		ear1="Etiolation Earring",
		ear2="Evans Earring",
		hands="Amalric Gages",
	    ring1="Vocane Ring +1",
		ring2="Defending Ring",
		waist="Shinjutsu-no-obi +1",
		legs={ name="Merlinic Shalwar", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Magic Damage +6','INT+14','Mag. Acc.+15','"Mag.Atk.Bns."+10',}},
		neck="Dualism Collar +1",
		back={ name="Taranus's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',}},
		feet="Psycloth Boots"}
    
  --------------------------------------------------------------------------------------------------------------------
  -- DEFINE RESTING SETS
  --------------------------------------------------------------------------------------------------------------------
	sets.resting = {}
    
  --------------------------------------------------------------------------------------------------------------------
  -- DEFINE ENGAGED SETS
  --------------------------------------------------------------------------------------------------------------------
	sets.engaged = {}

	sets.engaged.DT = {}
	
	
	
	sets.Hachirin = set_combine(sets.midcast['Elemental Magic'].MagicBurst, {waist="Hachirin-no-Obi"})
	
	
 end
 	
  ----------------------------------------------------------------------------
  -- Cancels Weaponskill if to far away
  ----------------------------------------------------------------------------
function job_precast(spell, action, spellMap, eventArgs)
     cancel_conflicting_buffs(spell, action, spellMap, eventArgs)
	 custom_aftermath_timers_precast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Ability' then
		if spell.english == "Accession" and buffactive['Dark Arts'] then
			eventArgs.cancel = true
			windower.send_command('@input /ja "Manifestation" <me>')
			return
		elseif spell.english == "Alacrity" and buffactive['Light Arts'] then
			eventArgs.cancel = true
			windower.send_command('@input /ja "Celerity" <me>')
			return
		elseif spell.english == "Celerity" and buffactive['Dark Arts'] then
			eventArgs.cancel = true
			windower.send_command('@input /ja "Alacrity" <me>')
			return
		elseif spell.english == "Dark Arts" and buffactive['Dark Arts'] then
			eventArgs.cancel = true
			windower.send_command('@input /ja "Addendum: Black" <me>')
			return
		elseif spell.english == "Light Arts" and buffactive['Light Arts'] then
			eventArgs.cancel = true
			windower.send_command('@input /ja "Addendum: White" <me>')
			return
		elseif spell.english == "Manifestation" and buffactive['Light Arts'] then
			eventArgs.cancel = true
			windower.send_command('@input /ja "Accession" <me>')
			return
		elseif spell.english == "Parsimony" and buffactive['Light Arts'] then
			eventArgs.cancel = true
			windower.send_command('@input /ja "Penury" <me>')
			return
		elseif spell.english == "Penury" and buffactive['Dark Arts'] then
			eventArgs.cancel = true
			windower.send_command('@input /ja "Parsimony" <me>')
			return
		end
	elseif spell.action_type == 'Magic' then
		if spell.skill == 'Dark Magic' then
			if spell.english:startswith('Drain') then
				equip(sets.precast.FC.Drain)
			elseif spell.english:startswith('Aspir') then
				equip(sets.precast.FC.Aspir)
			else
				equip(sets.precast.FC['Dark Magic'])
			end
		elseif spell.skill == 'Elemental Magic' then
			equip(sets.precast.FC['Elemental Magic'])
		elseif spell.skill == 'Enfeebling Magic' then
			equip(sets.precast.FC['Enfeebling Magic'])
		elseif spell.skill == 'Enhancing Magic' then
			if spell.english:startswith('Stoneskin') then
				equip(sets.precast.FC.Stoneskin)
			else
				equip(sets.precast.FC['Enhancing Magic'])
			end
		elseif spell.skill == 'Healing Magic' then
			equip(sets.precast.FC.Cure)
		end
	elseif spell.skill == 'Death' then
		    equip(sets.precast.FC.Death)
	end
end
  ----------------------------------------------------------------------------
  -- Ninjitsu shadow control
  ----------------------------------------------------------------------------
function job_midcast(spell, action, spellMap, eventArgs)
		--Cancels Ni shadows
	 if spell.name == 'Utsusemi: Ichi' and overwrite then
        send_command('cancel Copy Image|Copy Image (2)')
    end
	if state.Buff['Mana Wall'] then
		equip(sets.buff['Mana Wall'])
	end
	if spell.action_type == 'Magic' then
		if spell.element == world.day_element or spell.element == world.weather_element then
				equip(sets.Hachirin)
			if spell.skill == 'Enfeebling Magic' then
				if spell.english:startswith('Paralyze*|Slow*|Silence') then
					equip(sets.midcast['Enfeebling Magic'].Mnd)
				else
					equip(sets.midcast['Enfeebling Magic'])
				end
			elseif spell.skill == 'Enhancing Magic' then
			if spell.english:startswith('Warp*|Retrace|Escape|Tractor') then
					equip(sets.midcast.FastRecast)
				end
			end
		end
	end
	
end


function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.skill == 'Elemental Magic' then
	
		if state.MagicBurst.value == 'MagicBurst' then
			equip(sets.midcast['Elemental Magic'].MagicBurst)

		elseif spell.skill == 'Comet' then
			if state.MagicBurst.value == 'MagicBurst'  then
				equip(sets.midcast.Comet.MagicBurst)
			end
        elseif spell.element == world.day_element or spell.element == world.weather_element then
            equip(sets.midcast['Elemental Magic'], {waist="Hachirin-no-Obi"})
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

		elseif spell.english == 'Mana Wall' then
			enable('feet')
			enable('back')
			equip(sets.buff['Mana Wall'])
			disable('feet')
			disable('back')
		elseif spell.english == 'Sleep' or spell.english == 'Sleepga' then
            send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 60 down spells/00220.png')
        elseif spell.english == 'Sleep II' or spell.english == 'Sleepga II' then
            send_command('@timers c "'..spell.english..' ['..spell.target.name..']" 90 down spells/00220.png')
        end
    end
end

  ----------------------------------------------------------------------------
  -- Aftermath notification, sleep wake up, and debuff equip DT set
  ----------------------------------------------------------------------------
function job_buff_change(buff,gain, eventArgs)
   
	
    if buff:lower()=='sleep' then
        if gain and player.hp > 120 and player.status == "Engaged" then 
            equip()
        elseif not gain then 
            handle_equipping_gear(player.status)
        end
    elseif buff:lower()=='terror' then
        if gain and player.status == "Engaged" then 
           equip(sets.engaged.DT)
			     disable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'left_ring' , 'right_ring')
        elseif not gain then 
		         enable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'left_ring' , 'right_ring')
           handle_equipping_gear(player.status)
        end
    elseif buff:lower()=='petrification' then
        if gain and player.status == "Engaged" then 
           equip(sets.engaged.DT)
			     disable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'left_ring' , 'right_ring')
        elseif not gain then 
		         enable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'left_ring' , 'right_ring')
           handle_equipping_gear(player.status)
        end 
    elseif buff:lower()=='stun' then
        if gain and player.status == "Engaged" then 
           equip(sets.engaged.DT)
			     disable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'left_ring' , 'right_ring')
        elseif not gain then 
		         enable('head' , 'body' , 'hands' , 'back' , 'legs' , 'feet' , 'left_ring' , 'right_ring')
           handle_equipping_gear(player.status)
        end
    elseif buff:lower()=='doom' then
        if gain and player.status == "Engaged" then 
            equip(sets.buff.doom)
			disable('legs' , 'waist' , 'left_ring' , 'right_ring')
			add_to_chat(8, 'Doomed!!! Use Holy Waters!!!')
        elseif not gain then 
		    enable('left_ring' , 'right_ring')
            handle_equipping_gear(player.status)
		end
	end
	if buff == "Mana Wall" and not gain then
			enable('feet')
			enable('back')
			handle_equipping_gear(player.status)
	end
end
 
  ----------------------------------------------------------------------------
  -- sleep wake up, debuff equip DT set, and Sets Weapon to engaged set to include offensive mode being used
  ----------------------------------------------------------------------------
function customize_melee_set(meleeSet)
    if state.Buff.Sleep and player.hp > 120 and player.status == "Engaged" then
        meleeSet = set_combine(meleeSet,{})
    elseif state.Buff.Terror and player.status == "Engaged" then
        meleeSet = (sets.engaged.DT)
    elseif state.Buff.Petrification and player.status == "Engaged" then
        meleeSet = (sets.engaged.DT)
    elseif state.Buff.Stun and player.status == "Engaged" then
        meleeSet = (sets.engaged.DT)    
    end
    return meleeSet        
end

  ----------------------------------------------------------------------------
  -- updates idlemode use transportation rings
  ----------------------------------------------------------------------------
function customize_idle_set(idleSet)
    if state.WarpMode.value == 'Warp' then
		idleSet = set_combine(idleSet, sets.Warp)
	elseif state.WarpMode.value == 'Jima: Holla' then
        idleSet = set_combine(idleSet, sets.Holla)
	elseif state.WarpMode.value == 'Jima: Dem' then
        idleSet = set_combine(idleSet, sets.Dem)
    elseif state.WarpMode.value == 'Off' then
		idleSet = set_combine(idleSet)
	elseif player.mpp < 51 then
        idleSet = set_combine(idleSet, sets.latent_refresh)
	end
    return idleSet
end



  ----------------------------------------------------------------------------
  -- Capacity point bonus set
  ----------------------------------------------------------------------------
 
  
  
function display_current_job_state(eventArgs)
    display_current_caster_state()
    eventArgs.handled = true
end


  -------------------------------------------------------------------------------------------------------------------
  -- Select macro book on initial load or subjob change
  -------------------------------------------------------------------------------------------------------------------
function select_default_macro_book()
  -- Default macro set/book
  if player.sub_job == 'RDM' then
    set_macro_page(1, 2)
  elseif player.sub_job == 'SCH' then
    set_macro_page(1, 2)
  elseif player.sub_job == 'WHM' then
    set_macro_page(1, 2)
  else
    set_macro_page(1, 2)
  end
end