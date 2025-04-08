// Onay linkini kopyalama fonksiyonu
function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(function() {
        alert('Link kopyalandı!');
    }, function(err) {
        console.error('Link kopyalanamadı: ', err);
    });
}

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