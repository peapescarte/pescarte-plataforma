import "phoenix_html";
import "flowbite/dist/flowbite.phoenix.js";
import Inputmask from "inputmask";

const cpf = document.querySelector("#user_cpf");

// input masks
if (cpf) Inputmask({mask: "999.999.999-99"}).mask(cpf);

function onVisible(elem, callback) {
  const options = { root: document.documentElement };

  const observer = new IntersectionObserver((entries, _observer) => {
    entries.forEach(entry => callback(entry.intersectionRatio > 0));
  }, options);

  observer.observe(elem);
}

if (window.location.pathname === "/acessar") {
  onVisible(document.body, (visible) => {
    if (visible) document.body.classList.add("fish");
  });
}

// LIVE VIEW
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}});

// Connect if there are any LiveViews on the page
liveSocket.connect();

// Expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
// The latency simulator is enabled for the duration of the browser session.
// Call disableLatencySim() to disable:
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

// Show progress bar on live navigation and form submits
import topbar from "topbar";

topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"});
window.addEventListener("phx:page-loading-start", info => topbar.show());
window.addEventListener("phx:page-loading-stop", info => topbar.hide());
