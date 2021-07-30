<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="SmartHotel.Registration.Checkout" %>
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
    <section class="sh-form">
        <h2 class="sh-title">Customer Check Out</h2>
        <div class="sh-form_wrapper">
            <div class="row">
                <asp:Button ID="cancel_btn" class="sh-close-btn btn pull-right" runat="server" OnClick="BackBtn_Click"/>
                <section class="col-sm-6 customer-information">
                    <span class="sh-subtitle">Customer's information</span>
                    <div class="form-group">
                        <label class="sh-label" for="CustomerName">CUSTOMER NAME</label>
                        <input class="sh-input form-control" id="CustomerName" type="text" runat="server" />
                    </div>
                    <div class="form-group">
                        <label class="sh-label" for="Passport">PASSPORT Nº</label>
                        <input class="sh-input form-control" id="Passport" type="text" runat="server" />
                    </div>
                    <div class="form-group">
                        <label class="sh-label" for="CustomerId">CUSTOMER ID</label>
                        <input class="sh-input form-control" id="CustomerId" type="text" runat="server" disabled />
                    </div>
                    <div class="form-group">
                        <label class="sh-label" for="Address">ADDRESS</label>
                        <input class="sh-input form-control" id="Address" type="text" runat="server" />
                    </div>
                    <div class="form-group">
                        <label class="sh-label" for="CreditCard">CREDIT CARD</label>
                        <asp:TextBox ID="CreditCard" class="sh-input form-control" TextMode="Password" runat="server" disabled />
                    </div>
                </section>
                <section class="col-sm-6 room-information">
                    <span class="sh-subtitle">Room's information</span>
                    <div class="form-group">
                        <label class="sh-label" for="RoomType">ROOM TYPE</label>
                        <select class="sh-input form-control" id="RoomType">
                            <option class="sh-input_option" value="Double Room">Double Room</option>
                            <option class="sh-input_option" value="Single Room">Single Room</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="sh-label" for="RoomNumber">ROOM NUMBER</label>
                        <input class="sh-input form-control" id="RoomNumber" type="text" runat="server" />
                    </div>
                    <div class="form-group">
                        <label class="sh-label" for="Floor">FLOOR</label>
                        <input class="sh-input form-control" id="Floor" type="text" runat="server" />
                    </div>
                    <div class="form-group">
                        <label class="sh-label" for="Amount">AMOUNT</label>
                        <input class="sh-input form-control" id="Amount" type="text" runat="server" disabled />
                    </div>
                    <div class="form-group">
                        <label class="sh-label" for="Total">TOTAL</label>
                        <input class="sh-input form-control" id="Total" type="text" runat="server" disabled />
                    </div>
                    <div class="form-group">
                        <asp:Button ID="checkout_btn" class="sh-button btn pull-right" runat="server" OnClick="CheckoutBtn_Click" Text="CHECK OUT"/>
                    </div>                    
                </section>
            </div>
        </div>
    </section>
</asp:Content>