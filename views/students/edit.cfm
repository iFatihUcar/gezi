<cfinclude template="../../includes/header.cfm">

<div class="row">
    <div class="col-md-8 offset-md-2">
        <div class="card">
            <div class="card-header">
                <h2>Öğrenci Bilgilerini Düzenle</h2>
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

                <form action="index.cfm?action=updateStudent" method="post" class="needs-validation" novalidate>
                    <input type="hidden" name="STUDENT_ID" value="<cfoutput>#request.student.STUDENT_ID#</cfoutput>">

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="STUDENT_NAME" class="form-label">Öğrenci Adı *</label>
                            <input type="text" class="form-control" id="STUDENT_NAME" name="STUDENT_NAME" value="<cfoutput>#request.student.STUDENT_NAME#</cfoutput>" required>
                            <div class="invalid-feedback">Öğrenci adı gereklidir.</div>
                        </div>

                        <div class="col-md-6">
                            <label for="STUDENT_SURNAME" class="form-label">Öğrenci Soyadı *</label>
                            <input type="text" class="form-control" id="STUDENT_SURNAME" name="STUDENT_SURNAME" value="<cfoutput>#request.student.STUDENT_SURNAME#</cfoutput>" required>
                            <div class="invalid-feedback">Öğrenci soyadı gereklidir.</div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="STUDENT_CLASS" class="form-label">Sınıf *</label>
                        <input type="text" class="form-control" id="STUDENT_CLASS" name="STUDENT_CLASS" value="<cfoutput>#request.student.STUDENT_CLASS#</cfoutput>" required>
                        <div class="invalid-feedback">Sınıf gereklidir.</div>
                    </div>

                    <div class="mb-3">
                        <label for="PARENT_NAME" class="form-label">Veli Adı *</label>
                        <input type="text" class="form-control" id="PARENT_NAME" name="PARENT_NAME" value="<cfoutput>#request.student.PARENT_NAME#</cfoutput>" required>
                        <div class="invalid-feedback">Veli adı gereklidir.</div>
                    </div>

                    <div class="mb-3">
                        <label for="PARENT_PHONE" class="form-label">Veli Telefonu *</label>
                        <input type="tel" class="form-control" id="PARENT_PHONE" name="PARENT_PHONE" value="<cfoutput>#request.student.PARENT_PHONE#</cfoutput>" required>
                        <div class="invalid-feedback">Veli telefonu gereklidir.</div>
                    </div>

                    <div class="mb-4">
                        <label for="PARENT_EMAIL" class="form-label">Veli E-posta</label>
                        <input type="email" class="form-control" id="PARENT_EMAIL" name="PARENT_EMAIL" value="<cfoutput>#request.student.PARENT_EMAIL#</cfoutput>">
                    </div>

                    <div class="mb-4">
                        <label for="STUDENT_STATUS" class="form-label">Durum</label>
                        <select class="form-select" id="STUDENT_STATUS" name="STUDENT_STATUS">
                            <option value="ACTIVE" <cfif request.student.STUDENT_STATUS EQ "ACTIVE">selected</cfif>>Aktif</option>
                            <option value="INACTIVE" <cfif request.student.STUDENT_STATUS EQ "INACTIVE">selected</cfif>>Pasif</option>
                        </select>
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <a href="index.cfm?action=listStudents" class="btn btn-secondary me-md-2">İptal</a>
                        <button type="submit" class="btn btn-primary">Güncelle</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<cfinclude template="../../includes/footer.cfm">