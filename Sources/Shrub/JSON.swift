import Foundation

public typealias JSON = Shrub<String>

public protocol JSONFragment {}
extension JSON { public typealias Fragment = JSONFragment }

extension NSNull: JSON.Fragment {}
extension Bool: JSON.Fragment {}
extension Double: JSON.Fragment {}
extension String: JSON.Fragment {}
