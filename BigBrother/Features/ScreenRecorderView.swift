import SwiftUI
import ReplayKit
import Combine

struct ScreenRecorderView: View {
  @Environment(\.[\Throw.self]) var `throw`
  @Environment(\.[\ScreenRecorder.self]) var screenRecorder
  @State @Reference var recordingCancellable: AnyCancellable?
  @State var preview: Image?
  @State var isRecording: Bool = false
  var body: some View {
    VStack {
      Text("Big Brother App")
      recordButton
      preview.map {
        $0
        .resizable()
        .aspectRatio(contentMode: ContentMode.fit)
      }
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
    defer { isRecording = true }
    screenRecorder.recordingPublisher
      .print("recording")
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
          preview = Image(nsImage: nsImage)
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
