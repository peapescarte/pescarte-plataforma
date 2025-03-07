document.addEventListener("DOMContentLoaded", function() {
  const modalButtons = document.querySelectorAll('[id^="open-"][id$="-modal-btn"]');
  modalButtons.forEach(function(button) {
    button.addEventListener("click", function() {
      const modalId = button.id.replace("open-", "").replace("-modal-btn", "-modal");
      const modal = document.getElementById(modalId);
      if (modal) {
        modal.classList.add("is-active");
        document.body.classList.add("body-no-scroll");
      }
    });
  });

  const closeButtons = document.querySelectorAll(".modal-close");
  closeButtons.forEach(function(closeBtn) {
    closeBtn.addEventListener("click", function() {
      const modal = closeBtn.closest(".modal");
      if (modal) {
        modal.classList.remove("is-active");
        document.body.classList.remove("body-no-scroll");
      }
    });
  });

  const municipioSelectCreate = document.getElementById("document_municipio_id");
  const unitSelectCreate = document.getElementById("document_unit_id");
  if (municipioSelectCreate && unitSelectCreate) {
    const allUnitOptions = Array.from(unitSelectCreate.querySelectorAll("option")).filter(opt => opt.value !== "");
    municipioSelectCreate.addEventListener("change", function() {
      const selectedMunicipio = this.value;
      unitSelectCreate.innerHTML = "";
      const defaultOption = document.createElement("option");
      defaultOption.value = "";
      defaultOption.textContent = "Selecione uma Unidade";
      unitSelectCreate.appendChild(defaultOption);

      allUnitOptions.forEach(function(option) {
        if (option.getAttribute("data-municipio-id") === selectedMunicipio) {
          unitSelectCreate.appendChild(option.cloneNode(true));
        }
      });
    });
  }

  const municipioUpdateSelect = document.getElementById("municipio-update-select");
  const municipioUpdateForm = document.getElementById("municipio-update-form");
  const municipioIdHiddenInput = document.getElementById("municipio_update_id");
  const municipioNameInput = document.getElementById("municipio_name_update");
  if (municipioUpdateSelect && municipioUpdateForm) {
    municipioUpdateSelect.addEventListener("change", function() {
      const selectedOption = this.options[this.selectedIndex];
      const municipioId = selectedOption.value;
      const municipioName = selectedOption.getAttribute("data-nome") || "";

      municipioIdHiddenInput.value = municipioId;
      municipioNameInput.value = municipioName;

      if (municipioId) {
        municipioUpdateForm.action = `/pgtr/update_municipio/${municipioId}`;
      } else {
        municipioUpdateForm.action = "#";
      }
    });
  }

  const unitUpdateMunicipioFilter = document.getElementById("unit-update-municipio-filter");
  const unitUpdateSelect = document.getElementById("unit-update-select");
  const unitUpdateForm = document.getElementById("unit-update-form");

  const unitIdHiddenInput = document.getElementById("unit_update_id");
  const unitMunicipioSelectInForm = document.getElementById("unit_update_municipio_id");
  const unitNameInput = document.getElementById("unit_update_name");
  const unitSituationInput = document.getElementById("unit_update_situation");
  const unitNextStepInput = document.getElementById("unit_update_next_step");

  if (unitUpdateMunicipioFilter && unitUpdateSelect) {

    const allUnitUpdateOptions = Array.from(unitUpdateSelect.querySelectorAll("option")).filter(opt => opt.value !== "");

    unitUpdateMunicipioFilter.addEventListener("change", function() {
      const selectedMunicipioId = this.value;
      unitUpdateSelect.innerHTML = "";
      const defaultOption = document.createElement("option");
      defaultOption.value = "";
      defaultOption.textContent = "Selecione";
      unitUpdateSelect.appendChild(defaultOption);

      allUnitUpdateOptions.forEach(function(option) {
        if (option.getAttribute("data-municipio-id") === selectedMunicipioId) {
          unitUpdateSelect.appendChild(option.cloneNode(true));
        }
      });

      unitIdHiddenInput.value = "";
      unitNameInput.value = "";
      unitSituationInput.value = "";
      unitNextStepInput.value = "";
      if (unitMunicipioSelectInForm) {
        unitMunicipioSelectInForm.value = selectedMunicipioId || "";
      }
      unitUpdateForm.action = "#";
    });

    unitUpdateSelect.addEventListener("change", function() {
      const selectedOption = this.options[this.selectedIndex];
      const unitId = selectedOption.value;
      const municipioId = selectedOption.getAttribute("data-municipio-id") || "";
      const unitName = selectedOption.getAttribute("data-name") || "";
      const situation = selectedOption.getAttribute("data-situation") || "";
      const nextStep = selectedOption.getAttribute("data-next-step") || "";

      unitIdHiddenInput.value = unitId;
      if (unitMunicipioSelectInForm) {
        unitMunicipioSelectInForm.value = municipioId;
      }
      unitNameInput.value = unitName;
      unitSituationInput.value = situation;
      unitNextStepInput.value = nextStep;

      if (unitId) {
        unitUpdateForm.action = `/pgtr/update_unit/${unitId}`;
      } else {
        unitUpdateForm.action = "#";
      }
    });
  }

  const docTypeUpdateSelect = document.getElementById("document-type-update-select");
  const docTypeUpdateForm = document.getElementById("document-type-update-form");
  const docTypeIdHiddenInput = document.getElementById("document_type_update_id");
  const docTypeNameInput = document.getElementById("document_type_name_update");
  if (docTypeUpdateSelect && docTypeUpdateForm) {
    docTypeUpdateSelect.addEventListener("change", function() {
      const selectedOption = this.options[this.selectedIndex];
      const docTypeId = selectedOption.value;
      const docTypeName = selectedOption.getAttribute("data-name") || "";

      docTypeIdHiddenInput.value = docTypeId;
      docTypeNameInput.value = docTypeName;

      if (docTypeId) {
        docTypeUpdateForm.action = `/pgtr/update_document_type/${docTypeId}`;
      } else {
        docTypeUpdateForm.action = "#";
      }
    });
  }


  const docUpdateMunicipioFilter = document.getElementById("document-update-municipio-filter");
  const docUpdateUnitFilter = document.getElementById("document-update-unit-filter");
  const docUpdateTypeFilter = document.getElementById("document-update-type-filter");
  const docUpdateSelect = document.getElementById("document-update-select");
  const docUpdateForm = document.getElementById("document-update-form");

  const docIdHiddenInput = document.getElementById("document_update_id");
  const docUnitInForm = document.getElementById("document_update_unit_id");
  const docTypeInForm = document.getElementById("document_update_document_type_id");
  const docStatusInForm = document.getElementById("document_update_status");
  const docLinkInForm = document.getElementById("document_update_document_link");

  if (docUpdateMunicipioFilter && docUpdateUnitFilter && docUpdateTypeFilter && docUpdateSelect) {
    const allUnitOptionsDocUpdate = Array.from(docUpdateUnitFilter.querySelectorAll("option")).filter(opt => opt.value !== "");
    const allTypeOptionsDocUpdate = Array.from(docUpdateTypeFilter.querySelectorAll("option")).filter(opt => opt.value !== "");
    const allDocOptionsDocUpdate = Array.from(docUpdateSelect.querySelectorAll("option")).filter(opt => opt.value !== "");

    docUpdateMunicipioFilter.addEventListener("change", function() {
      const selectedMunicipioId = this.value;

      docUpdateUnitFilter.innerHTML = "";
      const defaultUnitOpt = document.createElement("option");
      defaultUnitOpt.value = "";
      defaultUnitOpt.textContent = "Selecione uma Unidade";
      docUpdateUnitFilter.appendChild(defaultUnitOpt);

      allUnitOptionsDocUpdate.forEach(function(opt) {
        if (opt.getAttribute("data-municipio-id") === selectedMunicipioId) {
          docUpdateUnitFilter.appendChild(opt.cloneNode(true));
        }
      });

      docUpdateTypeFilter.innerHTML = "";
      const defaultTypeOpt = document.createElement("option");
      defaultTypeOpt.value = "";
      defaultTypeOpt.textContent = "Selecione um Tipo";
      docUpdateTypeFilter.appendChild(defaultTypeOpt);

      docUpdateSelect.innerHTML = "";
      const defaultDocOpt = document.createElement("option");
      defaultDocOpt.value = "";
      defaultDocOpt.textContent = "Selecione o Documento";
      docUpdateSelect.appendChild(defaultDocOpt);

      docIdHiddenInput.value = "";
      if (docUnitInForm) docUnitInForm.value = "";
      if (docTypeInForm) docTypeInForm.value = "";
      if (docStatusInForm) docStatusInForm.value = "";
      if (docLinkInForm) docLinkInForm.value = "";
      docUpdateForm.action = "#";
    });

    docUpdateUnitFilter.addEventListener("change", function() {
      const selectedMunicipioId = docUpdateMunicipioFilter.value;
      const selectedUnitId = this.value;


      const docTypeIdsSet = new Set();
      allDocOptionsDocUpdate.forEach(function(docOpt) {
        const docUnit = docOpt.getAttribute("data-unit-id");
        if (docUnit === selectedUnitId) {
          const dtId = docOpt.getAttribute("data-document-type-id");
          docTypeIdsSet.add(dtId);
        }
      });

      docUpdateTypeFilter.innerHTML = "";
      const defaultTypeOpt = document.createElement("option");
      defaultTypeOpt.value = "";
      defaultTypeOpt.textContent = "Selecione um Tipo";
      docUpdateTypeFilter.appendChild(defaultTypeOpt);

      allTypeOptionsDocUpdate.forEach(function(typeOpt) {
        const typeId = typeOpt.value;
        if (docTypeIdsSet.has(typeId)) {
          docUpdateTypeFilter.appendChild(typeOpt.cloneNode(true));
        }
      });

      docUpdateSelect.innerHTML = "";
      const defaultDocOpt = document.createElement("option");
      defaultDocOpt.value = "";
      defaultDocOpt.textContent = "Selecione o Documento";
      docUpdateSelect.appendChild(defaultDocOpt);

      docIdHiddenInput.value = "";
      if (docUnitInForm) docUnitInForm.value = selectedUnitId || "";
      if (docTypeInForm) docTypeInForm.value = "";
      if (docStatusInForm) docStatusInForm.value = "";
      if (docLinkInForm) docLinkInForm.value = "";
      docUpdateForm.action = "#";
    });

    docUpdateTypeFilter.addEventListener("change", function() {
      const selectedUnitId = docUpdateUnitFilter.value;
      const selectedTypeId = this.value;

      docUpdateSelect.innerHTML = "";
      const defaultDocOpt = document.createElement("option");
      defaultDocOpt.value = "";
      defaultDocOpt.textContent = "Selecione o Documento";
      docUpdateSelect.appendChild(defaultDocOpt);

      allDocOptionsDocUpdate.forEach(function(docOpt) {
        const docUnit = docOpt.getAttribute("data-unit-id");
        const docType = docOpt.getAttribute("data-document-type-id");
        if (docUnit === selectedUnitId && docType === selectedTypeId) {
          docUpdateSelect.appendChild(docOpt.cloneNode(true));
        }
      });

      docIdHiddenInput.value = "";
      if (docTypeInForm) docTypeInForm.value = selectedTypeId || "";
      if (docStatusInForm) docStatusInForm.value = "";
      if (docLinkInForm) docLinkInForm.value = "";
      docUpdateForm.action = "#";
    });

    docUpdateSelect.addEventListener("change", function() {
      const selectedOption = this.options[this.selectedIndex];
      const docId = selectedOption.value;
      const unitId = selectedOption.getAttribute("data-unit-id") || "";
      const docTypeId = selectedOption.getAttribute("data-document-type-id") || "";
      const status = selectedOption.getAttribute("data-status") || "";
      const docLink = selectedOption.getAttribute("data-document-link") || "";

      docIdHiddenInput.value = docId;
      if (docUnitInForm) docUnitInForm.value = unitId;
      if (docTypeInForm) docTypeInForm.value = docTypeId;
      if (docStatusInForm) docStatusInForm.value = status;
      if (docLinkInForm) docLinkInForm.value = docLink;

      if (docId) {
        docUpdateForm.action = `/pgtr/update_document/${docId}`;
      } else {
        docUpdateForm.action = "#";
      }
    });
  }
});
