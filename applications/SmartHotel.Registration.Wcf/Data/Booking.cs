﻿// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SmartHotel.Registration.Wcf.Data
{
    public class Booking
    {
        public int Id { get; set; }
        public DateTime From { get; set; }
        public DateTime To { get; set; }
        public string CustomerId { get; set; }
        public string CustomerName { get; set; }
        public string Passport { get; set; }
        public string Address { get; set; }
        public string CreditCard { get; set; }
        public int Floor { get; set; }
        public int RoomNumber { get; set; }
        public int Amount { get; set; }
        public int Total { get; set; }
    }
}