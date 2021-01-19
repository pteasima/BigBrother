import SwiftUI
import ReplayKit
import Combine
import Vision

struct ScreenRecorderView: View {
  @Environment(\.[\Throw.self]) private var `throw`
  @Environment(\.[\ScreenRecorder.self]) private var screenRecorder
  @Environment(\.openURL) private var openURL
  @Environment(\.[\UpdatePreview.self]) private var updatePreview
  @State @Reference private var recordingCancellable: AnyCancellable?
  @State @Reference private var visionRequest: VNCoreMLRequest!
  @State private var isRecording: Bool = false
  @State private var buffer: CVPixelBuffer?
  var body: some View {
    VStack {
      Text("Big Brother App")
      recordButton
//      PreviewView(buffer: buffer)
//        .frame(width: 512, height: 512)
//        .background(Color.gray)
    }
    .padding()
    .onFirstAppear(perform: setupVision)
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
  
  func setupVision() {
    `throw`.try {
      let model = try VNCoreMLModel(for: VanGogh(configuration: .init()).model)
      let request = VNCoreMLRequest(model: model) { request, error in
        
        if let error = error { `throw`(error) }
        if let pixelBuffer = (request.results as? [VNPixelBufferObservation])?.first?.pixelBuffer {
print(pixelBuffer)
          //          buffer = pixelBuffer
          
//          print("io", CVPixelBufferGetIOSurface(pixelBuffer))
//          let compatibleBuffer = pixelBuffer.copyToMetalCompatible()!
          let ciImage = CIImage(cvImageBuffer: pixelBuffer)
          let rep = NSCIImageRep(ciImage: ciImage)
          let nsImage = NSImage(size: rep.size)
          nsImage.addRepresentation(rep)
          let image = Image(nsImage: nsImage)
              
          updatePreview(image)
        }
      }
      request.imageCropAndScaleOption = .scaleFit
      visionRequest = request
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
          let handler =
            VNImageRequestHandler(cmSampleBuffer: sampleBuffer, options: [:])
          do {
            try handler.perform([visionRequest])
          } catch {
            print("Failed to perform classification.\n\(error.localizedDescription)")
          }
//          guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
//          else { raise(SIGINT); return }
//          let ciImage = CIImage(cvImageBuffer: pixelBuffer)
//          let rep = NSCIImageRep(ciImage: ciImage)
//          let nsImage = NSImage(size: rep.size)
//          nsImage.addRepresentation(rep)
//          let image = Image(nsImage: nsImage)
//          updatePreview(image)
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


struct PreviewView: NSViewRepresentable {
  var buffer: CVPixelBuffer?
  func makeNSView(context: Context) -> NSView {
    .init()
  }
  func updateNSView(_ nsView: NSView, context: Context) {
    print("update")
    nsView.layer?.contents = buffer
  }
}
