import Foundation

public protocol GraphQLQueryType {
    var queryString: String { get }
}

public struct GraphQL {
    public typealias SelectionSet = [GraphQL.Field]
    public typealias Arguments = [String: AnyObject]
    
    public enum InputValueType: CustomStringConvertible {
        case IntValue(Bool)
        case FloatValue(Bool)
        case StringValue(Bool)
        case BooleanValue(Bool)
        case EnumValue(Bool)
        case ListValue(Bool)
        case ObjectValue(Bool)
        
        public var description: String {
            switch self {
            case IntValue(let required):
                return required ? "Int!" : "Int"
            case FloatValue(let required):
                return required ? "Float!" : "Float"
            case StringValue(let required):
                return required ? "String!" : "String"
            case BooleanValue(let required):
                return required ? "Boolean!" : "Boolean"
            case EnumValue(let required):
                return required ? "Enum!" : "Enum"
            case ListValue(let required):
                return required ? "List!" : "List"
            case ObjectValue(let required):
                return required ? "Object!": "Object"
            }
        }
    }
    
    public enum OperationType: String, CustomStringConvertible {
        // A write followed by a fetch
        case Mutation = "mutation"
        
        // A ready-only fetch
        case Query = "query"
        
        public var description: String {
            return rawValue
        }
    }
    
    /**
     Document Definition:
        Operation Definition
        Fragment Definition
     
     A GraphQL query document describes a complete file or request string received by a GraphQL service. A document contains multiple definitions of Operations and Fragments. GraphQL query documents are only executable by a server if they contain an operation. However documents which do not contain operations may still be parsed and validated to allow client to represent a single request across many documents.
     
     If a document contains only one operation, that operation may be unnamed or represented in the shorthand form, which omits both the query keyword and operation name. Otherwise, if a GraphQL query document contains multiple operations, each operation must be named. When submitting a query document with multiple operations to a GraphQL service, the name of the desired operation to be executed must also be provided.
    */
    public struct Document {
        public let operations: [GraphQLQueryType]
        
        init(operations: [GraphQLQueryType]) {
            self.operations = operations
        }
    }
    
    /**
     Operation Definition:
        OperationType Name? VariableDefinitions? Directives? SelectionSet
     
     There are two types of operations, as specified in `OperationType`. 
     
     Each operation is represented by an optional operation name and a selection set.
    */
    public struct Operation {
        public let type: OperationType
        public let name: String
        public let arguments: Arguments
        public let selectionSet: SelectionSet
        
        public init(type: OperationType, name: String = "", arguments: Arguments = Arguments(), selectionSet: SelectionSet) {
            self.type = type
            self.name = name
            self.arguments = arguments
            self.selectionSet = selectionSet
        }
    }
    
    /**
     Field Definition:
        Alias? Name Arguments? Directives? SelectionSet?
     
     Fields describe complex data or relationships to other data. In order to further explore this data, a field may itself contain a selection set, allowing for deeply nested requests.
     
     All GraphQL operations must specify their selections down to fields which return scalar values to ensure an unambiguously shaped response.
    */
    public struct Field {
        public let alias: String?
        public let name: String
        public let arguments: [String: AnyObject]
        
        public let selectionSet: SelectionSet
        
        public let fragments: [InlineFragment]
        
        var isRootNode: Bool {
            return name.isEmpty
        }

        public init(alias: String? = nil, name: String, arguments: Arguments = Arguments(), selectionSet: SelectionSet = SelectionSet(), fragments: [InlineFragment] = []) {
            for field in selectionSet {
                assert(!field.isRootNode, "You cannot add a root field as a child of another field")
            }
            
            self.alias = alias
            self.name = name
            self.arguments = arguments
            self.selectionSet = selectionSet
            self.fragments = fragments
        }
    }
    
    /**
     Directive Definition:
        @ Name Arguments?
     
     Directives provide a way to describe alternate runtime execution and type validation behavior in a GraphQL document.
     
     Directives have a name along with a list of arguments which may accept values of any input type.
     
     Directives can be used to describe additional information for fields, fragments, and operations.
    */
    public struct Directive {
        public let name: String
        public let arguments: Arguments
        
        public init(name: String, arguments: Arguments = Arguments()) {
            self.name = name
            self.arguments = arguments
        }
    }
    
    public struct Fragment {
        public let name: String
        public let typeCondition: String
        
        public let directive: Directive?
        public let selectionSet: SelectionSet
        
        public init(name: String, typeCondition: String, directive: Directive? = nil, selectionSet: SelectionSet) {
            self.name = name
            self.typeCondition = typeCondition
            self.directive = directive
            self.selectionSet = selectionSet
        }
    }
    
    /**
     InlineFragment Definition:
        ... TypeCondition? Directives? SelectionSet
     
     Fragments can be defined inline with a selection set. This is done to conditionally include fields based on their runtime type.
     
     Inline fragments may also be used to apply a directive to a group of fields. If the TypeCondition is omitted, an inline fragment is considered to be of the same type as the enclosing context.
    */
    public struct InlineFragment {
        public let typeCondition: String?
        public let directive: Directive?
        public let selectionSet: SelectionSet
        
        public init(typeCondition: String, selectionSet: SelectionSet) {
            self.typeCondition = typeCondition
            self.directive = nil
            self.selectionSet = selectionSet
        }
        
        public init(directive: Directive, selectionSet: SelectionSet) {
            self.typeCondition = nil
            self.directive = directive
            self.selectionSet = selectionSet
        }
        
        public init(typeCondition: String, directive: Directive, selectionSet: SelectionSet) {
            self.typeCondition = typeCondition
            self.directive = directive
            self.selectionSet = selectionSet
        }
    }
}
