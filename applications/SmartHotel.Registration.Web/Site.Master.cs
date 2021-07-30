﻿// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

using SmartHotel.Registration.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SmartHotel.Registration
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
                return;

            using (var client = ServiceClientFactory.NewServiceClient())
            {
                var summary = client.GetTodayRegistrationSummary();
                Checkins.InnerText = summary.CheckIns.ToString();
                Checkouts.InnerText = summary.CheckOuts.ToString();

                Clock.Text = DateTime.Now.ToShortTimeString();
            }
        }

        protected void ClockTimer_Tick(object sender, EventArgs e)
        {
            Clock.Text = DateTime.Now.ToShortTimeString();
        }
    }
}