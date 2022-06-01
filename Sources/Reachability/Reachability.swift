import Foundation
import Combine
import UIKit


public class Reachability {
    
    public static var share: Reachability!
    private var subscribtions = Set<AnyCancellable>()
    private var networkReachability = NetworkReachability()
    private var didBecomeActiveNotification = NotificationCenter.default
        .publisher(for: UIApplication.didBecomeActiveNotification)
        .map { _ in ReachabilityType.didApear}
        .eraseToAnyPublisher()
    private lazy var publisher: AnyPublisher<ReachabilityType, Never> = {
        Publishers
            .MergeMany(
                networkReachability.internetReconnection.eraseToAnyPublisher(),
                didBecomeActiveNotification
            )
            .share()
            .eraseToAnyPublisher()
    }()
    
    public func notify(
        every second: RunLoop.SchedulerTimeType.Stride,
        for types: ReachabilityType...
    ) -> AnyPublisher<[ReachabilityType], Never> {
        publisher
            .filter { types.contains($0) }
            .collect(.byTime(RunLoop.current, second))
            .eraseToAnyPublisher()
    }
    
    public static func config() {
        share = Reachability()
    }
    
}
