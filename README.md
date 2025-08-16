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

## Usage

### Downloading from GO Web Store

### Building from Source

## End Credits
