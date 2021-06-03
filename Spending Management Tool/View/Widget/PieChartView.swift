

import UIKit

public class DataPoint {
    let text: String
    let value: Float
    let color: UIColor

    public init(text: String, value: Float, color: UIColor) {
        self.text = text
        self.value = value
        self.color = color
    }
}

@IBDesignable public class PieChartView: UIView {

    public var dataPoints: [DataPoint]? {          // use whatever type that makes sense for your app, though I'd suggest an array (which is ordered) rather than a dictionary (which isn't)
        didSet { setNeedsDisplay() }
    }

    @IBInspectable public var lineWidth: CGFloat = 2 {
        didSet { setNeedsDisplay() }
    }

    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        dataPoints = [
            DataPoint(text: "foo", value: 3, color: UIColor.red),
            DataPoint(text: "bar", value: 4, color: UIColor.yellow),
            DataPoint(text: "baz", value: 5, color: UIColor.blue)
        ]
    }

    public override func draw(_ rect: CGRect) {
        guard dataPoints != nil else {
            return
        }

        let center = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
        let radius = min(bounds.size.width, bounds.size.height) / 2.0 - lineWidth
        let total = dataPoints?.reduce(Float(0)) { $0 + $1.value }
        var startAngle = CGFloat(Double.pi / 2)

        UIColor.black.setStroke()

        for dataPoint in dataPoints! {
            let endAngle = startAngle + CGFloat(2.0 * Double.pi) * CGFloat(dataPoint.value / total!)

            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.close()
            path.lineWidth = lineWidth
            dataPoint.color.setFill()

            path.fill()
            path.stroke()

            startAngle = endAngle
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
}
