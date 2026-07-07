# Car Toss

This is a simple FiveM script that lets a player pick up a nearby car and throw it, can be configed based on your preference as well :)

## Features

* Pick up the closest car if you are close enough to it
* Plays a pickup animation and a throw animation
* Throws the car forward with force so it flies
* Press the same key again while holding the car to throw it

## Installation

1. Download or clone this resource into your server's `resources` folder.
2. Add this line to your `server.cfg`:

   ```cfg
   ensure car-toss
   ```

3. Restart your server, or type `refresh` then `start car-toss` in the server console.

## How to Use It

| Action | Key |
|---|---|
| Pick up the nearest car | `G` (key code `47`) |
| Throw the car you are holding | `G` (press it again) |

Walk close to a car and press the key. The car will attach to you and you can walk around while holding it. Press the key again to throw the car in the direction you are facing.

## Settings

All the settings are at the top of `client.lua`.

| Variable | What it does | Default |
|---|---|---|
| `PICKUP_KEY` | The key used to pick up or throw | `47` (G) |
| `PICKUP_DISTANCE` | How close you need to be to pick up a car | `3.0` |
| `THROW_FORCE` | How hard the car gets thrown | `50.0` |
| `PICKUP_DICT` / `PICKUP_ANIM` | The animation used when picking up a car | `missminuteman_1ig_2` / `handsup_enter` |
| `THROW_DICT` / `THROW_ANIM` | The animation used when throwing a car | `weapons@projectile@` / `throw_m_fb_stand` |

You can look up other key codes in the FiveM controls list here: https://docs.fivem.net/docs/game-references/controls/

## Dependencies

None.

## Things to Know

* There are no permission checks. Any player can pick up and throw any car near them.
* Once a car is thrown, it stops being treated as a mission entity, so the server may delete it depending on your entity limits.

## License

MIT
