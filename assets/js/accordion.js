const phases = document.querySelectorAll('.phases');

phases.forEach(phase => {
    const accordions = phase.getElementsByClassName('accordion-bx');
    const image = phase.querySelector('img');
    const initHeight = image.scrollHeight;

    function adjustImageHeight() {
        let newHeight = initHeight;
        Array.from(accordions).forEach(accordion => {
            if (accordion.classList.contains('active')) {
                const phaseContentHeight = phase.querySelector('.phase-content').scrollHeight;
                newHeight = phaseContentHeight;
            }
        });
        image.style.height = `${newHeight}px`;
    }

    for (let i = 0; i < accordions.length; i++) {
        accordions[i].addEventListener('mouseover', function() {
            if (!this.classList.contains('active')) {
                this.classList.add('active');
                adjustImageHeight();
            }
        });

        accordions[i].addEventListener('mouseleave', function() {
            if (this.classList.contains('active')) {
                this.classList.remove('active');
                adjustImageHeight();
            }
        });
    }
});