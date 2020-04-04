//
//  NativeDialog.swift
//  RNNativeDialog
//
//  Created by Heysem Katibi on 1/23/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import UIKit
import PopupDialog

@objc(NativeDialog)
class NativeDialog: RCTEventEmitter {

  override func supportedEvents() -> [String]! {
    return ["native_dialog__positive_button", "native_dialog__negative_button", "native_dialog__neutral_button", "native_dialog__dismiss_dialog"]
  }

  @objc
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }

  func buildParams(_ button: DialogButton) -> [String: String] {
    switch button {
    case .positive:
      return ["action": "positive"]
    case .negative:
      return ["action": "negative"]
    case .neutral:
      return ["action": "neutral"]
    }
  }

  @objc(showDialog: resolver: rejecter:)
  func showDialog(options: [String: Any], resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    guard let viewConroller = UIApplication.shared.keyWindow?.rootViewController else {
      return
    }

    let dialogOptions = DialogOptions(options: options)

    var resolved = false
    dialogOptions.finishHandler = { (button, extras) in
      if !resolved {
        let params = self.buildParams(button)
        resolve(params)
        resolved = true
      }
    }

    dialogOptions.dismissHandler = {
      if !resolved {
        resolve(["action": "dismiss"])
        resolved = true
      }
    }

    dialogOptions.presentDialog(in: viewConroller)
  }

  @objc(showInputDialog: resolver: rejecter:)
  func showInputDialog(options: [String: Any], resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
      return
    }

    let dialogOptions = InputDialogOptions(options: options)

    var resolved = false
    dialogOptions.finishHandler = { (button, extras) in
      if !resolved {
        let params = self.buildParams(button)
        resolve(extras?.merging(params) { (_, new) in new })
        resolved = true
      }
    }

    dialogOptions.dismissHandler = {
      if !resolved {
        resolve(["action": "dismiss"])
        resolved = true
      }
    }

    dialogOptions.presentDialog(in: viewController)
  }

  @objc(showItemsDialog: resolver: rejecter:)
  func showItemsDialog(options: [String: Any], resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    guard let viewConroller = UIApplication.shared.keyWindow?.rootViewController else {
      return
    }


    let dialogOptions = ItemsDialogOptions(options: options)

    var resolved = false
    dialogOptions.itemSelectHandler = { (selectedIds) in
      if !resolved {
        resolve(["action": "positive", "value": selectedIds])
        resolved = true
      }
    }

    dialogOptions.finishHandler = { (button, extras) in
      if !resolved {
        let params = self.buildParams(button)
        resolve(params)
        resolved = true
      }
    }

    dialogOptions.dismissHandler = {
      if !resolved {
        resolve(["action": "dismiss"])
        resolved = true
      }
    }

    dialogOptions.presentDialog(in: viewConroller)
  }

  @objc(showNumberPickerDialog:)
  func showNumberPickerDialog(options: [String: Any]) {

  }

  @objc(showRatingDialog:)
  func showRatingDialog(options: [String: Any]) {

  }
}
