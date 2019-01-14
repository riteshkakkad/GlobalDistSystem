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
    public class AirplaneTypeRate
    {
        private Int64 _RateID;
        private Double _HourlyRate;

        private Double _WaitingCharge;
        private Double _FuelPositioning;
        private Double _NightHalt;
        private Double _Crew;
        private Double _WatchHour;
        private AirplaneType _PlaneType;
        private Country _Country;

        public Int64 RateID
        {
            get { return _RateID; }
            set { _RateID = value; }
        }
        public AirplaneType PlaneType
        {
            get { return _PlaneType; }
            set { _PlaneType = value; }
        }
        public Country Country
        {
            get { return _Country; }
            set { _Country = value; }
        }
        public Double HourlyRate
        {
            get { return _HourlyRate; }
            set { _HourlyRate = value; }
        }
        public Double WaitingCharge
        {
            get { return _WaitingCharge; }
            set { _WaitingCharge = value; }
        }
        public Double FuelPositioning
        {
            get { return _FuelPositioning; }
            set { _FuelPositioning = value; }
        }
        public Double NightHalt
        {
            get { return _NightHalt; }
            set { _NightHalt = value; }
        }
        public Double Crew
        {
            get { return _Crew; }
            set { _Crew = value; }
        }
        public Double WatchHour
        {
            get { return _WatchHour; }
            set { _WatchHour = value; }
        }
        public AirplaneTypeRate()
        {
            
        }

    }
}
