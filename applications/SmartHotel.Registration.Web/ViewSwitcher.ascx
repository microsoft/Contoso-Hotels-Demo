<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ViewSwitcher.ascx.cs" Inherits="SmartHotel.Registration.ViewSwitcher" %>
<div id="viewSwitcher">
  <%-- Copyright (c) Microsoft Corporation. --%>
  <%-- Licensed under the MIT license. --%>
    <%: CurrentView %> view | <a href="<%: SwitchUrl %>" data-ajax="false">Switch to <%: AlternateView %></a>
</div>