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
using Newtonsoft.Json;
using Iesi.Collections;
namespace Entities
{
    public class Airplane
    {
        private Int64 _AircraftId;
        private String _AircraftName;
        private Int32 _PassengerCapacity;
        private AirplaneType _AircraftType;
        private String _AircraftLocation;
        private Operator _Vendor;
        private Int32 _BaggageCapacity;
        private Int32 _Pilots;
        private Int32 _Crew;
        private Double _PricePerHour;
        private Currency _Currency;
        private Int16 _Status;
        private ISet _PhotoList = new ListSet();
        

        public Int64 AircraftId
        {
            get { return _AircraftId; }
            set { _AircraftId = value; }
        }
        public Int16 Status
        {
            get { return _Status; }
            set { _Status = value; }
        }
        public Double PricePerHour
        {
            get { return _PricePerHour; }
            set { _PricePerHour = value; }
        }
        public Currency Currency
        {
            get { return _Currency; }
            set { _Currency = value; }
        }
        public String AircraftName
        {
            get { return _AircraftName; }
            set { _AircraftName = value; }
        }
        public Int32 PassengerCapacity
        {
            get { return _PassengerCapacity; }
            set { _PassengerCapacity = value; }
        }
        public AirplaneType AircraftType
        {
            get { return _AircraftType; }
            set { _AircraftType = value; }
        }
      
        public Operator Vendor
        {
            get { return _Vendor; }
            set { _Vendor = value; }
        }
        [JsonIgnore]
        public ISet PhotoList
        {
            get { return _PhotoList; }
            set { _PhotoList = value; }
        }
        public String AircraftLocation
        {
            get { return _AircraftLocation; }
            set { _AircraftLocation = value; }
        }
        public Int32 BaggageCapacity
        {
            get { return _BaggageCapacity; }
            set { _BaggageCapacity = value; }
        }
        public Int32 Pilots
        {
            get { return _Pilots; }
            set { _Pilots = value; }
        }
        public Int32 Crew
        {
            get { return _Crew; }
            set { _Crew = value; }
        }

        public AircraftPhoto GetDisplayPic()
        {
            AircraftPhoto p = null;
            AircraftPhoto temp=null;
            foreach (AircraftPhoto ap in this.PhotoList)
            {
                temp=ap;
                if (ap.DisplayPic)
                    p = ap;
            }
            if (p == null)
                p = temp;
            return p;
        }
        public Airplane()
        {
          
        }
       
    }
}
