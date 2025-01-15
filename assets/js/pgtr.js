// Selecionar botões e modais
const openMunicipioModalBtn = document.getElementById("open-municipio-modal-btn");
const municipioModal = document.getElementById("municipio-modal");

const openUnitModalBtn = document.getElementById("open-unit-modal-btn");
const unitModal = document.getElementById("unit-modal");

const openDocTypeModalBtn = document.getElementById("open-document-type-modal-btn");
const docTypeModal = document.getElementById("document-type-modal");

const openDocumentModalBtn = document.getElementById("open-document-modal-btn");
const documentModal = document.getElementById("document-modal");

// Função auxiliar para abrir modal
function openModal(modalElement) {
  if (modalElement) {
    modalElement.classList.add("is-active");
  }
}

// Função auxiliar para fechar modal
function closeModal(modalElement) {
  if (modalElement) {
    modalElement.classList.remove("is-active");
  }
}

// Abrir cada modal ao clicar em seu botão
if (openMunicipioModalBtn && municipioModal) {
  openMunicipioModalBtn.addEventListener("click", () => {
    openModal(municipioModal);
  });
}

if (openUnitModalBtn && unitModal) {
  openUnitModalBtn.addEventListener("click", () => {
    openModal(unitModal);
  });
}

if (openDocTypeModalBtn && docTypeModal) {
  openDocTypeModalBtn.addEventListener("click", () => {
    openModal(docTypeModal);
  });
}

if (openDocumentModalBtn && documentModal) {
  openDocumentModalBtn.addEventListener("click", () => {
    openModal(documentModal);
  });
}

// Fechar modal ao clicar em qualquer elemento com a classe "modal-close"
const closeElements = document.querySelectorAll(".modal-close");
closeElements.forEach((el) => {
  el.addEventListener("click", () => {
    // Subindo até o .modal pai
    const modalParent = el.closest(".modal");
    if (modalParent) {
      closeModal(modalParent);
    }
  });
});
