# Changelog

## 0.5.1
- Add #5: Support little endianness in NBT files
- Add: Blocked player list API
- Add: Name change info API
- Change: Deprecate getStatistics as endpoint was removed
- Change: Switch to lints & update deps

## 0.5.0
- Add: Microsoft authentication endpoints (Note that these are not complete!)
- Change: Deprecate getStatus API as it got removed by Mojang
- Change: Move NBT functionality to separate library (same package though)
- Change: Remove deprecated API classes
- Change: Use new profile endpoint for profile queries and update profile API
- Fix: Server modt was invalid (thanks @TheKingDave)
- Fix: Catch auth errors when account has migrated
- Fix: The News endpoint changed

## 0.4.0

- Add: Dart JS support (NBT, Server ping and packets do not work on JS.)
- Add: API for Security Challenges
- Update: Added new blocked servers
- Change: We now use Minecraft version manifest Version 2
- Fix: Yggdrasil's authenticate function did not work
- Fix: Catch more errors in getStatus()

## 0.3.5

- Add: Change password API
- Add: Get UUID by name API
- Add: Name availability check API
- Change: `Mojang`, `Minecraft` and `Yggdrasil` classes have been deprecated. Use the globally available functions instead.
- Change: The API now catches and reports more and better exceptions
- Change: Now uses dart-lang/http library.

## 0.3.4

- Add: You can now register custom clientbound packets and implement a custom PacketReader.
- Fix: UTF-8 Values inside of any packet resulted in invalid data.

## 0.3.3

- Implement server pinging
- Generalized NBT file read/write internally.

## 0.3.2

- Custom NBT File exceptions
- More exceptions for Mojang functions
- Implement MinecraftPatchType

## 0.3.1

- Fix critical NBT_STRING write issue.
- Add NBT Tag equality operators.

## 0.3.0

- Support Dart null safety.
- Implement more exceptions.

## 0.2.0

- Add NBT File reading/writing.
- Add new API functions.
- Moved authentication API functions from `Mojang` to `Yggdrasil`.
- Update exceptions for API functions.

## 0.1.2

- Switch to Minecraft-Services API
- Follow effective Dart guidelines

## 0.1.1

- Minecraft API functions are now static

## 0.1.0

- Initial version
