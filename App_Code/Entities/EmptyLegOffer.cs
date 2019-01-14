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
    public class EmptyLegOffer
    {
        private Int64 _ID;
        private Double _BidAmount;
        private Currency _Currency;
       
        private Int32 _Status;
        private Boolean _IsAgent;
        private Customer _Customer;
        private Agent _Agent;
        private DateTime _TimeOfOffer;
        private EmptyLeg _EmptyLeg;

        public Int64 ID
        {
            get { return _ID; }
            set { _ID = value; }
        }
        public Double BidAmount
        {
            get { return _BidAmount; }
            set { _BidAmount = value; }
        }
        public Currency Currency
        {
            get { return _Currency; }
            set { _Currency = value; }
        }
       
        public Int32 Status
        {
            get { return _Status; }
            set { _Status = value; }
        }
        public Boolean IsAgent
        {
            get { return _IsAgent; }
            set { _IsAgent = value; }
        }
        public Customer Customer
        {
            get { return _Customer; }
            set { _Customer = value; }
        }
        public Agent Agent
        {
            get { return _Agent; }
            set { _Agent = value; }
        }
        public DateTime TimeOfOffer
        {
            get { return _TimeOfOffer; }
            set { _TimeOfOffer = value; }
        }
        public EmptyLeg EmptyLeg
        {
            get { return _EmptyLeg; }
            set { _EmptyLeg = value; }
        }
        public EmptyLegOffer()
        {

        }

    }
}
