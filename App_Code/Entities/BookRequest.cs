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
using System.Collections;
namespace Entities
{
    public class BookRequest
    {
        private Int64 _BookID;
        private String _TripType;
        private AirplaneType _PlaneType;
        private Int32 _PAX;
        private Contact _ContactDetails;
        private ISet _Legs = new ListSet();
        private Boolean _IsAgent;
        private Agent _Agent;
        private Int16 _Status;
        private DateTime _TimeofCreation;
        private Country _Domain;
        private String _Code;
        private Double _Budget;
        private Double _FinalBudget;
        private OperatorBid _AcceptedBid;
        private FixedPriceCharter _FixedPriceCharter;
        public BookRequest()
        {
        }

        public Int64 BookID
        {
            get { return _BookID; }
            set { _BookID = value; }
        }
        public String TripType
        {
            get { return _TripType; }
            set { _TripType = value; }
        }
        public AirplaneType PlaneType
        {
            get { return _PlaneType; }
            set { _PlaneType = value; }
        }
        public Int32 PAX
        {
            get { return _PAX; }
            set { _PAX = value; }
        }
        public Double Budget
        {
            get { return _Budget; }
            set { _Budget = value; }
        }
        public Double FinalBudget
        {
            get { return _FinalBudget; }
            set { _FinalBudget = value; }
        }
        public Contact ContactDetails
        {
            get { return _ContactDetails; }
            set { _ContactDetails = value; }
        }
        public ISet Legs
        {
            get { return _Legs; }
            set { _Legs = value; }
        }
        public Boolean IsAgent
        {
            get { return _IsAgent; }
            set { _IsAgent = value; }
        }
        public Agent Agent
        {
            get { return _Agent; }
            set { _Agent = value; }
        }
        public Int16 Status
        {
            get { return _Status; }
            set { _Status = value; }
        }
        public DateTime TimeofCreation
        {
            get { return _TimeofCreation; }
            set { _TimeofCreation = value; }
        }
        public Country Domain
        {
            get { return _Domain; }
            set { _Domain  = value; }
        }
        public String Code
        {
            get { return _Code; }
            set { _Code = value; }
        }
        public OperatorBid AcceptedBid
        {
            get { return _AcceptedBid; }
            set { _AcceptedBid = value; }
        }
        public FixedPriceCharter FixedPriceCharter
        {
            get { return _FixedPriceCharter; }
            set { _FixedPriceCharter = value; }
        }
        public void AddLeg(Leg leg)
        {
            leg.Request = this;
            Legs.Add(leg);
        }
        public Leg GetStartingLeg()
        {
            Leg startleg = null;
            foreach (Leg l in Legs)
            {
                if (l.Sequence == 1)
                {
                    startleg = l;
                }
            }
            return startleg;
        }
        public Leg GetEndingLeg()
        {
            Leg endleg = null;
            foreach (Leg l in Legs)
            {
                if (l.Sequence == Legs.Count)
                {
                    endleg = l;
                }
            }
            return endleg;
        }
        

        public String GetLegCodeString()
        {
            String legstring = "";
                     
            
            foreach (Leg l in this.Legs)
            {
                if (l.Sequence == 1)
                {
                    legstring += l.Source.ICAOCODE + " - ";
                }

                legstring += l.Destination.ICAOCODE + " - ";
            }

            return legstring.Remove(legstring.LastIndexOf("-"));
        }
        public String GetLegString()
        {
            String legstring = "";


            foreach (Leg l in this.Legs)
            {
                if (l.Sequence == 1)
                {
                    legstring += l.Source.AirfieldName + " - ";
                }

                legstring += l.Destination.AirfieldName + " - ";
            }

            return legstring.Remove(legstring.LastIndexOf("-"));
        }
        public ListSet GetLegCountries()
        {
            ListSet ls = new ListSet();
            foreach (Leg l in this.Legs)
            {
                ls.Add(l.Source.Country.Trim());
                ls.Add(l.Destination.Country.Trim());
            }
            return ls;
        }

    }
}
