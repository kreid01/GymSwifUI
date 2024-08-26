//
//  CollectionValueUtils.swift
//  GymUI
//
//  Created by Kieran Reid on 26/08/2024.
//

import Foundation

class CollectionValueUtils {
    func getCollectionValue(cards: [Card]) -> CollectionValue {
        let normalLow = getTotals(values: cards.map { $0.tcgplayer?.prices.normal?.low })
        let normalMid = getTotals(values: cards.map { $0.tcgplayer?.prices.normal?.mid })
        let normalHigh = getTotals(values: cards.map { $0.tcgplayer?.prices.normal?.high })
        let normalMarket = getTotals(values: cards.map { $0.tcgplayer?.prices.normal?.market })

        let holofoilLow = getTotals(values: cards.map { $0.tcgplayer?.prices.holofoil?.low })
        let holofoilMid = getTotals(values: cards.map { $0.tcgplayer?.prices.holofoil?.mid })
        let holofoilHigh = getTotals(values: cards.map { $0.tcgplayer?.prices.holofoil?.high })
        let holofoilMarket = getTotals(values: cards.map { $0.tcgplayer?.prices.holofoil?.market })

        let reverseHolofoilLow = getTotals(values: cards.map { $0.tcgplayer?.prices.reverseHolofoil?.low })
        let reverseHolofoilMid = getTotals(values: cards.map { $0.tcgplayer?.prices.reverseHolofoil?.mid })
        let reverseHolofoilHigh = getTotals(values: cards.map { $0.tcgplayer?.prices.reverseHolofoil?.high })
        let reverseHolofoilMarket = getTotals(values: cards.map { $0.tcgplayer?.prices.reverseHolofoil?.market })

        let normalPriceRange = PriceRange(
            low: normalLow,
            mid: normalMid,
            high: normalHigh,
            market: normalMarket
        )

        let holofoilPriceRange = PriceRange(
            low: holofoilLow,
            mid: holofoilMid,
            high: holofoilHigh,
            market: holofoilMarket
        )

        let reverseHolofoilPriceRange = PriceRange(
            low: reverseHolofoilLow,
            mid: reverseHolofoilMid,
            high: reverseHolofoilHigh,
            market: reverseHolofoilMarket
        )
        
        let normalDTO = PriceRangeDTO(priceRange: normalPriceRange, priceName: "Normal")

        let holoDTO = PriceRangeDTO(priceRange: holofoilPriceRange, priceName: "Holofoil")

        let reverseDTO = PriceRangeDTO(priceRange: reverseHolofoilPriceRange, priceName: "Reverse Holo")
        
        return CollectionValue(normalPriceRange: normalDTO
                               , holoPriceRange: holoDTO, reversePriceRange: reverseDTO)
    }
    
    func getTotals(values: [Float?]) -> Float {
        return values.reduce(0, { x, y in x + (y ?? 0) })
    }
}
