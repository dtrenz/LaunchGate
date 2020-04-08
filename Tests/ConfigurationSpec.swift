import Quick
import Nimble

@testable import LaunchGate

class ConfigurationSpec: QuickSpec {
  override func spec() {
    
    describe("AlertConfiguration") {
      
      describe("#init?") {
      
        context("when the alert message is not empty") {
          it("returns an instance of AlertConfiguration") {
            let alertConfig = AlertConfiguration(message: "Hello world", blocking: false)
            
            expect(alertConfig).notTo(beNil())
          }
        }
        
        context("when the alert message is empty") {
          it("returns nil") {
            let alertConfig = AlertConfiguration(message: "", blocking: false)
            
            expect(alertConfig).to(beNil())
          }
        }
        
      }
      
      describe("#rememberKey") {
        
        it("returns the expected key") {
          let alertConfig = AlertConfiguration(message: "Hello world", blocking: false)
          
          expect(alertConfig!.rememberKey) == "LAST_ALERT"
        }
        
      }
      
      describe("#rememberValue") {
        
        it("returns the alert message") {
          let alertConfig = AlertConfiguration(message: "Hello world", blocking: false)
          
          expect(alertConfig!.rememberString) == alertConfig!.message
        }
        
      }
      
    }
    
    describe("UpdateConfiguration") {
      
      describe("#init?") {
        
        context("when the update message && version are not empty") {
          it("returns an instance of UpdateConfiguration") {
            let updateConfig = UpdateConfiguration(version: "1.0", message: "An update is available.")
            
            expect(updateConfig).notTo(beNil())
          }
        }
        
        context("when the update version is empty") {
          it("returns nil") {
            let updateConfig = UpdateConfiguration(version: "", message: "An update is available.")
            
            expect(updateConfig).to(beNil())
          }
        }
        
        context("when the update message is empty") {
          it("returns nil") {
            let updateConfig = UpdateConfiguration(version: "1.0", message: "")
            
            expect(updateConfig).to(beNil())
          }
        }
        
      }
      
      describe("#rememberKey") {
        
        it("returns the expected key") {
          let updateConfig = UpdateConfiguration(version: "1.0", message: "An update is available.")
          
          expect(updateConfig!.rememberKey) == "OPTIONAL_UPDATE"
        }
        
      }
      
      describe("#rememberValue") {
        
        it("returns the update version") {
          let updateConfig = UpdateConfiguration(version: "1.0", message: "An update is available.")
          
          expect(updateConfig!.rememberString) == updateConfig!.version
        }
        
      }
      
    }

  }
}
