// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
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
