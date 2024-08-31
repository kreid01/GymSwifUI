import Foundation

public struct WishlistRepository {
    func GetWishlistPokemon() -> [Card] {
        print( Storage.getWishlist())
        return Storage.getWishlist()
    }
    
    func AddToWishlist(card: Card) {
       var wishlist = Storage.getWishlist()
        
        if wishlist.contains(where: {$0.id == card.id}) {
            return;
        }

        if wishlist.count == 0 {
            Storage.saveWishlist(wishlist: [card])
        } else {
            wishlist.append(card)
            Storage.saveWishlist(wishlist:wishlist)
        }
    }
    
    func RemoveFromWishlist(id: String) {
         var wishlist = Storage.getWishlist()
         wishlist = wishlist.filter{$0.id != id}
         Storage.saveWishlist(wishlist:wishlist)
    }
}
