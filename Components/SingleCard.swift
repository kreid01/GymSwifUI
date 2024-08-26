import SwiftUI

struct SingleCard : View {
    @State var card: Card;
    
    var body: some View {
        NavigationLink(destination: CardView(card: card)) {
            VStack {
                URLImage(width: 100, urlString: card.images.large)
                Text(card.name)
                    .padding()
                    .font(.custom("VT323", size: 16))
                    .foregroundColor(.black)
            }.frame(height:200)
        }
    }
}
