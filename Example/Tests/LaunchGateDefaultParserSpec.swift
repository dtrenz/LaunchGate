import Quick
import Nimble


@testable import LaunchGate

class LaunchGateDefaultParserSpec: QuickSpec {
  override func spec() {
    
    describe("#parse") {
      
      var jsonData: NSData!
      var parser: LaunchGateParser!
      
      beforeEach {
        parser = LaunchGateDefaultParser()
      }
      
      context("when valid JSON data is provided") {
        
        var config: LaunchGateConfiguration!
        
        beforeEach {
          jsonData = try! LaunchGateSpecHelper.loadFixture("config.json")
          config = parser.parse(jsonData)
        }
        
        it("parses the alert message from the configuration file") {
          expect(config.alert!.message) == "We are currently performing server maintenance. Please try again later."
        }
        
        it("parses the alert blocking flag from the configuration file") {
          expect(config.alert!.blocking) == true
        }
        
        it("parses the optional update version from the configuration file") {
          expect(config.optionalUpdate!.version) == "2.0"
        }
        
        it("parses the optional update message from the configuration file") {
          expect(config.optionalUpdate!.message) == "A new version of the application is available, please click below to update to the latest version."
        }
        
        it("parses the required update version from the configuration file") {
          expect(config.requiredUpdate!.version) == "1.2"
        }
        
        it("parses the required update message from the configuration file") {
          expect(config.requiredUpdate!.message) == "A new version of the application is available and is required to continue, please click below to update to the latest version."
        }
        
      }
      
      context("when an empty JSON configuration is provided") {
        
        it("returns nil") {
          jsonData = try! LaunchGateSpecHelper.loadFixture("config-malformed-empty.json")
          
          let config = parser.parse(jsonData)
          
          expect(config).to(beNil())
        }
        
      }
      
      context("when the JSON configuration data is missing an ios object") {
        
        it("returns nil") {
          jsonData = try! LaunchGateSpecHelper.loadFixture("config-malformed-ios.json")
          
          let config = parser.parse(jsonData)
          
          expect(config).to(beNil())
        }
        
      }
      
      context("when the JSON configuration data is missing an alert object") {
        
        it("returns nil") {
          jsonData = try! LaunchGateSpecHelper.loadFixture("config-malformed-alert.json")
          
          let config = parser.parse(jsonData)
          
          expect(config).to(beNil())
        }
        
      }
      
      context("when the JSON configuration data is missing an optionalUpdate object") {
        
        it("returns nil") {
          jsonData = try! LaunchGateSpecHelper.loadFixture("config-malformed-optional.json")
          
          let config = parser.parse(jsonData)
          
          expect(config).to(beNil())
        }
        
      }
      
      context("when the JSON configuration data is missing an requiredUpdate object") {
        
        it("returns nil") {
          jsonData = try! LaunchGateSpecHelper.loadFixture("config-malformed-alert.json")
          
          let config = parser.parse(jsonData)
          
          expect(config).to(beNil())
        }
        
      }
      
    }
    
  }
}