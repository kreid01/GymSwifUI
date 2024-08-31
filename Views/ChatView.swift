import SwiftUI
import Apollo
import ChatAPI

struct Message {
    let content: String;
    let date: String;
    let user: String
}


class ChatViewModel : ObservableObject {
    @Published var messages = [MessagesQuery.Data.Message]()
    @Published var notificationMessage: String?
    
    
    func sendMessage(content: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        let input = MessageInput(content: content, user: "Me", date: dateString)
        
        Network.shared.apollo.perform(mutation: PostMessageMutation(input: input)) { [weak self]
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
    
    func loadMoreMessages() {
        Network.shared.apollo.fetch(query: MessagesQuery()) { [weak self] result in guard let self = self else {
                return
            }

            switch result {
            case .success(let graphQLResult):
                if let messageConnection = graphQLResult.data?.messages {
                    self.messages.append(contentsOf: messageConnection.compactMap({ $0 }))
                }
                
                if let errors = graphQLResult.errors {
                    print(errors)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}



struct ChatView: View {
    @StateObject var viewModel = ChatViewModel()
    @State var message: String = ""
    @FocusState private var messageFieldIsFocused;
    
    func sendMessage() {
        viewModel.sendMessage(content: message)
        message = ""
    }
    
    var body : some View {
        NavigationStack {
            Text("Chats")
            VStack {
                ScrollView{
                    ForEach(0..<viewModel.messages.count, id: \.self) { index in
                        let message = viewModel.messages[index]
                        if message.user == "Me" {
                            HStack {
                                Circle().frame(width: 40, height: 40).offset(x: 5, y: -35)
                                VStack{
                                    HStack {
                                        Text(message.content).foregroundStyle(.white)
                                        Text(message.date).foregroundStyle(.white)
                                    }.frame(width: 250)
                                        .frame(minHeight: 30)
                                    Text(message.user).foregroundStyle(.white)
                                        
                                }.background(.blue)
                                    .cornerRadius(4)
                                    .frame(maxHeight: 60)
                                    .position(x: 130, y: 0)
                            }
                        } else {
                            HStack {
                                VStack{
                                    HStack {
                                        Text(message.content).foregroundStyle(.white)
                                        Text(message.date).foregroundStyle(.white)
                                    }.frame(width: 250)
                                        .frame(minHeight: 30)
                                    Text(message.user).foregroundStyle(.white)
                                }.background(.orange)
                                    .cornerRadius(4)
                                    .position(x: 210, y: 0)
                                    .frame(minHeight: 60)
                                Circle().frame(width: 40, height: 40).offset(x: -10, y: -35)
                            }
                        }
                    }.defaultScrollAnchor(.bottom)
                }
            }
            HStack {
                TextField("message", text: $message)
                    .focused($messageFieldIsFocused)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.asciiCapable)
                    .padding(10)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    .offset(x: 10, y:0)
                Button(action: sendMessage, label: {
                    Text("Send")
                        .foregroundColor(.white)
                }).padding(10)
                    .background(.blue)
                    .cornerRadius(2)
                    .frame(width: 100, height: 30)
            }.offset(x:0, y: -20)
            .task {
                viewModel.loadMoreMessages()
            }
        }
    }
}

#Preview {
    ChatView();
}
