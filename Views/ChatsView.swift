import SwiftUI

struct ChatsView: View {
    @StateObject var viewModel = ChatsViewModel()
    @State private var creatingChannel = false;
    @State private var newChannelName = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.channels, id: \.id) { channel in
                        NavigationLink(destination: ChatView(channelId: channel.id), label: {
                            Text(channel.name ?? "Unnamed Channel")
                        })
                    }
                    if self.creatingChannel == false {
                        Button(action: {
                            self.creatingChannel = !creatingChannel
                        }, label: {
                            Image(systemName: "plus")
                                .font(.system(size: 32))
                                .padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
                                .background(.green)
                                .foregroundColor(.white)
                                .cornerRadius(2)
                        }).offset(x: 130)
                    }}.refreshable {
                        viewModel.loadChannels()
                    }.navigationBarTitle("Messages", displayMode: .inline)
                
                if self.creatingChannel == true {
                    VStack {
                        Text("New Channel").padding([.bottom, .top], 5)
                        TextField("name", text: $newChannelName)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.asciiCapable)
                            .padding()
                            .border(.gray)
                        HStack {
                            Button(action: { viewModel.postChannel(name: newChannelName)
                                self.creatingChannel = false
                            }) {
                                Text("Create")
                                    .foregroundStyle(.white)
                                    .frame(width: 150, height: 40)
                            }.background(.blue)
                                .padding(5)
                            Button(action: {
                                self.creatingChannel = false}) {
                                Text("Cancel")
                                    .foregroundStyle(.white)
                                    .frame(width: 150, height: 40)
                            }.background(.blue)
                                .padding(5)
                        }
                    }.background(.white)
                        .border(.gray)
                        .padding(20)
                        .cornerRadius(20)
                        .offset(x:0, y:-50)
                }}
            }
        .task {
            viewModel.loadChannels()
        }
    }
}
#Preview {
    ChatsView()
}
