// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
import Inputmask from "inputmask";

const cpf = document.querySelector("#user_cpf");

// input masks
if (cpf) Inputmask({mask: "999.999.999-99"}).mask(cpf);
