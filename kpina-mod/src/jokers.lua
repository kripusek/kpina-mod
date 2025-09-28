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









