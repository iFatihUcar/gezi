<cfinclude template="../../includes/header.cfm">

<div class="d-flex justify-content-between align-items-center mb-4">
    <h1>Öğrenciler</h1>
    <a href="index.cfm?action=newStudentForm" class="btn btn-primary">
        <i class="bi bi-plus-circle"></i> Yeni Öğrenci Ekle
    </a>
</div>

<div class="card mb-4">
    <div class="card-header">
        <ul class="nav nav-tabs card-header-tabs">
            <li class="nav-item">
                <a class="nav-link <cfif url.status EQ 'ACTIVE'>active</cfif>" href="index.cfm?action=listStudents&status=ACTIVE">Aktif Öğrenciler</a>
            </li>
            <li class="nav-item">
                <a class="nav-link <cfif url.status EQ 'ALL'>active</cfif>" href="index.cfm?action=listStudents&status=ALL">Tüm Öğrenciler</a>
            </li>
            <li class="nav-item">
                <a class="nav-link <cfif url.status EQ 'INACTIVE'>active</cfif>" href="index.cfm?action=listStudents&status=INACTIVE">Pasif Öğrenciler</a>
            </li>
        </ul>
    </div>
    <div class="card-body">
        <cfif request.students.RecordCount GT 0>
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Öğrenci Adı Soyadı</th>
                            <th>Sınıf</th>
                            <th>Veli Adı</th>
                            <th>Veli Telefonu</th>
                            <th>Veli E-posta</th>
                            <th>Durum</th>
                            <th>İşlemler</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="request.students">
                            <tr>
                                <td>#STUDENT_NAME# #STUDENT_SURNAME#</td>
                                <td>#STUDENT_CLASS#</td>
                                <td>#PARENT_NAME#</td>
                                <td>#PARENT_PHONE#</td>
                                <td>#PARENT_EMAIL#</td>
                                <td>
                                    <span class="badge 
                                        <cfif STUDENT_STATUS EQ 'ACTIVE'>bg-success
                                        <cfelseif STUDENT_STATUS EQ 'INACTIVE'>bg-secondary
                                        <cfelse>bg-secondary</cfif>">
                                        #STUDENT_STATUS#
                                    </span>
                                </td>
                                <td>
                                    <div class="btn-group">
                                        <a href="index.cfm?action=editStudentForm&STUDENT_ID=#STUDENT_ID#" class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-pencil"></i> Düzenle
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
                    Aktif öğrenci bulunamadı.
                <cfelseif url.status EQ 'INACTIVE'>
                    Pasif öğrenci bulunamadı.
                <cfelse>
                    Herhangi bir öğrenci bulunamadı.
                </cfif>
                <a href="index.cfm?action=newStudentForm" class="alert-link">Yeni öğrenci ekle</a>
            </div>
        </cfif>
    </div>
</div>

<cfinclude template="../../includes/footer.cfm">