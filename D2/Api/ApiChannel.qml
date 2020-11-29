import CSI 1.0
import QtQuick 2.0
import "ApiClient.js" as ApiClient

Item {
  property int       index:       1
  property bool      onAirState:  null

  readonly property string    pathPrefix:  "app.traktor.mixer.channels." + index + "."

  AppProperty { id: propVolume;             path: pathPrefix + "volume";               onValueChanged: updateOnAirState() }
  AppProperty { id: propXfaderAssignLeft;   path: pathPrefix + "xfader_assign.left";   onValueChanged: updateOnAirState() }
  AppProperty { id: propXfaderAssignRight;  path: pathPrefix + "xfader_assign.right";  onValueChanged: updateOnAirState() }
  AppProperty { id: propXfaderAdjust;       path: "app.traktor.mixer.xfader.adjust";   onValueChanged: updateOnAirState() }

  function updateOnAirState() {
    var isOnAir = propVolume.value > 0
      && ((!propXfaderAssignLeft.value && !propXfaderAssignRight.value)
        || (propXfaderAssignLeft.value && propXfaderAdjust.value < 1)
        || (propXfaderAssignRight.value && propXfaderAdjust.value > 0))

    if (isOnAir != onAirState) {
      ApiClient.send("updateChannel/" + index, {
        isOnAir: isOnAir,
      })
      onAirState = isOnAir
    }
  }
}
