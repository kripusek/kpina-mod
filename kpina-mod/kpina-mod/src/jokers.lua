SMODS.Atlas{
    key = 'jokers',
    path = 'jokers.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'fercho',
    loc_txt = {
        name = 'kjebab',
        text = {
			'This Joker gives {X:mult,C:white}X#1#{} Mult for',
			'each {C:money}$1{} of {C:attention}sell value{} on the {C:attention}leftmost{} Joker,',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}',
			
		}
	},
	rarity = 4,
    blueprint_compat = true,

	-- Which atlas key to pull from.
	atlas = 'jokers',
	-- This card's position on the atlas, starting at {x=0,y=0} for the very top left.
	pos = { x = 0, y = 0 },
	-- Cost of card in shop.
	cost = 25,
	-- put all variables in here
	config = { extra = { xmult = 1, ferchoxmult = 1 } },

	loc_vars = function(self, info_queue, card)
		if card.area and card.area == G.jokers then
			return { vars = { card.ability.extra.xmult, card.ability.extra.xmult * G.jokers.cards[1].sell_cost } }
		else
			return { vars = { card.ability.extra.xmult, card.ability.extra.xmult } }
		end
	end,



	calculate = function(self, card, context)
		if context.before and context.main_eval and not context.blueprint then
			card.ability.extra.ferchoxmult = G.jokers.cards[1].sell_cost
		end
		if context.joker_main then
			return {
				xmult = card.ability.extra.ferchoxmult
			}
		end
	end
}

SMODS.Joker {
    key = 'kropka308',
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_txt = {
        name = 'kropka308',
        text = {
            'Gains {C:mult}-1{} Mult for each {C:attention}face card{} scored,',
            'and {C:mult}+0.5{} Mult for each {C:attention}non-face card{} scored.',
            '{C:inactive}(Currently {C:mult}#1#{C:inactive} Mult){}'
        }
    },
    rarity = 4,
    atlas = 'jokers',
    pos = { x = 1, y = 0 },
    cost = 25,

    config = { extra = { mult = 0 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { string.format("%.1f", card.ability.extra.mult) } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            local scored_card = context.other_card
            if not scored_card.debuff then
                if scored_card:is_face() then
                    card.ability.extra.mult = card.ability.extra.mult - 1
                    return {
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = "-1",
                            colour = G.C.RED
                        }),
                    }
                else
                    card.ability.extra.mult = card.ability.extra.mult + 0.5
                    return {
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = "+0.5",
                            colour = G.C.MULT
                        }),
                    }
                end
            end
        end

        if context.before and context.main_eval and not context.blueprint then
            for i = 1, #context.scoring_hand do
                local scored_card = context.scoring_hand[i]
                if not scored_card.debuff then
                    if scored_card:is_face() then
                        card.ability.extra.mult = card.ability.extra.mult - 1
                    else
                        card.ability.extra.mult = card.ability.extra.mult + 0.5
                    end
                end
            end
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker {
    key = 'rzempik',
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_txt = {
        name = 'rzempik',
        text = {
            'At end of round, {C:attention}eats{} adjacent {C:attention}Jokers{}.',
        'Gains {C:mult}X1{} Mult for each {C:attention}Joker{} eaten.',
        'If eats {C:attention}2 Jokers{}, gains {C:mult}X2.5{} Mult instead.',
        '{C:inactive}(Currently {C:mult}X#1#{C:inactive} Mult){}'
            
        }
    },
    rarity = 3,
    atlas = 'jokers',
    pos = { x = 2, y = 0 },
    cost = 25,

    config = { extra = { mult = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { string.format("%.1f", card.ability.extra.mult) } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    my_pos = i
                    break
                end
            end
            
            if my_pos then
                local jokers_eaten = 0
                local cards_to_remove = {}
                
                if my_pos > 1 then
                    table.insert(cards_to_remove, G.jokers.cards[my_pos - 1])
                    jokers_eaten = jokers_eaten + 1
                end
                
                if my_pos < #G.jokers.cards then
                    table.insert(cards_to_remove, G.jokers.cards[my_pos + 1])
                    jokers_eaten = jokers_eaten + 1
                end
                
                if jokers_eaten > 0 then
                    if jokers_eaten == 2 then
                        card.ability.extra.mult = card.ability.extra.mult + 2.5
                    else
                        card.ability.extra.mult = card.ability.extra.mult + 1
                    end
                    
                    for _, joker_card in ipairs(cards_to_remove) do
                        joker_card:remove()
                    end
                    
                    return {
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = "Ate " .. jokers_eaten .. " Joker" .. (jokers_eaten > 1 and "s" or ""),
                            colour = G.C.MULT
                        })
                    }
                end
            end
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker {
    key = 'michukelk',
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_txt = {
        name = 'michukelk',
        text = {
            'If you have a {C:attention}kjebab{} Joker,',
            'spawns a random {C:attention}Joker{} at end of round.'
        }
    },
    rarity = 4,
    atlas = 'jokers',
    pos = { x = 0, y = 1 },
    cost = 15,

    calculate = function(self, card, context)
        -- DEBUG: zobacz, czy calculate jest wołane i jakie mamy context.flags
        print('[michukelk] calculate called:',
              'end_of_round=' .. tostring(context.end_of_round or false),
              'cardarea=' .. (context.cardarea and (context.cardarea.name or tostring(context.cardarea)) or 'nil'),
              'repetition=' .. tostring(context.repetition or false),
              'individual=' .. tostring(context.individual or false),
              'blueprint=' .. tostring(context.blueprint or false))

        -- podstawowe guardy (uruchom tylko raz, przy zakończeniu rundy, dla kolekcji jokers)
        if not context.end_of_round then
            print('[michukelk] skipping: not end_of_round')
            return
        end
        if context.cardarea ~= G.jokers then
            print('[michukelk] skipping: context.cardarea ~= G.jokers')
            return
        end
        if context.repetition or context.individual or context.blueprint then
            print('[michukelk] skipping: repetition/individual/blueprint guard')
            return
        end

        -- Info o limitach
        local cur_count = #G.jokers.cards
        local cur_limit = (G.jokers.config and G.jokers.config.card_limit) or G.jokers.card_limit or 999
        print('[michukelk] jokers count=' .. tostring(cur_count) .. ' limit=' .. tostring(cur_limit))
        if cur_count >= cur_limit then
            print('[michukelk] skipping: card limit reached')
            return
        end

        -- SPRAWDZANIE: czy mamy "kjebab" (wiele metod - fallback)
        local function has_kjebab()
            -- metoda 1: SMODS.find_card (jeśli istnieje)
            if SMODS and SMODS.find_card then
                local found = SMODS.find_card('fercho')
                if found and #found > 0 then
                    print('[michukelk] found kjebab via SMODS.find_card')
                    return true
                end
            end

            -- metoda 2: iteracja G.jokers.cards i sprawdzenie center.key albo c.key
            for i = 1, #G.jokers.cards do
                local c = G.jokers.cards[i]
                local k = nil
                if c and c.config and c.config.center and c.config.center.key then
                    k = c.config.center.key
                elseif c and c.key then
                    k = c.key
                end
                if k == 'kjebab' or k == 'fercho' then
                    print('[michukelk] found kjebab by iter, key=' .. tostring(k))
                    return true
                end
            end

            print('[michukelk] kjebab not found')
            return false
        end

        if not has_kjebab() then
            return
        end

        -- Zbuduj pulę dostępnych Jokerów
        local joker_pool = {}
        for center_key, center_def in pairs(G.P_CENTERS) do
            if center_def.set == 'Joker' then
                table.insert(joker_pool, center_key)
            end
        end
        print('[michukelk] joker_pool size=' .. tostring(#joker_pool))
        if #joker_pool == 0 then
            print('[michukelk] no jokers in pool')
            return
        end

        local chosen = joker_pool[math.random(#joker_pool)]
        print('[michukelk] chosen center=' .. tostring(chosen))

        -- Funkcja próbująca różne metody stworzenia/dodania jokera (fallbacky)
        local function try_spawn(center_key)
            -- metoda A: create_card + add_to_deck + emplace / add_card / push
            local ok, err = pcall(function()
                local new_joker = create_card('Joker', G.jokers, nil, nil, nil, nil, center_key)
                if not new_joker then error('create_card returned nil') end
                if new_joker.add_to_deck then new_joker:add_to_deck() end
                if G.jokers.emplace then
                    G.jokers:emplace(new_joker)
                elseif G.jokers.add_card then
                    G.jokers:add_card(new_joker)
                elseif G.jokers.push then
                    G.jokers:push(new_joker)
                else
                    error('no known method to place joker into G.jokers')
                end
            end)
            if ok then return true end

            -- metoda B: SMODS.add_card (jeśli dostępna)
            if SMODS and SMODS.add_card then
                ok, err = pcall(function()
                    SMODS.add_card{ area = G.jokers, type = 'Joker', center = center_key }
                end)
                if ok then return true end
            end

            -- jeśli wszystkie zawiodły - zwróć błąd ostatni
            return false, err
        end

        local ok, err = try_spawn(chosen)
        if ok then
            print('[michukelk] spawn SUCCESS: ' .. tostring(chosen))
            return {
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = "Spawned Joker!",
                    colour = G.C.MULT
                })
            }
        else
            print('[michukelk] spawn FAILED: ' .. tostring(err))
            return {
                card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = "Spawn failed",
                    colour = G.C.RED
                })
            }
        end
    end
}






