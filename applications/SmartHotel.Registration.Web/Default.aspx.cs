// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

using SmartHotel.Registration.Data;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Management;
using System.Net;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SmartHotel.Registration
{
	public partial class _Default : Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{
			if (IsPostBack)
				return;

			int.TryParse(Request.QueryString["loadTime"], out int loadTime);


			DateTime start = DateTime.Now;
			while (DateTime.Now <= start.AddSeconds(loadTime)) ;

			int.TryParse(Request.QueryString["loadNet"], out int loadNet);

			using (var client = ServiceClientFactory.NewServiceClient())
			{
				var registrations = client.GetTodayRegistrations();
				RegistrationGrid.DataSource = registrations;
				RegistrationGrid.DataBind();


				start = DateTime.Now;
				Task.Factory.StartNew(() =>
				{
					while (DateTime.Now <= start.AddSeconds(loadNet))
					{
						HttpWebRequest request = WebRequest.CreateHttp(client.Endpoint.Address.Uri);
						request.Method = "POST";
						request.Timeout = 1000 * loadNet;
						Random rand = new Random();
						using (var stream = request.GetRequestStream())
						{
							byte[] bytes = new byte[100 * 1024 * 1024];
							rand.NextBytes(bytes);
							stream.Write(bytes, 0, bytes.Length);
						}
						try
						{
							using (request.GetResponse()) ;
						}
						catch { }
					}
				});
			}
		}

		protected void RegistrationGrid_SelectedIndexChanged(Object sender, EventArgs e)
		{
			GridViewRow row = RegistrationGrid.SelectedRow;

			var registrationId = RegistrationGrid.DataKeys[RegistrationGrid.SelectedIndex]["Id"];
			var registrationType = RegistrationGrid.DataKeys[RegistrationGrid.SelectedIndex]["Type"].ToString();

			if (registrationType == "CheckIn")
			{
				Response.Redirect($"Checkin.aspx?registration={registrationId}");
			}

			if (registrationType == "CheckOut")
			{
				Response.Redirect($"Checkout.aspx?registration={registrationId}");
			}
		}

		protected void RegistrationGrid_RowDataBound(object sender, GridViewRowEventArgs e)
		{
			if (e.Row.RowType != DataControlRowType.DataRow)
				return;
			e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(RegistrationGrid, "Select$" + e.Row.RowIndex);
		}
	}
}