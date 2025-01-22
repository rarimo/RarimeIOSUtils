@freestanding(declaration, names: arbitrary)
public macro registerCircuitWitness(_ circuitName: String) = #externalMacro(module: "RarimeIOSUtilsMacros", type: "RegisterCircuitWitnessMacro")
