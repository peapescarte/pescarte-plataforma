const accordions = document.getElementsByClassName('accordion-bx');

for (let i = 0; i < accordions.length; i++) {
    accordions[i].addEventListener('mouseover', function() {
        if (!this.classList.contains('active')) {
            this.classList.add('active');
        }
    });

    accordions[i].addEventListener('mouseleave', function() {
        if (this.classList.contains('active')) {
            this.classList.remove('active');
        }
    });
}