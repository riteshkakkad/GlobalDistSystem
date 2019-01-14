using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using NHibernate.Collection;
using Iesi.Collections;

namespace Entities
{
    public class OperatorQuote
    {
        private Int64 _OperatorQuoteID;
        private BookRequest _Request;
        private Airplane _Aircraft;
        
        private Int32 _FinalAmount;
        private Int32 _AirnetzAmount;
        private Boolean _NightHaltCharge;
        private Int32 _NightHalts;
        private Boolean _DayHaltCharge;
        private Int32 _DayHalts;
        private Boolean _CrewCharge;
        private Int32 _Crew;
        private Boolean _FacilityFees;
        private Boolean _LandingFees;
        private Boolean _InternationalServiceCharges;
        private Boolean _ServiceTax;
        private Double _MinimumFlyingHours;
        private String _CancellationChargeHoursMoreThan72;
        private String _CancellationChargeHours48To72;
        private String _CancellationChargeHours24To48;
        private String _CancellationChargeHours0To24;
        private String _InvoiceFileName;
        private String _InvoiceToCustomer;
        private String _Pilots;
        private String _Baggage;
        private String _Currency;
        private ISet _OperatorLegs = new ListSet();

        public Int64 OperatorQuoteID
        {
            get { return _OperatorQuoteID; }
            set { _OperatorQuoteID = value; }
        }
        public BookRequest Request
        {
            get { return _Request; }
            set { _Request = value; }
        }
        public Airplane Aircraft
        {
            get { return _Aircraft; }
            set { _Aircraft = value; }
        }
       
        public Int32 FinalAmount
        {
            get { return _FinalAmount; }
            set { _FinalAmount = value; }
        }
        public Int32 AirnetzAmount
        {
            get { return _AirnetzAmount; }
            set { _AirnetzAmount = value; }
        }
        public Boolean NightHaltCharge
        {
            get { return _NightHaltCharge; }
            set { _NightHaltCharge = value; }
        }
        public Int32 NightHalts
        {
            get { return _NightHalts; }
            set { _NightHalts = value; }
        }
        public Boolean DayHaltCharge
        {
            get { return _DayHaltCharge; }
            set { _DayHaltCharge = value; }
        }
        public Int32 DayHalts
        {
            get { return _DayHalts; }
            set { _DayHalts = value; }
        }
        public Boolean CrewCharge
        {
            get { return _CrewCharge; }
            set { _CrewCharge = value; }
        }
        public Int32 Crew
        {
            get { return _Crew; }
            set { _Crew = value; }
        }
        public Boolean FacilityFees
        {
            get { return _FacilityFees; }
            set { _FacilityFees = value; }
        }
        public Boolean LandingFees
        {
            get { return _LandingFees; }
            set { _LandingFees = value; }
        }
        public Boolean InternationalServiceCharges
        {
            get { return _InternationalServiceCharges; }
            set { _InternationalServiceCharges = value; }
        }
        public Boolean ServiceTax
        {
            get { return _ServiceTax; }
            set { _ServiceTax = value; }
        }
        public Double MinimumFlyingHours
        {
            get { return _MinimumFlyingHours; }
            set { _MinimumFlyingHours = value; }
        }
        public String CancellationChargeHoursMoreThan72
        {
            get { return _CancellationChargeHoursMoreThan72; }
            set { _CancellationChargeHoursMoreThan72 = value; }
        }
        public String CancellationChargeHours48To72
        {
            get { return _CancellationChargeHours48To72; }
            set { _CancellationChargeHours48To72 = value; }
        }
        public String CancellationChargeHours24To48
        {
            get { return _CancellationChargeHours24To48; }
            set { _CancellationChargeHours24To48 = value; }
        }
        public String CancellationChargeHours0To24
        {
            get { return _CancellationChargeHours0To24; }
            set { _CancellationChargeHours0To24 = value; }
        }
        public String InvoiceFileName
        {
            get { return _InvoiceFileName; }
            set { _InvoiceFileName = value; }
        }
        public String InvoiceToCustomer
        {
            get { return _InvoiceToCustomer; }
            set { _InvoiceToCustomer = value; }
        }
        public ISet OperatorLegs
        {
            get { return _OperatorLegs; }
            set { _OperatorLegs = value; }
        }
        public String Pilots
        {
            get { return _Pilots; }
            set { _Pilots = value; }
        }
        public String Baggage
        {
            get { return _Baggage; }
            set { _Baggage = value; }
        }
        public String Currency
        {
            get { return _Currency; }
            set { _Currency = value; }
        }

        public OperatorQuote()
        {
          
        }
        public String GetLegString()
        {
            String legstring = null;
            foreach (OperatorQuoteLeg oql in this.OperatorLegs)
            {
                if(oql.Sequence==1)
                {
                     legstring+=oql.Source.AirfieldName+" - ";
                 }

                legstring += oql.Destination.AirfieldName + " - ";
            }
            return legstring;
        }
        public DateTime GetStartDate()
        {
            DateTime date=DateTime.Now;
            foreach (OperatorQuoteLeg oql in this.OperatorLegs)
            {
                if (oql.Sequence == 1)
                {
                    date= oql.DepartsAt;
                }

               
            }
            return date;
        }
    }
}
