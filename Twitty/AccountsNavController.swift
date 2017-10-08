//
//  AccountsNavController.swift
//  Twitty
//
//  Created by Lia Zadoyan on 10/7/17.
//  Copyright © 2017 Lia Zadoyan. All rights reserved.
//

import UIKit

class AccountsNavController: UINavigationController, HalfModalPresentable {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isHalfModalMaximized() ? .default : .lightContent
    }
}
