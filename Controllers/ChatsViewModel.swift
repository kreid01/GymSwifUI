import Apollo
import SwiftUI
import ChatAPI

class ChatsViewModel : ObservableObject {
    @Published var channels: [GetChannelsQuery.Data.Channel] = []
    
    func loadChannels() {
        Network.shared.apollo.fetch(query: GetChannelsQuery()) { [weak self] result in
                guard let self = self else {
                    return
                }

                switch result {
                case .success(let graphQLResult):
                    if let channels = graphQLResult.data?.channels {
                        self.channels = channels;
                        print(channels)
                    }

                    if let errors = graphQLResult.errors {
                        print(errors)
                    }
                case .failure(let error):
                    print(error)
                }
                }
    }
    
    
    func postChannel(name: String) {
        Network.shared.apollo.perform(mutation: PostChannelMutation(input: ChannelInput(name: name))) { [weak self]
            result in guard self != nil else {
                return
            }
            
            switch result {
            case .success(let graphQLResult):
                if graphQLResult.data != nil {
                    
                }
                
                if graphQLResult.errors != nil {
                    print("error")
                }
            case .failure(_):
                print("failure")
            }
        }
    }
}

