import SwiftUI
import Apollo
import ChatAPI

struct ChatView: View {
    @State var message: String = ""
    @FocusState private var messageFieldIsFocused;
    @State var page: Int = 1
    
    @State private var _channelId: String;
    @StateObject var viewModel: ChatViewModel;
    
    init(channelId: String) {
        _channelId = channelId
        _viewModel = StateObject(wrappedValue:  ChatViewModel(channelId: channelId))
    }
    
    func sendMessage() {
        if !message.isEmpty {
            viewModel.sendMessage(content: message)
            message = ""
        }
    }
    
    @State private var isAtTop: Bool = false
    
    var body : some View {
        VStack {
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
                        
                        Spacer(minLength: 700)
                        ForEach(viewModel.messages.reversed(), id: \.self) { message in
                            if message.user == "Me" {
                                HStack {
                                    CacheAsyncImage(url: URL(string : "https://e7.pngegg.com/pngimages/173/464/png-clipart-pokeball-pokeball-thumbnail.png")!) {
                                        phase in
                                        switch phase {
                                            case .success(let image):
                                                image.resizable().scaledToFit()
                                                    .frame(width: 40, height:40)
                                                    .offset(x: -15, y: -25)
                                            case .empty:
                                                ProgressView()
                                            case .failure(_):
                                                ProgressView()
                                            @unknown default:
                                                fatalError()
                                        }
                                    }.frame(height: 50)
                                    VStack {
                                        HStack {
                                            Text(message.content).foregroundStyle(.white)
                                                .padding(5)
                                            Spacer()
                                        }
                                        Text(message.date.prefix(10))
                                            .foregroundStyle(.white.opacity(0.8))
                                            .offset(x: 60, y: 0)
                                    }
                                    .frame(width: 220)
                                    .frame(minHeight: 60)
                                    .background(.blue)
                                    .cornerRadius(4)
                                    .position(x: 65, y: 0)
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
                                    }
                                    .frame(width: 220)
                                    .frame(minHeight:60)
                                    .background(.orange)
                                    .cornerRadius(4)
                                    .position(x:230, y: 0)
                                    CacheAsyncImage(url: URL(string : "https://e7.pngegg.com/pngimages/173/464/png-clipart-pokeball-pokeball-thumbnail.png")!) {
                                        phase in
                                        switch phase {
                                            case .success(let image):
                                                image.resizable().scaledToFit()
                                                    .frame(width: 40, height: 40)
                                                    .offset(x: 25, y: -25)
                                            case .empty:
                                                ProgressView()
                                            case .failure(_):
                                                ProgressView()
                                            @unknown default:
                                                fatalError()
                                        }
                                    }.frame(height: 50)
                                }
                            }
                        }
                        .onChange(of: isAtTop) { atTop in
                            if atTop && viewModel.hasMoreMessage! {
                                page += 1
                                viewModel.loadMoreMesssages(page: page )
                            }
                        }
                        .onChange(of: viewModel.messages.count) { count in
                            if count > 1 {
                                // Scroll to the last message when there are more than 1
                                scrollProxy.scrollTo(viewModel.messages.last, anchor: .bottom)
                            } else if count == 1 {
                                // Scroll to the first message when there is only 1
                                scrollProxy.scrollTo(viewModel.messages.first, anchor: .bottom)
                            }
                        }
                    }
                    .defaultScrollAnchor(.bottom)
                    .padding([.bottom], 12)
                }
            }
            HStack {
                TextField("message", text: $message)
                    .focused($messageFieldIsFocused)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.asciiCapable)
                    .padding(10)
                    .border(Color.black, width: 1)
                    .offset(x: 10, y: 0)
                Button(action: sendMessage, label: {
                    Text("Send")
                        .foregroundColor(.white)
                })
                .padding(10)
                .background(.blue)
                .cornerRadius(2)
                .frame(width: 100, height: 30)
            }
            .offset(x: 0, y: -20)
            .task {
                viewModel.loadMoreMesssages(page: 1)
                viewModel.startSubscription()
            }
        }
    }
}

#Preview {
    ChatView(channelId: "4")
}

