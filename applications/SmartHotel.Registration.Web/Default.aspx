﻿<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" EnableEventValidation="false" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SmartHotel.Registration._Default" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
  <%-- Copyright (c) Microsoft Corporation. --%>
  <%-- Licensed under the MIT license. --%>
    <script type="text/javascript">
        var sdkInstance="appInsightsSDK";window[sdkInstance]="appInsights";var aiName=window[sdkInstance],aisdk=window[aiName]||function(e){function n(e){t[e]=function(){var n=arguments;t.queue.push(function(){t[e].apply(t,n)})}}var t={config:e};t.initialize=!0;var i=document,a=window;setTimeout(function(){var n=i.createElement("script");n.src=e.url||"https://az416426.vo.msecnd.net/scripts/b/ai.2.min.js",i.getElementsByTagName("script")[0].parentNode.appendChild(n)});try{t.cookie=i.cookie}catch(e){}t.queue=[],t.version=2;for(var r=["Event","PageView","Exception","Trace","DependencyData","Metric","PageViewPerformance"];r.length;)n("track"+r.pop());n("startTrackPage"),n("stopTrackPage");var s="Track"+r[0];if(n("start"+s),n("stop"+s),n("setAuthenticatedUserContext"),n("clearAuthenticatedUserContext"),n("flush"),!(!0===e.disableExceptionTracking||e.extensionConfig&&e.extensionConfig.ApplicationInsightsAnalytics&&!0===e.extensionConfig.ApplicationInsightsAnalytics.disableExceptionTracking)){n("_"+(r="onerror"));var o=a[r];a[r]=function(e,n,i,a,s){var c=o&&o(e,n,i,a,s);return!0!==c&&t["_"+r]({message:e,url:n,lineNumber:i,columnNumber:a,error:s}),c},e.autoExceptionInstrumented=!0}return t}(
        {
          instrumentationKey:"INSTRUMENTATION_KEY"
        }
        );window[aiName]=aisdk,aisdk.queue&&0===aisdk.queue.length&&aisdk.trackPageView({});
    </script>    
    <div class="row">
        <asp:GridView ID="RegistrationGrid" runat="server"
            OnSelectedIndexChanged="RegistrationGrid_SelectedIndexChanged"
            OnRowDataBound="RegistrationGrid_RowDataBound"
            DataKeyNames="Id,Type"
            AutoGenerateColumns="false"
            ShowHeader="true">
            <Columns>
                <asp:BoundField DataField="Id" Visible="false" />
                <asp:BoundField DataField="Type" Visible="false" />
                <asp:BoundField DataField="CustomerName" HeaderText="Customer Name" />
                <asp:BoundField DataField="Passport" HeaderText="Passport" />
                <asp:BoundField DataField="CustomerId" HeaderText="Customer Id" />
                <asp:BoundField DataField="Address" HeaderText="Address" />
                <asp:BoundField DataField="Type" HeaderText="Operation" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
