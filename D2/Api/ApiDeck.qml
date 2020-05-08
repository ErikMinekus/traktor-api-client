import CSI 1.0
import QtQuick 2.0
import "ApiClient.js" as ApiClient

Item {
  property int       deckId:  0

  readonly property string    deckLetter:  String.fromCharCode(65 + deckId)

  AppProperty { path: "app.traktor.decks." + (deckId+1) + ".is_loaded";         onValueChanged: deckLoadedTimer.start() }
  AppProperty { path: "app.traktor.decks." + (deckId+1) + ".is_loaded_signal";  onValueChanged: deckLoadedTimer.start() }

  AppProperty { id: propTitle;         path: "app.traktor.decks." + (deckId+1) + ".content.title" }
  AppProperty { id: propArtist;        path: "app.traktor.decks." + (deckId+1) + ".content.artist" }
  AppProperty { id: propAlbum;         path: "app.traktor.decks." + (deckId+1) + ".content.album" }
  AppProperty { id: propGenre;         path: "app.traktor.decks." + (deckId+1) + ".content.genre" }
  AppProperty { id: propComment;       path: "app.traktor.decks." + (deckId+1) + ".content.comment" }
  AppProperty { id: propLabel;         path: "app.traktor.decks." + (deckId+1) + ".content.label" }
  AppProperty { id: propMix;           path: "app.traktor.decks." + (deckId+1) + ".content.mix" }
  AppProperty { id: propRemixer;       path: "app.traktor.decks." + (deckId+1) + ".content.remixer" }
  AppProperty { id: propKey;           path: "app.traktor.decks." + (deckId+1) + ".content.musical_key" }
  AppProperty { id: propKeyText;       path: "app.traktor.decks." + (deckId+1) + ".content.legacy_key" }
  AppProperty { id: propTrackLength;   path: "app.traktor.decks." + (deckId+1) + ".track.content.track_length" }
  AppProperty { id: propElapsedTime;   path: "app.traktor.decks." + (deckId+1) + ".track.player.elapsed_time" }
  AppProperty { id: propBpm;           path: "app.traktor.decks." + (deckId+1) + ".tempo.base_bpm" }
  AppProperty { id: propTempo;         path: "app.traktor.decks." + (deckId+1) + ".tempo.tempo_for_display";      onValueChanged: tempoChangedTimer.restart() }
  AppProperty { id: propResultingKey;  path: "app.traktor.decks." + (deckId+1) + ".track.key.resulting.precise";  onValueChanged: keyChangedTimer.restart() }

  AppProperty {
    id: propIsPlaying
    path: "app.traktor.decks." + (deckId+1) + ".play"

    onValueChanged: {
      ApiClient.send("updateDeck/" + deckLetter, {
        elapsedTime: propElapsedTime.value,
      })
    }
  }
  AppProperty {
    id: propIsSynced
    path: "app.traktor.decks." + (deckId+1) + ".sync.enabled"

    onValueChanged: {
      ApiClient.send("updateDeck/" + deckLetter, {
        isSynced: propIsSynced.value,
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
        trackLength:  propTrackLength.value,
        elapsedTime:  propElapsedTime.value,
        bpm:          propBpm.value,
        tempo:        propTempo.value,
        resultingKey: propResultingKey.value,
        isSynced:     propIsSynced.value,
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
      })
    }
  }
}
