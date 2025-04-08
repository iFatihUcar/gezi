<cfinclude template="../../includes/header.cfm">

<div class="d-flex justify-content-between align-items-center mb-4">
    <h1><cfoutput>#request.trip.TRIP_NAME#</cfoutput> - Öğrenci Atamaları</h1>
    <a href="index.cfm?action=listTrips" class="btn btn-secondary">
        <i class="bi bi-arrow-left"></i> Gezilere Dön
    </a>
</div>

<div class="row">
    <div class="col-md-6 mb-4">
        <div class="card h-100">
            <div class="card-header">
                <h5 class="mb-0">Gezi Bilgileri</h5>
            </div>
            <div class="card-body">
                <table class="table">
                    <cfoutput>
                    <tr>
                        <th>Gezi Adı:</th>
                        <td>#request.trip.TRIP_NAME#</td>
                    </tr>
                    <tr>
                        <th>Gezi Tarihi:</th>
                        <td>#DateFormat(request.trip.TRIP_DATE, "dd.mm.yyyy")#</td>
                    </tr>
                    <tr>
                        <th>Gezi Konumu:</th>
                        <td>#request.trip.TRIP_LOCATION#</td>
                    </tr>
                    <tr>
                        <th>Gezi Ücreti:</th>
                        <td>#NumberFormat(request.trip.TRIP_COST, ",.##")# TL</td>
                    </tr>
                    <tr>
                        <th>Atanmış Öğrenci Sayısı:</th>
                        <td>#request.assignedStudents.RecordCount#</td>
                    </tr>
                    </cfoutput>
                </table>
                
                <div class="mt-3">
                    <a href="index.cfm?action=showApprovalLinks&TRIP_ID=<cfoutput>#request.trip.TRIP_ID#</cfoutput>" class="btn btn-primary w-100">
                        <i class="bi bi-link"></i> Onay Linklerini Göster
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-6 mb-4">
        <div class="card h-100">
            <div class="card-header">
                <h5 class="mb-0">Öğrenci Ekle</h5>
            </div>
            <div class="card-body">
                <cfif request.allStudents.RecordCount GT 0>
                    <form action="index.cfm?action=assignStudents" method="post">
                        <input type="hidden" name="TRIP_ID" value="<cfoutput>#request.trip.TRIP_ID#</cfoutput>">
                        
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="selectAll">
                                <label class="form-check-label" for="selectAll">
                                    <strong>Tümünü Seç</strong>
                                </label>
                            </div>
                        </div>
                        
                        <div class="mb-3" style="max-height: 300px; overflow-y: auto;">
                            <cfoutput query="request.allStudents">
                                <div class="form-check">
                                    <input class="form-check-input student-checkbox" type="checkbox" name="STUDENT_IDS" value="#STUDENT_ID#" id="student_#STUDENT_ID#">
                                    <label class="form-check-label" for="student_#STUDENT_ID#">
                                        #STUDENT_NAME# #STUDENT_SURNAME# (#STUDENT_CLASS#)
                                    </label>
                                </div>
                            </cfoutput>
                        </div>
                        
                        <button type="submit" class="btn btn-success w-100">
                            <i class="bi bi-person-plus"></i> Seçili Öğrencileri Ekle
                        </button>
                    </form>
                <cfelse>
                    <div class="alert alert-info">
                        Henüz öğrenci eklenmemiş. <a href="index.cfm?action=newStudentForm" class="alert-link">Yeni öğrenci eklemek için tıklayın</a>.
                    </div>
                </cfif>
            </div>
        </div>
    </div>
</div>

<div class="card mb-4">
    <div class="card-header">
        <h5 class="mb-0">Geziye Atanmış Öğrenciler</h5>
    </div>
    <div class="card-body">
        <cfif request.assignedStudents.RecordCount GT 0>
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Öğrenci Adı Soyadı</th>
                            <th>Sınıf</th>
                            <th>Veli Adı</th>
                            <th>Veli Telefonu</th>
                            <th>Onay Durumu</th>
                            <th>İşlemler</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="request.assignedStudents">
                            <tr>
                                <td>#STUDENT_NAME# #STUDENT_SURNAME#</td>
                                <td>#STUDENT_CLASS#</td>
                                <td>#PARENT_NAME#</td>
                                <td>#PARENT_PHONE#</td>
                                <td>
                                    <span class="badge 
                                        <cfif APPROVAL_STATUS EQ 'APPROVED'>badge-approved
                                        <cfelseif APPROVAL_STATUS EQ 'REJECTED'>badge-rejected
                                        <cfelse>badge-pending</cfif>">
                                        <cfif APPROVAL_STATUS EQ 'APPROVED'>Onaylandı
                                        <cfelseif APPROVAL_STATUS EQ 'REJECTED'>Reddedildi
                                        <cfelse>Bekliyor</cfif>
                                    </span>
                                </td>
                                <td>
                                    <a href="index.cfm?action=removeStudentFromTrip&TRIP_ID=#request.trip.TRIP_ID#&STUDENT_ID=#STUDENT_ID#" 
                                       class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('Bu öğrenciyi geziden çıkarmak istediğinize emin misiniz?');">
                                        <i class="bi bi-person-dash"></i> Geziden Çıkar
                                    </a>
                                </td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
            </div>
        <cfelse>
            <div class="alert alert-info">
                Bu geziye henüz öğrenci atanmamış. Yukarıdaki formdan öğrenci ekleyebilirsiniz.
            </div>
        </cfif>
    </div>
</div>

<cfinclude template="../../includes/footer.cfm">