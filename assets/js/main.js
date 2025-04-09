// Onay linkini kopyalama fonksiyonu
$(document).ready(function () {
    window.copyToClipboard = function (text) {
        const tempInput = document.createElement("input");
        tempInput.value = text;
        document.body.appendChild(tempInput);
        tempInput.select();
        tempInput.setSelectionRange(0, 99999); // mobil uyumlu
        document.execCommand("copy");
        document.body.removeChild(tempInput);
    };
});

// Öğrenci seçim checkbox'larını kontrol etme
document.addEventListener('DOMContentLoaded', function() {
    // Select All checkbox functionality
    const selectAllCheckbox = document.getElementById('selectAll');
    if (selectAllCheckbox) {
        selectAllCheckbox.addEventListener('change', function() {
            const checkboxes = document.querySelectorAll('.student-checkbox');
            checkboxes.forEach(checkbox => {
                checkbox.checked = selectAllCheckbox.checked;
            });
        });
    }
    
    // Form doğrulama
    const forms = document.querySelectorAll('.needs-validation');
    
    Array.from(forms).forEach(form => {
        form.addEventListener('submit', event => {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            
            form.classList.add('was-validated');
        }, false);
    });
});
