import CSI 1.0
import QtQuick 2.0
import "ApiClient.js" as ApiClient

Item {
  property int       index:            1
  property bool      isOnAirState:     null
  property real      onAirLevelState:  null

  readonly property string    pathPrefix:  "app.traktor.mixer.channels." + index + "."

  AppProperty { id: propVolume;             path: pathPrefix + "volume";               onValueChanged: updateOnAirState() }
  AppProperty { id: propXfaderAssignLeft;   path: pathPrefix + "xfader_assign.left";   onValueChanged: updateOnAirState() }
  AppProperty { id: propXfaderAssignRight;  path: pathPrefix + "xfader_assign.right";  onValueChanged: updateOnAirState() }
  AppProperty { id: propXfaderAdjust;       path: "app.traktor.mixer.xfader.adjust";   onValueChanged: updateOnAirState() }

  Timer {
    id: onAirLevelChangedTimer
    interval: 250

    onTriggered: {
      var onAirLevel = propVolume.value
      if ((propXfaderAssignLeft.value && propXfaderAdjust.value > 0.5)
        || (propXfaderAssignRight.value && propXfaderAdjust.value < 0.5)) {
        onAirLevel *= 1 - Math.abs(propXfaderAdjust.value * 2 - 1)
      }

      if (onAirLevel != onAirLevelState) {
        ApiClient.send("updateChannel/" + index, {
          onAirLevel: onAirLevel,
        })
        onAirLevelState = onAirLevel
      }
    }
  }

  function updateOnAirState() {
    var isOnAir = propVolume.value > 0
      && ((!propXfaderAssignLeft.value && !propXfaderAssignRight.value)
        || (propXfaderAssignLeft.value && propXfaderAdjust.value < 1)
        || (propXfaderAssignRight.value && propXfaderAdjust.value > 0))

    if (isOnAir != isOnAirState) {
      ApiClient.send("updateChannel/" + index, {
        isOnAir: isOnAir,
      })
      isOnAirState = isOnAir
    }

    onAirLevelChangedTimer.restart()
  }
}
