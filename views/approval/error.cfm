<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gezi Onay Formu - Hata</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f5f5f5;
            padding-top: 40px;
            padding-bottom: 40px;
        }
        .approval-card {
            max-width: 800px;
            margin: 0 auto;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .error-icon {
            font-size: 5rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card approval-card mb-4">
            <div class="card-header bg-danger text-white">
                <h3 class="mb-0">Gezi Onay Formu - Hata</h3>
            </div>
            <div class="card-body text-center">
                <i class="bi bi-exclamation-triangle-fill text-warning error-icon mb-3"></i>
                <h3 class="mb-3">Hata Oluştu</h3>
                <div class="alert alert-danger">
                    <cfoutput>#request.error#</cfoutput>
                </div>
                <p class="mt-4">Lütfen gezi öğretmeninizle iletişime geçiniz.</p>
            </div>
            <div class="card-footer text-center text-muted">
                <small>&copy; 2025 Gezi Onay Sistemi</small>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>