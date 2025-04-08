<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gezi Onay Formu - Onay Alındı</title>
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
        .success-icon {
            font-size: 5rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card approval-card mb-4">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0">Gezi Onay Formu</h3>
            </div>
            <div class="card-body text-center">
                <cfif request.approvalStatus EQ "APPROVED">
                    <i class="bi bi-check-circle-fill text-success success-icon mb-3"></i>
                    <h3 class="mb-3">Gezi Onayınız Alınmıştır</h3>
                    <p class="lead">Geziye katılım için onayınız başarıyla kaydedilmiştir.</p>
                <cfelse>
                    <i class="bi bi-x-circle-fill text-danger success-icon mb-3"></i>
                    <h3 class="mb-3">Gezi Ret Kararınız Alınmıştır</h3>
                    <p class="lead">Geziye katılım için ret kararınız başarıyla kaydedilmiştir.</p>
                </cfif>
                
                <cfoutput>
                    <div class="row mt-4">
                        <div class="col-md-6 offset-md-3">
                            <div class="card mb-3">
                                <div class="card-header bg-light">
                                    <h5 class="mb-0">Gezi ve Öğrenci Bilgileri</h5>
                                </div>
                                <div class="card-body text-start">
                                    <p><strong>Gezi Adı:</strong> #request.tripInfo.TRIP_NAME#</p>
                                    <p><strong>Gezi Tarihi:</strong> #DateFormat(request.tripInfo.TRIP_DATE, "dd.mm.yyyy")#</p>
                                    <p><strong>Öğrenci:</strong> #request.tripInfo.STUDENT_NAME# #request.tripInfo.STUDENT_SURNAME#</p>
                                    <p><strong>Onay Durumu:</strong> 
                                        <span class="badge <cfif request.approvalStatus EQ 'APPROVED'>bg-success<cfelse>bg-danger</cfif>">
                                            <cfif request.approvalStatus EQ 'APPROVED'>Onaylandı<cfelse>Reddedildi</cfif>
                                        </span>
                                    </p>
                                    <p><strong>Onay Tarihi:</strong> #DateFormat(Now(), "dd.mm.yyyy")# #TimeFormat(Now(), "HH:mm")#</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </cfoutput>
                
                <p class="text-muted mt-3">Bu sayfayı kapatabilirsiniz.</p>
            </div>
            <div class="card-footer text-center text-muted">
                <small>&copy; 2025 Gezi Onay Sistemi</small>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>