﻿// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Web;

namespace SmartHotel.Registration.Wcf.Models
{
    [DataContract]
    public class RegistrationDaySummary
    {
        [DataMember]
        public DateTime Date { get; set; }
        [DataMember]
        public int CheckIns { get; set; }
        [DataMember]
        public int CheckOuts { get; set; }
    }
}