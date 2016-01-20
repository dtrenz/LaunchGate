import Quick
import Nimble

@testable import LaunchGate

class LaunchGateSpec: QuickSpec {
  override func spec() {
    describe("the update URI") {
      
      it("is configurable") {
        let testURI = "https://www.launchgate.com/update.json"
        
        let launchGate = LaunchGate(uri: testURI)
        
        expect(launchGate.uri) == "https://www.launchgate.com/update.json"
      }
      
    }
  }
}
