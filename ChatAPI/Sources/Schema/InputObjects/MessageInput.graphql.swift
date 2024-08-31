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
    date: String
  ) {
    __data = InputDict([
      "content": content,
      "user": user,
      "date": date
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
}
