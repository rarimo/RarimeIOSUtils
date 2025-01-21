import Foundation

import RarimeIOSUtils

enum ZKUtils {
    static let ERROR_SIZE = UInt(256)
    static let WITNESS_SIZE = UInt(100 * 1024 * 1024)
    static let PROOF_SIZE = UInt(4 * 1024 * 1024)
    static let PUB_SIGNALS_SIZE = UInt(4 * 1024 * 1024)

    private static func handleWitnessError(
        _ result: Int32,
        _ errorBuffer: UnsafeMutablePointer<UInt8>,
        _ wtnsSize: UnsafeMutablePointer<UInt>
    ) throws {}

//    #registerCircuitWitness("registerIdentity")
}
