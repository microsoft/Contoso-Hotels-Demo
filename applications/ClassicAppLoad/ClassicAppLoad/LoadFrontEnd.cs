// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

using System;
using System.Collections.Generic;
using System.Net;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Extensions.Logging;

namespace ClassicAppLoad
{
    public static class LoadFrontEnd
    {
        [FunctionName(nameof(LoadFrontEnd))]
        public async static Task Run([TimerTrigger("*/15 * */3 * * *")]TimerInfo myTimer, ILogger log)
		{
			ServicePointManager.ServerCertificateValidationCallback = ServicePointManager.ServerCertificateValidationCallback ?? ((sender, cert, chain, sslPolicyErrors) => true);
			int count = 4;
			List<Task> tasks = new List<Task>();
			for (int i = 0; i < count; i++)
				tasks.Add(Task.Factory.StartNew(SendRequest));

			await Task.WhenAll(tasks.ToArray());
		}
		private static void SendRequest()
		{
			HttpWebRequest request = WebRequest.CreateHttp($"{Environment.GetEnvironmentVariable("classipAppUrl")}/Default?loadTime=15");
			try
			{
				using (var response = request.GetResponse() as HttpWebResponse)
				{
					Console.WriteLine(response.StatusCode);
				}
			}
			catch (Exception ex)
			{
				Console.WriteLine(ex);
			}
		}
	}
}
