import Alamofire
import Combine
import Foundation


class NetworkReachability {
    
    typealias NetworkReachabilityStatus = Alamofire.NetworkReachabilityManager.NetworkReachabilityStatus
    
    var internetReconnection = PassthroughSubject<ReachabilityType, Never>()
    private let networkReachabilityManager: Alamofire.NetworkReachabilityManager
    private var status: PassthroughSubject<NetworkReachabilityStatus, Never>
    private let cancellable: AnyCancellable
    
    init() {
        networkReachabilityManager = Alamofire.NetworkReachabilityManager()!
        status = PassthroughSubject<Alamofire.NetworkReachabilityManager.NetworkReachabilityStatus, Never>()
        cancellable = status
            .pairwise
            .filter { first, second in
                guard
                    [.notReachable, .unknown].contains(first),
                    case .reachable = second
                else { return false }
                return true
            }
            .map { _ in .network }
            .subscribe(internetReconnection)
        networkReachabilityManager.startListening { status in
            self.status.send(status)
        }
    }
    
    deinit { networkReachabilityManager.stopListening() }
    
}
