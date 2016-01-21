import Quick
import Nimble

<<<<<<< HEAD
import Alamofire


=======
>>>>>>> develop
@testable import LaunchGate

class LaunchGateRemoteFileManagerSpec: QuickSpec {
  override func spec() {
<<<<<<< HEAD
    
    let exampleURI = "https://www.launchgate.com/update.json"
    
    describe("#init") {
      
      it("the URI is stored in the remote file manager") {
        let remoteFileManager = LaunchGateRemoteFileManager(remoteFileURI: exampleURI)
        
        expect(remoteFileManager.remoteFileURI.URLString) == exampleURI
      }
      
    }
    
    describe("#fetchRemoteFile") {
      
      class MockLaunchGateRemoteFileManager : LaunchGateRemoteFileManager {
        var createRemoteFileRequestWasCalledWithRemoteFileURI = false
        var performRemoteFileRequestWasCalled = false
        
        override func createRemoteFileRequest(uri: URLStringConvertible) -> Request? {
          if uri.URLString == "https://www.launchgate.com/update.json" {
            createRemoteFileRequestWasCalledWithRemoteFileURI = true
          }
          
          return nil
        }
        
        override func performRemoteFileRequest(request: Request, responseHandler: (response: AnyObject?) -> Void) {
          request.responseJSON { response in
            //
          }
        }
      }
      
      let remoteFileManager = MockLaunchGateRemoteFileManager(remoteFileURI: exampleURI)
      
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
    
=======
    describe("the update URI") {
      
      it("is configurable") {
        let testURI = "https://www.launchgate.com/update.json"
        
        let remoteFileManager = LaunchGateRemoteFileManager(remoteFileURI: testURI)
        
        expect(remoteFileManager.remoteFileURI.URLString) == "https://www.launchgate.com/update.json"
      }
      
    }
>>>>>>> develop
  }
}
