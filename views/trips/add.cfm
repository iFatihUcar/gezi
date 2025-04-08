<cfinclude template="../../includes/header.cfm">

<div class="row">
    <div class="col-md-8 offset-md-2">
        <div class="card">
            <div class="card-header">
                <h2>Yeni Gezi Oluştur</h2>
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
                
                <form action="index.cfm?action=addTrip" method="post" class="needs-validation" novalidate>
                    <div class="mb-3">
                        <label for="TRIP_NAME" class="form-label">Gezi Adı *</label>
                        <input type="text" class="form-control" id="TRIP_NAME" name="TRIP_NAME" value="<cfif IsDefined('request.formData.TRIP_NAME')><cfoutput>#request.formData.TRIP_NAME#</cfoutput></cfif>" required>
                        <div class="invalid-feedback">Gezi adı gereklidir.</div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="TRIP_DESCRIPTION" class="form-label">Gezi Açıklaması</label>
                        <textarea class="form-control" id="TRIP_DESCRIPTION" name="TRIP_DESCRIPTION" rows="3"><cfif IsDefined('request.formData.TRIP_DESCRIPTION')><cfoutput>#request.formData.TRIP_DESCRIPTION#</cfoutput></cfif></textarea>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="TRIP_DATE" class="form-label">Gezi Tarihi *</label>
                            <input type="date" class="form-control" id="TRIP_DATE" name="TRIP_DATE" value="<cfif IsDefined('request.formData.TRIP_DATE')><cfoutput>#request.formData.TRIP_DATE#</cfoutput></cfif>" required>
                            <div class="invalid-feedback">Gezi tarihi gereklidir.</div>
                        </div>
                        
                        <div class="col-md-6">
                            <label for="TRIP_COST" class="form-label">Gezi Ücreti (TL)</label>
                            <input type="number" class="form-control" id="TRIP_COST" name="TRIP_COST" value="<cfif IsDefined('request.formData.TRIP_COST')><cfoutput>#request.formData.TRIP_COST#</cfoutput><cfelse>0</cfif>" min="0" step="0.01">
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label for="TRIP_LOCATION" class="form-label">Gezi Konumu *</label>
                        <input type="text" class="form-control" id="TRIP_LOCATION" name="TRIP_LOCATION" value="<cfif IsDefined('request.formData.TRIP_LOCATION')><cfoutput>#request.formData.TRIP_LOCATION#</cfoutput></cfif>" required>
                        <div class="invalid-feedback">Gezi konumu gereklidir.</div>
                    </div>
                    
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <a href="index.cfm?action=listTrips" class="btn btn-secondary me-md-2">İptal</a>
                        <button type="submit" class="btn btn-primary">Gezi Oluştur</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<cfinclude template="../../includes/footer.cfm">