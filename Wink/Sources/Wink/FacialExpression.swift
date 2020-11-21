//
//  DefaultFacialExpressionAnalyzersProvider.swift
//  
//
//  Created by Cesar Vargas on 21.11.20.
//

import Foundation
import ARKit

public struct FacialExpression: RawRepresentable, Equatable {
  public var rawValue: String

  public init(rawValue: String) {
    self.rawValue = rawValue
  }

  public typealias RawValue = String

  public static let mouthSmileLeft = FacialExpression(rawValue: "mouthSmileLeft")
  public static let mouthSmileRight = FacialExpression(rawValue: "mouthSmileRight")
  public static let browInnerUp =  FacialExpression(rawValue: "browInnerUp")
  public static let tongueOut =  FacialExpression(rawValue: "tongueOut")
  public static let cheekPuff =  FacialExpression(rawValue: "cheekPuff")
  public static let eyeBlinkLeft =  FacialExpression(rawValue: "eyeBlinkLeft")
  public static let eyeBlinkRight =  FacialExpression(rawValue: "eyeBlinkRight")
  public static let jawOpen =  FacialExpression(rawValue: "jawOpen")
}

extension FacialExpression {
  static let test = FacialExpression(rawValue: "")
}

public struct FacialExpressionAnalyzer {
  let facialExpression: FacialExpression
  let blendShapeLocation: ARFaceAnchor.BlendShapeLocation
  let minimumValidCoefficient: Decimal

  public init(facialExpression: FacialExpression,
       blendShapeLocation: ARFaceAnchor.BlendShapeLocation,
       minimumValidCoefficient: Decimal = 0.5) {
    self.facialExpression = facialExpression
    self.blendShapeLocation = blendShapeLocation
    self.minimumValidCoefficient = minimumValidCoefficient
  }
}

final class DefaultFacialExpressionAnalyzersProvider {
  func defaultFacialExpressionAnalyzers() -> [FacialExpressionAnalyzer] {
    [FacialExpressionAnalyzer(facialExpression: FacialExpression.mouthSmileLeft, blendShapeLocation: .mouthSmileLeft),
     FacialExpressionAnalyzer(facialExpression: FacialExpression.mouthSmileRight, blendShapeLocation: .mouthSmileRight),
     FacialExpressionAnalyzer(facialExpression: FacialExpression.browInnerUp, blendShapeLocation: .browInnerUp),
     FacialExpressionAnalyzer(facialExpression: FacialExpression.tongueOut, blendShapeLocation: .tongueOut),
     FacialExpressionAnalyzer(facialExpression: FacialExpression.cheekPuff, blendShapeLocation: .cheekPuff),
     FacialExpressionAnalyzer(facialExpression: FacialExpression.eyeBlinkLeft, blendShapeLocation: .eyeBlinkLeft),
     FacialExpressionAnalyzer(facialExpression: FacialExpression.eyeBlinkRight, blendShapeLocation: .eyeBlinkRight),
     FacialExpressionAnalyzer(facialExpression: FacialExpression.jawOpen, blendShapeLocation: .jawOpen)]
  }
}
