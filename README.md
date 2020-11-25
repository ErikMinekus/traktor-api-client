# API client to send live data from Traktor Pro to a web server

By default data is sent to `http://localhost:8080`. You can change this in `ApiClient.js`.

The following endpoints are used:
- `/deckLoaded/<deck>`: Called when a track is loaded into a deck.
- `/updateDeck/<deck>`: Called when certain values or state changes for a deck.
- `/updateMasterClock`: Called when the master deck or BPM changes.
- `/updateChannel/<channel>`: Called when state changes for a mixer channel.

## How to install

**Mac:**

  - Navigate to /Applications/Native Instruments/Traktor Pro 3
  - Right click Traktor.app, then click Show Package Contents
  - Navigate to Contents/Resources/qml/CSI
  - Make a backup of the D2 folder!
  - Replace the D2 folder
  - Restart Traktor
  - If you don't own a Traktor Kontrol D2:
    - Go to Preferences > Controller Manager
    - Below the Device dropdown, click Add… > Traktor > Kontrol D2

**Windows:**

  - Navigate to C:\Program Files\Native Instruments\Traktor Pro 3\Resources64\qml\CSI
  - Make a backup of the D2 folder!
  - Replace the D2 folder
  - Restart Traktor
  - If you don't own a Traktor Kontrol D2:
    - Go to Preferences > Controller Manager
    - Below the Device dropdown, click Add… > Traktor > Kontrol D2
