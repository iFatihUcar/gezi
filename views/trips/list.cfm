<cfinclude template="../../includes/header.cfm">

<div class="d-flex justify-content-between align-items-center mb-4">
    <h1>Geziler</h1>
    <a href="index.cfm?action=newTripForm" class="btn btn-primary">
        <i class="bi bi-plus-circle"></i> Yeni Gezi Oluştur
    </a>
</div>

<div class="card mb-4">
    <div class="card-header">
        <ul class="nav nav-tabs card-header-tabs">
            <li class="nav-item">
                <a class="nav-link <cfif url.status EQ 'ACTIVE'>active</cfif>" href="index.cfm?action=listTrips&status=ACTIVE">Aktif Geziler</a>
            </li>
            <li class="nav-item">
                <a class="nav-link <cfif url.status EQ 'ALL'>active</cfif>" href="index.cfm?action=listTrips&status=ALL">Tüm Geziler</a>
            </li>
            <li class="nav-item">
                <a class="nav-link <cfif url.status EQ 'COMPLETED'>active</cfif>" href="index.cfm?action=listTrips&status=COMPLETED">Tamamlanan Geziler</a>
            </li>
            <li class="nav-item">
                <a class="nav-link <cfif url.status EQ 'CANCELED'>active</cfif>" href="index.cfm?action=listTrips&status=CANCELED">İptal Edilen Geziler</a>
            </li>
        </ul>
    </div>
    <div class="card-body">
        <cfif request.trips.RecordCount GT 0>
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Gezi Adı</th>
                            <th>Tarih</th>
                            <th>Konum</th>
                            <th>Öğrenci Sayısı</th>
                            <th>Durum</th>
                            <th>İşlemler</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="request.trips">
                            <tr>
                                <td>#TRIP_NAME#</td>
                                <td>#DateFormat(TRIP_DATE, "dd.mm.yyyy")#</td>
                                <td>#TRIP_LOCATION#</td>
                                <td>#STUDENT_COUNT#</td>
                                <td>
                                    <span class="badge 
                                        <cfif TRIP_STATUS EQ 'ACTIVE'>bg-success
                                        <cfelseif TRIP_STATUS EQ 'COMPLETED'>bg-info
                                        <cfelseif TRIP_STATUS EQ 'CANCELED'>bg-danger
                                        <cfelse>bg-secondary</cfif>">
                                        #TRIP_STATUS#
                                    </span>
                                </td>
                                <td>
                                    <div class="btn-group">
                                        <a href="index.cfm?action=editTripForm&TRIP_ID=#TRIP_ID#" class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-pencil"></i> Düzenle
                                        </a>
                                        <a href="index.cfm?action=assignStudentsForm&TRIP_ID=#TRIP_ID#" class="btn btn-sm btn-outline-success">
                                            <i class="bi bi-people"></i> Öğrenciler
                                        </a>
                                        <a href="index.cfm?action=showApprovalLinks&TRIP_ID=#TRIP_ID#" class="btn btn-sm btn-outline-info">
                                            <i class="bi bi-link"></i> Onay Linkleri
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
            </div>
        <cfelse>
            <div class="alert alert-info">
                <cfif url.status EQ 'ACTIVE'>
                    Aktif gezi bulunamadı.
                <cfelseif url.status EQ 'COMPLETED'>
                    Tamamlanan gezi bulunamadı.
                <cfelseif url.status EQ 'CANCELED'>
                    İptal edilen gezi bulunamadı.
                <cfelse>
                    Herhangi bir gezi bulunamadı.
                </cfif>
                <a href="index.cfm?action=newTripForm" class="alert-link">Yeni gezi oluştur</a>
            </div>
        </cfif>
    </div>
</div>

<cfinclude template="../../includes/footer.cfm">