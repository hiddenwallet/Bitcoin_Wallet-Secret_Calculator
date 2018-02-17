import UIKit

@IBDesignable
class roundButton: UIButton {
    @IBInspectable var RoundButton:Bool = false{
        didSet{
            if RoundButton{
                setCornerRadius()
            }
        }
    }
    override func prepareForInterfaceBuilder() {
        if RoundButton {
            setCornerRadius()
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setCornerRadius()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius()
    }
    
    func setCornerRadius() {
        layer.cornerRadius = 0
        layer.borderColor = UIColor(white: 1.0, alpha: 0.1).cgColor
        layer.borderWidth = 0.5
    }
    
//    override var isHighlighted: Bool{
//        didSet{
//            if isHighlighted{
//                let animateView = UIView(frame: frame)
//                animateView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
//                animateView.layer.cornerRadius = animateView.frame.height / 2.0
//                
//                superview?.addSubview(animateView)
//                
//                UIView.animate(withDuration: 0.2, animations: {
//                    animateView.transform = CGAffineTransform(scaleX: 5, y: 5)
//                    animateView.alpha = 0.0
//                }, completion: { (finished) in
//                    animateView.removeFromSuperview()
//                })
//            }
//        }
//    }
    
}
