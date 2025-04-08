<cfcomponent output="false">
    <!--- Öğrenci oluşturma --->
    <cffunction name="createStudent" access="public" returntype="numeric">
        <cfargument name="STUDENT_NAME" type="string" required="true">
        <cfargument name="STUDENT_SURNAME" type="string" required="true">
        <cfargument name="STUDENT_CLASS" type="string" required="true">
        <cfargument name="PARENT_NAME" type="string" required="true">
        <cfargument name="PARENT_PHONE" type="string" required="true">
        <cfargument name="PARENT_EMAIL" type="string" required="false" default="">
        <cfargument name="STUDENT_STATUS" type="string" required="false" default="ACTIVE">
        <cfargument name="CREATED_BY" type="numeric" required="true">
        
        <cfset var studentID = 0>
        
        
        
        <cftransaction>
            <cfquery name="insertStudent" datasource="#variables.dbName#" username="#variables.dbUser#" password="#variables.dbPassword#" result="studentResult">
                INSERT INTO STUDENTS (
                    STUDENT_NAME,
                    STUDENT_SURNAME,
                    STUDENT_CLASS,
                    PARENT_NAME,
                    PARENT_PHONE,
                    PARENT_EMAIL,
                    STUDENT_STATUS,
                    CREATED_BY,
                    CREATED_DATE
                ) VALUES (
                    <cfqueryparam value="#arguments.STUDENT_NAME#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#arguments.STUDENT_SURNAME#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#arguments.STUDENT_CLASS#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#arguments.PARENT_NAME#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#arguments.PARENT_PHONE#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#arguments.PARENT_EMAIL#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#arguments.STUDENT_STATUS#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#arguments.CREATED_BY#" cfsqltype="CF_SQL_INTEGER">,
                    <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_TIMESTAMP">
                )
            </cfquery>
            
            <cfset studentID = studentResult.IDENTITYCOL>
        </cftransaction>
        
        <cfreturn studentID>
    </cffunction>
    
    <!--- Tüm öğrencileri getirme --->
    <cffunction name="getAllStudents" access="public" returntype="query">
        <cfargument name="status" type="string" required="false" default="ACTIVE">
        
        
        
        <cfquery name="qStudents" datasource="DEV_DB_MSSQL">
            SELECT 
                STUDENT_ID,
                STUDENT_NAME,
                STUDENT_SURNAME,
                STUDENT_CLASS,
                PARENT_NAME,
                PARENT_PHONE,
                PARENT_EMAIL,
                STUDENT_STATUS,
                CREATED_BY,
                CREATED_DATE
            FROM 
                STUDENTS
            WHERE 
                <cfif arguments.status NEQ "ALL">
                    STUDENT_STATUS = <cfqueryparam value="#arguments.status#" cfsqltype="CF_SQL_VARCHAR">
                </cfif>
            ORDER BY 
                STUDENT_CLASS, STUDENT_SURNAME, STUDENT_NAME
        </cfquery>
        
        <cfreturn qStudents>
    </cffunction>
    
    <!--- Belirli bir öğrenciyi getirme --->
    <cffunction name="getStudentById" access="public" returntype="query">
        <cfargument name="STUDENT_ID" type="numeric" required="true">
        
        
        
        <cfquery name="qStudent" datasource="DEV_DB_MSSQL">
            SELECT 
                STUDENT_ID,
                STUDENT_NAME,
                STUDENT_SURNAME,
                STUDENT_CLASS,
                PARENT_NAME,
                PARENT_PHONE,
                PARENT_EMAIL,
                STUDENT_STATUS,
                CREATED_BY,
                CREATED_DATE
            FROM 
                STUDENTS
            WHERE 
                STUDENT_ID = <cfqueryparam value="#arguments.STUDENT_ID#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        
        <cfreturn qStudent>
    </cffunction>
    
    <!--- Öğrenciyi geziye ekleme --->
    <cffunction name="assignStudentToTrip" access="public" returntype="boolean">
        <cfargument name="STUDENT_ID" type="numeric" required="true">
        <cfargument name="TRIP_ID" type="numeric" required="true">
        <cfargument name="CREATED_BY" type="numeric" required="true">
        
        
        
        <cftry>
            <!--- Önce bu öğrencinin bu geziye daha önce eklenip eklenmediğini kontrol edelim --->
            <cfquery name="checkAssignment" datasource="DEV_DB_MSSQL">
                SELECT COUNT(*) AS ASSIGNMENT_COUNT
                FROM TRIP_STUDENTS
                WHERE 
                    STUDENT_ID = <cfqueryparam value="#arguments.STUDENT_ID#" cfsqltype="CF_SQL_INTEGER">
                    AND TRIP_ID = <cfqueryparam value="#arguments.TRIP_ID#" cfsqltype="CF_SQL_INTEGER">
            </cfquery>
            
            <cfif checkAssignment.ASSIGNMENT_COUNT EQ 0>
                <cfquery name="insertAssignment" datasource="DEV_DB_MSSQL">
                    INSERT INTO TRIP_STUDENTS (
                        STUDENT_ID,
                        TRIP_ID,
                        CREATED_BY,
                        CREATED_DATE
                    ) VALUES (
                        <cfqueryparam value="#arguments.STUDENT_ID#" cfsqltype="CF_SQL_INTEGER">,
                        <cfqueryparam value="#arguments.TRIP_ID#" cfsqltype="CF_SQL_INTEGER">,
                        <cfqueryparam value="#arguments.CREATED_BY#" cfsqltype="CF_SQL_INTEGER">,
                        <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_TIMESTAMP">
                    )
                </cfquery>
            </cfif>
            
            <cfreturn true>
            
            <cfcatch type="any">
                <cfreturn false>
            </cfcatch>
        </cftry>
    </cffunction>
    
    <!--- Geziye katılacak öğrencileri getirme --->
    <cffunction name="getStudentsByTrip" access="public" returntype="query">
        <cfargument name="TRIP_ID" type="numeric" required="true">
        
        
        
        <cfquery name="qTripStudents" datasource="DEV_DB_MSSQL">
            SELECT 
                S.STUDENT_ID,
                S.STUDENT_NAME,
                S.STUDENT_SURNAME,
                S.STUDENT_CLASS,
                S.PARENT_NAME,
                S.PARENT_PHONE,
                S.PARENT_EMAIL,
                TS.CREATED_DATE AS ASSIGNMENT_DATE,
                TA.APPROVAL_ID,
                TA.APPROVAL_STATUS,
                TA.APPROVAL_DATE
            FROM 
                STUDENTS S
            INNER JOIN 
                TRIP_STUDENTS TS ON S.STUDENT_ID = TS.STUDENT_ID
            LEFT JOIN 
                TRIP_APPROVALS TA ON TS.STUDENT_ID = TA.STUDENT_ID AND TS.TRIP_ID = TA.TRIP_ID
            WHERE 
                TS.TRIP_ID = <cfqueryparam value="#arguments.TRIP_ID#" cfsqltype="CF_SQL_INTEGER">
                AND S.STUDENT_STATUS = 'ACTIVE'
            ORDER BY 
                S.STUDENT_CLASS, S.STUDENT_SURNAME, S.STUDENT_NAME
        </cfquery>
        
        <cfreturn qTripStudents>
    </cffunction>
    
    <!--- Öğrenciyi geziden çıkarma --->
    <cffunction name="removeStudentFromTrip" access="public" returntype="boolean">
        <cfargument name="STUDENT_ID" type="numeric" required="true">
        <cfargument name="TRIP_ID" type="numeric" required="true">
        
        
        
        <cftry>
            <cfquery name="deleteAssignment" datasource="DEV_DB_MSSQL">
                DELETE FROM TRIP_STUDENTS
                WHERE 
                    STUDENT_ID = <cfqueryparam value="#arguments.STUDENT_ID#" cfsqltype="CF_SQL_INTEGER">
                    AND TRIP_ID = <cfqueryparam value="#arguments.TRIP_ID#" cfsqltype="CF_SQL_INTEGER">
            </cfquery>
            
            <cfreturn true>
            
            <cfcatch type="any">
                <cfreturn false>
            </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>