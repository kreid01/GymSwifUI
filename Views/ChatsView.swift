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
                        HStack {
                            Spacer()
                            Button(action: {
                                self.creatingChannel = !creatingChannel
                            }, label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 24))
                                    .padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
                                    .background(.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            })
                        }
                    }}.refreshable {
                        viewModel.loadChannels()
                    }.navigationBarTitle("Messages", displayMode: .inline)
                
                if self.creatingChannel == true {
                    VStack {
                        Form {
                            Text("Create Channel")
                            TextField("Channel Name", text: $newChannelName)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.asciiCapable)
                                .padding()
                                .border(.gray)
                                .cornerRadius(2)

                            HStack {
                                Button(action: 
                                        { 
                                    if !newChannelName.isEmpty {
                                        viewModel.postChannel(name: newChannelName)
                                        self.creatingChannel = false
                                    }
                                }) {
                                    Text("Create")
                                        .foregroundStyle(.white)
                                        .frame(width: 120, height: 35)
                                        .cornerRadius(10)
                                }.background(.blue)
                                    .padding(5)
                                Spacer()
                                Button(action: {
                                    self.creatingChannel = false}) {
                                    Text("Cancel")
                                        .foregroundStyle(.white)
                                        .frame(width: 120, height: 35)
                                        .cornerRadius(10)
                                }.background(.blue)
                                    .padding(5)
                            }
                        }.frame(height: .infinity)
                    }
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
