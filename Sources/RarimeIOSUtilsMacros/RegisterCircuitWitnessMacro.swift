import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct RegisterCircuitWitnessMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard let argument = node.arguments.first?.expression,
              let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
              segments.count == 1,
              case .stringSegment(let literalSegment)? = segments.first
        else {
            throw MacroExpansionErrorMessage("Need a static string")
        }

        let circuitName = literalSegment.content.text

        return [
            """
            static func calcWtns_\(raw: circuitName)(
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

                let result = witnesscalc_\(raw: circuitName)(
                    (descriptionFileData as NSData).bytes, UInt(descriptionFileData.count),
                    (privateInputsJson as NSData).bytes, UInt(privateInputsJson.count),
                    wtnsBuffer, wtnsSize,
                    errorBuffer, ERROR_SIZE
                )

                try handleWitnessError(result, errorBuffer, wtnsSize)

                return Data(bytes: wtnsBuffer, count: Int(wtnsSize.pointee))
            #endif
            }
            """,
        ]
    }
}

@main
struct RarimeIOSUtilsPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StringifyMacro.self,
        RegisterCircuitWitnessMacro.self,
    ]
}
