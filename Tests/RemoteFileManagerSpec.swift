import Quick
import Nimble


@testable import LaunchGate

class RemoteFileManagerSpec: QuickSpec {
  override func spec() {

    let exampleURI = "https://www.launchgate.com/update.json"

    describe("#init") {

      it("the URI is stored in the remote file manager") {
        let remoteFileManager = RemoteFileManager(remoteFileURIString: exampleURI)

        expect(remoteFileManager.remoteFileURI!.absoluteString) == exampleURI
      }

    }

    describe("#fetchRemoteFile") {

      class MockRemoteFileManager: RemoteFileManager {
        var createRemoteFileRequestWasCalledWithRemoteFileURI = false
        var performRemoteFileRequestWasCalled = false

        override func createRemoteFileRequest(uri: NSURL) -> NSURLRequest? {
          if uri.absoluteString == "https://www.launchgate.com/update.json" {
            createRemoteFileRequestWasCalledWithRemoteFileURI = true
          }

          return nil
        }

        override func performRemoteFileRequest(request: NSURLRequest, responseHandler: (data: NSData) -> Void) {
          // no-op
        }
      }

      let remoteFileManager = MockRemoteFileManager(remoteFileURIString: exampleURI)

      beforeEach {
        remoteFileManager.fetchRemoteFile { _ in }
      }

      it("creates a request from the given URI") {
        expect(remoteFileManager.createRemoteFileRequestWasCalledWithRemoteFileURI) == true
      }

      it("performs the remote file request") {
        expect(remoteFileManager.createRemoteFileRequestWasCalledWithRemoteFileURI) == true
      }

    }

  }
}
