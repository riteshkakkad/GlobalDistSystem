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
    public class OperatorQuoteLeg
    {
        private Int64 _OperatorQuoteLegID;
        private OperatorQuote _OperatorQuote;
        private Airfield _Source;
        private Airfield _Destination;
        private Int32 _Sequence;
        private DateTime _DepartsAt;
        private Double _FlyingTime;

        public Int64 OperatorQuoteLegID
        {
            get { return _OperatorQuoteLegID; }
            set { _OperatorQuoteLegID = value; }
        }
        public OperatorQuote OperatorQuote
        {
            get { return _OperatorQuote; }
            set { _OperatorQuote = value; }
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
        
        public Double FlyingTime
        {
            get { return _FlyingTime; }
            set { _FlyingTime = value; }
        }
        public DateTime DepartsAt
        {
            get { return _DepartsAt; }
            set { _DepartsAt = value; }
        }
        public Int32 Sequence
        {
            get { return _Sequence; }
            set { _Sequence = value; }
        }

        
        public OperatorQuoteLeg()
        {
          
        }
    }
}
