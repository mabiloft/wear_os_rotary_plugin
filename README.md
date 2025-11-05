# wear_os_rotary_plugin

[![pub package](https://img.shields.io/badge/version-0.1.0-blue?style=flat-square)](https://pub.dev/packages/wear_os_rotary_plugin)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)

A Flutter package providing a beautiful circular scrollbar overlay for Wear OS screens. This package works seamlessly with the [`wearable_rotary`](https://pub.dev/packages/wearable_rotary) package to provide visual feedback for rotary input scrolling on Wear OS devices.

## Features

- 🎯 **Circular Scrollbar**: Beautiful circular scrollbar positioned around the edge of the screen
- 📱 **Wear OS Optimized**: Designed specifically for Wear OS devices
- 🎨 **Customizable**: Customize colors, sizes, animations, and behavior
- ⚡ **Auto-hide**: Automatically hides the scrollbar when scrolling stops
- 🔄 **Smooth Animations**: Smooth fade in/out animations with customizable curves
- 📊 **Real-time Updates**: Automatically tracks scroll position and updates in real-time

## Installation

### Depend on it

Run this command:

```bash
flutter pub add wear_os_rotary_plugin
```

This will add a line like this to your package's `pubspec.yaml` (and run an implicit `flutter pub get`):

```yaml
dependencies:
  wear_os_rotary_plugin: ^0.1.0
```

Alternatively, your editor might support `flutter pub get`. Check the docs for your editor to learn more.

### Import it

Now in your Dart code, you can use:

```dart
import 'package:wear_os_rotary_plugin/wear_os_rotary_plugin.dart';
```

## Android Configuration

To use rotary input with Wear OS, you need to forward generic motion events to the `wearable_rotary` package in your `MainActivity.kt`:

```kotlin
import com.samsung.wearable_rotary.WearableRotaryPlugin

class MainActivity: FlutterActivity() {
    override fun onGenericMotionEvent(event: MotionEvent?): Boolean {
        return when {
            WearableRotaryPlugin.onGenericMotionEvent(event) -> true
            else -> super.onGenericMotionEvent(event)
        }
    }
}
```

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:wear_os_rotary_plugin/wear_os_rotary_plugin.dart';

class MyWearOSScreen extends StatelessWidget {
  const MyWearOSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WearOsScrollbar(
      builder: (context, rotaryScrollController) => ListView.builder(
        controller: rotaryScrollController,
        padding: const EdgeInsets.all(16),
        itemCount: 50,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Item #$index',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
```

### Advanced Example with Customization

```dart
import 'package:flutter/material.dart';
import 'package:wear_os_rotary_plugin/wear_os_rotary_plugin.dart';

class CustomizedWearOSScreen extends StatelessWidget {
  const CustomizedWearOSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WearOsScrollbar(
      autoHide: true,
      autoHideDuration: const Duration(seconds: 2),
      padding: 12.0,
      width: 3.0,
      speed: 60.0,
      opacityAnimationCurve: Curves.easeOut,
      opacityAnimationDuration: const Duration(milliseconds: 300),
      builder: (context, rotaryScrollController) => ListView.builder(
        controller: rotaryScrollController,
        itemCount: 100,
        itemBuilder: (context, index) => ListTile(
          title: Text('Item $index'),
          subtitle: Text('Subtitle for item $index'),
        ),
      ),
    );
  }
}
```

## API Reference

### WearOsScrollbar

A widget that displays a circular scrollbar overlay for Wear OS screens.

#### Parameters

- `builder` (required): Builder function that receives a [RotaryScrollController] and builds the scrollable widget. The controller is automatically created and managed by the widget.
- `autoHide` (default: `true`): Whether to automatically hide the scrollbar after scrolling stops
- `threshold` (default: `0.2`): Threshold to avoid jittering when scrolling
- `bezelCorrection` (default: `0.5`): Bezel correction factor for Samsung devices
- `speed` (default: `50.0`): Scroll amount in screen dimensions
- `padding` (default: `8.0`): Padding of the scrollbar from the screen edge
- `width` (default: `2.0`): Width of the scrollbar track and thumb
- `opacityAnimationCurve` (default: `Curves.easeInOut`): Animation curve for fade in/out
- `opacityAnimationDuration` (default: `500ms`): Animation duration for fade in/out
- `autoHideDuration` (default: `1500ms`): Duration before auto-hiding the scrollbar

## Important Notes

- **Automatic Controller Management**: The [RotaryScrollController] is automatically created and managed by [WearOsScrollbar]. You don't need to create or dispose it manually.
- **Rotary Input**: This package provides the visual scrollbar. Rotary input is handled by the [`wearable_rotary`](https://pub.dev/packages/wearable_rotary) package's `RotaryScrollController`, which is automatically provided to your builder function.
- **Wear OS Only**: This package is designed for Wear OS devices and may not work as expected on other platforms

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
