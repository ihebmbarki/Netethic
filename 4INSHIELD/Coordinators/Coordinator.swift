//
//  Coordinator.swift
//  4INSHIELD
//
//  Created by kaisensData on 4/7/2023.
//

import Foundation
import UIKit

protocol Coordinator{
    var childCoordinators: [Coordinator] {get set}
    var navigationController: UINavigationController {get set}
    
    func start()
}
