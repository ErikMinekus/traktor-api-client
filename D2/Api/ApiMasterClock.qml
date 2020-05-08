import CSI 1.0
import QtQuick 2.0
import "ApiClient.js" as ApiClient

Item {
  AppProperty { id: propMasterDeckId;  path: "app.traktor.masterclock.source_id";  onValueChanged: updateMasterClock() }
  AppProperty { id: propMasterBpm;     path: "app.traktor.masterclock.tempo";      onValueChanged: masterBpmChangedTimer.restart() }

  Timer {
    id: masterBpmChangedTimer
    interval: 250

    onTriggered: updateMasterClock()
  }

  function updateMasterClock() {
    ApiClient.send("updateMasterClock", {
      deck: (propMasterDeckId.value == -1) ? null : String.fromCharCode(65 + propMasterDeckId.value),
      bpm: propMasterBpm.value,
    })
  }
}
