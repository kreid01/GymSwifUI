// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct MessageInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    content: String,
    user: String,
    date: String,
    channelId: Int
  ) {
    __data = InputDict([
      "content": content,
      "user": user,
      "date": date,
      "channelId": channelId
    ])
  }

  public var content: String {
    get { __data["content"] }
    set { __data["content"] = newValue }
  }

  public var user: String {
    get { __data["user"] }
    set { __data["user"] = newValue }
  }

  public var date: String {
    get { __data["date"] }
    set { __data["date"] = newValue }
  }

  public var channelId: Int {
    get { __data["channelId"] }
    set { __data["channelId"] = newValue }
  }
}
