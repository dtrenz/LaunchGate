import Quick
import Nimble

@testable import LaunchGate

class DialogManagerSpec: QuickSpec {
  override func spec() {
    
    describe("#displayAlertDialog") {
      
      it("passes the alert type and alert message to createAlertController") {
        
        class MockDialogManager: DialogManager {
          var testAlert: AlertConfiguration!
          var createAlertControllerWasCalledWithAlert = false
          
          override func createAlertController(_ type: DialogManager.DialogType, message: String) -> UIAlertController {
            if case let .Alert(blocking) = type, blocking == testAlert.blocking && message == testAlert.message {
              createAlertControllerWasCalledWithAlert = true
            }
            
            return UIAlertController()
          }
          
          override func displayAlertController(_ alert: UIAlertController, completion: (() -> Void)?) {}  // stub
        }
        
        let alert = AlertConfiguration(message: "Hello World", blocking: true)!
        let dialogManager = MockDialogManager()
        dialogManager.testAlert = alert
        
        dialogManager.displayAlertDialog(alert, blocking: alert.blocking)
        
        expect(dialogManager.createAlertControllerWasCalledWithAlert) == true
      }
      
    }
    
    describe("dialog memory logic ") {
      
      class MockViewController: UIViewController {
        override func presentViewController(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
          completion!()
        }
      }
      
      class MockDialogManager: DialogManager {
        override func topViewController() -> UIViewController? {
          return MockViewController()
        }
      }
      
      let dialogManager = MockDialogManager()
      
      context("when displaying a non-blocking alert dialog") {
        it("the alert should be remembered") {
          let alert = AlertConfiguration(message: "Hello World", blocking: false)!
          
          Memory.forget(alert)
          
          dialogManager.displayAlertDialog(alert, blocking: alert.blocking)
          
          expect(Memory.contains(alert)).toEventually(beTrue())
        }
      }
      
      context("when displaying a blocking alert dialog") {
        it("the alert should not be remembered") {
          let alert = AlertConfiguration(message: "Hello World", blocking: true)!
          
          Memory.forget(alert)
          
          dialogManager.displayAlertDialog(alert, blocking: alert.blocking)
          
          expect(Memory.contains(alert)).toEventually(beFalse())
        }
      }
      
      context("when displaying an optional update dialog") {
        it("the optional update should be remembered") {
          let update = UpdateConfiguration(version: "1.2", message: "Update available")!
          
          Memory.forget(update)
          
          dialogManager.displayOptionalUpdateDialog(update, updateURL: NSURL())
          
          expect(Memory.contains(update)).toEventually(beTrue())
        }
      }
      
      context("when displaying a required update dialog") {
        it("the required update should not be remembered") {
          let update = UpdateConfiguration(version: "1.1", message: "Update required")!
          
          Memory.forget(update)
          
          dialogManager.displayRequiredUpdateDialog(update, updateURL: NSURL())
          
          expect(Memory.contains(update)).toEventually(beFalse())
        }
      }
      
    }

  }
}
