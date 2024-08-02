const contactForm = document.querySelector('.contact-form');

contactForm.addEventListener('submit', async function(event) {
    event.preventDefault();
    
    const name = document.getElementById('form-name').value;
    const email = document.getElementById('form-email').value;
    const subject = document.getElementById('form-dropdown').value;
    const message = document.getElementById('form-message').value;

    const response = await fetch('/send-email', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            name,
            email,
            subject,
            message
        })
    });

    if (response.ok) {
        alert('O email foi enviado com sucesso!');
    } else {
        const errorData = await response.json();
        alert(`O email não pode ser enviado. Erro: ${errorData.error}`);
    }
});