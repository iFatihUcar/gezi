<cfcomponent output="false">
    <!--- Constructor --->
    <cffunction name="init" access="public" returntype="any">
        <cfset variables.tripModel = CreateObject("component", "gezi_onay_sistemi.models.TRIP")>
        <cfset variables.studentModel = CreateObject("component", "gezi_onay_sistemi.models.STUDENT")>
        <cfset variables.tokenModel = CreateObject("component", "gezi_onay_sistemi.models.TOKEN")>
        <cfset variables.approvalModel = CreateObject("component", "gezi_onay_sistemi.models.APPROVAL")>
        <cfreturn this>
    </cffunction>
    
    <!--- Öğretmen Dashboard --->
    <cffunction name="dashboard" access="public" returntype="void">
        <cfset request.upcomingTrips = variables.tripModel.getAllTrips(status="ACTIVE")>
        <cfinclude template="../views/teacher/dashboard.cfm">
    </cffunction>
    
    <!--- Onay Linklerini Gösterme --->
    <cffunction name="showApprovalLinks" access="public" returntype="void">
        <cfargument name="TRIP_ID" type="numeric" required="true">
        
        <cfset var userID = session.userID> <!--- Kullanıcı kimliğini session'dan alıyoruz --->
        <cfset var baseURL = "https://yourdomain.com/approval/form.cfm"> <!--- Onay sayfasının URL'i --->
        
        <cfset request.trip = variables.tripModel.getTripById(TRIP_ID=arguments.TRIP_ID)>
        <cfset request.tripStudents = variables.studentModel.getStudentsByTrip(TRIP_ID=arguments.TRIP_ID)>
        <cfset request.approvalStats = variables.approvalModel.getTripApprovalStats(TRIP_ID=arguments.TRIP_ID)>
        
        <!--- Her öğrenci için onay linki oluştur --->
        <cfset request.approvalLinks = []>
        
        <cfloop query="request.tripStudents">
            <cfset var token = variables.tokenModel.createToken(
                TRIP_ID = arguments.TRIP_ID,
                STUDENT_ID = request.tripStudents.STUDENT_ID,
                CREATED_BY = userID
            )>
            
            <cfset var approvalLink = {
                studentID = request.tripStudents.STUDENT_ID,
                studentName = request.tripStudents.STUDENT_NAME & " " & request.tripStudents.STUDENT_SURNAME,
                studentClass = request.tripStudents.STUDENT_CLASS,
                parentName = request.tripStudents.PARENT_NAME,
                parentPhone = request.tripStudents.PARENT_PHONE,
                parentEmail = request.tripStudents.PARENT_EMAIL,
                approvalStatus = request.tripStudents.APPROVAL_STATUS,
                approvalDate = request.tripStudents.APPROVAL_DATE,
                token = token,
                link = "#baseURL#?token=#token#"
            }>
            
            <cfset ArrayAppend(request.approvalLinks, approvalLink)>
        </cfloop>
        
        <cfinclude template="../views/teacher/approval_links.cfm">
    </cffunction>
    
    <!--- Onay Linkini Yenileme --->
    <cffunction name="refreshApprovalLink" access="public" returntype="void">
        <cfargument name="TRIP_ID" type="numeric" required="true">
        <cfargument name="STUDENT_ID" type="numeric" required="true">
        
        <cfset var userID = session.userID> <!--- Kullanıcı kimliğini session'dan alıyoruz --->
        
        <!--- Eski token'ları geçersiz kıl ve yeni token oluştur --->
        <cfset variables.tokenModel.createToken(
            TRIP_ID = arguments.TRIP_ID,
            STUDENT_ID = arguments.STUDENT_ID,
            CREATED_BY = userID,
            FORCE_NEW = true
        )>
        
        <cflocation url="index.cfm?action=showApprovalLinks&TRIP_ID=#arguments.TRIP_ID#" addtoken="false">
    </cffunction>
</cfcomponent>