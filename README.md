# TJJupiter-demo-ios

Sample iOS app demonstrating the **TJJupiterSDK** for indoor positioning and navigation.

## Overview

`TJJupiterSample` is a minimal UIKit app that shows how to integrate the TJJupiterSDK into an iOS project. It starts and stops the Jupiter location service, authenticates with TJLabs, and renders the live indoor-positioning result (building, level, X/Y, heading) on screen. The bundled run uses the SDK's simulation mode with sample sensor fixtures so you can see the pipeline working without walking through a real venue.

## Features

- Start / stop the Jupiter service from a single screen
- Live display of service status, building name, level, X/Y coordinates, and heading
- TJLabs authentication via `TJJupiterAuth.shared.auth(...)`
- Simulation mode driven by bundled JSON fixtures (`Rfd1.json`, `Uvd1.json`, `Event1.json`)
- Configured for `UserMode.MODE_VEHICLE` and sector `20` out of the box
- Implements `JupiterServiceManagerDelegate` for result, report, and in/out-state callbacks

## Requirements

- Xcode 15 or newer (developed against Xcode 26.0.1)
- iOS 15.0+ device or simulator (iPhone only)
- Swift 5.0
- CocoaPods 1.16+
- A local checkout of **TJJupiterSDK 2.0.0** (the Podfile consumes it via a local `:path =>`)

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

1. Clone the repository.

   ```bash
   git clone https://github.com/<your-org>/TJJupiter-demo-ios.git
   cd TJJupiter-demo-ios
   ```

2. Obtain a local copy of `TJJupiterSDK` (v2.0.0) from TJLabs.

3. Open `Podfile` and update line 6 so the `:path` argument points to your local SDK checkout:

   ```ruby
   pod 'TJJupiterSDK', :path => '<YOUR_LOCAL_PATH>/TJJupiterSDK'
   ```

   The path currently committed in the repo is a developer-specific absolute path and will not resolve on your machine.

4. Install pods.

   ```bash
   pod install
   ```

5. Open the workspace (not the `.xcodeproj`):

   ```bash
   open TJJupiterSample.xcworkspace
   ```

## Configuration

- **Auth keys.** `MainViewController.doAuth()` (`TJJupiterSample/MainViewController.swift:228`) calls `TJJupiterAuth.shared.auth(accessKey:secretAccessKey:)` with sample credentials. Replace these with your own access key / secret access key issued by TJLabs before shipping anything.
- **Sector & user mode.** `startService()` (`TJJupiterSample/MainViewController.swift:243`) hard-codes `sectorId = 20` and `UserMode.MODE_VEHICLE`. Change these to match the venue and use case you are testing.
- **Mocking mode.** It inables mocking mode.

## Run

1. Select the `TJJupiterSample` scheme in Xcode.
2. Choose a device or simulator running iOS 15.0+.
3. Build & run (`⌘R`).
4. Tap **시작** (Start) to launch the Jupiter service. The status, building, level, X/Y, and heading labels will update as results arrive.
5. Tap **중지** (Stop) to halt the service.

## Permissions

`TJJupiterSample/Info.plist` declares the following background modes used by the SDK:

- `bluetooth-central` — BLE scanning for indoor positioning
- `location` — continuous location updates

iOS will prompt for the corresponding permissions on first launch. Bluetooth and motion sensors are not available on the simulator, so for an end-to-end run you should test on a real device.

## Tests

`TJJupiterSampleTests/` and `TJJupiterSampleUITests/` are present but currently contain only the default Xcode-generated scaffolding. There are no real assertions yet — treat them as a starting point if you want to add coverage.

## License

No license file is included in this repository.
