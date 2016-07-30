import UIKit

class NewDetail : UIViewController {
    // Create a scrollView property that we'll set as our view in -loadView
    let scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
    
    override func loadView() {
        // calling self.view later on will return a UIView!, but we can simply call
        // self.scrollView to adjust properties of the scroll view:
        self.view = self.scrollView
        
        // setup the scroll view
        self.scrollView.contentSize = CGSize(width:1234, height: 5678)
        // etc...
    }
    
    func example() {
        let sampleSubView = UIView()
        self.view.addSubview(sampleSubView) // adds to the scroll view
        
        // cannot do this:
        // self.view.contentOffset = CGPoint(x: 10, y: 20)
        // so instead we do this:
        self.scrollView.contentOffset = CGPoint(x: 10, y: 20)
    }
    
}