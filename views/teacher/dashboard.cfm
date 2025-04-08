<cfinclude template="../../includes/header.cfm">

<div class="row mb-4">
    <div class="col">
        <h1>Öğretmen Paneli</h1>
        <p class="lead">Hoş geldiniz, <strong><cfoutput>#session.fullName#</cfoutput></strong>. Bu panel üzerinden gezileri ve öğrencileri yönetebilirsiniz.</p>
    </div>
</div>

<div class="row mb-4">
    <div class="col-md-6 mb-3">
        <div class="card h-100">
            <div class="card-header">
                <h5 class="mb-0">Hızlı Erişim</h5>
            </div>
            <div class="card-body">
                <div class="d-grid gap-2">
                    <a href="index.cfm?action=newTripForm" class="btn btn-primary">
                        <i class="bi bi-plus-circle"></i> Yeni Gezi Oluştur
                    </a>
                    <a href="index.cfm?action=newStudentForm" class="btn btn-success">
                        <i class="bi bi-person-plus"></i> Yeni Öğrenci Ekle
                    </a>
                    <a href="index.cfm?action=listTrips" class="btn btn-info text-white">
                        <i class="bi bi-list-ul"></i> Tüm Gezileri Görüntüle
                    </a>
                    <a href="index.cfm?action=listStudents" class="btn btn-secondary">
                        <i class="bi bi-people"></i> Tüm Öğrencileri Görüntüle
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-6 mb-3">
        <div class="card h-100">
            <div class="card-header">
                <h5 class="mb-0">Yaklaşan Geziler</h5>
            </div>
            <div class="card-body">
                <cfif request.upcomingTrips.RecordCount GT 0>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Gezi Adı</th>
                                    <th>Tarih</th>
                                    <th>Öğrenci</th>
                                    <th>İşlemler</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="request.upcomingTrips" maxrows="5">
                                    <tr>
                                        <td>#TRIP_NAME#</td>
                                        <td>#DateFormat(TRIP_DATE, "dd.mm.yyyy")#</td>
                                        <td>#STUDENT_COUNT#</td>
                                        <td>
                                            <a href="index.cfm?action=showApprovalLinks&TRIP_ID=#TRIP_ID#" class="btn btn-sm btn-primary">
                                                <i class="bi bi-link"></i> Onay Linkleri
                                            </a>
                                        </td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                    <cfif request.upcomingTrips.RecordCount GT 5>
                        <div class="text-end mt-2">
                            <a href="index.cfm?action=listTrips" class="btn btn-outline-primary btn-sm">Tümünü Görüntüle</a>
                        </div>
                    </cfif>
                <cfelse>
                    <div class="alert alert-info">
                        Henüz gezi oluşturulmamış. Hemen yeni bir gezi oluşturmak için 
                        <a href="index.cfm?action=newTripForm" class="alert-link">tıklayın</a>.
                    </div>
                </cfif>
            </div>
        </div>
    </div>
</div>

<cfinclude template="../../includes/footer.cfm">