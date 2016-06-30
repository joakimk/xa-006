let Socket = window.Phoenix.Socket

let socket = new Socket("/socket", { params: {} })
socket.connect()

let channel = socket.channel("hot_code_update", {})
channel.join()

function loadApp() {
  let demo = new Demo();
  let element = demo.start()
  let container = document.getElementById("js-container")
  container.innerHTML = ""
  container.appendChild(element)
}

window.codeVersion = 1

channel.on("updated_code", (data) => {
  console.log("Hot updating code...")

  window.codeVersion += 1

  var script = document.createElement("script")
  script.type = "text/javascript"
  script.innerHTML = data.source
  document.body.appendChild(script)

  loadApp()
})

loadApp()

