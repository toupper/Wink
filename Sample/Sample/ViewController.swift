//
//  ViewController.swift
//  Sample
//
//  Created by Cesar Vargas on 16.11.20.
//

import UIKit
import Wink
import Combine

extension FacialExpression {
  var text: String? {
    switch self {
    case FacialExpression.mouthSmileLeft:
      return "Mouth Smile Left"
    case FacialExpression.mouthSmileRight:
      return "Mouth Smile Right"
    case FacialExpression.browInnerUp:
      return "Brow Inner Up"
    case FacialExpression.tongueOut:
      return "Tonge out"
    case FacialExpression.cheekPuff:
      return "Cheek Puff"
    case FacialExpression.eyeBlinkLeft:
      return "Eye Blink Left"
    case FacialExpression.eyeBlinkRight:
      return "Eye Blink Right"
    case FacialExpression.jawOpen:
      return "Jaw Open"
    default:
      return nil
    }
  }
}

extension FacialExpression {
  static let eyeWideLeft = FacialExpression(rawValue: "eyeWideLeft")
}

class ViewController: UIViewController {
  @IBOutlet weak var facialExpressionsTextView: UITextView!
  private var cancellables = Set<AnyCancellable>()
  let facialExpressionDetectorViewController = FacialExpressionDetectorViewController()

  override func viewDidLoad() {
    super.viewDidLoad()

    addFacialExpressionDetector()
    addMoreFacialExpressionsToBeDetected()
    adjustFacialExpressionView()
    subscribeToFacialExpressionChanges()
  }

  private func addFacialExpressionDetector() {
    addChild(facialExpressionDetectorViewController)

    view.addSubview(facialExpressionDetectorViewController.view)
    facialExpressionDetectorViewController.didMove(toParent: self)
  }

  private func addMoreFacialExpressionsToBeDetected() {
    facialExpressionDetectorViewController.analyzers.append(FacialExpressionAnalyzer(facialExpression: FacialExpression.eyeWideLeft, blendShapeLocation: .eyeWideLeft, minimumValidCoefficient: 0.6))
  }

  private func adjustFacialExpressionView() {
    facialExpressionDetectorViewController.view.translatesAutoresizingMaskIntoConstraints = false
    facialExpressionDetectorViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    facialExpressionDetectorViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
    facialExpressionDetectorViewController.view.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
    facialExpressionDetectorViewController.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
  }

  private func subscribeToFacialExpressionChanges() {
    facialExpressionDetectorViewController.facialExpressionPublisher.sink(receiveValue: { expressions in
      DispatchQueue.main.async {
        self.facialExpressionsTextView.text = expressions.compactMap { $0.text}.joined(separator: ", ")
      }
    }).store(in: &cancellables)
  }
}


