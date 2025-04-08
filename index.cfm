<cfparam name="url.action" default="login">

<cfif NOT IsDefined("session.userID") AND url.action NEQ "login" AND url.action NEQ "doLogin">
    <cflocation url="index.cfm?action=login" addtoken="false">
</cfif>

<cfswitch expression="#url.action#">
    <!--- Authentication --->
    <cfcase value="login">
        <cfinclude template="views/login.cfm">
    </cfcase>


    
    <cfcase value="doLogin">
        <cfparam name="form.username" default="">
        <cfparam name="form.password" default="">    
        
        <cfquery name="qLogin" datasource="DEV_DB_MSSQL">
            SELECT 
                USER_ID, 
                USERNAME, 
                FULL_NAME, 
                USER_TYPE 
            FROM 
                USERS 
            WHERE 
                USERNAME = <cfqueryparam value="#form.username#" cfsqltype="CF_SQL_VARCHAR"> 
                AND PASSWORD = <cfqueryparam value="#form.password#" cfsqltype="CF_SQL_VARCHAR"> 
                AND USER_STATUS = 'ACTIVE'
        </cfquery>
        
        
        <cfif qLogin.RecordCount GT 0>
            <cfset session.userID = qLogin.USER_ID>
            <cfset session.username = qLogin.USERNAME>
            <cfset session.fullName = qLogin.FULL_NAME>
            <cfset session.userType = qLogin.USER_TYPE>
            
            <cfquery name="updateLastLogin" datasource="DEV_DB_MSSQL">
                UPDATE USERS
                SET LAST_LOGIN_DATE = <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_TIMESTAMP">
                WHERE USER_ID = <cfqueryparam value="#session.userID#" cfsqltype="CF_SQL_INTEGER">
            </cfquery>
            
            <cflocation url="index.cfm?action=dashboard" addtoken="false">
        <cfelse>
            <cflocation url="index.cfm?action=login&error=1" addtoken="false">
        </cfif>
    </cfcase>
    
    <cfcase value="logout">
        <cfset StructDelete(session, "userID")>
        <cfset StructDelete(session, "username")>
        <cfset StructDelete(session, "fullName")>
        <cfset StructDelete(session, "userType")>
        
        <cflocation url="index.cfm?action=login" addtoken="false">
    </cfcase>
    
    <!--- Teacher Dashboard --->
    <cfcase value="dashboard">
        <cfset teacherController = CreateObject("component", "controllers.teacher")>
        <cfset teacherController.dashboard()>
    </cfcase>
    
    <!--- Trips --->
    <cfcase value="listTrips">
        <cfparam name="url.status" default="ACTIVE">
        <cfset tripController = CreateObject("component", "controllers.trip")>
        <cfset tripController.listTrips(status=url.status)>
    </cfcase>
    
    <cfcase value="newTripForm">
        <cfset tripController = CreateObject("component", "controllers.trip")>
        <cfset tripController.newTripForm()>
    </cfcase>
    
    <cfcase value="addTrip">
        <cfset tripController = CreateObject("component", "controllers.trip")>
        <cfset tripController.addTrip(
            TRIP_NAME = form.TRIP_NAME,
            TRIP_DESCRIPTION = form.TRIP_DESCRIPTION,
            TRIP_DATE = form.TRIP_DATE,
            TRIP_LOCATION = form.TRIP_LOCATION,
            TRIP_COST = form.TRIP_COST
        )>
    </cfcase>
    
    <cfcase value="editTripForm">
        <cfparam name="url.TRIP_ID" default="0">
        <cfset tripController = CreateObject("component", "controllers.trip")>
        <cfset tripController.editTripForm(TRIP_ID=url.TRIP_ID)>
    </cfcase>
    
    <cfcase value="updateTrip">
        <cfset tripController = CreateObject("component", "controllers.trip")>
        <cfset tripController.updateTrip(
            TRIP_ID = form.TRIP_ID,
            TRIP_NAME = form.TRIP_NAME,
            TRIP_DESCRIPTION = form.TRIP_DESCRIPTION,
            TRIP_DATE = form.TRIP_DATE,
            TRIP_LOCATION = form.TRIP_LOCATION,
            TRIP_COST = form.TRIP_COST,
            TRIP_STATUS = form.TRIP_STATUS
        )>
    </cfcase>
    
    <cfcase value="deleteTrip">
        <cfparam name="url.TRIP_ID" default="0">
        <cfset tripController = CreateObject("component", "controllers.trip")>
        <cfset tripController.deleteTrip(TRIP_ID=url.TRIP_ID)>
    </cfcase>
    
    <!--- Students --->
    <cfcase value="listStudents">
        <cfparam name="url.status" default="ACTIVE">
        <cfset studentController = CreateObject("component", "controllers.student")>
        <cfset studentController.listStudents(status=url.status)>
    </cfcase>
    
    <cfcase value="newStudentForm">
        <cfset studentController = CreateObject("component", "controllers.student")>
        <cfset studentController.newStudentForm()>
    </cfcase>
    
    <cfcase value="addStudent">
        <cfset studentController = CreateObject("component", "controllers.student")>
        <cfset studentController.addStudent(
            STUDENT_NAME = form.STUDENT_NAME,
            STUDENT_SURNAME = form.STUDENT_SURNAME,
            STUDENT_CLASS = form.STUDENT_CLASS,
            PARENT_NAME = form.PARENT_NAME,
            PARENT_PHONE = form.PARENT_PHONE,
            PARENT_EMAIL = form.PARENT_EMAIL
        )>
    </cfcase>
    
    <cfcase value="assignStudentsForm">
        <cfparam name="url.TRIP_ID" default="0">
        <cfset studentController = CreateObject("component", "controllers.student")>
        <cfset studentController.assignStudentsForm(TRIP_ID=url.TRIP_ID)>
    </cfcase>
    
    <cfcase value="assignStudents">
        <cfset studentController = CreateObject("component", "controllers.student")>
        <cfset studentController.assignStudents(
            TRIP_ID = form.TRIP_ID,
            STUDENT_IDS = IsDefined("form.STUDENT_IDS") ? form.STUDENT_IDS : ""
        )>
    </cfcase>
    
    <cfcase value="removeStudentFromTrip">
        <cfparam name="url.TRIP_ID" default="0">
        <cfparam name="url.STUDENT_ID" default="0">
        <cfset studentController = CreateObject("component", "controllers.student")>
        <cfset studentController.removeStudentFromTrip(
            TRIP_ID = url.TRIP_ID,
            STUDENT_ID = url.STUDENT_ID
        )>
    </cfcase>
    
    <!--- Approval Links --->
    <cfcase value="showApprovalLinks">
        <cfparam name="url.TRIP_ID" default="0">
        <cfset teacherController = CreateObject("component", "controllers.teacher")>
        <cfset teacherController.showApprovalLinks(TRIP_ID=url.TRIP_ID)>
    </cfcase>
    
    <cfcase value="refreshApprovalLink">
        <cfparam name="url.TRIP_ID" default="0">
        <cfparam name="url.STUDENT_ID" default="0">
        <cfset teacherController = CreateObject("component", "controllers.teacher")>
        <cfset teacherController.refreshApprovalLink(
            TRIP_ID = url.TRIP_ID,
            STUDENT_ID = url.STUDENT_ID
        )>
    </cfcase>
    
    <cfdefaultcase>
        <cflocation url="index.cfm?action=dashboard" addtoken="false">
    </cfdefaultcase>
</cfswitch>