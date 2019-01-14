using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Newtonsoft.Json;

namespace Entities
{
    public class OperatorBid
    {
        private Int64 _BidID;
        private Operator _Operator;
        private BookRequest _Request;
        private Airplane _Aircraft;
        private Double _BidAmount;
        private Double _FinalBidAmount;
        private Currency _Currency;
        private DateTime _TimeOfBid;
        private String _AdditionalDetails;
        private Int16 _Status;
        private Boolean _Accepted;
        public Int64 BidID
        {
            get { return _BidID; }
            set { _BidID = value; }
        }
        [JsonIgnore]
        public Operator Operator
        {
            get { return _Operator; }
            set { _Operator = value; }
        }
        [JsonIgnore]
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
        public Double BidAmount
        {
            get { return _BidAmount; }
            set { _BidAmount = value; }
        }
        public Double FinalBidAmount
        {
            get { return _FinalBidAmount; }
            set { _FinalBidAmount = value; }
        }
        public Int16 Status
        {
            get { return _Status; }
            set { _Status = value; }
        }
        public DateTime TimeOfBid
        {
            get { return _TimeOfBid; }
            set { _TimeOfBid = value; }
        }
        public Currency Currency
        {
            get { return _Currency; }
            set { _Currency = value; }
        }
        public String AdditionalDetails
        {
            get { return _AdditionalDetails; }
            set { _AdditionalDetails = value; }
        }
       
        public OperatorBid()
        {
            
        }

    }
}
