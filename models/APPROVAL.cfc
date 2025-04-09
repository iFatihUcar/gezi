<cfcomponent output="false">
    <!--- Onay durumunu kaydetme --->
    <cffunction name="saveApproval" access="public" returntype="boolean">
        <cfargument name="TRIP_ID" type="numeric" required="true">
        <cfargument name="STUDENT_ID" type="numeric" required="true">
        <cfargument name="APPROVAL_STATUS" type="string" required="true">
        <cfargument name="APPROVAL_NOTES" type="string" required="false" default="">
        <cfargument name="APPROVAL_IP" type="string" required="false" default="">
        
        
        
        <cftry>
            <!--- Önce bu öğrenci için bu geziye dair bir onay kaydı var mı kontrol edelim --->
            <cfquery name="checkApproval" datasource="DEV_DB_MSSQL">
                SELECT APPROVAL_ID
                FROM TRIP_APPROVALS
                WHERE 
                    STUDENT_ID = <cfqueryparam value="#arguments.STUDENT_ID#" cfsqltype="CF_SQL_INTEGER">
                    AND TRIP_ID = <cfqueryparam value="#arguments.TRIP_ID#" cfsqltype="CF_SQL_INTEGER">
            </cfquery>
            
            <cfif checkApproval.RecordCount GT 0>
                <!--- Mevcut onayı güncelle --->
                <cfquery name="updateApproval" datasource="DEV_DB_MSSQL">
                    UPDATE TRIP_APPROVALS
                    SET
                        APPROVAL_STATUS = <cfqueryparam value="#arguments.APPROVAL_STATUS#" cfsqltype="CF_SQL_VARCHAR">,
                        APPROVAL_NOTES = <cfqueryparam value="#arguments.APPROVAL_NOTES#" cfsqltype="CF_SQL_VARCHAR">,
                        APPROVAL_DATE = <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_TIMESTAMP">,
                        APPROVAL_IP = <cfqueryparam value="#arguments.APPROVAL_IP#" cfsqltype="CF_SQL_VARCHAR">
                    WHERE
                        APPROVAL_ID = <cfqueryparam value="#checkApproval.APPROVAL_ID#" cfsqltype="CF_SQL_INTEGER">
                </cfquery>
            <cfelse>
                <!--- Yeni onay kaydı oluştur --->
                <cfquery name="insertApproval" datasource="DEV_DB_MSSQL">
                    INSERT INTO TRIP_APPROVALS (
                        TRIP_ID,
                        STUDENT_ID,
                        APPROVAL_STATUS,
                        APPROVAL_NOTES,
                        APPROVAL_DATE,
                        APPROVAL_IP
                    ) VALUES (
                        <cfqueryparam value="#arguments.TRIP_ID#" cfsqltype="CF_SQL_INTEGER">,
                        <cfqueryparam value="#arguments.STUDENT_ID#" cfsqltype="CF_SQL_INTEGER">,
                        <cfqueryparam value="#arguments.APPROVAL_STATUS#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value="#arguments.APPROVAL_NOTES#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_TIMESTAMP">,
                        <cfqueryparam value="#arguments.APPROVAL_IP#" cfsqltype="CF_SQL_VARCHAR">
                    )
                </cfquery>
            </cfif>
            
            <cfreturn true>
            
            <cfcatch type="any">
                <cfreturn false>
            </cfcatch>
        </cftry>
    </cffunction>

    <!--- Token ile onay bilgisini getirme --->
    <cffunction name="getApprovalByToken" access="public" returntype="query">
        <cfargument name="token" type="string" required="true">

        <cfquery name="qApproval" datasource="DEV_DB_MSSQL">
            SELECT 
                T.TRIP_ID,
                T.TRIP_NAME,
                T.TRIP_DATE,
                T.TRIP_LOCATION,
                T.TRIP_COST,
                S.STUDENT_ID,
                S.STUDENT_NAME,
                S.STUDENT_SURNAME,
                S.STUDENT_CLASS,
                S.PARENT_NAME,
                S.PARENT_PHONE,
                S.PARENT_EMAIL,
                TA.APPROVAL_ID,
                TA.APPROVAL_STATUS,
                TA.APPROVAL_DATE,
                TK.TOKEN,
                TK.EXPIRE_DATE
            FROM 
                APPROVAL_TOKENS TK
            INNER JOIN 
                TRIPS T ON TK.TRIP_ID = T.TRIP_ID
            INNER JOIN 
                STUDENTS S ON TK.STUDENT_ID = S.STUDENT_ID
            LEFT JOIN 
                TRIP_APPROVALS TA ON TK.TRIP_ID = TA.TRIP_ID AND TK.STUDENT_ID = TA.STUDENT_ID
            WHERE 
                TK.TOKEN = <cfqueryparam value="#arguments.token#" cfsqltype="CF_SQL_VARCHAR">
                AND TK.EXPIRE_DATE >= <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_TIMESTAMP">
                AND T.TRIP_STATUS = 'ACTIVE'
                AND S.STUDENT_STATUS = 'ACTIVE'
        </cfquery>

        <cfreturn qApproval>
    </cffunction>

    
    <!--- Belirli bir geziyi getirme (Onay linki için) --->
    <cffunction name="getTripInfoByToken" access="public" returntype="query">
        <cfargument name="TOKEN" type="string" required="true">
        
        
        
        <cfquery name="qTripInfo" datasource="DEV_DB_MSSQL">
            SELECT 
                T.TRIP_ID,
                T.TRIP_NAME,
                T.TRIP_DESCRIPTION,
                T.TRIP_DATE,
                T.TRIP_LOCATION,
                T.TRIP_COST,
                S.STUDENT_ID,
                S.STUDENT_NAME,
                S.STUDENT_SURNAME,
                S.STUDENT_CLASS,
                S.PARENT_NAME,
                S.PARENT_PHONE,
                S.PARENT_EMAIL,
                TA.APPROVAL_ID,
                TA.APPROVAL_STATUS,
                TA.APPROVAL_NOTES,
                TA.APPROVAL_DATE,
                TK.TOKEN,
                TK.EXPIRE_DATE
            FROM 
                APPROVAL_TOKENS TK
            INNER JOIN 
                TRIPS T ON TK.TRIP_ID = T.TRIP_ID
            INNER JOIN 
                STUDENTS S ON TK.STUDENT_ID = S.STUDENT_ID
            LEFT JOIN 
                TRIP_APPROVALS TA ON TK.TRIP_ID = TA.TRIP_ID AND TK.STUDENT_ID = TA.STUDENT_ID
            WHERE 
                TK.TOKEN = <cfqueryparam value="#arguments.TOKEN#" cfsqltype="CF_SQL_VARCHAR">
                AND TK.EXPIRE_DATE > <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_TIMESTAMP">
                AND T.TRIP_STATUS = 'ACTIVE'
                AND S.STUDENT_STATUS = 'ACTIVE'
        </cfquery>
        
        <cfreturn qTripInfo>
    </cffunction>
    
    <!--- Gezi onay istatistiklerini getirme --->
    <cffunction name="getTripApprovalStats" access="public" returntype="struct">
        <cfargument name="TRIP_ID" type="numeric" required="true">
        
        
        
        <cfquery name="qApprovalStats" datasource="DEV_DB_MSSQL">
            SELECT 
                COUNT(TS.STUDENT_ID) AS TOTAL_STUDENTS,
                COUNT(TA.APPROVAL_ID) AS TOTAL_RESPONSES,
                SUM(CASE WHEN TA.APPROVAL_STATUS = 'APPROVED' THEN 1 ELSE 0 END) AS APPROVED,
                SUM(CASE WHEN TA.APPROVAL_STATUS = 'REJECTED' THEN 1 ELSE 0 END) AS REJECTED,
                SUM(CASE WHEN TA.APPROVAL_ID IS NULL THEN 1 ELSE 0 END) AS PENDING
            FROM 
                TRIP_STUDENTS TS
            LEFT JOIN 
                TRIP_APPROVALS TA ON TS.TRIP_ID = TA.TRIP_ID AND TS.STUDENT_ID = TA.STUDENT_ID
            WHERE 
                TS.TRIP_ID = <cfqueryparam value="#arguments.TRIP_ID#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        
        <cfset approvalStats = {
            totalStudents = qApprovalStats.TOTAL_STUDENTS,
            totalResponses = qApprovalStats.TOTAL_RESPONSES,
            approved = qApprovalStats.APPROVED,
            rejected = qApprovalStats.REJECTED,
            pending = qApprovalStats.PENDING,
            approvedPercent = (qApprovalStats.TOTAL_STUDENTS GT 0) ? NumberFormat((qApprovalStats.APPROVED / qApprovalStats.TOTAL_STUDENTS) * 100, "99.0") : 0,
            rejectedPercent = (qApprovalStats.TOTAL_STUDENTS GT 0) ? NumberFormat((qApprovalStats.REJECTED / qApprovalStats.TOTAL_STUDENTS) * 100, "99.0") : 0,
            pendingPercent = (qApprovalStats.TOTAL_STUDENTS GT 0) ? NumberFormat((qApprovalStats.PENDING / qApprovalStats.TOTAL_STUDENTS) * 100, "99.0") : 0
        }>
        
        <cfreturn approvalStats>
    </cffunction>


</cfcomponent>