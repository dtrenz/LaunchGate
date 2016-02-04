import Quick
import Nimble

@testable import LaunchGate

class LaunchGateSpec: QuickSpec {
  override func spec() {

    let exampleURI = "https://www.example.com/example.json"

    describe("#init") {
      
      it("the URI is stored in the remote file manager") {
        let launchGate = LaunchGate(uri: exampleURI)

        expect(launchGate.remoteFileManager.remoteFileURI!.absoluteString) == exampleURI
      }
      
    }

    describe("#performCheck") {

      class MockLaunchGateRemoteFileManager : LaunchGateRemoteFileManager {
        var fetchRemoteFileWasCalled = false

        override func fetchRemoteFile(callback: (NSData) -> Void) {
          fetchRemoteFileWasCalled = true
        }
      }

      it("calls LaunchGateRemoteFileManager#fetchRemoteFile") {
        let launchGate = LaunchGate(uri: exampleURI)
        let mockRemoteFileManager = MockLaunchGateRemoteFileManager(remoteFileURIString: exampleURI)
        launchGate.remoteFileManager = mockRemoteFileManager

        launchGate.performCheck()

        expect(mockRemoteFileManager.remoteFileURI!.absoluteString) == exampleURI
      }

    }

  }
}
