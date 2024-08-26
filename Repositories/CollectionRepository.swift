class CollectionRepository {
    func GetCollectionPokemon() -> [Card] {
        return Storage.getCollection()
    }
    
    func AddToCollection(card: Card) {
        var collection = Storage.getCollection()
         if collection.count == 0 {
             Storage.saveCollection(collection: [card] )
         } else {
             collection.append(card)
             Storage.saveCollection( collection: collection)
         }
    }
    
    func RemoveFromCollection(card: Card) {
         var collection = Storage.getCollection()
         collection = collection.filter{$0.id != card.id}
         Storage.saveCollection( collection: collection)
    }
}
