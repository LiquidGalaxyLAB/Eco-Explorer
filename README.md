<p align="center">
  <img alt="Eco Explorer for Liquid Galaxy" src="https://github.com/LiquidGalaxyLAB/Eco-Explorer/blob/main/assets/logos/logo.png?raw=true" height="250px">
</p>  

# Eco Explorer for Liquid Galaxy

## Table of Contents

- **[About the Application](#about-the-application)**
- **[Features](#features)**
- **[Tech Stack](#tech-stack)**
- **[Prerequisites](#prerequisites)**
- **[Usage](#usage)**
- **[End Credits](#end-credits)**

## About the Application

* Eco Explorer for Liquid Galaxy is a **Google Summer of Code 2025 project with the Liquid Galaxy Organization**. Details can be viewed in [Google Summer of Code Post](https://summerofcode.withgoogle.com/programs/2025/projects/5LWWagWD), [Project Proposal](https://docs.google.com/document/d/1nkxPkUJKnywNoUq8j_fWccEUoKljx3gN8Pv26rplnmA/).
* Eco Explorer for Liquid Galaxy provides a master interface that showcases a dashboard of various expansive forests around the globe and allows users to explore them in depth.
* The application provides features like Virtual Tour, Biodiversity Display, Graphical Visualizations, and Catastrophe Status of the forests.
* It works with the Liquid Galaxy rig to provide an immersive and educational experience to your virtual forest discovery.
## Features

* **Tour Guide**: A feature that integrates Groq API and Deepgram Text-to-Speech API to create a voice-guided tour itinerary of various POIs in the forest. It creates an immersive experience, synchronizing the voice guide with the Liquid Galaxy rig tour.
* **Biodiversity Display**: It uses the 3D KMZ models generated using Blender to display vivid and diverse flora and fauna found in the forest.
* **Air Quality Visualizer**: Creates graphical visualizations for the Air Quality Index(AQI), its historical data, and concentrations of various pollutants found in the air of the forest, signifying its environmental status and sustainability.
* **Forest Fires**: Displays the active forest fires around the forest coordinates, along with their danger levels and magnitudes.
* **Deforestation Timelapse**: Shows a detailed quantitative deforestation data of the forests ranging from 2003 to 2023.
* **Joystick Rig Controller**: The joystick provides a simple and fun user interface to control the Liquid Galaxy rig with ranged control over parameters like Latitude, Longitude, Tilt, Heading and Altitude.
* **Voice Module**: It is a simple Regex-based voice command module controlling the application. It responds to commands like "Take me to Amazon Rainforest", "Switch to Settings screen", "Open the Help Menu", etc.

## Tech Stack

| Module               | Tool/Framework                           |
|----------------------|------------------------------------------|
| **Frontend**         | Flutter (Cross-platform)                 |
| **Tour Inference**   | Groq (Gemma-2-9B-IT)                     |
| **Text-to-Speech**   | Deepgram                                 |
| **REST APIs**        | NASA FIRMS API, OpenWeather API          |

## Prerequisites

* 6.x-inch Android mobile phone
  
### API Keys Setup

You will need API keys to run the system:

- **Groq API Key**: Get from [https://console.groq.com/keys](https://console.groq.com)  
- **Deepgram API Key**: Get from [https://console.deepgram.com](https://console.deepgram.com)
- **OpenWeather API Key**: Get from [https://docs.openweather.co.uk/our-initiatives/student-initiative](https://docs.openweather.co.uk/our-initiatives/student-initiative)
- **NASA FIRMS API Key**: Get from [https://firms.modaps.eosdis.nasa.gov/api/map_key/](https://firms.modaps.eosdis.nasa.gov/api/map_key/)

## Usage

### Downloading from GO Web Store

#### Steps:
* Download and install the app using this [Go Web Store link](https://store.liquidgalaxy.eu/app.html?name=Eco%20Explorer%20for%20Liquid%20Galaxy). 
* To connect to the Liquid Galaxy rig, go to the Preferences(⚙️) screen and go to LG Connection Tab; then fill the details mentioned there.
* To get complete access of the features of the application, follow the steps mentioned in [Prerequisites](#prerequisites) to get  the API keys and paste it in the text fields in the API Authentication(🔑) screen.

* You are now ready to explore the depth of the forests!

### Building from Source

#### Prerequisites:

* Android Studio, Visual Studio Code or any other IDE that supports Flutter development
* Flutter SDK
* Android SDK
* Android 6.x-inch device or emulator
* Git

Documentation on how to set up Flutter SDK and its environment can be found [here](https://flutter.dev/docs/get-started/install). Make sure to have [Git](https://git-scm.com/) and [Flutter](https://flutter.dev) installed in your machine before proceeding.

#### Steps:

* Clone the repository via the following terminal command:

```bash
$ git clone https://github.com/LiquidGalaxyLAB/Eco-Explorer.git
$ cd Eco-Explorer
```

* After you have successfully cloned the project, set up Google Maps API Key as Eco Explorer for Liquid Galaxy uses [Google maps Android API](https://developers.google.com/maps/documentation/android-sdk/overview?hl=pt-br) as the map service. To use Google maps you required an **API KEY**. To get this key you need to:

1. Have a Google Account
2. Create a Google Cloud Project
3. Open Google Cloud Console
4. Enable Maps Android SDK
5. Generate an API KEY

With the key in hand, the next step is placing the key inside the app. Go to *android/app/main* and edit the **AndroidManifest.xml**.

Replace the **PLACE_HERE_YOUR_API_KEY** with the key you just created.

```XML
<application
        android:label="Eco Explorer for Liquid Galaxy"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <meta-data android:name="com.google.android.geo.API_KEY"
            android:value="PLACE_HERE_YOUR_API_KEY"/>
```  

* To run the code, open a terminal and navigate to the project root directory. First you need to install the packages by running:

```bash
$ flutter pub get
```

* Now we check if our devices are connected and if all the environment is correct by the following terminal command:

```bash
$ flutter doctor
```

*  After this, we run our app by using the following command:

```bash
$ flutter run
```

* To build the APK, use the following terminal command:

```bash
$ flutter build apk
```

> ⓘ  Once done, the APK file may be found into the `/build/app/outputs/flutter-apk/` directory, named `app-release.apk`.

* Finally setup the connection with the Liquid Galaxy in the same way as we did previously.

## End Credits
### An application orchestrated by
* [Shuvam Swapnil Dash](https://github.com/Ssdosaofc)
* Mentors - Gabry Izquierdo, Alfredo Bautista
* Organization Admin - Andreu Ibáñez
