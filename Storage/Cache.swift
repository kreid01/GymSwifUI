import SwiftUI


struct Cache {
    static let setsKey = "sets"
    static let userSessionKey = "com.save.caches"
    static let cardsKey = "cards"

    struct Cache {
        let Sets: [Set]
        let Cards: [Card]
    }
    
    struct JSONCache  {
        let Sets: Data
        let Cards: Data
    }
    
    static func saveCards(cards: [Card]) {
        do {
            var cachedCards = getCards()
            let cachedSets = getSets()
            let encoder = JSONEncoder()
             cachedCards.append(contentsOf: cards)
            let cardsData = try encoder.encode(cachedCards)
            let setsData = try encoder.encode(cachedSets)
            print("caching")
            UserDefaults.standard.set([ setsKey:setsData,cardsKey:cardsData], forKey: userSessionKey)
        }
        catch {
            print("Error")
        }
    }
    
    static func save(sets: [Set]) {
        do {
            let encoder = JSONEncoder()
            let setsData = try encoder.encode(sets)
            let cardsData = try encoder.encode(getCards())
            UserDefaults.standard.set([setsKey: setsData, cardsKey: cardsData], forKey: userSessionKey)
        }
        catch {
            print("Error")
        }
    }
    
    static func getCards() -> [Card] {
        do {
            guard let data = UserDefaults.standard.value(forKey: userSessionKey) as? [String:Data] else {
                return Cache(Sets:[], Cards:[]).Cards
            }
            let decoder = JSONDecoder()
            let cards: [Card] = try decoder.decode([Card].self, from: data[cardsKey] ?? Data.init())
            return Cache(Sets:[], Cards:cards).Cards
        } catch {
            print("Unable to Decode Details (\(error))")
        }
        
        return Cache(Sets: [], Cards:[]).Cards
    }
    
    static func getSetCards(setId: String) -> [Card] {
        return getCards().filter{$0.set.id == setId}
    }
    
    static func getSets() -> [Set] {
        do {
            guard let data = UserDefaults.standard.value(forKey: userSessionKey) as? [String:Data] else {
                return Cache(Sets:[], Cards: []).Sets
            }
            let decoder = JSONDecoder()
            let sets: [Set] = try decoder.decode([Set].self, from: data[setsKey] ?? Data.init())
            return Cache(Sets:  sets, Cards: []).Sets
        } catch {
            print("Unable to Decode Details (\(error))")
        }
        
        return Cache(Sets:[], Cards: []).Sets
    }
}


#Preview {
    ContentView()
}
