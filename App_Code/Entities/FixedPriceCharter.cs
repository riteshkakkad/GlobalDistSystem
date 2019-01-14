using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace Entities
{
    public class FixedPriceCharter
    {
        private Int64 _ID;
        private Airfield _Source;
        private Airfield _Destination;
        private Airplane _Aircraft;
        private DateTime _PostedOn;
        private Double _Quote;
        private DateTime _ExpiresOn;
        private Int32 _Status;
        private Currency _Currency;

        public Int64 ID
        {
            get { return _ID; }
            set { _ID = value; }
        }
        public Airfield Source
        {
            get { return _Source; }
            set { _Source = value; }
        }
        public Airfield Destination
        {
            get { return _Destination; }
            set { _Destination = value; }
        }
        public Airplane Aircraft
        {
            get { return _Aircraft; }
            set { _Aircraft = value; }
        }
        public DateTime PostedOn
        {
            get { return _PostedOn; }
            set { _PostedOn = value; }
        }
        public Double Quote
        {
            get { return _Quote; }
            set { _Quote = value; }
        }
        public DateTime ExpiresOn
        {
            get { return _ExpiresOn; }
            set { _ExpiresOn = value; }
        }
        public Int32 Status
        {
            get { return _Status; }
            set { _Status = value; }
        }
        public Currency Currency
        {
            get { return _Currency; }
            set { _Currency = value; }
        }
        public FixedPriceCharter()
        {

        }

    }
}
