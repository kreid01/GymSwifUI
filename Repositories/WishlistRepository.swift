import Foundation

public struct WishlistRepository {
    func GetWishlistPokemon() -> [Card] {
        print( Storage.getWishlist())
        return Storage.getWishlist()
    }
    
    func AddToWishlist(card: Card) {
       var wishlist = Storage.getWishlist()
        if wishlist.count == 0 {
            Storage.saveWishlist(wishlist: [card])
        } else {
            wishlist.append(card)
            Storage.saveWishlist(wishlist:wishlist)
        }
    }
    
    func RemoveFromWishlist(card: Card) {
         var wishlist = Storage.getWishlist()
         wishlist = wishlist.filter{$0.id != card.id}
         Storage.saveWishlist(wishlist:wishlist)
    }
}
