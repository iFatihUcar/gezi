<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gezi Onay Formu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
        .btn-approval {
            width: 150px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card approval-card mb-4">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0">Gezi Onay Formu</h3>
            </div>
            <div class="card-body">
                <cfif IsDefined("request.error")>
                    <div class="alert alert-danger">
                        <cfoutput>#request.error#</cfoutput>
                    </div>
                <cfelse>
                    <cfoutput>
                        <h4 class="mb-4 text-center">#request.tripInfo.TRIP_NAME# Gezisi</h4>
                        
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="card mb-3">
                                    <div class="card-header bg-light">
                                        <h5 class="mb-0">Gezi Bilgileri</h5>
                                    </div>
                                    <div class="card-body">
                                        <p><strong>Gezi Tarihi:</strong> #DateFormat(request.tripInfo.TRIP_DATE, "dd.mm.yyyy")#</p>
                                        <p><strong>Gezi Yeri:</strong> #request.tripInfo.TRIP_LOCATION#</p>
                                        <p><strong>Gezi Ücreti:</strong> #NumberFormat(request.tripInfo.TRIP_COST, ",.##")# TL</p>
                                        <p class="mb-0"><strong>Açıklama:</strong> #request.tripInfo.TRIP_DESCRIPTION#</p>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="card">
                                    <div class="card-header bg-light">
                                        <h5 class="mb-0">Öğrenci Bilgileri</h5>
                                    </div>
                                    <div class="card-body">
                                        <p><strong>Öğrenci Adı Soyadı:</strong> #request.tripInfo.STUDENT_NAME# #request.tripInfo.STUDENT_SURNAME#</p>
                                        <p><strong>Sınıf:</strong> #request.tripInfo.STUDENT_CLASS#</p>
                                        <p><strong>Veli Adı:</strong> #request.tripInfo.PARENT_NAME#</p>
                                        <p class="mb-0"><strong>Veli Telefonu:</strong> #request.tripInfo.PARENT_PHONE#</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <cfif isDefined("request.tripInfo.APPROVAL_STATUS") AND request.tripInfo.APPROVAL_STATUS NEQ "">
                            <div class="alert alert-info text-center">
                                <h5 class="mb-0">
                                    <cfif request.tripInfo.APPROVAL_STATUS EQ "APPROVED">
                                        <span class="text-success">Bu gezi için daha önce ONAY verdiniz.</span>
                                    <cfelseif request.tripInfo.APPROVAL_STATUS EQ "REJECTED">
                                        <span class="text-danger">Bu gezi için daha önce RED verdiniz.</span>
                                    </cfif>
                                    <br>
                                    <small>(Onay durumunuzu aşağıdan güncelleyebilirsiniz)</small>
                                </h5>
                            </div>
                        </cfif>
                        
                        <form action="approve.cfm?action=saveApproval" method="post" class="mt-3">
                            <input type="hidden" name="TOKEN" value="#request.tripInfo.TOKEN#">
                            
                            <div class="mb-3">
                                <label for="APPROVAL_NOTES" class="form-label">Notlar (İsteğe bağlı):</label>
                                <textarea class="form-control" id="APPROVAL_NOTES" name="APPROVAL_NOTES" rows="3" placeholder="Gezi ile ilgili eklemek istediğiniz notlar..."></textarea>
                            </div>
                            
                            <div class="d-flex justify-content-center mb-3">
                                <button type="submit" name="APPROVAL_STATUS" value="APPROVED" class="btn btn-success btn-lg btn-approval me-3">
                                    <i class="bi bi-check-circle"></i> ONAYLIYORUM
                                </button>
                                <button type="submit" name="APPROVAL_STATUS" value="REJECTED" class="btn btn-danger btn-lg btn-approval">
                                    <i class="bi bi-x-circle"></i> REDDEDİYORUM
                                </button>
                            </div>
                        </form>
                    </cfoutput>
                </cfif>
            </div>
            <div class="card-footer text-center text-muted">
                <small>&copy; 2025 Gezi Onay Sistemi</small>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>