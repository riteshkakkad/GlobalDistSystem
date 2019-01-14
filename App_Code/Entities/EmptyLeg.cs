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
    public class EmptyLeg
    {
        private Int64 _ID;
        private Airplane _Aircraft;
        private Airfield _Source;
        private Airfield _Destination;
        private DateTime _DepartureFromDate;
        private DateTime _DepartureToDate;
        private Int32 _Status;
        private Double _ActualPrice;
        private Double _OfferPrice;
        private Currency _Currency;
        private DateTime _PostedOn;
        private EmptyLegOffer _AcceptedOffer;

        public Int64 ID
        {
            get { return _ID; }
            set { _ID = value; }
        }
        public EmptyLegOffer AcceptedOffer
        {
            get { return _AcceptedOffer; }
            set { _AcceptedOffer = value; }
        }
        public Currency Currency
        {
            get { return _Currency; }
            set { _Currency = value; }
        }
        public DateTime PostedOn
        {
            get { return _PostedOn; }
            set { _PostedOn = value; }
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
        public DateTime DepartureFromDate
        {
            get { return _DepartureFromDate; }
            set { _DepartureFromDate = value; }
        }
        public DateTime DepartureToDate
        {
            get { return _DepartureToDate; }
            set { _DepartureToDate = value; }
        }
        public Int32 Status
        {
            get { return _Status; }
            set { _Status = value; }
        }
        public Double ActualPrice
        {
            get { return _ActualPrice; }
            set { _ActualPrice = value; }
        }
        public Double OfferPrice
        {
            get { return _OfferPrice; }
            set { _OfferPrice = value; }
        }
        public EmptyLeg()
        {
            
        }

    }
}
