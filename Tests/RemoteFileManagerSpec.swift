import Quick
import Nimble

@testable import LaunchGate

class RemoteFileManagerSpec: QuickSpec {
  override func spec() {

    let exampleURL = URL(string: "https://www.launchgate.com/update.json")!

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

        override func performRemoteFileRequest(_ session: NSURLSession, url: NSURL, responseHandler: (_ data: NSData) -> Void) {
          if url.absoluteString == "https://www.launchgate.com/update.json" {
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
    
    describe("#performRemoteFileRequest") {
      
      // only mocking this class for verification in the callbackWasCalledWithData check below.
      class MockData: NSData {}
      
      class MockURLSessionDataTask: NSURLSessionDataTask {
        override func resume() {} // stub
      }
      
      class MockURLSession: NSURLSession {
        var dataTaskWithURLWasCalled = false
        
        let testData = MockData()
        
        override func dataTaskWithURL(_ url: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
          dataTaskWithURLWasCalled = true
          
          completionHandler(testData, nil, nil)
          
          return MockURLSessionDataTask()
        }
      }
      
      it("performs the HTTP request") {
        let session = MockURLSession()
        let remoteFileManager = RemoteFileManager(remoteFileURL: exampleURL)
        
        remoteFileManager.performRemoteFileRequest(session, url: exampleURL) { (_) in }
        
        expect(session.dataTaskWithURLWasCalled) == true
      }
      
      it("sends the response data to the callback") {
        let session = MockURLSession()
        let remoteFileManager = RemoteFileManager(remoteFileURL: exampleURL)
        
        var callbackWasCalledWithData = false
        
        remoteFileManager.performRemoteFileRequest(session, url: exampleURL) { (data) in
          if data === session.testData {
            callbackWasCalledWithData = true
          }
        }
        
        expect(callbackWasCalledWithData) == true
      }
      
    }

  }
}
