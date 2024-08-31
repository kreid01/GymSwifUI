struct CollectionValue {
    let normalPriceRange: PriceRangeDTO;
    let holoPriceRange: PriceRangeDTO;
    let reversePriceRange: PriceRangeDTO;
    
    let estimatedTotals: [PriceRangeDTO]
    
    init(normalPriceRange: PriceRangeDTO, holoPriceRange: PriceRangeDTO, reversePriceRange: PriceRangeDTO) {
        self.normalPriceRange = normalPriceRange
        self.holoPriceRange = holoPriceRange
        self.reversePriceRange = reversePriceRange
        self.estimatedTotals = [normalPriceRange, holoPriceRange, reversePriceRange]
    }
}
