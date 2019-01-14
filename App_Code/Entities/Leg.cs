using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

namespace Entities
{
    public class Leg
    {
        private Int64 _LegID;
        private BookRequest _Request;
        private Airfield _Source;
        private Airfield _Destination;
        private DateTime _Date;
        private Int32 _Sequence;

        public Leg()
        {

        }
        public Int64 LegID
        {
            get { return _LegID; }
            set { _LegID = value; }
        }
        public BookRequest Request
        {
            get { return _Request; }
            set { _Request = value; }
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
        public DateTime Date
        {
            get { return _Date; }
            set { _Date = value; }
        }
        public Int32 Sequence
        {
            get { return _Sequence; }
            set { _Sequence = value; }
        }
        public String GetLegString()
        {
            String legstring = "";
            legstring += this.Source.AirfieldName + " - ";
            legstring += this.Destination.AirfieldName;
            return legstring;
        }



    }
}
