<cfinclude template="../../includes/header.cfm">

<div class="d-flex justify-content-between align-items-center mb-4">
    <h1><cfoutput>#request.trip.TRIP_NAME#</cfoutput> - Onay Linkleri</h1>
    <div>
        <a href="index.cfm?action=assignStudentsForm&TRIP_ID=<cfoutput>#request.trip.TRIP_ID#</cfoutput>" class="btn btn-success me-2">
            <i class="bi bi-people"></i> Öğrenci Atama
        </a>
        <a href="index.cfm?action=listTrips" class="btn btn-secondary">
            <i class="bi bi-arrow-left"></i> Gezilere Dön
        </a>
    </div>
</div>

<div class="row mb-4">
    <div class="col-md-4 mb-3">
        <div class="card">
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
                    </cfoutput>
                </table>
            </div>
        </div>
    </div>
    
    <div class="col-md-8 mb-3">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">Onay Durumu</h5>
            </div>
            <div class="card-body">
                <div class="row text-center">
                    <div class="col-md-4 mb-3">
                        <div class="card bg-success text-white">
                            <div class="card-body">
                                <h3 class="card-title"><cfoutput>#request.approvalStats.approved#</cfoutput></h3>
                                <p class="card-text">Onaylanan</p>
                                <small><cfoutput>#request.approvalStats.approvedPercent#%</cfoutput></small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4 mb-3">
                        <div class="card bg-danger text-white">
                            <div class="card-body">
                                <h3 class="card-title"><cfoutput>#request.approvalStats.rejected#</cfoutput></h3>
                                <p class="card-text">Reddedilen</p>
                                <small><cfoutput>#request.approvalStats.rejectedPercent#%</cfoutput></small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4 mb-3">
                        <div class="card bg-warning">
                            <div class="card-body">
                                <h3 class="card-title"><cfoutput>#request.approvalStats.pending#</cfoutput></h3>
                                <p class="card-text">Bekleyen</p>
                                <small><cfoutput>#request.approvalStats.pendingPercent#%</cfoutput></small>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="progress mt-2">
                    <div class="progress-bar bg-success" role="progressbar" style="width: <cfoutput>#request.approvalStats.approvedPercent#%</cfoutput>" 
                         aria-valuenow="<cfoutput>#request.approvalStats.approvedPercent#</cfoutput>" aria-valuemin="0" aria-valuemax="100">
                        <cfoutput>#request.approvalStats.approvedPercent#%</cfoutput>
                    </div>
                    <div class="progress-bar bg-danger" role="progressbar" style="width: <cfoutput>#request.approvalStats.rejectedPercent#%</cfoutput>" 
                         aria-valuenow="<cfoutput>#request.approvalStats.rejectedPercent#</cfoutput>" aria-valuemin="0" aria-valuemax="100">
                        <cfoutput>#request.approvalStats.rejectedPercent#%</cfoutput>
                    </div>
                    <div class="progress-bar bg-warning" role="progressbar" style="width: <cfoutput>#request.approvalStats.pendingPercent#%</cfoutput>" 
                         aria-valuenow="<cfoutput>#request.approvalStats.pendingPercent#</cfoutput>" aria-valuemin="0" aria-valuemax="100">
                        <cfoutput>#request.approvalStats.pendingPercent#%</cfoutput>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="card mb-4">
    <div class="card-header">
        <h5 class="mb-0">Öğrenci Onay Linkleri</h5>
    </div>
    <div class="card-body">
        <cfif ArrayLen(request.approvalLinks) GT 0>
            <div class="alert alert-info mb-3">
                <i class="bi bi-info-circle"></i> Aşağıdaki linkleri velilere WhatsApp, SMS veya e-posta üzerinden iletebilirsiniz. Veliler bu linkler üzerinden gezi onaylarını verebilirler.
            </div>
            
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Öğrenci Adı Soyadı</th>
                            <th>Sınıf</th>
                            <th>Veli Adı</th>
                            <th>Veli İletişim</th>
                            <th>Onay Durumu</th>
                            <th>Onay Linki</th>
                            <th>İşlemler</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfloop array="#request.approvalLinks#" index="link">
                            <cfoutput>
                                <tr>
                                    <td>#link.studentName#</td>
                                    <td>#link.studentClass#</td>
                                    <td>#link.parentName#</td>
                                    <td>
                                        <small>Tel: #link.parentPhone#</small><br>
                                        <cfif len(link.parentEmail)>
                                            <small>E-posta: #link.parentEmail#</small>
                                        </cfif>
                                    </td>
                                    <td>
                                        <span class="badge 
                                            <cfif link.approvalStatus EQ 'APPROVED'>badge-approved
                                            <cfelseif link.approvalStatus EQ 'REJECTED'>badge-rejected
                                            <cfelse>badge-pending</cfif>">
                                            <cfif link.approvalStatus EQ 'APPROVED'>Onaylandı
                                            <cfelseif link.approvalStatus EQ 'REJECTED'>Reddedildi
                                            <cfelse>Bekliyor</cfif>
                                        </span>
                                        <cfif isDefined("link.approvalDate") AND isDate(link.approvalDate)>
                                            <br><small>#DateFormat(link.approvalDate, "dd.mm.yyyy")# #TimeFormat(link.approvalDate, "HH:mm")#</small>
                                        </cfif>
                                    </td>
                                    <td>
                                        <div class="input-group">
                                            <input type="text" class="form-control form-control-sm" value="#link.link#" readonly>
                                            <button class="btn btn-sm btn-outline-secondary copy-btn" type="button" onclick="copyToClipboard('#link.link#')">
                                                <i class="bi bi-clipboard"></i>
                                            </button>
                                        </div>
                                    </td>
                                    <cfinclude template="../../includes/header.cfm">

<div class="d-flex justify-content-between align-items-center mb-4">
    <h1><cfoutput>#request.trip.TRIP_NAME#</cfoutput> - Onay Linkleri</h1>
    <div>
        <a href="index.cfm?action=assignStudentsForm&TRIP_ID=<cfoutput>#request.trip.TRIP_ID#</cfoutput>" class="btn btn-success me-2">
            <i class="bi bi-people"></i> Öğrenci Atama
        </a>
        <a href="index.cfm?action=listTrips" class="btn btn-secondary">
            <i class="bi bi-arrow-left"></i> Gezilere Dön
        </a>
    </div>
</div>

<div class="row mb-4">
    <div class="col-md-4 mb-3">
        <div class="card">
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
                    </cfoutput>
                </table>
            </div>
        </div>
    </div>
    
    <div class="col-md-8 mb-3">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">Onay Durumu</h5>
            </div>
            <div class="card-body">
                <div class="row text-center">
                    <div class="col-md-4 mb-3">
                        <div class="card bg-success text-white">
                            <div class="card-body">
                                <h3 class="card-title"><cfoutput>#request.approvalStats.approved#</cfoutput></h3>
                                <p class="card-text">Onaylanan</p>
                                <small><cfoutput>#request.approvalStats.approvedPercent#%</cfoutput></small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4 mb-3">
                        <div class="card bg-danger text-white">
                            <div class="card-body">
                                <h3 class="card-title"><cfoutput>#request.approvalStats.rejected#</cfoutput></h3>
                                <p class="card-text">Reddedilen</p>
                                <small><cfoutput>#request.approvalStats.rejectedPercent#%</cfoutput></small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4 mb-3">
                        <div class="card bg-warning">
                            <div class="card-body">
                                <h3 class="card-title"><cfoutput>#request.approvalStats.pending#</cfoutput></h3>
                                <p class="card-text">Bekleyen</p>
                                <small><cfoutput>#request.approvalStats.pendingPercent#%</cfoutput></small>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="progress mt-2">
                    <div class="progress-bar bg-success" role="progressbar" style="width: <cfoutput>#request.approvalStats.approvedPercent#%</cfoutput>" 
                         aria-valuenow="<cfoutput>#request.approvalStats.approvedPercent#</cfoutput>" aria-valuemin="0" aria-valuemax="100">
                        <cfoutput>#request.approvalStats.approvedPercent#%</cfoutput>
                    </div>
                    <div class="progress-bar bg-danger" role="progressbar" style="width: <cfoutput>#request.approvalStats.rejectedPercent#%</cfoutput>" 
                         aria-valuenow="<cfoutput>#request.approvalStats.rejectedPercent#</cfoutput>" aria-valuemin="0" aria-valuemax="100">
                        <cfoutput>#request.approvalStats.rejectedPercent#%</cfoutput>
                    </div>
                    <div class="progress-bar bg-warning" role="progressbar" style="width: <cfoutput>#request.approvalStats.pendingPercent#%</cfoutput>" 
                         aria-valuenow="<cfoutput>#request.approvalStats.pendingPercent#</cfoutput>" aria-valuemin="0" aria-valuemax="100">
                        <cfoutput>#request.approvalStats.pendingPercent#%</cfoutput>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="card mb-4">
    <div class="card-header">
        <h5 class="mb-0">Öğrenci Onay Linkleri</h5>
    </div>
    <div class="card-body">
        <cfif ArrayLen(request.approvalLinks) GT 0>
            <div class="alert alert-info mb-3">
                <i class="bi bi-info-circle"></i> Aşağıdaki linkleri velilere WhatsApp, SMS veya e-posta üzerinden iletebilirsiniz. Veliler bu linkler üzerinden gezi onaylarını verebilirler.
            </div>
            
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Öğrenci Adı Soyadı</th>
                            <th>Sınıf</th>
                            <th>Veli Adı</th>
                            <th>Veli İletişim</th>
                            <th>Onay Durumu</th>
                            <th>Onay Linki</th>
                            <th>İşlemler</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfloop array="#request.approvalLinks#" index="link">
                            <cfoutput>
                                <tr>
                                    <td>#link.studentName#</td>
                                    <td>#link.studentClass#</td>
                                    <td>#link.parentName#</td>
                                    <td>
                                        <small>Tel: #link.parentPhone#</small><br>
                                        <cfif len(link.parentEmail)>
                                            <small>E-posta: #link.parentEmail#</small>
                                        </cfif>
                                    </td>
                                    <td>
                                        <span class="badge 
                                            <cfif link.approvalStatus EQ 'APPROVED'>badge-approved
                                            <cfelseif link.approvalStatus EQ 'REJECTED'>badge-rejected
                                            <cfelse>badge-pending</cfif>">
                                            <cfif link.approvalStatus EQ 'APPROVED'>Onaylandı
                                            <cfelseif link.approvalStatus EQ 'REJECTED'>Reddedildi
                                            <cfelse>Bekliyor</cfif>
                                        </span>
                                        <cfif isDefined("link.approvalDate") AND isDate(link.approvalDate)>
                                            <br><small>#DateFormat(link.approvalDate, "dd.mm.yyyy")# #TimeFormat(link.approvalDate, "HH:mm")#</small>
                                        </cfif>
                                    </td>
                                    <td>
                                        <div class="input-group">
                                            <input type="text" class="form-control form-control-sm" value="#link.link#" readonly>
                                            <button class="btn btn-sm btn-outline-secondary copy-btn" type="button" onclick="copyToClipboard('#link.link#')">
                                                <i class="bi bi-clipboard"></i>
                                            </button>
                                        </div>
                                    </td>
                                    <td>
                                        <a href="index.cfm?action=refreshApprovalLink&TRIP_ID=#request.trip.TRIP_ID#&STUDENT_ID=#link.studentID#" 
                                           class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-arrow-clockwise"></i> Linki Yenile
                                        </a>
                                    </td>
                                </tr>
                            </cfoutput>
                        </cfloop>
                    </tbody>
                </table>
            </div>
        <cfelse>
            <div class="alert alert-warning">
                Bu geziye henüz öğrenci atanmamış. <a href="index.cfm?action=assignStudentsForm&TRIP_ID=<cfoutput>#request.trip.TRIP_ID#</cfoutput>" class="alert-link">Öğrenci atamak için tıklayın</a>.
            </div>
        </cfif>
    </div>
</div>

<cfinclude template="../../includes/footer.cfm">