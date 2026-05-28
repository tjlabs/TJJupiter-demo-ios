# TJJupiter-demo-ios

Sample iOS app demonstrating the **TJJupiterSDK** for indoor positioning and navigation.

## Overview

`TJJupiterSample` is a minimal UIKit app that shows how to integrate the TJJupiterSDK into an iOS project. It starts and stops the Jupiter location service, authenticates with TJLabs, and renders the live indoor-positioning result (building, level, X/Y, heading) on screen. The bundled run uses the SDK's simulation mode with sample sensor fixtures so you can see the pipeline working without walking through a real venue.

## Features

- Start / stop the Jupiter service from a single screen
- Live display of service status, building name, level, X/Y coordinates, and heading
- TJLabs authentication via `TJJupiterAuth.shared.auth(...)`
- Implements `JupiterServiceManagerDelegate` for result, report, and in/out-state callbacks
- Built-in `Mock Mode` selector for testing SDK scenarios without live movement

## Requirements

- Xcode 15 or newer (developed against Xcode 26.0.1)
- iOS 15.0+ device or simulator (iPhone only)
- Swift 5.0
- CocoaPods 1.16+

## Project Structure

```
TJJupiter-demo-ios/
├── TJJupiterSample/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── MainViewController.swift     # Main screen + SDK integration
│   ├── UIColorExtension.swift
│   ├── Assets.xcassets/
│   ├── Base.lproj/
│   └── Info.plist
├── TJJupiterSampleTests/             # Xcode-generated scaffolding
├── TJJupiterSampleUITests/           # Xcode-generated scaffolding
├── Podfile
└── TJJupiterSample.xcworkspace       # Open this, not the .xcodeproj
```

## Setup


1. Open `Podfile` and update line 6 so the `:path` argument points to your local SDK checkout:

   ```ruby
   pod 'TJJupiterSDK', '2.0.2'
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

## Configuration

- **Auth keys.** `MainViewController.doAuth()` calls `TJJupiterAuth.shared.auth(accessKey:secretAccessKey:)` with sample credentials. Replace these with your own access key / secret access key issued by TJLabs before shipping anything.
- **Sector & user mode.** `MainViewController` hard-codes `sectorId = 20` and `UserMode.MODE_VEHICLE`. Change these to match the venue and use case you are testing.
- **Mock Mode.** The sample exposes a `Mock Mode` menu backed by `JupiterServiceManager.setMockMode(mode:completion:)`.

## Mock Mode

Use `Mock Mode` when you want the SDK to emit testable positioning results for the configured service area without relying on live movement.

- The button is enabled after the service has been initialized, and it stays available while the service is running.
- The default selection is `None`, which means no mock scenario is applied.
- You can switch modes from the `Mock Mode` drop-down on the main screen. The status label updates after each apply attempt.
- Available mock scenarios in this sample:
  - `NONE`
  - `VEHICLE_OUTDOOR_PARKING`
  - `VEHICLE_INDOOR_OUTDOOR`
  - `PEDESTRIAN_INDOOR_PARKING`
  - `PEDESTRIAN_PARKING_INDOOR`
- The current sample configuration uses `sectorId = 20` and `userMode = .MODE_VEHICLE`. If you want to test a different environment or a pedestrian-oriented flow, update those values in `MainViewController.swift` as well.
- While a mock mode change is being applied, the button is temporarily disabled to avoid overlapping requests.

## Run

1. Select the `TJJupiterSample` scheme in Xcode.
2. Choose a device or simulator running iOS 15.0+.
3. Build & run (`⌘R`).
4. Tap **초기화** (Initialize) first. After initialization succeeds, the `Mock Mode` button becomes available.
5. Optionally choose a scenario from the `Mock Mode` menu.
6. Tap **시작** (Start) to launch the Jupiter service. The status, building, level, X/Y, and heading labels will update as results arrive.
7. Tap **중지** (Stop) to halt the service.

## Permissions

`TJJupiterSample/Info.plist` declares the following background modes used by the SDK:

- `bluetooth-central` — BLE scanning for indoor positioning
- `location` — continuous location updates

iOS will prompt for the corresponding permissions on first launch. Bluetooth and motion sensors are not available on the simulator, so for an end-to-end run you should test on a real device.

## Tests

`TJJupiterSampleTests/` and `TJJupiterSampleUITests/` are present but currently contain only the default Xcode-generated scaffolding. There are no real assertions yet — treat them as a starting point if you want to add coverage.

## License

No license file is included in this repository.
