import Quick
import Nimble

@testable import LaunchGate

class DefaultParserSpec: QuickSpec {
  override func spec() {
    
    describe("#parse") {
      
      var jsonData: Data!
      var parser: LaunchGateParser!
      
      beforeEach {
        parser = DefaultParser()
      }
      
      context("when valid JSON data is provided") {
        
        var config: LaunchGateConfiguration!
        
        beforeEach {
          jsonData = try! SpecHelper.loadFixture("config.json")
          config = parser.parse(jsonData)
        }
        
        it("parses the alert message from the configuration file") {
          expect(config.alert!.message) == "We are currently performing server maintenance. Please try again later."
        }
        
        it("parses the alert blocking flag from the configuration file") {
          expect(config.alert!.blocking) == true
        }
        
        it("parses the optional update version from the configuration file") {
          expect(config.optionalUpdate!.version) == "1.2"
        }
        
        it("parses the optional update message from the configuration file") {
          expect(config.optionalUpdate!.message) == "A new version of this app is available."
        }
        
        it("parses the required update version from the configuration file") {
          expect(config.requiredUpdate!.version) == "1.1"
        }
        
        it("parses the required update message from the configuration file") {
          expect(config.requiredUpdate!.message) == "An update is required to continue using this app."
        }
        
      }
      
      context("when an empty JSON configuration is provided") {
        
        it("returns nil") {
          jsonData = try! SpecHelper.loadFixture("config-malformed-empty.json")
          
          let config = parser.parse(jsonData)
          
          expect(config).to(beNil())
        }
        
      }
      
      context("when the JSON configuration data is missing an ios object") {
        
        it("returns nil") {
          jsonData = try! SpecHelper.loadFixture("config-malformed-ios.json")
          
          let config = parser.parse(jsonData)
          
          expect(config).to(beNil())
        }
        
      }
      
      context("when the JSON configuration only contains an alert object") {
        
        it("the alert configuration should not be nil") {
          jsonData = try! SpecHelper.loadFixture("config-alert.json")
          
          let config = parser.parse(jsonData)
          
          expect(config!.alert).toNot(beNil())
        }
        
        it("the optional update configuration should be nil") {
          jsonData = try! SpecHelper.loadFixture("config-alert.json")
          
          let config = parser.parse(jsonData)
          
          expect(config!.optionalUpdate).to(beNil())
        }
        
        it("the required update configuration should be nil") {
          jsonData = try! SpecHelper.loadFixture("config-alert.json")
          
          let config = parser.parse(jsonData)
          
          expect(config!.requiredUpdate).to(beNil())
        }
        
      }
      
      context("when the JSON configuration only contains an optionalUpdate object") {
        
        it("the optional update configuration should not be nil") {
          jsonData = try! SpecHelper.loadFixture("config-optional.json")
          
          let config = parser.parse(jsonData)
          
          expect(config!.optionalUpdate).toNot(beNil())
        }
        
        it("the alert configuration should be nil") {
          jsonData = try! SpecHelper.loadFixture("config-optional.json")
          
          let config = parser.parse(jsonData)
          
          expect(config!.alert).to(beNil())
        }
        
        it("the required update configuration should be nil") {
          jsonData = try! SpecHelper.loadFixture("config-optional.json")
          
          let config = parser.parse(jsonData)
          
          expect(config!.requiredUpdate).to(beNil())
        }
        
      }
      
      context("when the JSON configuration only contains a requiredUpdate object") {
        
        it("the required update configuration should not be nil") {
          jsonData = try! SpecHelper.loadFixture("config-required.json")
          
          let config = parser.parse(jsonData)
          
          expect(config!.requiredUpdate).toNot(beNil())
        }
        
        it("the alert configuration should be nil") {
          jsonData = try! SpecHelper.loadFixture("config-required.json")
          
          let config = parser.parse(jsonData)
          
          expect(config!.alert).to(beNil())
        }
        
        it("the optional update configuration should be nil") {
          jsonData = try! SpecHelper.loadFixture("config-required.json")
          
          let config = parser.parse(jsonData)
          
          expect(config!.optionalUpdate).to(beNil())
        }
        
      }
      
      context("when the JSON configuration contains a malformed alert object") {
        
        it("returns nil") {
          jsonData = try! SpecHelper.loadFixture("config-malformed-alert.json")
          
          let config = parser.parse(jsonData)
          
          expect(config).to(beNil())
        }
        
      }
      
      context("when the JSON configuration contains a malformed optionalUpdate object") {
        
        it("returns nil") {
          jsonData = try! SpecHelper.loadFixture("config-malformed-optional.json")
          
          let config = parser.parse(jsonData)
          
          expect(config).to(beNil())
        }
        
      }
      
      context("when the JSON configuration contains a malformed requiredUpdate object") {
        
        it("returns nil") {
          jsonData = try! SpecHelper.loadFixture("config-malformed-required.json")
          
          let config = parser.parse(jsonData)
          
          expect(config).to(beNil())
        }
        
      }
      
    }
    
  }
}
