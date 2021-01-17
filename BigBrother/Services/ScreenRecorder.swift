import ReplayKit
import SwiftUI
import Combine
import CombineExt

typealias ScreenRecorder = RPScreenRecorder

extension ScreenRecorder: EnvironmentKey {
  public static var defaultValue: RPScreenRecorder { .shared() }
}

extension ScreenRecorder {
  var recordingPublisher: AnyPublisher<(sampleBuffer: CMSampleBuffer, sampleBufferType: RPSampleBufferType), Error> {
    AnyPublisher.create { subscriber in
      self.startCapture { sampleBuffer, sampleBufferType, error in
        if let error = error { subscriber.send(completion: .failure(error)) }
        else { subscriber.send((sampleBuffer, sampleBufferType)) }
      } completionHandler: { error in
        if let error = error { subscriber.send(completion: .failure(error)) }
      }
      return AnyCancellable { [weak self] in
        self?.stopCapture(handler: nil)
      }
   }
  }
}
