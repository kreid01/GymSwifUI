// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class DeleteChannelMutation: GraphQLMutation {
  public static let operationName: String = "DeleteChannel"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation DeleteChannel($id: ID!) { deleteChannel(id: $id) }"#
    ))

  public var id: ID

  public init(id: ID) {
    self.id = id
  }

  public var __variables: Variables? { ["id": id] }

  public struct Data: ChatAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ChatAPI.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("deleteChannel", String?.self, arguments: ["id": .variable("id")]),
    ] }

    public var deleteChannel: String? { __data["deleteChannel"] }
  }
}
