import Foundation

public struct WishlistRepository {
    func GetWishlistPokemon() -> [Card] {
        print( Storage.getWishlist())
        return Storage.getWishlist()
    }
    
    func AddToWishlist(card: Card) {
       var wishlist = Storage.getWishlist()
        let collection = Storage.getCollection()
        if wishlist.count == 0 {
            Storage.save(wishlist: [card], collection:[card] )
        } else {
            wishlist.append(card)
            Storage.save(wishlist:wishlist , collection: collection)
        }
    }
    
    func RemoveFromWishlist(card: Card) {
         var wishlist = Storage.getWishlist()
         let collection = Storage.getCollection()
         wishlist = wishlist.filter{$0.id != card.id}
         Storage.save(wishlist:wishlist , collection: collection)
    }
}
