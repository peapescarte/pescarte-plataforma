import Glide from "@glidejs/glide/dist/glide.esm.js";

const glide1 = new Glide(".glide1", {
  type: "slider",
  gap: 20,
  perView: 1,
  autoplay: 3500,
  hoverpause: true,
  animationDuration: 1500,
  direction: "ltr",
});

glide1.on("run", function () {
  const bullets = document.querySelectorAll(".glide1 .glide__bullet");
  bullets.forEach((bullet, index) => {
    if (index === glide1.index) {
      bullet.classList.add("active");
    } else {
      bullet.classList.remove("active");
    }
  });
});

const glide2 = new Glide(".glide2", {
  type: "carousel",
  autoplay: 5000,
  perView: 1,
  focusAt: "center",
  gap: 24,
  peek: 107,
});

glide2.on("run", function () {
  const bullets = document.querySelectorAll(".glide2 .glide__bullet");
  bullets.forEach((bullet, index) => {
    if (index === glide2.index) {
      bullet.classList.add("active");
    } else {
      bullet.classList.remove("active");
    }
  });
});

if (window.location.pathname === "/") {
  glide1.mount();
  glide2.mount();
}
