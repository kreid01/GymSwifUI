class CollectionRepository {
    func GetCollectionPokemon() -> [Card] {
        return Storage.getCollection()
    }
    
    func AddToCollection(card: Card) {
        let wishlist = Storage.getWishlist()
        var collection = Storage.getCollection()
         if collection.count == 0 {
             Storage.save(wishlist: [card], collection:[card] )
         } else {
             collection.append(card)
             Storage.save(wishlist:wishlist , collection: collection)
         }
    }
    
    func RemoveFromCollection(card: Card) {
         let wishlist = Storage.getWishlist()
         var collection = Storage.getCollection()
         collection = collection.filter{$0.id != card.id}
         Storage.save(wishlist:wishlist , collection: collection)
    }
}
