import Quick
import Nimble


@testable import LaunchGate

class RemoteFileManagerSpec: QuickSpec {
  override func spec() {

    let exampleURL = NSURL(string: "https://www.launchgate.com/update.json")!

    describe("#init") {

      it("the URI is stored in the remote file manager") {
        let remoteFileManager = RemoteFileManager(remoteFileURL: exampleURL)

        expect(remoteFileManager.remoteFileURL) == exampleURL
      }

    }

    describe("#fetchRemoteFile") {

      class MockRemoteFileManager: RemoteFileManager {
        var performRemoteFileRequestWasCalled = false
        var performRemoteFileRequestWasCalledWithRemoteFileURI = false

        override func performRemoteFileRequest(request: NSURLRequest, responseHandler: (data: NSData) -> Void) {          
          if request.URL?.absoluteString == "https://www.launchgate.com/update.json" {
            performRemoteFileRequestWasCalledWithRemoteFileURI = true
          }
        }
      }

      let remoteFileManager = MockRemoteFileManager(remoteFileURL: exampleURL)

      beforeEach {
        remoteFileManager.fetchRemoteFile { _ in }
      }

      it("performs the remote file request") {
        expect(remoteFileManager.performRemoteFileRequestWasCalledWithRemoteFileURI) == true
      }

    }

  }
}
