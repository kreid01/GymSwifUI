class CollectionRepository {
    func GetCollectionPokemon() -> [Card] {
        return Storage.getCollection()
    }
    
    func AddToCollection(card: Card) {
        var collection = Storage.getCollection()
        
        if collection.contains(where: {$0.id == card.id}) {
            return;
        }

         if collection.count == 0 {
             Storage.saveCollection(collection: [card] )
         } else {
             collection.append(card)
             Storage.saveCollection( collection: collection)
         }
    }
    
    func RemoveFromCollection(id: String) {
         var collection = Storage.getCollection()
         collection = collection.filter{$0.id != id}
         Storage.saveCollection( collection: collection)
    }
}
