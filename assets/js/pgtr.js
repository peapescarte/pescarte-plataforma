document.addEventListener("DOMContentLoaded", function() {
  const modalButtons = document.querySelectorAll('[id^="open-"][id$="-modal-btn"]');

  for (let i = 0; i < modalButtons.length; i++) {
    const button = modalButtons[i];
    button.addEventListener("click", function() {
      const modalId = button.id.replace("open-", "").replace("-modal-btn", "-modal");
      const modal = document.getElementById(modalId);
      if (modal) {
        modal.classList.add("is-active");
      }
    });
  }

  const closeButtons = document.querySelectorAll(".modal-close");

  for (let i = 0; i < closeButtons.length; i++) {
    const closeBtn = closeButtons[i];
    closeBtn.addEventListener("click", function() {
      const modal = closeBtn.closest(".modal");
      if (modal) {
        modal.classList.remove("is-active");
      }
    });
  }
});

document.addEventListener("DOMContentLoaded", function() {
  const municipioSelect = document.getElementById("document_municipio_id");
  const unitSelect = document.getElementById("document_unit_id");

  const allUnitOptions = Array.from(unitSelect.querySelectorAll("option")).filter(opt => opt.value !== "");

  municipioSelect.addEventListener("change", function() {
    const selectedMunicipio = this.value;

    unitSelect.innerHTML = "";
    const defaultOption = document.createElement("option");
    defaultOption.value = "";
    defaultOption.textContent = "Selecione uma Unidade";
    unitSelect.appendChild(defaultOption);

    allUnitOptions.forEach(function(option) {
      if (option.getAttribute("data-municipio-id") === selectedMunicipio) {
        unitSelect.appendChild(option.cloneNode(true));
      }
    });
  });
});

document.addEventListener("DOMContentLoaded", function() {
  const modalButtons = document.querySelectorAll('[id^="open-"][id$="-modal-btn"]');

  for (let i = 0; i < modalButtons.length; i++) {
    const button = modalButtons[i];
    button.addEventListener("click", function() {
      const modalId = button.id.replace("open-", "").replace("-modal-btn", "-modal");
      const modal = document.getElementById(modalId);
      if (modal) {
        modal.classList.add("is-active");
        document.body.classList.add("body-no-scroll");
      }
    });
  }

  const closeButtons = document.querySelectorAll(".modal-close");

  for (let i = 0; i < closeButtons.length; i++) {
    const closeBtn = closeButtons[i];
    closeBtn.addEventListener("click", function() {
      const modal = closeBtn.closest(".modal");
      if (modal) {
        modal.classList.remove("is-active");
        document.body.classList.remove("body-no-scroll");
      }
    });
  }
});
