<cfcomponent output="false">
    <!--- Constructor --->
    <cffunction name="init" access="public" returntype="any">
        <cfset variables.studentModel = CreateObject("component", "gezi_onay_sistemi.models.STUDENT")>
        <cfreturn this>
    </cffunction>
    
    <!--- Tüm öğrencileri listeleme --->
    <cffunction name="listStudents" access="public" returntype="void">
        <cfargument name="status" type="string" required="false" default="ACTIVE">
        
        <cfset request.students = variables.studentModel.getAllStudents(status=arguments.status)>
        <cfinclude template="../views/students/list.cfm">
    </cffunction>
    
    <!--- Öğrenci ekleme formu --->
    <cffunction name="newStudentForm" access="public" returntype="void">
        <cfinclude template="../views/students/add.cfm">
    </cffunction>
    
    <!--- Öğrenci ekleme --->
    <cffunction name="addStudent" access="public" returntype="void">
        <cfargument name="STUDENT_NAME" type="string" required="true">
        <cfargument name="STUDENT_SURNAME" type="string" required="true">
        <cfargument name="STUDENT_CLASS" type="string" required="true">
        <cfargument name="PARENT_NAME" type="string" required="true">
        <cfargument name="PARENT_PHONE" type="string" required="true">
        <cfargument name="PARENT_EMAIL" type="string" required="false" default="">
        
        <cfset var userID = session.userID> <!--- Kullanıcı kimliğini session'dan alıyoruz --->
        
        <!--- Form doğrulama --->
        <cfset var errors = []>
        
        <cfif Trim(arguments.STUDENT_NAME) EQ "">
            <cfset ArrayAppend(errors, "Öğrenci adı boş olamaz.")>
        </cfif>
        
        <cfif Trim(arguments.STUDENT_SURNAME) EQ "">
            <cfset ArrayAppend(errors, "Öğrenci soyadı boş olamaz.")>
        </cfif>
        
        <cfif Trim(arguments.STUDENT_CLASS) EQ "">
            <cfset ArrayAppend(errors, "Öğrenci sınıfı boş olamaz.")>
        </cfif>
        
        <cfif Trim(arguments.PARENT_NAME) EQ "">
            <cfset ArrayAppend(errors, "Veli adı boş olamaz.")>
        </cfif>
        
        <cfif Trim(arguments.PARENT_PHONE) EQ "">
            <cfset ArrayAppend(errors, "Veli telefonu boş olamaz.")>
        </cfif>
        
        <cfif ArrayLen(errors) GT 0>
            <cfset request.errors = errors>
            <cfset request.formData = arguments>
            <cfinclude template="../views/students/add.cfm">
            <cfreturn>
        </cfif>
        
        <!--- Öğrenci ekleme --->
        <cfset var studentID = variables.studentModel.createStudent(
            STUDENT_NAME = arguments.STUDENT_NAME,
            STUDENT_SURNAME = arguments.STUDENT_SURNAME,
            STUDENT_CLASS = arguments.STUDENT_CLASS,
            PARENT_NAME = arguments.PARENT_NAME,
            PARENT_PHONE = arguments.PARENT_PHONE,
            PARENT_EMAIL = arguments.PARENT_EMAIL,
            CREATED_BY = userID
        )>
        
        <cfif studentID GT 0>
            <cflocation url="index.cfm?action=listStudents" addtoken="false">
        <cfelse>
            <cfset request.errors = ["Öğrenci eklenirken bir hata oluştu. Lütfen tekrar deneyiniz."]>
            <cfset request.formData = arguments>
            <cfinclude template="../views/students/add.cfm">
        </cfif>
    </cffunction>
    
    <!--- Öğrencileri geziye atama formu --->
    <cffunction name="assignStudentsForm" access="public" returntype="void">
        <cfargument name="TRIP_ID" type="numeric" required="true">
        
        <cfset var tripModel = CreateObject("component", "gezi_onay_sistemi.models.TRIP")>
        
        <cfset request.trip = tripModel.getTripById(TRIP_ID=arguments.TRIP_ID)>
        <cfset request.assignedStudents = variables.studentModel.getStudentsByTrip(TRIP_ID=arguments.TRIP_ID)>
        <cfset request.allStudents = variables.studentModel.getAllStudents(status="ACTIVE")>
        
        <cfinclude template="../views/students/assign.cfm">
    </cffunction>
    
    <!--- Öğrencileri geziye atama --->
    <cffunction name="assignStudents" access="public" returntype="void">
        <cfargument name="TRIP_ID" type="numeric" required="true">
        <cfargument name="STUDENT_IDS" type="string" required="false" default="">
        
        <cfset var userID = session.userID> <!--- Kullanıcı kimliğini session'dan alıyoruz --->
        
        <!--- Öğrenci ID'lerini diziye dönüştürme --->
        <cfset var studentIDList = ListToArray(arguments.STUDENT_IDS)>
        
        <!--- Her bir öğrenciyi geziye ekleme --->
        <cfloop array="#studentIDList#" index="studentID">
            <cfset variables.studentModel.assignStudentToTrip(
                STUDENT_ID = studentID,
                TRIP_ID = arguments.TRIP_ID,
                CREATED_BY = userID
            )>
        </cfloop>
        
        <cflocation url="index.cfm?action=assignStudentsForm&TRIP_ID=#arguments.TRIP_ID#" addtoken="false">
    </cffunction>
    
    <!--- Öğrenciyi geziden çıkarma --->
    <cffunction name="removeStudentFromTrip" access="public" returntype="void">
        <cfargument name="TRIP_ID" type="numeric" required="true">
        <cfargument name="STUDENT_ID" type="numeric" required="true">
        
        <cfset variables.studentModel.removeStudentFromTrip(
            STUDENT_ID = arguments.STUDENT_ID,
            TRIP_ID = arguments.TRIP_ID
        )>
        
        <cflocation url="index.cfm?action=assignStudentsForm&TRIP_ID=#arguments.TRIP_ID#" addtoken="false">
    </cffunction>
</cfcomponent>