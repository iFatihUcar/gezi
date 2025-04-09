<cfset token = Trim(URL.token)>
<cfset request.tripInfo = {}>
<cfset request.error = "">

<cfif Len(token)>
    <cfset approvalModel = CreateObject("component", "gezi_onay_sistemi.models.APPROVAL")>
    <cfset tripQuery = approvalModel.getTripInfoByToken(token = token)>

    <cfif tripQuery.RecordCount EQ 0>
        <cfset request.error = "Geçersiz veya süresi dolmuş bir onay bağlantısı.">
    <cfelse>
        <!--- Query'deki ilk satırı struct olarak al (doğru yöntemle) --->
        <cfset request.tripInfo = {
            TRIP_ID = tripQuery.TRIP_ID[1],
            TRIP_NAME = tripQuery.TRIP_NAME[1],
            TRIP_DESCRIPTION = tripQuery.TRIP_DESCRIPTION[1],
            TRIP_DATE = tripQuery.TRIP_DATE[1],
            TRIP_LOCATION = tripQuery.TRIP_LOCATION[1],
            TRIP_COST = tripQuery.TRIP_COST[1],
            STUDENT_ID = tripQuery.STUDENT_ID[1],
            STUDENT_NAME = tripQuery.STUDENT_NAME[1],
            STUDENT_SURNAME = tripQuery.STUDENT_SURNAME[1],
            STUDENT_CLASS = tripQuery.STUDENT_CLASS[1],
            PARENT_NAME = tripQuery.PARENT_NAME[1],
            PARENT_PHONE = tripQuery.PARENT_PHONE[1],
            PARENT_EMAIL = tripQuery.PARENT_EMAIL[1],
            APPROVAL_ID = tripQuery.APPROVAL_ID[1],
            APPROVAL_STATUS = tripQuery.APPROVAL_STATUS[1],
            APPROVAL_NOTES = tripQuery.APPROVAL_NOTES[1],
            APPROVAL_DATE = tripQuery.APPROVAL_DATE[1],
            TOKEN = tripQuery.TOKEN[1],
            EXPIRE_DATE = tripQuery.EXPIRE_DATE[1]
        }>
    </cfif>
<cfelse>
    <cfset request.error = "Geçersiz bağlantı.">
</cfif>


<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Gezi Onay Formu</title>
    <link rel="icon" href="/gezi_onay_sistemi/assets/images/favicon.ico" type="image/x-icon">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f5f5f5; padding-top: 40px; padding-bottom: 40px; }
        .approval-card { max-width: 800px; margin: 0 auto; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .btn-approval { width: 150px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="card approval-card mb-4">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0">Gezi Onay Formu</h3>
            </div>
            <div class="card-body">

                <cfif Len(request.error)>
                <cfif StructKeyExists(URL, "success")>
                    <div class="alert alert-success text-center">
                        ✅ Onayınız başarıyla kaydedildi. Teşekkür ederiz!
                    </div>
                </cfif>
                    <div class="alert alert-danger text-center">
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
                                        <p><strong>Gezi Ücreti:</strong> #LSNumberFormat(Val(request.tripInfo.TRIP_COST))# TL</p>
                                        <p><strong>Açıklama:</strong> #request.tripInfo.TRIP_DESCRIPTION#</p>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="card">
                                    <div class="card-header bg-light">
                                        <h5 class="mb-0">Öğrenci Bilgileri</h5>
                                    </div>
                                    <div class="card-body">
                                        <p><strong>Ad Soyad:</strong> #request.tripInfo.STUDENT_NAME# #request.tripInfo.STUDENT_SURNAME#</p>
                                        <p><strong>Sınıf:</strong> #request.tripInfo.STUDENT_CLASS#</p>
                                        <p><strong>Veli:</strong> #request.tripInfo.PARENT_NAME#</p>
                                        <p><strong>Veli Telefon:</strong> #request.tripInfo.PARENT_PHONE#</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <cfif StructKeyExists(request.tripInfo, "APPROVAL_STATUS")>
                            <cfif request.tripInfo.APPROVAL_STATUS EQ "APPROVED">
                                <div class="alert alert-success text-center">
                                    ✅ Bu gezi için onay verdiniz.<br>
                                    <small>İsterseniz aşağıdan kararınızı değiştirebilirsiniz.</small>
                                </div>
                            <cfelseif request.tripInfo.APPROVAL_STATUS EQ "REJECTED">
                                <div class="alert alert-warning text-center">
                                    ❌ Bu gezi için red verdiniz.<br>
                                    <small>İsterseniz aşağıdan kararınızı değiştirebilirsiniz.</small>
                                </div>
                            </cfif>
                        </cfif>

                        <form action="approve.cfm?action=saveApproval" method="post" class="mt-3">
                            <input type="hidden" name="TOKEN" value="#request.tripInfo.TOKEN#">

                            <div class="mb-3">
                                <label class="form-label">Notlar (isteğe bağlı):</label>
                                <textarea class="form-control" name="APPROVAL_NOTES" rows="3"></textarea>
                            </div>

                            <div class="d-flex justify-content-center mb-3">
                                <button type="submit" name="APPROVAL_STATUS" value="APPROVED" class="btn btn-success btn-lg me-3">ONAYLIYORUM</button>
                                <button type="submit" name="APPROVAL_STATUS" value="REJECTED" class="btn btn-danger btn-lg">REDDİYORUM</button>
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
</body>
</html>
