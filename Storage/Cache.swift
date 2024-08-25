import SwiftUI


struct Cache {
    static let setsKey = "sets"
    static let userSessionKey = "com.save.caches"

    struct SetsCache {
        let Sets: [Set]
    }
    
    struct JSONSetsCache  {
        let Sets: Data
    }
    
    static func save(sets: [Set]) {
        do {
            let encoder = JSONEncoder()
            let setsData = try encoder.encode(sets)
            UserDefaults.standard.set([setsKey: setsData], forKey: userSessionKey)
        }
        catch {
            print("Error")
        }
    }
    
    static func getSets() -> SetsCache {
        do {
            guard let data = UserDefaults.standard.value(forKey: userSessionKey) as? [String:Data] else {
                return SetsCache(Sets:[])
            }
            let decoder = JSONDecoder()
            let sets: [Set] = try decoder.decode([Set].self, from: data[setsKey]!)
            return SetsCache(Sets:  sets)
        } catch {
            print("Unable to Decode Details (\(error))")
        }
        
        return SetsCache(Sets:[])
    }
}


#Preview {
    ContentView()
}
