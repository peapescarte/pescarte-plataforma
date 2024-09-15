const phases = document.querySelectorAll('.phases');
const units = document.querySelectorAll('.units-accordions');

units.forEach(phase => {
    const accordions = phase.getElementsByClassName('accordion-bx');
    const image = phase.querySelector('img');
    const initHeight = image.scrollHeight;
    
    function adjustImageHeight() {
        const windowWidth = window.innerWidth;
        
        if (windowWidth > 768) {
            let newHeight = initHeight;
            Array.from(accordions).forEach(accordion => {
                if (accordion.classList.contains('active')) {
                    const phaseContentHeight = phase.querySelector('.production-units').scrollHeight;
                    newHeight = phaseContentHeight;
                }
            });
            image.style.height = `${newHeight}px`;
        }
    }

    for (let i = 0; i < accordions.length; i++) {
        accordions[i].addEventListener('click', function() {
            if (!this.classList.contains('active')) {
                this.classList.add('active');
                adjustImageHeight();
            } else {
                this.classList.remove('active');
                adjustImageHeight();
            }
        });
    }
});

phases.forEach(phase => {
    const accordions = phase.getElementsByClassName('accordion-bx');
    const image = phase.querySelector('img');
    const initHeight = image.scrollHeight;
    
    
    function adjustImageHeight() {
        const windowWidth = window.innerWidth;
        
        if (windowWidth > 768) {
            let newHeight = initHeight;
            Array.from(accordions).forEach(accordion => {
                if (accordion.classList.contains('active')) {
                    const phaseContentHeight = phase.querySelector('.phase-content').scrollHeight;
                    newHeight = phaseContentHeight;
                }
            });
            image.style.height = `${newHeight}px`;
        }
        const windowWidth = window.innerWidth;
        
        if (windowWidth > 768) {
            let newHeight = initHeight;
            Array.from(accordions).forEach(accordion => {
                if (accordion.classList.contains('active')) {
                    const phaseContentHeight = phase.querySelector('.phase-content').scrollHeight;
                    newHeight = phaseContentHeight;
                }
            });
            image.style.height = `${newHeight}px`;
        }
    }

    for (let i = 0; i < accordions.length; i++) {
        accordions[i].addEventListener('click', function() {
            if (!this.classList.contains('active')) {
                this.classList.add('active');
                adjustImageHeight();
            } else {
                this.classList.remove('active');
                adjustImageHeight();
            }
        });
    }
});
