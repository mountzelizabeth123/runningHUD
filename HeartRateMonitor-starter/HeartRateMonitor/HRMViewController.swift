/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreBluetooth
let heartRateServiceCBUUID = CBUUID(string: "0xFFE0")
let desiredCharacteristic = CBUUID(string: "0xFFE1")

class HRMViewController: UIViewController {

  @IBOutlet weak var heartRateLabel: UILabel!
  @IBOutlet weak var bodySensorLocationLabel: UILabel!
  var centralManager: CBCentralManager!
  var heartRatePeripheral: CBPeripheral!

  override func viewDidLoad() {
    centralManager = CBCentralManager(delegate: self, queue: nil)
    super.viewDidLoad()

    // Make the digits monospaces to avoid shifting when the numbers change
    heartRateLabel.font = UIFont.monospacedDigitSystemFont(ofSize: heartRateLabel.font!.pointSize, weight: .regular)
  }

  func onHeartRateReceived(_ heartRate: Int) {
    heartRateLabel.text = String(heartRate)
    print("BPM: \(heartRate)")
  }
}

extension HRMViewController: CBCentralManagerDelegate {
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state {
      case .unknown:
        print("central.state is .unknown")
      case .resetting:
        print("central.state is .resetting")
      case .unsupported:
        print("central.state is .unsupported")
      case .unauthorized:
        print("central.state is .unauthorized")
      case .poweredOff:
        print("central.state is .poweredOff")
      case .poweredOn:
        print("central.state is .poweredOn")
        centralManager.scanForPeripherals(withServices: [heartRateServiceCBUUID])
    }
  }
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    print(peripheral)
    heartRatePeripheral = peripheral
    heartRatePeripheral.delegate = self
    centralManager.stopScan()
    centralManager.connect(heartRatePeripheral)
  }
  
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    print("Connected!")
    
    heartRatePeripheral.discoverServices([heartRateServiceCBUUID])
    
  }
  
}

extension HRMViewController: CBPeripheralDelegate {
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    guard let services = peripheral.services else { return }

    for service in services {
      print(service)
      peripheral.discoverCharacteristics(nil, for: service)
    }

  }
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                  error: Error?) {
    guard let characteristics = service.characteristics else { return }

    for characteristic in characteristics {
      print(characteristic)
      if characteristic.properties.contains(.read) {
        print("\(characteristic.uuid): properties contains .read")
      }
      if characteristic.properties.contains(.notify) {
        print("\(characteristic.uuid): properties contains .notify")
      }
      if characteristic.properties.contains(.write) {
        print("\(characteristic.uuid): properties contains .write")
      }
      if characteristic.properties.contains(.writeWithoutResponse) {
        print("\(characteristic.uuid): properties contains .writeWithoutResponse")
//        var parameter = NSString("abc")
//        let data = NSData(bytes: &parameter, length: 3)
        let testvar = "test script"
        let data = testvar.data(using: .ascii)
        peripheral.writeValue(data!, for: characteristic, type: CBCharacteristicWriteType.withoutResponse)
      }
      peripheral.readValue(for: characteristic)

    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                  error: Error?) {
    switch characteristic.uuid {
      case heartRateServiceCBUUID:
        print(characteristic.value ?? "no value")
      default:
        print("Unhandled Characteristic UUID: \(characteristic.uuid)")
    }
  }
  
  /// Called when .withResponse is used.
  func peripheral(_ peripheral: CBPeripheral,
          didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
      if let error = error {
          print("Error writing to characteristic: \(error)")
          return
      }
  }
  
  
//  func write(data: Data) {
//    let characteristic = desiredCharacteristic
//
//    let data = "abc"
//
//    peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
//  }
  
  /// Write data to the peripheral.
//  func centralManager(write)
//  func write(data: Data) {
//      let characteristic = desiredCharacteristic
//      peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
//      // .withResponse is more expensive but gives you confirmation.
//      // It's an exercise for the reader to ask for a response and handle
//      // timeouts waiting for said response.
//      // I found it simpler to deal with that at a higher level in a
//      // messaging framework.
//  }

}

//updated up to "Obtaining the Body Sensor Location"
//tutorial //https://www.kodeco.com/231-core-bluetooth-tutorial-for-ios-heart-rate-monitor

