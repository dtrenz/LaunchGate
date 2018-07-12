import Quick
import Nimble

@testable import LaunchGate

class LaunchGateSpec: QuickSpec {
  override func spec() {

    let configURI = "https://www.example.com/example.json"
    let appStoreURI = "itms-apps://itunes.apple.com/us/app/wikipedia-mobile/id324715238"

    describe("#init") {
      
      let illegalURI = " " // spaces are illegal URL characters
      
      it("returns nil, if the configURI is not a valid URL") {
        let launchGate = LaunchGate(configURI: illegalURI, appStoreURI: appStoreURI)

        expect(launchGate).to(beNil())
      }
      
      it("returns nil, if the appStoreURI is not a valid URL") {
        let launchGate = LaunchGate(configURI: configURI, appStoreURI: illegalURI)
        
        expect(launchGate).to(beNil())
      }
      
      it("creates a URL from the configURI") {
        let launchGate = LaunchGate(configURI: configURI, appStoreURI: appStoreURI)
        
        expect(launchGate!.configurationFileURL.absoluteString) == configURI
      }
      
      it("creates a URL from the appStoreURI") {
        let launchGate = LaunchGate(configURI: configURI, appStoreURI: appStoreURI)
        
        expect(launchGate!.updateURL.absoluteString) == appStoreURI
      }
      
    }
    
    describe("#check") {
      
      class MockLaunchGate: LaunchGate {
        var performCheckWasCalledWithRemoteFileManager = false
        
        override func performCheck(_ remoteFileManager: RemoteFileManager) {
          if remoteFileManager.remoteFileURL.absoluteString == "https://www.example.com/example.json" {
            performCheckWasCalledWithRemoteFileManager = true
          }
        }
      }
      
      it("calls performCheck with a remote file manager that has been initialized with the config URI") {
        let launchGate = MockLaunchGate(configURI: configURI, appStoreURI: appStoreURI)
        
        launchGate!.check()
        
        expect(launchGate!.performCheckWasCalledWithRemoteFileManager) == true
      }
      
    }

    describe("#performCheck") {
      let jsonData = try! SpecHelper.loadFixture("config.json")

      class MockRemoteFileManager: RemoteFileManager {
        var testData: Data!
        
        var fetchRemoteFileWasCalled = false

        override func fetchRemoteFile(_ callback: @escaping (Data) -> Void) {
          fetchRemoteFileWasCalled = true
          
          callback(testData)
        }
      }
      
      var mockRemoteFileManager: MockRemoteFileManager!
      
      beforeEach {
        mockRemoteFileManager = MockRemoteFileManager(remoteFileURL: URL(string: "https://raw.githubusercontent.com/dtrenz/LaunchGate/master/example.json")!)
        mockRemoteFileManager.testData = jsonData
      }

      it("calls LaunchGateRemoteFileManager#fetchRemoteFile") {
        let launchGate = LaunchGate(configURI: configURI, appStoreURI: appStoreURI)

        launchGate!.performCheck(mockRemoteFileManager)

        expect(mockRemoteFileManager.fetchRemoteFileWasCalled) == true
      }
      
      context("when the configuration JSON is downloaded") {
        
        class MockParser: LaunchGateParser {
          var testData: Data!
          var parseWasCalledWithJSON = false
          
          func parse(_ jsonData: Data) -> LaunchGateConfiguration? {
            if jsonData == testData {
              parseWasCalledWithJSON = true
            }
            
            return LaunchGateConfiguration(alert: nil, optionalUpdate: nil, requiredUpdate: nil)
          }
        }
        
        let parser = MockParser()
        
        beforeEach {
          parser.testData = jsonData
        }
        
        it("uses its parser to parse the JSON") {
          let launchGate = LaunchGate(configURI: configURI, appStoreURI: appStoreURI)
          launchGate!.parser = parser
          
          launchGate!.performCheck(mockRemoteFileManager)
          
          expect(parser.parseWasCalledWithJSON) == true
        }
        
        it("calls displayDialogIfNecessary") {
          
          class MockLaunchGate: LaunchGate {
            var testConfig: LaunchGateConfiguration!
            
            var displayDialogWasCalled = false
            
            override func displayDialogIfNecessary(_ config: LaunchGateConfiguration, dialogManager: DialogManager) {
              displayDialogWasCalled = true
            }
          }
          
          let launchGate = MockLaunchGate(configURI: configURI, appStoreURI: appStoreURI)
          launchGate!.parser = parser
          
          launchGate!.performCheck(mockRemoteFileManager)
          
          expect(launchGate!.displayDialogWasCalled) == true
          
        }
      }

    }
    
    describe("#displayDialogIfNecessary") {
      
      class MockLaunchGate: LaunchGate {
        override func currentAppVersion() -> String? { return "1.0" }
      }
      
      class MockDialogManager: DialogManager {
        var displayAlertDialogWasCalled = false
        var displayRequiredUpdateDialogWasCalled = false
        var displayOptionalUpdateDialogWasCalled = false
        
        override func displayAlertDialog(_ configObject: DialogManager.RememberableDialogSubject, blocking: Bool) { displayAlertDialogWasCalled = true }
        override func displayOptionalUpdateDialog(_ updateConfig: RememberableDialogSubject, updateURL: URL) { displayOptionalUpdateDialogWasCalled = true }
        override func displayRequiredUpdateDialog(_ updateConfig: Dialogable, updateURL: URL) { displayRequiredUpdateDialogWasCalled = true }
      }
      
      var launchGate: MockLaunchGate!
      var dialogManager: MockDialogManager!
      var config: LaunchGateConfiguration!
      
      beforeEach {
        launchGate = MockLaunchGate(configURI: configURI, appStoreURI: appStoreURI)
        dialogManager = MockDialogManager()
        config = LaunchGateConfiguration()
      }
      
      context("when the app is eligible for a required update") {
        
        it("displays a required update dialog") {
          config.requiredUpdate = UpdateConfiguration(version: "1.1", message: "Update required!")
          
          launchGate.displayDialogIfNecessary(config, dialogManager: dialogManager)
          
          expect(dialogManager.displayRequiredUpdateDialogWasCalled) == true
        }
        
      }
        
       context("when the app is eligible for an optional update") {
                
        it("displays an optional update dialog") {
            let optionalUpdate = UpdateConfiguration(version: "1.2", message: "Optional update availabe.")
            config.optionalUpdate = optionalUpdate
            Memory.forget(optionalUpdate!)

            launchGate.displayDialogIfNecessary(config, dialogManager: dialogManager)
                    
          expect(dialogManager.displayOptionalUpdateDialogWasCalled) == true
        }
      }
      
      context("when an alert should be displayed") {
        
        it("displays an alert dialog") {
          let alert = AlertConfiguration(message: "Hello world", blocking: true)
          config.alert = alert
          Memory.forget(alert!)
          
          launchGate.displayDialogIfNecessary(config, dialogManager: dialogManager)
          
          expect(dialogManager.displayAlertDialogWasCalled) == true
        }
        
      }
      
    }
    
    describe("#shouldShowAlertDialog") {
      
      var launchGate: LaunchGate!
      
      beforeEach {
        launchGate = LaunchGate(configURI: configURI, appStoreURI: appStoreURI)
      }
      
      context("given the alert HAS NOT been displayed before") {
        
        context("when the alert is a blocking alert") {
          it("returns true") {
            let alertConfig = AlertConfiguration(message: "Hello world", blocking: true)!
            Memory.forget(alertConfig)
            
            let result = launchGate.shouldShowAlertDialog(alertConfig)
            
            expect(result) == true
          }
        }
        
      }
      
      context("given the alert HAS been displayed before") {
        
        context("when the alert is a blocking alert") {
          it("returns true") {
            let alertConfig = AlertConfiguration(message: "Hello world", blocking: true)!
            Memory.remember(alertConfig)
            
            let result = launchGate.shouldShowAlertDialog(alertConfig)
            
            expect(result) == true
          }
        }
        
      }
      
    }
    
    describe("#shouldShowOptionalUpdateDialog") {
      
      var launchGate: LaunchGate!
      let updateConfig = UpdateConfiguration(version: "1.2", message: "An update is available")!
      
      beforeEach {
        launchGate = LaunchGate(configURI: configURI, appStoreURI: appStoreURI)
        Memory.forget(updateConfig)
      }
      
      context("given the update HAS NOT been displayed before") {
        
        beforeEach {
          Memory.forget(updateConfig)
        }
        
        context("when the app version is LESS THAN the update version") {
          let appVersion = "1.0"
        
          it("returns true") {
            Memory.forget(updateConfig)
            let result = launchGate.shouldShowOptionalUpdateDialog(updateConfig, appVersion: appVersion)
            
            expect(result) == true
          }
        }
        
        context("when the app version is GREATER THAN the update version") {
          let appVersion = "1.3"
        
          it("returns false") {
            let result = launchGate.shouldShowOptionalUpdateDialog(updateConfig, appVersion: appVersion)
            
            expect(result) == false
          }
        }
        
        context("when the app version is EQUAL TO the update version") {
          let appVersion = "1.2"
          
          it("returns false") {
            let result = launchGate.shouldShowOptionalUpdateDialog(updateConfig, appVersion: appVersion)
            
            expect(result) == false
          }
        }
        
      }
      
      context("given the update HAS been displayed before") {
        
        beforeEach {
          Memory.remember(updateConfig)
        }
        
        context("when the app version is LESS THAN the update version") {
          let appVersion = "1.1"
          
          it("returns true") {
            let result = launchGate.shouldShowOptionalUpdateDialog(updateConfig, appVersion: appVersion)
            
            expect(result) == false
          }
        }

      }
      
    }
    
    describe("#shouldShowRequiredUpdateDialog") {
      
      var launchGate: LaunchGate!
      let updateConfig = UpdateConfiguration(version: "1.1", message: "An update is available.")!
      
      beforeEach {
        launchGate = LaunchGate(configURI: configURI, appStoreURI: appStoreURI)
      }
      
      it("when the app version is less than the update version, returns true") {
        let result = launchGate.shouldShowRequiredUpdateDialog(updateConfig, appVersion: "1.0")
        
        expect(result) == true
      }
      
      it("when the app version is greater than the update version, returns falses") {
        let result = launchGate.shouldShowRequiredUpdateDialog(updateConfig, appVersion: "1.2")
        
        expect(result) == false
      }
      
      it("when the app version is equal to the update version, returns false") {
        let result = launchGate.shouldShowRequiredUpdateDialog(updateConfig, appVersion: "1.1")
        
        expect(result) == false
      }
      
    }

  }
}
