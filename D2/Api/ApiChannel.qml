import CSI 1.0
import QtQuick 2.0
import "ApiClient.js" as ApiClient

Item {
  property int       index:       1
  property bool      onAirState:  null

  readonly property string    pathPrefix:  "app.traktor.mixer.channels." + index + "."

  AppProperty {
    id: propVolume
    path: pathPrefix + "volume"

    onValueChanged: {
      var isOnAir = propVolume.value > 0

      if (isOnAir != onAirState) {
        ApiClient.send("updateChannel/" + index, {
          isOnAir: isOnAir,
        })
        onAirState = isOnAir
      }
    }
  }
}
