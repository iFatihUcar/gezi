<cfcomponent output="false">
    <!--- Constructor --->
    <cffunction name="init" access="public" returntype="any">
        <cfset variables.tripModel = CreateObject("component", "gezi_onay_sistemi.models.TRIP")>
        <cfreturn this>
    </cffunction>
    
    <!--- Tüm gezileri listeleme --->
    <cffunction name="listTrips" access="public" returntype="void">
        <cfargument name="status" type="string" required="false" default="ACTIVE">
        
        <cfset request.trips = variables.tripModel.getAllTrips(status=arguments.status)>
        <cfinclude template="../views/trips/list.cfm">
    </cffunction>
    
    <!--- Yeni gezi formu --->
    <cffunction name="newTripForm" access="public" returntype="void">
        <cfinclude template="../views/trips/add.cfm">
    </cffunction>
    
    <!--- Gezi ekleme --->
    <cffunction name="addTrip" access="public" returntype="void">
        <cfargument name="TRIP_NAME" type="string" required="true">
        <cfargument name="TRIP_DESCRIPTION" type="string" required="true">
        <cfargument name="TRIP_DATE" type="string" required="true">
        <cfargument name="TRIP_LOCATION" type="string" required="true">
        <cfargument name="TRIP_COST" type="string" required="false" default="0">
        
        <cfset var tripDate = ParseDateTime(arguments.TRIP_DATE)>
        <cfset var tripCost = val(arguments.TRIP_COST)>
        <cfset var userID = session.userID> <!--- Kullanıcı kimliğini session'dan alıyoruz --->
        
        <!--- Form doğrulama --->
        <cfset var errors = []>
        
        <cfif Trim(arguments.TRIP_NAME) EQ "">
            <cfset ArrayAppend(errors, "Gezi adı boş olamaz.")>
        </cfif>
        
        <cfif Trim(arguments.TRIP_LOCATION) EQ "">
            <cfset ArrayAppend(errors, "Gezi lokasyonu boş olamaz.")>
        </cfif>
        
        <cfif DateCompare(tripDate, Now()) LT 0>
            <cfset ArrayAppend(errors, "Gezi tarihi geçmiş bir tarih olamaz.")>
        </cfif>
        
        <cfif ArrayLen(errors) GT 0>
            <cfset request.errors = errors>
            <cfset request.formData = arguments>
            <cfinclude template="../views/trips/add.cfm">
            <cfreturn>
        </cfif>
        
        <!--- Gezi ekleme --->
        <cfset var tripID = variables.tripModel.createTrip(
            TRIP_NAME = arguments.TRIP_NAME,
            TRIP_DESCRIPTION = arguments.TRIP_DESCRIPTION,
            TRIP_DATE = tripDate,
            TRIP_LOCATION = arguments.TRIP_LOCATION,
            TRIP_COST = tripCost,
            CREATED_BY = userID
        )>
        
        <cfif tripID GT 0>
            <cflocation url="index.cfm?action=listTrips" addtoken="false">
        <cfelse>
            <cfset request.errors = ["Gezi eklenirken bir hata oluştu. Lütfen tekrar deneyiniz."]>
            <cfset request.formData = arguments>
            <cfinclude template="../views/trips/add.cfm">
        </cfif>
    </cffunction>
    
    <!--- Gezi düzenleme formu --->
    <cffunction name="editTripForm" access="public" returntype="void">
        <cfargument name="TRIP_ID" type="numeric" required="true">
        
        <cfset request.trip = variables.tripModel.getTripById(TRIP_ID=arguments.TRIP_ID)>
        
        <cfif request.trip.RecordCount EQ 0>
            <cflocation url="index.cfm?action=listTrips" addtoken="false">
        </cfif>
        
        <cfinclude template="../views/trips/edit.cfm">
    </cffunction>
    
    <!--- Gezi güncelleme --->
    <cffunction name="updateTrip" access="public" returntype="void">
        <cfargument name="TRIP_ID" type="numeric" required="true">
        <cfargument name="TRIP_NAME" type="string" required="true">
        <cfargument name="TRIP_DESCRIPTION" type="string" required="true">
        <cfargument name="TRIP_DATE" type="string" required="true">
        <cfargument name="TRIP_LOCATION" type="string" required="true">
        <cfargument name="TRIP_COST" type="string" required="false" default="0">
        <cfargument name="TRIP_STATUS" type="string" required="false" default="ACTIVE">
        
        <cfset var tripDate = ParseDateTime(arguments.TRIP_DATE)>
        <cfset var tripCost = val(arguments.TRIP_COST)>
        <cfset var userID = session.userID> <!--- Kullanıcı kimliğini session'dan alıyoruz --->
        
        <!--- Form doğrulama --->
        <cfset var errors = []>
        
        <cfif Trim(arguments.TRIP_NAME) EQ "">
            <cfset ArrayAppend(errors, "Gezi adı boş olamaz.")>
        </cfif>
        
        <cfif Trim(arguments.TRIP_LOCATION) EQ "">
            <cfset ArrayAppend(errors, "Gezi lokasyonu boş olamaz.")>
        </cfif>
        
        <cfif ArrayLen(errors) GT 0>
            <cfset request.errors = errors>
            <cfset request.formData = arguments>
            <cfset request.trip = variables.tripModel.getTripById(TRIP_ID=arguments.TRIP_ID)>
            <cfinclude template="../views/trips/edit.cfm">
            <cfreturn>
        </cfif>
        
        <!--- Gezi güncelleme --->
        <cfset var success = variables.tripModel.updateTrip(
            TRIP_ID = arguments.TRIP_ID,
            TRIP_NAME = arguments.TRIP_NAME,
            TRIP_DESCRIPTION = arguments.TRIP_DESCRIPTION,
            TRIP_DATE = tripDate,
            TRIP_LOCATION = arguments.TRIP_LOCATION,
            TRIP_COST = tripCost,
            TRIP_STATUS = arguments.TRIP_STATUS,
            UPDATED_BY = userID
        )>
        
        <cfif success>
            <cflocation url="index.cfm?action=listTrips" addtoken="false">
        <cfelse>
            <cfset request.errors = ["Gezi güncellenirken bir hata oluştu. Lütfen tekrar deneyiniz."]>
            <cfset request.formData = arguments>
            <cfset request.trip = variables.tripModel.getTripById(TRIP_ID=arguments.TRIP_ID)>
            <cfinclude template="../views/trips/edit.cfm">
        </cfif>
    </cffunction>
    
    <!--- Gezi silme --->
    <cffunction name="deleteTrip" access="public" returntype="void">
        <cfargument name="TRIP_ID" type="numeric" required="true">
        
        <cfset var userID = session.userID> <!--- Kullanıcı kimliğini session'dan alıyoruz --->
        
        <cfset var success = variables.tripModel.deleteTrip(
            TRIP_ID = arguments.TRIP_ID,
            UPDATED_BY = userID
        )>
        
        <cflocation url="index.cfm?action=listTrips" addtoken="false">
    </cffunction>
</cfcomponent>