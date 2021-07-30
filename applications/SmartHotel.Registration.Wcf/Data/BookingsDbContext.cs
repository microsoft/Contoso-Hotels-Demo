﻿// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace SmartHotel.Registration.Wcf.Data
{
    public class BookingsDbContext: DbContext
    {
        public BookingsDbContext() : base(Environment.GetEnvironmentVariable("DefaultConnection") ??  "DefaultConnection")
        {
            Database.SetInitializer(new BookingsDbContextInitializer());
        }

        public DbSet<Booking> Bookings { get; set; }

    }
}