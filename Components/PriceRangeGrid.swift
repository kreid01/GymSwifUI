import SwiftUI

struct PriceRangeGrid : View {
    
    @State var priceRanges: [PriceRangeDTO]
    
    var body : some View {
        List {
            Grid {
                GridRow {
                    Text("Name")
                    Text("Low")
                    Text("Mid")
                    Text("High")
                    Text("Market")
                }
                .bold()
                Divider()
                ForEach(priceRanges) { value in
                    GridRow {
                        Text(value.name)
                            .font(. system(size: 16))
                        Text(value.lowString)
                            .font(. system(size: 16))
                        Text(value.midString)
                            .font(. system(size: 16))
                        Text(value.highString)
                            .font(. system(size: 16))
                        Text(value.marketString)
                            .font(. system(size: 16))
                    }
                    if value != priceRanges.last {
                        Divider()
                    }
                }
            }
        }.scrollContentBackground(.hidden)
            .background(.white.opacity(0))
    }

}
