//
//  ContentView.swift
//  hatHUD
//
//  Created by Elizabeth Mountz on 5/25/23.
//

import SwiftUI
import CoreMotion

struct TestView : View {
        
        let movementManager = CMMotionManager()
        let data = String("Test")
//        movementManager.startAccelerometerUpdates()
//        movementManager.accelerometerUpdateInterval = 1
//        let data = self.movementManager.accelerometerData
//
        var body: some View {
            Text("Acceleration is \(data)")
    }

}
//struct ContentView: View {
//
//    //setup motion manager
//    let motionManager = CMMotionManager()
//    let queue = OperationQueue()
//
//    //record the values
//    @State var pitch: [Double] = [0]
//    @State var yaw: [Double] = [0]
//    @State var roll: [Double] = [0]
//
//
//    var body: some View {
//
//        let _ = print("Pitch is \(pitch)")
//        let _ = print("yaw is \(yaw)")
//        let _ = print("roll is \(roll)")
//
////            .onAppear{
////
////                //modify motion manager
////                self.motionManager.startDeviceMotionUpdates(to: self.queue){
////                    (data: CMDeviceMotion?, error: Error?) in
////
////                    let attitude: CMAttitude = data!.attitude
////
////                    pitch.append(Double(attitude.pitch))
////                    yaw.append(Double(attitude.yaw))
////                    roll.append(Double(attitude.roll))
////                }
////            }
//    }
//}
//
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

struct Previews_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
