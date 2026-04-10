# TJJupiter-demo-ios

Sample iOS app demonstrating the **TJJupiterSDK** for indoor positioning and navigation.
`TJJupiterSample` is a minimal UIKit app that shows how to integrate the TJJupiterSDK into an iOS project. It starts and stops the Jupiter location service, authenticates with TJLabs, and renders the live indoor-positioning result (building, level, X/Y, heading) on screen. The bundled run uses the SDK's simulation mode with sample sensor fixtures so you can see the pipeline working without walking through a real venue.


---

## Features

- Start / stop the Jupiter service from a single screen
- Live display of service status, building name, level, X/Y coordinates, and heading
- TJLabs authentication via `TJJupiterAuth.shared.auth(...)`
- Implements `JupiterServiceManagerDelegate` for result, report, and in/out-state callbacks
- Enable mocking mode to get result out for the service area (Configured for `UserMode.MODE_VEHICLE` and sector `20`)


---

## Requirements

- iOS 15.0+
- Swift 5.0+
- Info.plist
    - Privacy - Motion Usage Description
    - Privacy - Bluetooth Peripheral Usage Description
    - Privacy - Bluetooth Always Usage Description
    - Privacy - Location When In Usage Description
    - Required device capabilities
        - item : Accelerometer
        - item : Gyroscope
        - item : Magnetometer
        - item : Bluetooth Low Energy
    - Required background modes
        - App communicates using CoreBluetooth
        - App registers for location updates


---

## Setup


1. Open `Podfile` and update line 6 so the `:path` argument points to your local SDK checkout:

   ```ruby
   pod 'TJJupiterSDK', '2.0.0'
   ```

   if you cannot find pod, type this line above.
   
   ```ruby
   source '<https://github.com/CocoaPods/Specs.git>'
   ```

3. Install pods.

   ```bash
   pod install
   ```

4. Open the workspace (not the `.xcodeproj`):

   ```bash
   open TJJupiterSample.xcworkspace
   ```


---

## Quick Guide
### 1. Authenticate
- **Auth keys.** `MainViewController.doAuth()` (`TJJupiterSample/MainViewController.swift:228`) calls `TJJupiterAuth.shared.auth(accessKey:secretAccessKey:)` with sample credentials. Replace these with your own access key / secret access key issued by TJLabs before shipping anything.
- 
```swift
TJJupiterAuth.shared.auth(
    accessKey: "YOUR_ACCESS_KEY",
    secretAccessKey: "YOUR_SECRET_ACCESS_KEY"
) { code, success in
    print("Auth:", success)
}
```

### 2. Start Service
- **Sector & user mode.** `startService()` (`TJJupiterSample/MainViewController.swift:243`) hard-codes `sectorId = 20` and `UserMode.MODE_VEHICLE`. Change these to match the venue and use case you are testing.
- Sector IDs are assigned and managed by TJLabs.
- For production usage, use the sector ID provided by TJLabs.
```swift
manager.startService(
    region: JupiterRegion.KOREA.rawValue,
    sectorId: 123,
    mode: .MODE_AUTO,
    debugOption: false
)
```

### 3. Stop Service

```swift
manager.stopService { success, message in
    print("Stopped:", success)
}
```

### Mocking Mode
- Since Jupiter performs positioning based on TJLABS' BLE beacons, it cannot receive indoor location data outside of the actual service area.
- If you use the mocking mode below, you can receive a randomly defined JupiterResult even outside the service area.
- Use `sectorId = 20` and `UserMode.MODE_VEHICLE` in mocking mode, which corresponds to Songdo Convensia

```swift
manager.setMockingMode()
```

---

## Run

1. Select the `TJJupiterSample` scheme in Xcode.
2. Choose a device or simulator running iOS 15.0+.
3. Build & run (`⌘R`).
4. Tap **시작** (Start) to launch the Jupiter service. The status, building, level, X/Y, and heading labels will update as results arrive.
5. Tap **중지** (Stop) to halt the service.

