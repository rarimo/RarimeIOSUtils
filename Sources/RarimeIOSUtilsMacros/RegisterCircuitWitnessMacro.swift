import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct RegisterCircuitWitnessMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf decl: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard case let .argumentList(arguments) = node.arguments,
              let firstArg = arguments.first?.expression as? StringLiteralExprSyntax,
              let circuitName = firstArg.segments.first?.description
        else {
            throw MacroExpansionErrorMessage("Expected a circuit name as a string literal.")
        }

        let functionDecl = """
        static func calcWtns_\(circuitName)(
            _ descriptionFileData: Data,
            _ privateInputsJson: Data
        ) throws -> Data {
        #if targetEnvironment(simulator)
            return Data()
        #else
            let wtnsSize = UnsafeMutablePointer<UInt>.allocate(capacity: Int(1))
            wtnsSize.initialize(to: WITNESS_SIZE)
            let wtnsBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(WITNESS_SIZE))
            let errorBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(ERROR_SIZE))

            let result = witnesscalc_\(circuitName)(
                (descriptionFileData as NSData).bytes, UInt(descriptionFileData.count),
                (privateInputsJson as NSData).bytes, UInt(privateInputsJson.count),
                wtnsBuffer, wtnsSize,
                errorBuffer, ERROR_SIZE
            )

            try handleWitnessError(result, errorBuffer, wtnsSize)

            return Data(bytes: wtnsBuffer, count: Int(wtnsSize.pointee))
        #endif
        }
        """

        return [DeclSyntax(stringLiteral: functionDecl)]
    }
}

@main
struct RarimeIOSUtilsPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StringifyMacro.self,
        RegisterCircuitWitnessMacro.self,
    ]
}
