# MeshCore SAR

Flutter app for Search and Rescue operations over a [MeshCore](https://github.com/meshcore-dev) mesh radio network via Bluetooth Low Energy.

## Features

- **Messaging** — send/receive messages to contacts and channels
- **Voice messages** — push-to-talk voice over the mesh using [Codec2](https://github.com/drowe67/codec2) ultra-low-bitrate speech compression (700–3200 bps); fragments are streamed on demand via direct BLE links without requiring firmware changes
- **Image messages** — send photos over the mesh as AVIF-compressed fragments; images are fetched on demand when the recipient taps the placeholder; configurable resolution (64 / 128 / 256 px), compression level, and colour/grayscale mode
- **Contacts** — track team members, repeaters, and rooms with live telemetry
- **SAR Markers** — drop emoji-coded location pins (person found, fire, staging area) via chat messages
- **Map** — view team positions and markers on OpenStreetMap / topo / satellite; tiles cached for offline use
- **Location tracking** — periodic GPS updates broadcast to the mesh
- **Packet log** — inspect raw BLE frames for debugging

## BLE Protocol

MeshCore SAR is powered by the `meshcore_client` package:
**[github.com/dz0ny/meshcore_client](https://github.com/dz0ny/meshcore_client)**

The client handles BLE connection management, command queueing, and binary frame parsing/building, and is extracted so you can build custom tools, integrations, and apps on top of MeshCore.

## Requirements

- Flutter 3.19+ / Dart 3.3+
- Physical device with Bluetooth (BLE does not work on simulators)
- iOS 13+ or Android SDK 21+

## Build

```bash
flutter pub get
flutter run                        # debug
flutter build apk --release        # Android
flutter build ios --release        # iOS
```

## GitHub Actions artifacts

Every push runs the `Build And Upload Release Assets` workflow and uploads build artifacts for:

- Android (`.apk`)
- Linux (`.tar.gz`)
- macOS (`.dmg`)
- Windows (`.zip`)

How to download them:

1. Open the repository on GitHub.
2. Go to **Actions**.
3. Open a workflow run named `Build And Upload Release Assets`.
4. In the run summary, scroll to **Artifacts**.
5. Download the artifact you need (`release-android`, `release-linux`, `release-macos`, `release-windows`).

For published releases, the same files are also attached to the GitHub Release page.

### iOS signing

```bash
open ios/Runner.xcworkspace
# Select team in Signing & Capabilities, then run from Xcode
```

### Clean rebuild

```bash
flutter clean && flutter pub get
cd ios && pod deintegrate && pod install && cd ..
```

## Permissions

| Platform | Permissions |
|----------|-------------|
| iOS | Bluetooth, Location (when in use), Microphone (voice), Photo Library / Camera (images) |
| Android | `BLUETOOTH_SCAN`, `BLUETOOTH_CONNECT`, `ACCESS_FINE_LOCATION`, `INTERNET`, `RECORD_AUDIO`, `READ_MEDIA_IMAGES` |

## Wire protocols

### SAR Marker

```
S:<emoji>:<lat>,<lon>
```

Examples: `S:🧑:46.0569,14.5058` · `S:🔥:46.057,14.506` · `S:🏕️:46.0571,14.506`

### Voice messages (on-demand, direct contacts only)

Control plane (text):

```
VE1:{sid}:{mode}:{total}:{durationMs}:{senderKey6}:{ts}:{ver}   ← envelope
VR1:{sid}:a:{requesterKey6}:{ts}:{ver}                          ← fetch request
```

Data plane (binary via `cmdSendRawData` / `pushRawData`, ≤160 bytes/packet):

```
[0x56 'V'][sessionId:4B][mode:1B][idx:1B][total:1B][Codec2 frame...]
```

Codec2 modes: 700C / 1200 / 1300 / 1400 / 1600 / 2400 / 3200 bps.

### Image messages (on-demand, direct contacts only)

Control plane (text):

```
IE1:{sid}:{fmt}:{total}:{w}:{h}:{bytes}:{senderKey6}:{ts}:{ver}  ← envelope
IR1:{sid}:a:{requesterKey6}:{ts}:{ver}                           ← fetch request
```

Data plane (binary via `cmdSendRawData` / `pushRawData`, ≤160 bytes/packet):

```
[0x49 'I'][sessionId:4B][fmt:1B][idx:1B][total:1B][AVIF fragment...]
```

Images are compressed to AVIF (configurable up to 256×256, grayscale by default). At 152 bytes of payload per fragment a typical image takes 7–20 fragments — comparable to a short voice clip.

## Architecture

```
lib/
├── models/       — data types (re-exported from meshcore_client)
├── providers/    — state management (Provider pattern)
├── screens/      — top-level pages
├── services/     — location tracking, SSE bridge, tile cache
└── widgets/      — reusable UI components
```
