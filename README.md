# typescript-wdio-appium-nml-ios-multi-device

WDIO + Applitools NML (TypeScript) — iOS against a **local Appium server**
(multi-device variant), no cloud vendor. Runs `analyticsX_nml_multidevice.ios.test.ts`,
which uses Applitools' `Configuration.addMultiDeviceTarget(...)` to render the same
checkpoints across multiple simulated iPhone form factors from a single local Appium
session.

Ported from `javascript-wdio-appium-nml-ios-multi-device` (the JS local multi-device
sibling — note it also has no `-local` suffix, matching this folder's naming).

## Prerequisites

- A running Appium server: `appium` (defaults to `http://127.0.0.1:4723`)
- A target: either a real iOS device, or the iOS Simulator.

## App builds

`static_instrumented_sample_application/ios/` bundles both a real-device `.ipa` and a
Simulator-compatible `.app` for each app (AnalyticsX, Accessibility). `IOS_TARGET` in
`.env` selects which one gets used:

- `IOS_TARGET=real` (a physically connected iPhone) → uses the `.ipa`
- `IOS_TARGET=simulator` (default) → uses the `.app`

## Sample application (plug-and-play)

This branch does not commit the sample app binaries — download them from the
`main` branch's `static_instrumented_sample_application/` folder and place that
folder at the project root (same level as `package.json`):

    git clone --depth 1 --branch main https://github.com/applitools/NML.git nml-main
    cp -R nml-main/static_instrumented_sample_application ./static_instrumented_sample_application
    rm -rf nml-main

`static_instrumented_sample_application/ios/` contains both the real-device `.ipa`
and a Simulator-compatible `.app` for each app (AnalyticsX, Accessibility).

## Run

```
npm test
```
