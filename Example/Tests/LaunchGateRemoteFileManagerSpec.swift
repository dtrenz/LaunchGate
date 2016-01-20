import Quick
import Nimble

@testable import LaunchGate

class LaunchGateRemoteFileManagerSpec: QuickSpec {
  override func spec() {
    describe("the update URI") {
      
      it("is configurable") {
        let testURI = "https://www.launchgate.com/update.json"
        
        let remoteFileManager = LaunchGateRemoteFileManager(remoteFileURI: testURI)
        
        expect(remoteFileManager.remoteFileURI.URLString) == "https://www.launchgate.com/update.json"
      }
      
    }
  }
}
