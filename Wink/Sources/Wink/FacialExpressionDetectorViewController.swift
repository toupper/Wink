//
//  FacialExpressionDetectorViewController.swift
//  
//
//  Created by Cesar Vargas on 16.11.20.
//

import Foundation
import UIKit
import ARKit
import Combine

public class FacialExpressionDetectorViewController: UIViewController, ARSCNViewDelegate {
  var sceneView: ARSCNView!

  public var analyzers = DefaultFacialExpressionAnalyzersProvider().defaultFacialExpressionAnalyzers()

  lazy public var facialExpressionPublisher: AnyPublisher<[FacialExpression], Never> = facialExpressionSubject.eraseToAnyPublisher()
  private let facialExpressionSubject: PassthroughSubject<[FacialExpression], Never> = PassthroughSubject<[FacialExpression], Never>()

  public override func viewDidLoad() {
    super.viewDidLoad()

    sceneView = ARSCNView()

    self.view.addSubview(sceneView)

      guard ARFaceTrackingConfiguration.isSupported else {
          fatalError("Face tracking not available on this on this device model!")
      }

      sceneView.delegate = self
      sceneView.showsStatistics = true
    }

  private func adjustSceneViewConstraints() {
    sceneView.translatesAutoresizingMaskIntoConstraints = false
    sceneView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    sceneView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
    sceneView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    let configuration = ARFaceTrackingConfiguration()
      sceneView.session.run(configuration)
  }

  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    sceneView.session.pause()
  }

  public func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let faceMesh = ARSCNFaceGeometry(device: sceneView.device!)
        let node = SCNNode(geometry: faceMesh)
        node.geometry?.firstMaterial?.fillMode = .lines
        return node
    }

  public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    if let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry {
      faceGeometry.update(from: faceAnchor.geometry)
      detectFacialExpression(from: faceAnchor)
    }
  }

  func detectFacialExpression(from anchor: ARFaceAnchor) {
    let facialExpressions: [FacialExpression] = analyzers.compactMap {
      let blendShape = anchor.blendShapes[$0.blendShapeLocation]

      return blendShape?.decimalValue ?? 0.0 > $0.minimumValidCoefficient ? $0.facialExpression : nil
    }

    facialExpressionSubject.send(facialExpressions)
  }
}
