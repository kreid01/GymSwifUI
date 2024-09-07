func sortCards(sort: Int, cards: [Card]) -> [Card] {
    var newCards = cards
    if sort == 0 { return newCards }
    newCards.sort {
        if sort == 1 {
            return $0.name < $1.name
        }
        if sort == 2 {
            return $0.name > $1.name
        }
        if sort == 3 {
            if let type1 = $0.types?[0], let type2 = $1.types?[0] {
                return type1 < type2
            }
        }
        if sort == 4 {
            if let type1 = $0.types?[0], let type2 = $1.types?[0] {
                return type1 > type2
            }
        }
        if sort == 5 {
            return getTotalPriceAverage(prices: $0.tcgplayer?.prices ?? nil) < getTotalPriceAverage(prices: $1.tcgplayer?.prices)
        } else {
            return getTotalPriceAverage(prices: $0.tcgplayer?.prices) > getTotalPriceAverage(prices: $1.tcgplayer?.prices)
        }
    }
    return newCards
}

func getTotalPriceAverage(prices: Prices?) -> Float {
    var allPrices: [Float] = []
    if prices == nil {
        return 0
    }

    if let holofoilPrices = prices!.holofoil {
        allPrices.append(contentsOf: getValidPrices(from: holofoilPrices))
    }

    if let normalPrices = prices!.normal {
        allPrices.append(contentsOf: getValidPrices(from: normalPrices))
    }

    if let reverseHolofoilPrices = prices!.reverseHolofoil {
        allPrices.append(contentsOf: getValidPrices(from: reverseHolofoilPrices))
    }

    guard !allPrices.isEmpty else {
        return 0
    }

    let totalSum = allPrices.reduce(0, +)
    return totalSum / Float(allPrices.count)
}

private func getValidPrices(from priceRange: PriceRange) -> [Float] {
    return [priceRange.low, priceRange.mid, priceRange.high, priceRange.market]
        .compactMap { $0 }
        .filter { $0 > 0 }
}
