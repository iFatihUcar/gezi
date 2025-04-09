<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gezi Onay Sistemi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="/gezi_onay_sistemi/assets/css/main.css" rel="stylesheet">
    <link rel="icon" href="/gezi_onay_sistemi/assets/images/favicon.ico" type="image/x-icon">

</head>
<body>
    <header class="py-3 mb-4 border-bottom">
        <div class="container d-flex flex-wrap justify-content-between">
            <p class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-dark text-decoration-none">
                <span class="fs-4">Gezi Onay Sistemi</span>
            </p>
            <cfif IsDefined("session.userID") AND session.userID GT 0>
                <ul class="nav nav-pills">
                    <li class="nav-item"><a href="index.cfm?action=dashboard" class="nav-link">Ana Sayfa</a></li>
                    <li class="nav-item"><a href="index.cfm?action=listTrips" class="nav-link">Geziler</a></li>
                    <li class="nav-item"><a href="index.cfm?action=listStudents" class="nav-link">Öğrenciler</a></li>
                    <li class="nav-item"><a href="index.cfm?action=logout" class="nav-link bg-danger text-white">Çıkış</a></li>
                </ul>
            </cfif>
        </div>
    </header>
    
    <main class="container py-4">