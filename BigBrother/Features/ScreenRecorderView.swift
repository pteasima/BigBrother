import SwiftUI
import ReplayKit
import Combine

struct ScreenRecorderView: View {
  @Environment(\.[\Throw.self]) private var `throw`
  @Environment(\.[\ScreenRecorder.self]) private var screenRecorder
  @Environment(\.openURL) private var openURL
  @Environment(\.[\UpdatePreview.self]) var updatePreview
  @State @Reference private var recordingCancellable: AnyCancellable?
  @State private var isRecording: Bool = false
  var body: some View {
    VStack {
      Text("Big Brother App")
      recordButton
    }
    .padding()
  }
  
  @ViewBuilder var recordButton: some View {
    if isRecording {
      Button(action: stopRecording) {
        Text("Stop Recording")
      }
    } else {
      Button(action: startRecording) {
        Text("Start Recording")
      }
    }
  }
  
  func startRecording() {
    openURL(URL(string: "bigbrother://")!)
    defer { isRecording = true }
    screenRecorder.recordingPublisher
      .sendErrors(to: `throw`)
      .throttle(for: 1, scheduler: DispatchQueue.main, latest: false)
      .sink { sampleBuffer, sampleBufferType in
        switch sampleBufferType {
        case .video:
          guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
          else { raise(SIGINT); return }
          let ciImage = CIImage(cvImageBuffer: pixelBuffer)
          let rep = NSCIImageRep(ciImage: ciImage)
          let nsImage = NSImage(size: rep.size)
          nsImage.addRepresentation(rep)
          let image = Image(nsImage: nsImage)
          updatePreview(image)
        default:
          break
        }
        
      }
      .store(in: &recordingCancellable)
  }
  
  func stopRecording() {
    defer { isRecording = false }
    recordingCancellable.cancelAndRemove()
  }
}

struct ScreenRecorderView_Previews: PreviewProvider {
  static var previews: some View {
    ScreenRecorderView()
      .showErrors()
  }
}
