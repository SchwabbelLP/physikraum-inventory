// Physikraum Inventory - Custom JavaScript

document.addEventListener('DOMContentLoaded', function() {
    
    // Auto-hide alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });

    // Quantity adjustment buttons
    const quantityButtons = document.querySelectorAll('.btn-quantity');
    quantityButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const itemId = this.dataset.itemId;
            const action = this.dataset.action;
            adjustQuantity(itemId, action);
        });
    });

    // Dynamic subcategory loading
    const categorySelect = document.getElementById('categorySelect');
    if (categorySelect) {
        categorySelect.addEventListener('change', function() {
            loadSubcategories(this.value);
        });
    }
});

// Adjust item quantity via AJAX
function adjustQuantity(itemId, action) {
    const url = `/items/${itemId}/quantity/${action}`;
    
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Update quantity display
            const quantityElement = document.querySelector(`#quantity-${itemId}`);
            if (quantityElement) {
                quantityElement.textContent = data.newQuantity;
                
                // Add/remove zero class
                if (data.newQuantity === 0) {
                    quantityElement.classList.add('quantity-zero');
                } else {
                    quantityElement.classList.remove('quantity-zero');
                }
                
                // Flash animation
                quantityElement.classList.add('fade-in');
                setTimeout(() => {
                    quantityElement.classList.remove('fade-in');
                }, 300);
            }
            
            // Show success message
            showToast('Menge erfolgreich aktualisiert', 'success');
        } else {
            showToast(data.message || 'Fehler beim Aktualisieren', 'danger');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('Netzwerkfehler', 'danger');
    });
}

// Load subcategories based on selected category
function loadSubcategories(categoryId) {
    const subcategorySelect = document.getElementById('subcategorySelect');
    if (!subcategorySelect) return;
    
    if (!categoryId) {
        subcategorySelect.innerHTML = '<option value="">Bitte zuerst Kategorie wählen</option>';
        subcategorySelect.disabled = true;
        return;
    }
    
    fetch(`/api/categories/${categoryId}/subcategories`)
        .then(response => response.json())
        .then(data => {
            subcategorySelect.innerHTML = '<option value="">
