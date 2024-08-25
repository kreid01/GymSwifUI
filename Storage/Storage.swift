import SwiftUI


struct Storage {
    static let wishlistKey = "wishlist"
    static let userSessionKey = "com.save.usersession"
    static let collectionKey = "collection"
    
    struct UserDetails {
        let wishlist: [Card]
        let collection: [Card]
    }
    
    struct JSONUserDetails {
        let wishlist: Data
        let collection: Data
    }
    
    static func save(wishlist: [Card], collection: [Card]) {
        do {
            let encoder = JSONEncoder()
            let wishlisData = try encoder.encode(wishlist)
            let collectionData = try encoder.encode(collection)
            UserDefaults.standard.set([wishlistKey: wishlisData, collectionKey: collectionData], forKey: userSessionKey)
        }
        catch {
            print("Error")
        }
    }
    
    static func getUserDetails() -> UserDetails {
        do {
            guard let data = UserDefaults.standard.value(forKey: userSessionKey) as? [String:Data] else {
                return UserDetails(wishlist:[], collection: [])
            }
            let decoder = JSONDecoder()
            let wishlist: [Card] = try decoder.decode([Card].self, from: data[wishlistKey]!)
            let collection: [Card] = try decoder.decode([Card].self, from: data[collectionKey]!)
            return UserDetails(wishlist: wishlist, collection:collection)
        } catch {
            print("Unable to Decode Details (\(error))")
        }
        
        return UserDetails(wishlist:[], collection: [])
    }
    
    static func getWishlist() -> [Card] {
        return getUserDetails().wishlist
    }
    
    static func getCollection() -> [Card] {
        return getUserDetails().collection
    }
}


#Preview {
    ContentView()
}
