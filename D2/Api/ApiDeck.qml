import CSI 1.0
import QtQuick 2.0
import "ApiClient.js" as ApiClient

Item {
  property int       deckId:  0

  readonly property string    deckLetter:  String.fromCharCode(65 + deckId)
  readonly property string    pathPrefix:  "app.traktor.decks." + (deckId+1) + "."

  AppProperty { path: pathPrefix + "is_loaded";         onValueChanged: deckLoadedTimer.start() }
  AppProperty { path: pathPrefix + "is_loaded_signal";  onValueChanged: deckLoadedTimer.start() }

  AppProperty { id: propTitle;         path: pathPrefix + "content.title" }
  AppProperty { id: propArtist;        path: pathPrefix + "content.artist" }
  AppProperty { id: propAlbum;         path: pathPrefix + "content.album" }
  AppProperty { id: propGenre;         path: pathPrefix + "content.genre" }
  AppProperty { id: propComment;       path: pathPrefix + "content.comment" }
  AppProperty { id: propLabel;         path: pathPrefix + "content.label" }
  AppProperty { id: propMix;           path: pathPrefix + "content.mix" }
  AppProperty { id: propRemixer;       path: pathPrefix + "content.remixer" }
  AppProperty { id: propKey;           path: pathPrefix + "content.musical_key" }
  AppProperty { id: propKeyText;       path: pathPrefix + "content.legacy_key" }
  AppProperty { id: propGridOffset;    path: pathPrefix + "content.grid_offset" }
  AppProperty { id: propTrackLength;   path: pathPrefix + "track.content.track_length" }
  AppProperty { id: propElapsedTime;   path: pathPrefix + "track.player.elapsed_time" }
  AppProperty { id: propNextCuePoint;  path: pathPrefix + "track.player.next_cue_point" }
  AppProperty { id: propBpm;           path: pathPrefix + "tempo.base_bpm" }
  AppProperty { id: propTempo;         path: pathPrefix + "tempo.tempo_for_display";      onValueChanged: tempoChangedTimer.restart() }
  AppProperty { id: propResultingKey;  path: pathPrefix + "track.key.resulting.precise";  onValueChanged: keyChangedTimer.restart() }

  AppProperty {
    id: propIsPlaying
    path: pathPrefix + "play"

    onValueChanged: {
      ApiClient.send("updateDeck/" + deckLetter, {
        elapsedTime: propElapsedTime.value,
        nextCuePos: getNextCuePos(),
        isPlaying: propIsPlaying.value,
      })
    }
  }
  AppProperty {
    id: propIsSynced
    path: pathPrefix + "sync.enabled"

    onValueChanged: {
      ApiClient.send("updateDeck/" + deckLetter, {
        isSynced: propIsSynced.value,
      })
    }
  }
  AppProperty {
    id: propIsKeyLockOn
    path: pathPrefix + "track.key.lock_enabled"

    onValueChanged: {
      ApiClient.send("updateDeck/" + deckLetter, {
        isKeyLockOn: propIsKeyLockOn.value,
      })
    }
  }

  Timer {
    id: deckLoadedTimer
    interval: 250

    onTriggered: {
      ApiClient.send("deckLoaded/" + deckLetter, {
        title:        propTitle.value,
        artist:       propArtist.value,
        album:        propAlbum.value,
        genre:        propGenre.value,
        comment:      propComment.value,
        label:        propLabel.value,
        mix:          propMix.value,
        remixer:      propRemixer.value,
        key:          propKey.value,
        keyText:      propKeyText.value,
        gridOffset:   propGridOffset.value/1000,
        trackLength:  propTrackLength.value,
        elapsedTime:  propElapsedTime.value,
        nextCuePos:   getNextCuePos(),
        bpm:          propBpm.value,
        tempo:        propTempo.value,
        resultingKey: propResultingKey.value,
        isPlaying:    propIsPlaying.value,
        isSynced:     propIsSynced.value,
        isKeyLockOn:  propIsKeyLockOn.value,
      })
    }
  }
  Timer {
    id: tempoChangedTimer
    interval: 250

    onTriggered: {
      ApiClient.send("updateDeck/" + deckLetter, {
        tempo: propTempo.value,
      })
    }
  }
  Timer {
    id: keyChangedTimer
    interval: 250

    onTriggered: {
      ApiClient.send("updateDeck/" + deckLetter, {
        resultingKey: propResultingKey.value,
      })
    }
  }
  Timer {
    interval: 1000
    repeat: true
    running: propIsPlaying.value

    onTriggered: {
      ApiClient.send("updateDeck/" + deckLetter, {
        elapsedTime: propElapsedTime.value,
        nextCuePos: getNextCuePos(),
      })
    }
  }

  function getNextCuePos() {
    return (propNextCuePoint.value == -1) ? null : propNextCuePoint.value/1000
  }
}
