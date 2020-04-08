import Quick
import Nimble

@testable import LaunchGate

class MemorySpec: QuickSpec {
    override func spec() {

        struct RememberableItem: Rememberable {
            var rememberKey: String { "rememberKey" }
            var rememberString: String { "rememberString" }
        }

        describe("#remember") {
            it("stores the item in user defaults") {
                let item = RememberableItem()
                Memory.forget(item)
                
                Memory.remember(item)
                
                expect(UserDefaults.standard.string(forKey: item.rememberKey)) == item.rememberString
            }
        }
        
        describe("#forget") {
            it("removes the item from user defaults") {
                let item = RememberableItem()
                Memory.remember(item)
                
                Memory.forget(item)
                
                expect(UserDefaults.standard.string(forKey: item.rememberKey)).to(beNil())
            }
        }
        
        describe("#contains") {
            
            context("when the item is stored in memory") {
                it("returns true") {
                    let item = RememberableItem()
                    Memory.remember(item)
                    
                    expect(Memory.contains(item)) == true
                }
            }
            
            context("when the item is not stored in memory") {
                it("returns false") {
                    let item = RememberableItem()
                    Memory.forget(item)
                    
                    expect(Memory.contains(item)) == false
                }
            }
            
        }
        
    }
}
