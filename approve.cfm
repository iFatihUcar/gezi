<cfparam name="url.action" default="showApprovalForm">
<cfparam name="url.token" default="">

<cfswitch expression="#url.action#">
    <cfcase value="showApprovalForm">
        <cfif url.token NEQ "">
            <cfset approvalController = CreateObject("component", "controllers.approval")>
            <cfset approvalController.showApprovalForm(TOKEN=url.token)>
        <cfelse>
            <cflocation url="index.cfm" addtoken="false">
        </cfif>
    </cfcase>
    
    <cfcase value="saveApproval">
        <cfparam name="form.TOKEN" default="">
        <cfparam name="form.APPROVAL_STATUS" default="">
        <cfparam name="form.APPROVAL_NOTES" default="">
        
        <cfif form.TOKEN NEQ "" AND form.APPROVAL_STATUS NEQ "">
            <cfset approvalController = CreateObject("component", "controllers.approval")>
            <cfset approvalController.saveApproval(
                TOKEN = form.TOKEN,
                APPROVAL_STATUS = form.APPROVAL_STATUS,
                APPROVAL_NOTES = form.APPROVAL_NOTES
            )>
        <cfelse>
            <cflocation url="index.cfm" addtoken="false">
        </cfif>
    </cfcase>
    
    <cfdefaultcase>
        <cflocation url="index.cfm" addtoken="false">
    </cfdefaultcase>
</cfswitch>