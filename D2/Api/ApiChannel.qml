import CSI 1.0
import QtQuick 2.0
import "ApiClient.js" as ApiClient

Item {
  property int       index:       1
  property bool      onAirState:  null
  property bool      assignLeft:  null
  property bool      assignRight: null

  readonly property string    pathPrefix:  "app.traktor.mixer.channels." + index + "."

  AppProperty {
    id: propVolume
    path: pathPrefix + "volume"

    onValueChanged: {
      updateChannel()
      volumeChangedTimer.restart()
    }
  }
  AppProperty { id: propXfaderAssignLeft;   path: pathPrefix + "xfader_assign.left";   onValueChanged: updateChannel() }
  AppProperty { id: propXfaderAssignRight;  path: pathPrefix + "xfader_assign.right";  onValueChanged: updateChannel() }
  AppProperty {
    id: propXfaderAdjust
    path: "app.traktor.mixer.xfader.adjust"
    
    onValueChanged: {
      updateChannel()
      xfaderAdjustChangedTimer.restart()
    }
  }
  Timer {
    id: volumeChangedTimer
    interval: 250

    onTriggered: {
      ApiClient.send("updateChannel/" + index, {
        volume: propVolume.value,
      })
    }
  }
  Timer {
    id: xfaderAdjustChangedTimer
    interval: 250

    onTriggered: {
      ApiClient.send("updateChannel/" + index, {
        xfaderAdjust: propXfaderAdjust.value,
      })
    }
  }

  function updateChannel() {
    var isOnAir = propVolume.value > 0
      && ((!propXfaderAssignLeft.value && !propXfaderAssignRight.value)
        || (propXfaderAssignLeft.value && propXfaderAdjust.value < 1)
        || (propXfaderAssignRight.value && propXfaderAdjust.value > 0))
    var changedValues = {}
    var update = false

    if (isOnAir != onAirState) {
      changedValues.isOnAir = isOnAir
      update = true
    }
    if (assignLeft != propXfaderAssignLeft.value) {
      changedValues.xfaderAssignLeft = propXfaderAssignLeft.value
      update = true
    }
    if (assignRight != propXfaderAssignRight.value) {
      changedValues.xfaderAssignRight = propXfaderAssignRight.value
      update = true
    }

    if (update)
      ApiClient.send("updateChannel/" + index, changedValues)

    onAirState = isOnAir
    assignLeft = propXfaderAssignLeft.value
    assignRight = propXfaderAssignRight.value

  }
}