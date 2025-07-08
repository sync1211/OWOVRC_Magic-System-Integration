# OWOVRC Magic System Integration

This repository contains config files for [OWOVRC](https://github.com/sync1211/owoskin-vrc) and [TouchOSC](https://hexler.net/touchosc) for adding haptic feedback to [Raideus' Magic Circle System](https://jinxxy.com/Raideus/Magic) via the [OWO Suit](https://owogame.com/)

This integration does not require any modification of the original Magic Circle asset and as such works on public avatars with very little setup.

![Screenshot](./.github/screenshot.png)

>**NOTE:** These presets are still in alpha. There may be bugs.

This integration was tested on the Magic System asset released on 21.10.2024.

## Demo
https://github.com/user-attachments/assets/2ca5ef7a-ac78-4fec-9acc-05d4f6523cd4

## Installation

* Import `oscPresets.json` into [OWOVRC's Presets effect](https://github.com/sync1211/owoskin-vrc/wiki/Effects#presets)
* Open `magic-system.tosc` into TouchOSC

## Troubleshooting

### TouchOSC reacts to VRChat parameters but ignores parameters of the magic system
Update the VRCFury prefix on the parameters' OSC paths in TouchOSC.

Use the avatar debug window in VRChat to view the prefix your avatar uses.

The prefix usually has the format `VF123_`.

### TouchOSC does not react to any parameters

Check if the receiver port in TouchOSC is correct. (`Edit` > `Connections` > `OSC`)

Make sure there are no other applications listening on the same port.

It is recommended to use a OSC routing application, such as [VRCOSC](https://vrcosc.com/) or [VRCRouter](https://github.com/valuef/VRCRouter) to avoid port conflicts.

## Credits

Thanks to Zenta for helping design the sensations.


## Disclaimer

I am not affiliated with OWOGame, nor Raideus.
