<!DOCTYPE html>
<html>
<head>
    <title>Hata Oluştu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="card text-white bg-danger">
            <div class="card-header">
                <h3>Bir Hata Oluştu</h3>
            </div>
            <div class="card-body">
                <cfdump var="#error#" label="Hata Detayları">
            </div>
        </div>
    </div>
</body>
</html>