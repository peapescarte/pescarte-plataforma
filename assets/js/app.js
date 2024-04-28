import "phoenix_html";
import Inputmask from "inputmask";

const cpf = document.querySelector("#user_cpf");

// input masks
if (cpf) Inputmask({ mask: "999.999.999-99" }).mask(cpf);

function onVisible(elem, callback) {
  const options = { root: document.documentElement };

  const observer = new IntersectionObserver((entries, _observer) => {
    entries.forEach((entry) => callback(entry.intersectionRatio > 0));
  }, options);

  observer.observe(elem);
}

if (window.location.pathname === "/acessar") {
  onVisible(document.body, (visible) => {
    if (visible) document.body.classList.add("fish");
  });
}

// Phoenix Hooks
let Hooks = {};

Hooks.CpfNumberMask = {
  mounted() {
    this.el.addEventListener("input", e => {
      let match = this.el.value.replace(/\D/g, "").match(/^(\d{3})(\d{3})(\d{3})(\d{2})$/)
      if (match) {
        this.el.value = `${match[1]}.${match[2]}.${match[3]}-${match[4]}`
      }
    })
  }
}

Hooks.NavbarHover = {
  mounted() {
    const navbar = document.querySelector("#auth-navbar");

    navbar.addEventListener("mouseover", (e) => {
      this.pushEventTo(navbar, "mouseover");
    });

    navbar.addEventListener("mouseleave", (e) => {
      this.pushEventTo(navbar, "mouseleave");
    });
  },
};

// LIVE VIEW
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});

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

topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (info) => topbar.show());
window.addEventListener("phx:page-loading-stop", (info) => topbar.hide());

import Glide from "@glidejs/glide/dist/glide.esm";

const glide1 = new Glide('.glide1', {
  type: 'slider',
  gap: 20,
  perview: 1,
  autoplay: 2000,
  hoverpause: true,
  animationDuration: 750,
});

glide1.on('run', function () {
  const bullets = document.querySelectorAll('.glide__bullet');
  bullets.forEach((bullet, index) => {
    if (index === glide1.index) {
      bullet.classList.add('active');
    } else {
      bullet.classList.remove('active');
    }
  });
});

glide1.mount();

const glide2 = new Glide('.glide2', {
  type: 'slider',
  perview: 3,
  peek: {
    before: 500,
    after: 500
  },
  startAt: 1
});

glide2.mount();
