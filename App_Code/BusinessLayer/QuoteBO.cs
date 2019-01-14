using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using Entities;
using DataAccessLayer;
using Iesi.Collections;
using System.Collections;
using NHibernate;
using System.Collections.Generic;

namespace BusinessLayer
{
    public class QuoteBO
    {
        AirplaneType _AirplaneType;
        String _TripType;
        ISet _legs = new HashedSet();

        public QuoteBO()
        {
           
        }
        public AirplaneType AirplaneType
        {
            get { return _AirplaneType; }
            set { _AirplaneType = value; }
        }
        public String TripType
        {
            get { return _TripType; }
            set { _TripType = value; }
        }
        public ISet legs
        {
            get { return _legs; }
            set { _legs = value; }
        }


    }
}
