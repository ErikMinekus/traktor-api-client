var API_BASE_URL = "http://localhost:8080"

function send(endpoint, data) {
  var request = new XMLHttpRequest(),
      body    = JSON.stringify(data)

  request.open("POST", API_BASE_URL + "/" + endpoint, true)
  request.setRequestHeader("Content-Type", "application/json")
  request.setRequestHeader("Content-Length", body.length)
  request.send(body)
}
