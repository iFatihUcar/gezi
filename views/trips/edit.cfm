<cfinclude template="../../includes/header.cfm">

<div class="row">
    <div class="col-md-8 offset-md-2">
        <div class="card">
            <div class="card-header">
                <h2>Gezi Düzenle</h2>
            </div>
            <div class="card-body">
                <cfif IsDefined("request.errors") AND ArrayLen(request.errors) GT 0>
                    <div class="alert alert-danger">
                        <ul class="mb-0">
                            <cfloop array="#request.errors#" index="error">
                                <li><cfoutput>#error#</cfoutput></li>
                            </cfloop>
                        </ul>
                    </div>
                </cfif>
                
                <form action="index.cfm?action=updateTrip" method="post" class="needs-validation" novalidate>
                    <cfoutput>
                        <input type="hidden" name="TRIP_ID" value="#request.trip.TRIP_ID#">
                        
                        <div class="mb-3">
                            <label for="TRIP_NAME" class="form-label">Gezi Adı *</label>
                            <input type="text" class="form-control" id="TRIP_NAME" name="TRIP_NAME" 
                                value="#IsDefined('request.formData.TRIP_NAME') ? request.formData.TRIP_NAME : request.trip.TRIP_NAME#" required>
                            <div class="invalid-feedback">Gezi adı gereklidir.</div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="TRIP_DESCRIPTION" class="form-label">Gezi Açıklaması</label>
                            <textarea class="form-control" id="TRIP_DESCRIPTION" name="TRIP_DESCRIPTION" rows="3">#IsDefined('request.formData.TRIP_DESCRIPTION') ? request.formData.TRIP_DESCRIPTION : request.trip.TRIP_DESCRIPTION#</textarea>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="TRIP_DATE" class="form-label">Gezi Tarihi *</label>
                                <input type="date" class="form-control" id="TRIP_DATE" name="TRIP_DATE" 
                                    value="#IsDefined('request.formData.TRIP_DATE') ? request.formData.TRIP_DATE : DateFormat(request.trip.TRIP_DATE, 'yyyy-mm-dd')#" required>
                                <div class="invalid-feedback">Gezi tarihi gereklidir.</div>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="TRIP_COST" class="form-label">Gezi Ücreti (TL)</label>
                                <input type="number" class="form-control" id="TRIP_COST" name="TRIP_COST" 
                                    value="#IsDefined('request.formData.TRIP_COST') ? request.formData.TRIP_COST : request.trip.TRIP_COST#" min="0" step="0.01">
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="TRIP_LOCATION" class="form-label">Gezi Konumu *</label>
                            <input type="text" class="form-control" id="TRIP_LOCATION" name="TRIP_LOCATION" 
                                value="#IsDefined('request.formData.TRIP_LOCATION') ? request.formData.TRIP_LOCATION : request.trip.TRIP_LOCATION#" required>
                            <div class="invalid-feedback">Gezi konumu gereklidir.</div>
                        </div>
                        
                        <div class="mb-4">
                            <label for="TRIP_STATUS" class="form-label">Gezi Durumu</label>
                            <select class="form-select" id="TRIP_STATUS" name="TRIP_STATUS">
                                <option value="ACTIVE" #IsDefined('request.formData.TRIP_STATUS') ? (request.formData.TRIP_STATUS EQ 'ACTIVE' ? 'selected' : '') : (request.trip.TRIP_STATUS EQ 'ACTIVE' ? 'selected' : '')#>Aktif</option>
                                <option value="COMPLETED" #IsDefined('request.formData.TRIP_STATUS') ? (request.formData.TRIP_STATUS EQ 'COMPLETED' ? 'selected' : '') : (request.trip.TRIP_STATUS EQ 'COMPLETED' ? 'selected' : '')#>Tamamlandı</option>
                                <option value="CANCELED" #IsDefined('request.formData.TRIP_STATUS') ? (request.formData.TRIP_STATUS EQ 'CANCELED' ? 'selected' : '') : (request.trip.TRIP_STATUS EQ 'CANCELED' ? 'selected' : '')#>İptal Edildi</option>
                            </select>
                        </div>
                    </cfoutput>
                    
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <a href="index.cfm?action=listTrips" class="btn btn-secondary me-md-2">İptal</a>
                        <button type="submit" class="btn btn-primary">Gezi Güncelle</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<cfinclude template="../../includes/footer.cfm">