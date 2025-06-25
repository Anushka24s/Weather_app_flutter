<<<<<<< HEAD
# weather_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
=======
# Weather App
## A modern Flutter-based weather application that provides real-time weather updates with an intuitive and visually appealing interface.

<p align="center">
  <img src="https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExbXJkY3kyYXJsbXJ0ejFubG92bm1raWV5YXcyZjFvcmZ4c3BicjQ5eSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/Ke7i5t6QDmDSO82Uga/giphy.gif" alt="MasterHead" />
</p>


## Features

1. Real-Time Weather Data: Fetches current weather conditions (temperature, sky status, pressure, wind speed, humidity) and hourly forecasts for London using the OpenWeatherMap API.
2. Dynamic Theme Switching: Toggle between light and dark modes with a single tap, adapting the UI seamlessly.
3. Interactive UI: Includes a refresh button to update weather data and a temperature variation chart using Syncfusion Flutter Charts.
4. Animated Splash Screen: Displays a scaling sun icon with the "Weather now" title, transitioning to the main screen after 3 seconds.
5. Weather-Based Card Design: Main card dynamically changes color based on weather (e.g., light yellow for clear, light blue for cloudy) with enhanced styling.
6. Additional Information: Shows humidity, wind speed, and pressure in animated cards with blue-tinted borders in light mode.
7. Subtle Animations: Features a pulsing weather icon, animated card elevation, and a background with slowly moving light blue clouds for a dynamic effect.
8. Responsive Layout: Designed with Google Fonts (Poppins) for a polished look, centered content, and adjustable padding for various screen sizes.

## Design Implementation

1. Color Scheme: Utilizes a light mode gradient (light blue to light yellow) and a dark mode gradient (deep blue-grey), with consistent text color (0xFF455A64 in light mode, Colors.white70 in dark mode).
2. Card Styling: The main weather card features a gradient border, elevated shadow, and a glowing icon effect, enhancing visual appeal without images.
3. Typography: Employs GoogleFonts.poppins with varying weights (w400, w600, w700) for headers, labels, and values, ensuring readability and elegance.
4. Animations: Implements flutter_animate for fade-in and scale animations on forecast and additional info cards, ScaleTransition for the weather icon, and AnimatedPhysicalModel for card elevation. A custom CustomPaint with CloudPainter adds subtle cloud movement in the background.
5. Layout: Uses Stack, Column, and Row with SafeArea for a responsive, centered design, integrating all elements harmoniously.

https://github.com/user-attachments/assets/1ff808df-33fe-4e77-8f04-a5d01b6cad6c

>>>>>>> 15e256175596f02e6ead1adb1b2057e21f34dde9
