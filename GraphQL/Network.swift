import Apollo
import Foundation

class Network {
  static let shared = Network()

  private(set) lazy var apollo = ApolloClient(url: URL(string: "http://localhost:8080/query")!)
}
