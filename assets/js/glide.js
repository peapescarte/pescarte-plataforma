import Glide from "@glidejs/glide/dist/glide.esm";

const glide1 = new Glide('.glide1', {
  type: 'slider',
  gap: 20,
  perview: 1,
  autoplay: 35 * 10 * 10,
  hoverpause: true,
  animationDuration: 15 * 100,
  direction: 'ltr'
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
  type: 'carousel',
  autoplay: 5000,
  perView: 1,
  focusAt: 'center',
  gap: 24,
  peek: 107
});

glide2.mount();
