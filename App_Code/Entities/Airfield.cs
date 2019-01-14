using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using NHibernate;
using NHibernate.Cfg;

namespace Entities
{
    public class Airfield
    {
        private String _ICAOCODE;
        private String _AirfieldName;
        private Char _NS;
        private Int32 _LattitudeDegrees;
        private Int32 _LattitudeMinutes;
        private Char _EW;
        private Int32 _LongitudeDegrees;
        private Int32 _LongitudeMinutes;
        private Int32 _Altitude;
        private Int32 _Runway;
        private String _Country;
        private String _IATACode;
        private String _City;
        private String _State;
        private String _AlternativeNames;


        public String ICAOCODE
        {
            get { return _ICAOCODE; }
            set { _ICAOCODE = value; }
        }
        public String AirfieldName
        {
            get { return _AirfieldName; }
            set { _AirfieldName = value; }
        }
        public String City
        {
            get { return _City; }
            set { _City = value; }
        }
        public String State
        {
            get { return _State; }
            set { _State = value; }
        }
        public String IATACode
        {
            get { return _IATACode; }
            set { _IATACode = value; }
        }
        public String AlternativeNames
        {
            get { return _AlternativeNames; }
            set { _AlternativeNames = value; }
        }
        public Char NS
        {
            get { return _NS; }
            set { _NS = value; }
        }
        public Int32 LattitudeDegrees
        {
            get { return _LattitudeDegrees; }
            set { _LattitudeDegrees = value; }
        }
        public Int32 LattitudeMinutes
        {
            get { return _LattitudeMinutes; }
            set { _LattitudeMinutes = value; }
        }
        public Char EW
        {
            get { return _EW; }
            set { _EW = value; }
        }
        public Int32 LongitudeDegrees
        {
            get { return _LongitudeDegrees; }
            set { _LongitudeDegrees = value; }
        }
        public Int32 LongitudeMinutes
        {
            get { return _LongitudeMinutes; }
            set { _LongitudeMinutes = value; }
        }
        public Int32 Altitude
        {
            get { return _Altitude; }
            set { _Altitude = value; }
        }
        public Int32 Runway
        {
            get { return _Runway; }
            set { _Runway = value; }
        }
        public String Country
        {
            get { return _Country; }
            set { _Country = value; }
        }
        public Airfield()
        {
           
        }
        public Double GetDistaneFrom(Airfield a)
        {
            Double distance;
            if (this.ICAOCODE == a.ICAOCODE)
            {
                distance = 0;
            }
            else
            {
                Double thislatdegrees = (this.NS == 'S' ? -1 : 1) * (this.LattitudeDegrees + this.LattitudeMinutes / 60.0);
                Double thislongdegrees = (this.EW == 'W' ? -1 : 1) * (this.LongitudeDegrees + this.LongitudeMinutes / 60.0);

                Double alatdegrees = (a.NS == 'S' ? -1 : 1) * (a.LattitudeDegrees + a.LattitudeMinutes / 60.0);
                Double alongdegrees = (a.EW == 'W' ? -1 : 1) * (a.LongitudeDegrees + a.LongitudeMinutes / 60.0);

                Double lat1 = (Math.PI * thislatdegrees / 180);
                Double lat2 = (Math.PI * alatdegrees / 180);
                Double long1 = (Math.PI * thislongdegrees / 180);
                Double long2 = (Math.PI * alongdegrees / 180);
                Double EarthRadius = 6371;

                Double latdiff = lat2 - lat1;
                Double longdiff = long2 - long1;
                Double ap = (Math.Sin(latdiff / 2) * Math.Sin(latdiff / 2)) + Math.Cos(lat1) * Math.Cos(lat2) * Math.Sin(longdiff / 2) * Math.Sin(longdiff / 2);
                Double c = 2 * Math.Atan2(Math.Sqrt(ap), Math.Sqrt(1 - ap));

                distance = EarthRadius * c;
            }
            return distance;

        }
        public Double GetLattitudeDecimal()
        {
            Double thislatdegrees = (this.NS == 'S' ? -1 : 1) * (this.LattitudeDegrees + this.LattitudeMinutes / 60.0);
            return thislatdegrees;
        }
        public Double GetLongitudeDecimal()
        {
            Double thislongdegrees = (this.EW == 'W' ? -1 : 1) * (this.LongitudeDegrees + this.LongitudeMinutes / 60.0);
            return thislongdegrees;
        }

        public String GetAirfieldString()
        {
            String resp = "";
           
            if (this.AirfieldName != null && this.AirfieldName != "")
                resp += this.AirfieldName.Trim() + ", ";
            if (this.City != null && this.City != "")
                resp += Capitalize(this.City.Trim().ToLower()) + ", ";
            if (this.State != null && this.State != "")
                resp += Capitalize(this.State.Trim().ToLower()) + ", ";
            if (this.Country != null && this.Country != "")
                resp += this.Country.Trim();

            resp += " (" + this.ICAOCODE + ")";

            return resp;
        }
        public Boolean IsHeliport()
        {
            return this.ICAOCODE.StartsWith("A-A");
        }
        public Boolean IsTemporary()
        {
            return this.ICAOCODE.StartsWith("T-T");
        }
        public String Capitalize(String s)
        {
            return char.ToUpper(s[0]) + s.Substring(1);
        }
    }
}
