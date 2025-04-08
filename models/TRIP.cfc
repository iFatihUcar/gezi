<cfcomponent output="false">
    <!--- Gezi oluşturma --->
    <cffunction name="createTrip" access="public" returntype="numeric">
        <cfargument name="TRIP_NAME" type="string" required="true">
        <cfargument name="TRIP_DESCRIPTION" type="string" required="true">
        <cfargument name="TRIP_DATE" type="date" required="true">
        <cfargument name="TRIP_LOCATION" type="string" required="true">
        <cfargument name="TRIP_COST" type="numeric" required="false" default="0">
        <cfargument name="TRIP_STATUS" type="string" required="false" default="ACTIVE">
        <cfargument name="CREATED_BY" type="numeric" required="true">
        
        <cfset var tripID = 0>
        
        
        
        <cftransaction>
            <cfquery name="insertTrip" datasource="#variables.dbName#" username="#variables.dbUser#" password="#variables.dbPassword#" result="tripResult">
                INSERT INTO TRIPS (
                    TRIP_NAME,
                    TRIP_DESCRIPTION,
                    TRIP_DATE,
                    TRIP_LOCATION,
                    TRIP_COST,
                    TRIP_STATUS,
                    CREATED_BY,
                    CREATED_DATE
                ) VALUES (
                    <cfqueryparam value="#arguments.TRIP_NAME#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#arguments.TRIP_DESCRIPTION#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#arguments.TRIP_DATE#" cfsqltype="CF_SQL_DATE">,
                    <cfqueryparam value="#arguments.TRIP_LOCATION#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#arguments.TRIP_COST#" cfsqltype="CF_SQL_NUMERIC">,
                    <cfqueryparam value="#arguments.TRIP_STATUS#" cfsqltype="CF_SQL_VARCHAR">,
                    <cfqueryparam value="#arguments.CREATED_BY#" cfsqltype="CF_SQL_INTEGER">,
                    <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_TIMESTAMP">
                )
            </cfquery>
            
            <cfset tripID = tripResult.IDENTITYCOL>
        </cftransaction>
        
        <cfreturn tripID>
    </cffunction>
    
    <!--- Tüm gezileri getirme --->
    <cffunction name="getAllTrips" access="public" returntype="query">
        <cfargument name="status" type="string" required="false" default="ACTIVE">
        
        
        
        <cfquery name="qTrips" datasource="DEV_DB_MSSQL">
            SELECT 
                T.TRIP_ID,
                T.TRIP_NAME,
                T.TRIP_DESCRIPTION,
                T.TRIP_DATE,
                T.TRIP_LOCATION,
                T.TRIP_COST,
                T.TRIP_STATUS,
                T.CREATED_BY,
                T.CREATED_DATE,
                COUNT(TS.STUDENT_ID) AS STUDENT_COUNT
            FROM 
                TRIPS T
            LEFT JOIN 
                TRIP_STUDENTS TS ON T.TRIP_ID = TS.TRIP_ID
            WHERE 
                <cfif arguments.status NEQ "ALL">
                    T.TRIP_STATUS = <cfqueryparam value="#arguments.status#" cfsqltype="CF_SQL_VARCHAR">
                </cfif>
            GROUP BY 
                T.TRIP_ID, T.TRIP_NAME, T.TRIP_DESCRIPTION, T.TRIP_DATE, 
                T.TRIP_LOCATION, T.TRIP_COST, T.TRIP_STATUS, T.CREATED_BY, T.CREATED_DATE
            ORDER BY 
                T.TRIP_DATE DESC
        </cfquery>
        
        <cfreturn qTrips>
    </cffunction>
    
    <!--- Belirli bir geziyi getirme --->
    <cffunction name="getTripById" access="public" returntype="query">
        <cfargument name="TRIP_ID" type="numeric" required="true">
        
        
        
        <cfquery name="qTrip" datasource="DEV_DB_MSSQL">
            SELECT 
                TRIP_ID,
                TRIP_NAME,
                TRIP_DESCRIPTION,
                TRIP_DATE,
                TRIP_LOCATION,
                TRIP_COST,
                TRIP_STATUS,
                CREATED_BY,
                CREATED_DATE
            FROM 
                TRIPS
            WHERE 
                TRIP_ID = <cfqueryparam value="#arguments.TRIP_ID#" cfsqltype="CF_SQL_INTEGER">
        </cfquery>
        
        <cfreturn qTrip>
    </cffunction>
    
    <!--- Gezi güncelleme --->
    <cffunction name="updateTrip" access="public" returntype="boolean">
        <cfargument name="TRIP_ID" type="numeric" required="true">
        <cfargument name="TRIP_NAME" type="string" required="true">
        <cfargument name="TRIP_DESCRIPTION" type="string" required="true">
        <cfargument name="TRIP_DATE" type="date" required="true">
        <cfargument name="TRIP_LOCATION" type="string" required="true">
        <cfargument name="TRIP_COST" type="numeric" required="false" default="0">
        <cfargument name="TRIP_STATUS" type="string" required="false" default="ACTIVE">
        <cfargument name="UPDATED_BY" type="numeric" required="true">
        
        
        
        <cftry>
            <cfquery name="updateTrip" datasource="DEV_DB_MSSQL">
                UPDATE TRIPS
                SET
                    TRIP_NAME = <cfqueryparam value="#arguments.TRIP_NAME#" cfsqltype="CF_SQL_VARCHAR">,
                    TRIP_DESCRIPTION = <cfqueryparam value="#arguments.TRIP_DESCRIPTION#" cfsqltype="CF_SQL_VARCHAR">,
                    TRIP_DATE = <cfqueryparam value="#arguments.TRIP_DATE#" cfsqltype="CF_SQL_DATE">,
                    TRIP_LOCATION = <cfqueryparam value="#arguments.TRIP_LOCATION#" cfsqltype="CF_SQL_VARCHAR">,
                    TRIP_COST = <cfqueryparam value="#arguments.TRIP_COST#" cfsqltype="CF_SQL_NUMERIC">,
                    TRIP_STATUS = <cfqueryparam value="#arguments.TRIP_STATUS#" cfsqltype="CF_SQL_VARCHAR">,
                    UPDATED_BY = <cfqueryparam value="#arguments.UPDATED_BY#" cfsqltype="CF_SQL_INTEGER">,
                    UPDATED_DATE = <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_TIMESTAMP">
                WHERE
                    TRIP_ID = <cfqueryparam value="#arguments.TRIP_ID#" cfsqltype="CF_SQL_INTEGER">
            </cfquery>
            
            <cfreturn true>
            
            <cfcatch type="any">
                <cfreturn false>
            </cfcatch>
        </cftry>
    </cffunction>
    
    <!--- Gezi silme (durum güncelleme) --->
    <cffunction name="deleteTrip" access="public" returntype="boolean">
        <cfargument name="TRIP_ID" type="numeric" required="true">
        <cfargument name="UPDATED_BY" type="numeric" required="true">
        
        
        
        <cftry>
            <cfquery name="deleteTrip" datasource="DEV_DB_MSSQL">
                UPDATE TRIPS
                SET
                    TRIP_STATUS = 'DELETED',
                    UPDATED_BY = <cfqueryparam value="#arguments.UPDATED_BY#" cfsqltype="CF_SQL_INTEGER">,
                    UPDATED_DATE = <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_TIMESTAMP">
                WHERE
                    TRIP_ID = <cfqueryparam value="#arguments.TRIP_ID#" cfsqltype="CF_SQL_INTEGER">
            </cfquery>
            
            <cfreturn true>
            
            <cfcatch type="any">
                <cfreturn false>
            </cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>