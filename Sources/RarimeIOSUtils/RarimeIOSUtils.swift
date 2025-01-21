@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "RarimeIOSUtilsMacros", type: "StringifyMacro")

@freestanding(expression)
public macro registerCircuitWitness(_ circuitName: String) -> () = #externalMacro(module: "RarimeIOSUtilsMacros", type: "RegisterCircuitWitnessMacro")
