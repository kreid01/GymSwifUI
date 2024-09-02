import SwiftUI
import Apollo
import ChatAPI

struct ChatView: View {
    @StateObject var viewModel = ChatViewModel()
    @State var message: String = ""
    @FocusState private var messageFieldIsFocused;
    @State var page: Int = 1
    
    func sendMessage() {
        viewModel.sendMessage(content: message)
        message = ""
    }
    
    @State private var isAtTop: Bool = false

    var body : some View {
        NavigationStack {
            Text("Chats")
            VStack {
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        VStack {
                            GeometryReader { geo in
                                Color.clear
                                    .onChange(of: geo.frame(in: .global).minY) { minY in
                                        let threshold: CGFloat = 50
                                        self.isAtTop = minY >= threshold && self.viewModel.messages != []
                                    }
                            }
                            .frame(height: 0)}
                        ForEach(viewModel.messages.reversed(), id: \.self) { message in
                            if message.user == "Me" {
                                HStack {
                                    Circle().frame(width: 40, height: 40).offset(x: 5, y: -35)
                                        .foregroundStyle(.teal)
                                    VStack {
                                        HStack {
                                            Text(message.content).foregroundStyle(.white)
                                                .padding(5)
                                            Spacer()
                                        }
                                        Text(message.date.prefix(10))
                                            .foregroundStyle(.white.opacity(0.8))
                                            .offset(x: 60, y: 0)
                                        
                                    }.frame(width: 220)
                                        .frame(minHeight: 60)
                                        .background(.blue)
                                        .cornerRadius(4)
                                        .position(x: 120, y: 0)
                                        .padding(3)
                                }
                            } else {
                                HStack {
                                    VStack {
                                        HStack {
                                            Text(message.content).foregroundStyle(.white)
                                                .padding(5)
                                            Spacer()
                                        }
                                        Text(message.date.prefix(10))
                                            .foregroundStyle(.white.opacity(0.8))
                                            .offset(x: 60, y: 0)
                                        
                                    }.frame(width: 220)
                                        .frame(minHeight: 60)
                                        .background(.orange)
                                        .cornerRadius(4)
                                        .position(x:230, y: 0)
                                    Circle().frame(width: 40, height: 40).offset(x: -5, y: -35)
                                        .foregroundStyle(.teal)
                                }
                            }
                        }.scrollTargetLayout()
                        .onChange(of: isAtTop) { atTop in
                            if atTop && viewModel.hasMoreMessage! {
                                            page += 1
                                            viewModel.loadMoreMesssages(page: page )
                                        }
                                    }
                        .onChange(of: viewModel.messages.count) { count in
                                scrollProxy.scrollTo(viewModel.messages[(page - 1) + 11])
                        }
                    }.defaultScrollAnchor(.bottom)
                        .padding([.bottom], 12)
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
                viewModel.loadMoreMesssages(page: 1)
                viewModel.startSubscription()
            }
        }
    }
}


#Preview {
    ChatView();
}
