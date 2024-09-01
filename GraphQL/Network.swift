import Apollo
import ApolloWebSocket
import Foundation

class Network {
    static let shared = Network()

    private(set) lazy var apollo: ApolloClient = {
        let client = URLSessionClient()
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = DefaultInterceptorProvider(client: client, store: store)
        let url = URL(string: "http://localhost:8080/query")!
        let transport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url)

        let webSocket = WebSocket(
            url: URL(string: "ws://localhost:8080/query")!,
            protocol: .graphql_ws
        )

        let webSocketTransport = WebSocketTransport(websocket: webSocket)

        let splitTransport = SplitNetworkTransport(
            uploadingNetworkTransport: transport,
            webSocketNetworkTransport: webSocketTransport
        )

        return ApolloClient(networkTransport: splitTransport, store: store)
    }()
}
