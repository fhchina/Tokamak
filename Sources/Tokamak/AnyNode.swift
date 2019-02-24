//
//  Node.swift
//  Tokamak
//
//  Created by Max Desiatov on 30/11/2018.
//

enum NodeType: Equatable {
  static func ==(lhs: NodeType, rhs: NodeType) -> Bool {
    switch (lhs, rhs) {
    case let (.host(ltype), .host(rtype)):
      return ltype == rtype
    case let (.composite(ltype), .composite(rtype)):
      return ltype == rtype
    default:
      return false
    }
  }

  case host(AnyHostComponent.Type)
  case composite(AnyCompositeComponent.Type)
  case context(AnyContext.Type)
  case null

  var composite: AnyCompositeComponent.Type? {
    guard case let .composite(type) = self else { return nil }

    return type
  }

  var host: AnyHostComponent.Type? {
    guard case let .host(type) = self else { return nil }

    return type
  }
}

public struct AnyNode: Equatable {
  // Equatable can't be automatically derived for `type` property?
  public static func ==(lhs: AnyNode, rhs: AnyNode) -> Bool {
    return
      lhs.ref === rhs.ref &&
      lhs.type == rhs.type &&
      lhs.children == rhs.children &&
      lhs.props == rhs.props
  }

  public let ref: AnyObject?
  public let props: AnyEquatable
  public let children: AnyEquatable
  let type: NodeType

  public func isSubtypeOf<T>(_: T.Type) -> Bool {
    return type.host is T.Type || type.composite is T.Type
  }

  public func isSubtypeOf<T, U>(_: T.Type, or: U.Type) -> Bool {
    return isSubtypeOf(T.self) || isSubtypeOf(U.self)
  }

  public func isSubtypeOf<T, U, V>(
    _: T.Type,
    or _: U.Type,
    or _: V.Type
  ) -> Bool {
    return isSubtypeOf(T.self) || isSubtypeOf(U.self) || isSubtypeOf(V.self)
  }
}

extension Null {
  public static func node() -> AnyNode {
    return AnyNode(
      ref: nil,
      props: AnyEquatable(Null()),
      children: AnyEquatable(Null()),
      type: .null
    )
  }
}

extension Component where Children == Null {
  public static func node(_ props: Props) -> AnyNode {
    return node(props, Null())
  }
}

extension Component where Props == Null, Children == Null {
  public static func node() -> AnyNode {
    return node(Null(), Null())
  }
}

extension Component where Props: Default, Props.DefaultValue == Props {
  public static func node(_ children: Children) -> AnyNode {
    return node(Props.defaultValue, children)
  }
}

extension Component where Children == [AnyNode] {
  public static func node(_ props: Props,
                          _ child: AnyNode) -> AnyNode {
    return node(props, [child])
  }

  public static func node(_ props: Props) -> AnyNode {
    return node(props, [])
  }
}

extension Component where Props: Default, Props.DefaultValue == Props,
  Children == [AnyNode] {
  public static func node(_ child: AnyNode) -> AnyNode {
    return node(Props.defaultValue, [child])
  }

  public static func node() -> AnyNode {
    return node(Props.defaultValue, [])
  }
}

extension HostComponent {
  public static func node(_ props: Props, _ children: Children) -> AnyNode {
    return AnyNode(
      ref: nil,
      props: AnyEquatable(props),
      children: AnyEquatable(children),
      type: .host(self)
    )
  }
}

extension CompositeComponent {
  public static func node(
    _ props: Props,
    _ children: Children
  ) -> AnyNode {
    return AnyNode(
      ref: nil,
      props: AnyEquatable(props),
      children: AnyEquatable(children),
      type: .composite(self)
    )
  }
}

extension RefComponent {
  public static func node(
    ref: Ref<RefTarget?>,
    _ props: Props,
    _ children: Children
  ) -> AnyNode {
    return AnyNode(
      ref: ref,
      props: AnyEquatable(props),
      children: AnyEquatable(children),
      type: .host(self)
    )
  }
}
